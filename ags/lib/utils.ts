import { exec, execAsync } from 'astal';

/**
 * @returns true if all `bins` are found
 */
export function dependencies(...bins: string[]): boolean {
	const missing = bins.filter((bin) => {
		try {
			exec(`which ${bin}`);
			return false;
		} catch {
			return true;
		}
	});
	if (missing.length > 0) {
		console.warn(`missing dependencies: ${missing.join(', ')}`);

		// HACK use built-in notification sender when it releases
		execAsync(
			`notify-send "Missing dependencies" "${missing.join(', ')}"`
		).catch((e) =>
			console.warn(`Failed to send missing dependency notification: ${e}`)
		);
	}
	return missing.length === 0;
}

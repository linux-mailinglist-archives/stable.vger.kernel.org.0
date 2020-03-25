Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49F4192A48
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYNmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 09:42:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:37150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgCYNma (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 09:42:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2D058AD0F;
        Wed, 25 Mar 2020 13:42:28 +0000 (UTC)
Subject: Re: [PATCH 5.5 066/189] driver core: Call sync_state() even if
 supplier has no consumers
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Takashi Iwai <tiwai@suse.de>
References: <20200310123639.608886314@linuxfoundation.org>
 <20200310123646.283600281@linuxfoundation.org>
From:   Jiri Slaby <jslaby@suse.cz>
Autocrypt: addr=jslaby@suse.cz; prefer-encrypt=mutual; keydata=
 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
Message-ID: <93643339-612c-3438-fff8-4eac728118a0@suse.cz>
Date:   Wed, 25 Mar 2020 14:42:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310123646.283600281@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10. 03. 20, 13:38, Greg Kroah-Hartman wrote:
> From: Saravana Kannan <saravanak@google.com>
> 
> commit 21eb93f432b1a785df193df1a56a59e9eb3a985f upstream.
> 
> The initial patch that added sync_state() support didn't handle the case
> where a supplier has no consumers. This was because when a device is
> successfully bound with a driver, only its suppliers were checked to see
> if they are eligible to get a sync_state(). This is not sufficient for
> devices that have no consumers but still need to do device state clean
> up. So fix this.
> 
> Fixes: fc5a251d0fd7ca90 (driver core: Add sync_state driver/bus callback)

This causes NULL ptr dereferences (in 5.5 only). It is enough to load
the mac80211_hwsim module.

The backport to 5.5 needs at least these two commits:
commit ac338acf514e7b578fa9e3742ec2c292323b4c1a
Author: Saravana Kannan <saravanak@google.com>
Date:   Fri Feb 21 00:05:09 2020 -0800

    driver core: Add dev_has_sync_state()

commit 77036165d8bcf7c7b2a2df28a601ec2c52bb172d
Author: Saravana Kannan <saravanak@google.com>
Date:   Fri Feb 21 00:05:10 2020 -0800

    driver core: Skip unnecessary work when device doesn't have sync_state()


and playing with includes.

I am not sure if a revert wouldn't be better -- leaving up to maintainers.

https://bugzilla.suse.com/show_bug.cgi?id=1167245

> BUG: kernel NULL pointer dereference, address: 0000000000000048
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> CPU: 0 PID: 2433 Comm: modprobe Not tainted 5.5.9-1-default #1
openSUSE Tumbleweed (unreleased)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-0-ga698c89-rebuilt.opensuse.org 04/01/2014
> RIP: 0010:device_links_flush_sync_list+0xa7/0xe0
> Code: 48 89 4a 08 48 89 11 48 89 85 d0 00 00 00 48 89 85 d8 00 00 00
49 39 ec 74 0c 48 8d bd 80 00 00 00 e8 ad 5a 2c 00 48 8b 45 60 <48> 8b
40 48 48 85 c0 75 80 48 8b 45 68 48 85 c0 0f 84 7b ff ff ff
> RSP: 0018:ffffa55dc2803b40 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffa55dc2803a98 RCX: ffffa55dc2803b68
> RDX: ffffa55dc2803b68 RSI: ffff90831c64e800 RDI: ffffa55dc2803b68
> RBP: ffff90831c64e800 R08: 0000000000000000 R09: 0000000000000228
> R10: 0000000000000dc0 R11: 0000000001320122 R12: ffff90831c64e800
> R13: ffffa55dc2803b68 R14: ffffffffa6f20080 R15: 0000000000000000
> FS:  00007f252bf63740(0000) GS:ffff90831e400000(0000)
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000048 CR3: 00000000123ec000 CR4: 00000000000006f0
> Call Trace:
>  device_links_driver_bound+0x194/0x220
>  driver_bound+0x4c/0xe0
>  device_bind_driver+0x4d/0x60
>  mac80211_hwsim_new_radio+0x14a/0xdc0 [mac80211_hwsim]
>  ? __class_register+0x10c/0x170
>  ? 0xffffffffc092c000
>  init_mac80211_hwsim+0x26f/0x1000 [mac80211_hwsim]
>  ? 0xffffffffc092c000
>  do_one_initcall+0x46/0x200
>  ? _cond_resched+0x15/0x30
>  ? kmem_cache_alloc_trace+0x189/0x280
>  ? do_init_module+0x23/0x230
>  do_init_module+0x5c/0x230
>  load_module+0x14b2/0x1650
>  ? __do_sys_init_module+0x16e/0x1a0
>  __do_sys_init_module+0x16e/0x1a0
>  do_syscall_64+0x64/0x240
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7f252c08ed9a
> Code: 48 8b 0d f9 f0 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f
84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 af 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d c6 f0 0b 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffd0bc12378 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
> RAX: ffffffffffffffda RBX: 0000559358949ee0 RCX: 00007f252c08ed9a
> RDX: 000055935894a750 RSI: 000000000002180b RDI: 00007f2527cc8010
> RBP: 00007f2527cc8010 R08: 0000000000000000 R09: 00007f252c4559e0
> R10: 0000000000000001 R11: 0000000000000246 R12: 000055935894a750
> R13: 0000000000000000 R14: 0000559358949f80 R15: 0000559358949ee0
> Modules linked in: mac80211_hwsim(+) mac80211 cfg80211 libarc4
nls_utf8 isofs fuse af_packet rfkill xt_tcpudp ip6t_REJECT
nf_reject_ipv6 ip6t_rpfilter ipt_REJECT nf_reject_ipv4 xt_conntrack
ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat iptable_mangle iptable_raw
iptable_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set
nfnetlink ebtable_filter ebtables scsi_transport_iscsi ip6table_filter
ip6_tables iptable_filter ip_tables x_tables bpfilter ppdev
snd_hda_codec_generic ledtrig_audio bochs_drm drm_vram_helper
drm_ttm_helper ttm drm_kms_helper snd_hda_intel snd_intel_dspcfg
snd_hda_codec drm snd_hda_core joydev snd_hwdep pcspkr snd_pcm
parport_pc snd_timer snd parport fb_sys_fops syscopyarea sysfillrect
soundcore sysimgblt i2c_piix4 button hid_generic usbhid btrfs
blake2b_generic libcrc32c xor ehci_pci ata_generic raid6_pq ehci_hcd
sr_mod cdrom usbcore ata_piix virtio_net virtio_blk serio_raw floppy
virtio_scsi
>  net_failover failover qemu_fw_cfg sg dm_multipath dm_mod scsi_dh_rdac
scsi_dh_emc scsi_dh_alua
> CR2: 0000000000000048
> ---[ end trace 085626c17d7c1908 ]---



> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20200221080510.197337-2-saravanak@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/base/core.c |   23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -745,25 +745,31 @@ static void __device_links_queue_sync_st
>  /**
>   * device_links_flush_sync_list - Call sync_state() on a list of devices
>   * @list: List of devices to call sync_state() on
> + * @dont_lock_dev: Device for which lock is already held by the caller
>   *
>   * Calls sync_state() on all the devices that have been queued for it. This
> - * function is used in conjunction with __device_links_queue_sync_state().
> + * function is used in conjunction with __device_links_queue_sync_state(). The
> + * @dont_lock_dev parameter is useful when this function is called from a
> + * context where a device lock is already held.
>   */
> -static void device_links_flush_sync_list(struct list_head *list)
> +static void device_links_flush_sync_list(struct list_head *list,
> +					 struct device *dont_lock_dev)
>  {
>  	struct device *dev, *tmp;
>  
>  	list_for_each_entry_safe(dev, tmp, list, links.defer_sync) {
>  		list_del_init(&dev->links.defer_sync);
>  
> -		device_lock(dev);
> +		if (dev != dont_lock_dev)
> +			device_lock(dev);
>  
>  		if (dev->bus->sync_state)
>  			dev->bus->sync_state(dev);
>  		else if (dev->driver && dev->driver->sync_state)
>  			dev->driver->sync_state(dev);
>  
> -		device_unlock(dev);
> +		if (dev != dont_lock_dev)
> +			device_unlock(dev);
>  
>  		put_device(dev);
>  	}
> @@ -801,7 +807,7 @@ void device_links_supplier_sync_state_re
>  out:
>  	device_links_write_unlock();
>  
> -	device_links_flush_sync_list(&sync_list);
> +	device_links_flush_sync_list(&sync_list, NULL);
>  }
>  
>  static int sync_state_resume_initcall(void)
> @@ -865,6 +871,11 @@ void device_links_driver_bound(struct de
>  			driver_deferred_probe_add(link->consumer);
>  	}
>  
> +	if (defer_sync_state_count)
> +		__device_links_supplier_defer_sync(dev);
> +	else
> +		__device_links_queue_sync_state(dev, &sync_list);
> +
>  	list_for_each_entry(link, &dev->links.suppliers, c_node) {
>  		if (!(link->flags & DL_FLAG_MANAGED))
>  			continue;
> @@ -883,7 +894,7 @@ void device_links_driver_bound(struct de
>  
>  	device_links_write_unlock();
>  
> -	device_links_flush_sync_list(&sync_list);
> +	device_links_flush_sync_list(&sync_list, dev);
>  }
>  
>  static void device_link_drop_managed(struct device_link *link)
> 
> 

thanks,
-- 
js
suse labs

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2345842E
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbhKUOuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 09:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhKUOuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 09:50:05 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64B1C061574;
        Sun, 21 Nov 2021 06:47:00 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id f65so3354021pgc.0;
        Sun, 21 Nov 2021 06:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=fa28gFKI+HrbvF5e6qu9NIQ8WuNEHTGdWETnk+vlUvM=;
        b=RHZ2VH6J7JudlxLOigPrryKb4qjfC3aBTc6EEq4g04MVbHzUhBG/9hdm2yi3jgc+Wb
         DhM8Wcwmywlq7ZzgWYZd6nJvODumX5wuJW+L1qzCCGQr7UmK2P0srDq6cQL29mtX7nsM
         ajFaRwJR4Yn4Lv3WFX82/9qF2DCYXUbCV9wZQsq1u46fQ+ZmFegenfui1kD1d5DymaTy
         Y8zDdYx+WumMt+myDGKojz8Hb7IXfnkd5YRqTxEd7+Rxve4TjQUrxvQZtMkwes8Do/mF
         lVU2LsX6LLkGbgwRmbCuu9XE3TognJ2XctXBSfAoBb5WED6FT8X9LsjR4kr3dvES78yl
         3pLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=fa28gFKI+HrbvF5e6qu9NIQ8WuNEHTGdWETnk+vlUvM=;
        b=IH5ZL40+SJ/H3Ii4M4oy19CS6cOSzWaS2ZiKeghSw3N7TVKKoayEa2Nls4gEYCU47R
         16Zr62mD8OtL9QouyCIIkz65vTs9HEr/eXze/J+wCxRyDlrQJeMHgiAkvpoeT2CBQ36s
         3fhCqUE+v53bh9WfjzOPLJgOVAz7wzz3lITbV6MwnXv28BSdTVyAobOO84951oI9zkJv
         gbDpb2x9w9M8JYuXKse0ykbQK3LvGhC+T9ZqI8I8MT6PZAirZiioLgWzjllHljkf2qCR
         FqC6LrCyx48c4KDBWnJEDRE0onqHViRBWIj3wGhrro0BM0DHBUbTvHR77EBvSHDTdgo9
         CPHw==
X-Gm-Message-State: AOAM532p3PA7Bquj/k5WpWmRdN+2XJPP1w4w08S5ht3AbtjWfET5Mpfg
        8R9Npm8C6Z4TGTBkR2GxaM5cJEgapGw4B0djvYRkfVL9nPXYJA==
X-Google-Smtp-Source: ABdhPJxc/TWsX/pF6JGXZ7IK3WuAdIWpfvm90FYSmo0MPd5zHRiKrl/zlZWocgyaKO2ay3ATxbOB3btdw4TXBUOppg0=
X-Received: by 2002:a65:648b:: with SMTP id e11mr28054278pgv.138.1637506019924;
 Sun, 21 Nov 2021 06:46:59 -0800 (PST)
MIME-Version: 1.0
From:   Chris Rankin <rankincj@gmail.com>
Date:   Sun, 21 Nov 2021 14:46:49 +0000
Message-ID: <CAK2bqVJWOj=MOy++zNHzzF8UvmsGcOAtNxvosa60L2NMOAxnGg@mail.gmail.com>
Subject: [WARN][AMDGPU] Linux 5.15.4 with AMD Bonaire GPU
To:     dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

i have found this warning in my vanilla 5.15.4 kernel's dmesg log:

[   87.687139] ------------[ cut here ]------------
[   87.710799] WARNING: CPU: 1 PID: 1 at
drivers/gpu/drm/ttm/ttm_bo.c:409 ttm_bo_release+0x1c/0x266 [ttm]
[   87.718965] Modules linked in: nf_nat_ftp nf_conntrack_ftp cfg80211
af_packet nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_mangle
iptable_raw iptable_security nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter bnep it87 hwmon_vid dm_mod
dax snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio
snd_hda_codec_hdmi snd_hda_intel uvcvideo videobuf2_vmalloc
videobuf2_memops snd_intel_dspcfg snd_hda_codec snd_usb_audio
snd_usbmidi_lib snd_hwdep videobuf2_v4l2 snd_virtuoso snd_oxygen_lib
videobuf2_common btusb snd_mpu401_uart input_leds snd_hda_core
videodev btbcm snd_rawmidi btintel joydev snd_seq mc led_class
bluetooth ecdh_generic rfkill snd_seq_device ecc snd_pcm r8169
coretemp snd_hrtimer i2c_i801 psmouse
[   87.719024]  i2c_smbus pcspkr kvm_intel realtek kvm snd_timer
gpio_ich mdio_devres iTCO_wdt snd libphy mxm_wmi irqbypass soundcore
tiny_power_button lpc_ich i7core_edac acpi_cpufreq button wmi nfsd
auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc fuse configfs zram
zsmalloc ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
hid_microsoft usbhid sr_mod cdrom sd_mod amdgpu uhci_hcd
drm_ttm_helper ehci_pci ttm mfd_core ehci_hcd gpu_sched xhci_pci
xhci_hcd i2c_algo_bit crc32c_intel serio_raw drm_kms_helper
firewire_ohci ahci libahci pata_jmicron firewire_core libata crc_itu_t
cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops
cfbcopyarea cec rc_core scsi_mod usbcore drm bsg scsi_common
usb_common drm_panel_orientation_quirks ipmi_devintf ipmi_msghandler
msr sha256_ssse3 sha256_generic ipv6 crc_ccitt
[   87.876267] CPU: 1 PID: 1 Comm: systemd Tainted: G          I       5.15.4 #1
[   87.882109] Hardware name: Gigabyte Technology Co., Ltd.
EX58-UD3R/EX58-UD3R, BIOS FB  05/04/2009
[   87.889800] RIP: 0010:ttm_bo_release+0x1c/0x266 [ttm]
[   87.893615] Code: 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 56
41 55 41 54 4c 8d a7 90 fe ff ff 55 53 83 7f 4c 00 48 89 fb 48 8b 6f
e8 74 02 <0f> 0b 80 7b 18 00 48 8b 43 88 0f 85 ac 00 00 00 4c 8d 6b 90
49 39
[   87.911829] RSP: 0018:ffffc90000023e00 EFLAGS: 00010202
[   87.915886] RAX: 0000000000000001 RBX: ffff888123a449c8 RCX: 000000000000004c
[   87.921825] RDX: 00000000000001f3 RSI: ffffffffa02ee0e5 RDI: ffff888123a449c8
[   87.927750] RBP: ffff88810d6652f0 R08: 0000000000000001 R09: 0000000000000003
[   87.933869] R10: 0000000040000000 R11: ffff888109970600 R12: ffff888123a44858
[   87.939767] R13: ffff888146e35ad0 R14: ffff888146dad6c0 R15: 0000000000000000
[   87.945604] FS:  00007f901262ab40(0000) GS:ffff888343c40000(0000)
knlGS:0000000000000000
[   87.952390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   87.956837] CR2: 000055d9edfa8fa0 CR3: 0000000102180000 CR4: 00000000000006e0
[   87.962704] Call Trace:
[   87.963876]  <TASK>
[   87.964742]  amdgpu_bo_unref+0x15/0x1e [amdgpu]
[   87.968219]  amdgpu_gem_object_free+0x2b/0x45 [amdgpu]
[   87.972135]  drm_gem_dmabuf_release+0x11/0x1a [drm]
[   87.975792]  dma_buf_release+0x36/0x7d
[   87.978363]  __dentry_kill+0xf5/0x12f
[   87.980749]  dput+0xfc/0x136
[   87.982386]  __fput+0x17a/0x1cc
[   87.984234]  task_work_run+0x64/0x75
[   87.986615]  exit_to_user_mode_prepare+0x88/0x112
[   87.990111]  syscall_exit_to_user_mode+0x14/0x1f
[   87.993513]  do_syscall_64+0x7a/0x80
[   87.995873]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   87.999798] RIP: 0033:0x7f9013160fdb
[   88.002129] Code: 03 00 00 00 0f 05 48 3d 00 f0 ff ff 77 41 c3 48
83 ec 18 89 7c 24 0c e8 33 81 f8 ff 8b 7c 24 0c 41 89 c0 b8 03 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 81 81 f8 ff
8b 44
[   88.020215] RSP: 002b:00007ffda9891d20 EFLAGS: 00000293 ORIG_RAX:
0000000000000003
[   88.026698] RAX: 0000000000000000 RBX: 00007f901262a8f0 RCX: 00007f9013160fdb
[   88.032789] RDX: 0000000000000000 RSI: 000000055d9edfc6 RDI: 0000000000000069
[   88.038864] RBP: 0000000000000069 R08: 0000000000000000 R09: 000000000000007f
[   88.045044] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
[   88.051033] R13: 000055d9ecadd680 R14: 000055d9eca96719 R15: 000055d9edf412f0
[   88.056868]  </TASK>
[   88.057758] ---[ end trace bf3184763fd2083a ]---

I have seen a warning like this one in every dmesg log from 5.14.x
onwards, and it is clearly still present in the 5.15.x series too.

My GPU is a Radeon R7 360 (Bonaire).

Cheers,
Chris

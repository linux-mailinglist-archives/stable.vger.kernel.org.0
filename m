Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A7F456603
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 00:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhKRXFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 18:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhKRXFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 18:05:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79018C06173E;
        Thu, 18 Nov 2021 15:02:42 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so7121980pjb.4;
        Thu, 18 Nov 2021 15:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bIM6Ba/7xK6AIAQ7aluqQKyzqluGdhQ73YnvOapk94w=;
        b=otAaHStgH50NW2LsMQfOUiyFA4y7mt+NFR3+8olr0vDXdUkSDnXLT7yQazMIL5EKfM
         QHF4RIjwZyCmk5j9qXJej6rB+/9DmyI3r8U9BH6b0GH64c/w3uFHqlN7UhXguIKLdxjG
         h8cvYy+jLBabC7a5fT9/5cC9gCQrcG3N2a9VXSGdosH/WviTmeFTo8uwMUuczuDhHszR
         FihNPqpaaUMNy8wiOPRbM+FaXFkTMB+tTrnWnJ3ihhW7GheXhUILIu/GqsS7UTdtZvqZ
         nQbiQsWd39WtOjFwX2RwKUhnH6M6fv/am81VpDKPhHTdI5YPa3MTZx8Cg14B0BTZQiOS
         XCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bIM6Ba/7xK6AIAQ7aluqQKyzqluGdhQ73YnvOapk94w=;
        b=gw5KWVK1G8nAjX0JqrQdbOeUW8BBTQZW6ShCNzUDriwbf4K37cCmFhmwRy8OaPyjlD
         NDnN8bGuQd/Cn2hMwTCnLS/EyZPUibSUxhE4KghvTI0KJRVQhGzqxWnqXib3dWaMgQYK
         L1F3rVa3LwP/WLhg/SAY7TmDl4nH+WsNHRZYNyrvYqbtuoi/l13QeMGG98kojHFpAAtv
         /ZZHL+lWHAzjI0KbgSOngyMsHH6UJxSNnDNBxdUJ5ebtFSUdc+wnymnLwCB1UNd8KtVO
         CwP8XJUpzcLe7unwx00dcjg27ahHysLmk/E5857ADIjMKGTqEKiFU5s06F2iWt4FQZPS
         ldUA==
X-Gm-Message-State: AOAM530XYrVebFICqY238iwr81YR1/GCvdUp4QppgbNqY5bf027CMGDl
        OU7zhKTALvafdSjWeZZszJRbz84XacRqvg2VC0wkvt4XO9Sy5Q==
X-Google-Smtp-Source: ABdhPJxA1hukCNBkgsl+2BmMpkNsPwSY6jWJ25EHz75uDySHB65nqrHbnEyMIppdKLg+NdPPa9EMnF4PVf51OLTbz7w=
X-Received: by 2002:a17:90b:1e4f:: with SMTP id pi15mr14529866pjb.181.1637276561761;
 Thu, 18 Nov 2021 15:02:41 -0800 (PST)
MIME-Version: 1.0
References: <CAK2bqV+NuRYNU0dHni9Cmfvi5CZ7Ycp6rGrNRDLzrdU9xkSXaw@mail.gmail.com>
 <99d07599-3d72-d389-cfc2-f463230037a5@leemhuis.info> <ed000478-2a60-0066-c337-a04bffc112b1@leemhuis.info>
 <YZYc6uSpp76Sz4vO@kroah.com> <YZZdUxGbKJKz0x8i@kroah.com>
In-Reply-To: <YZZdUxGbKJKz0x8i@kroah.com>
From:   Chris Rankin <rankincj@gmail.com>
Date:   Thu, 18 Nov 2021 23:02:30 +0000
Message-ID: <CAK2bqVJyi-g0b=dSDPS5ELb1d8joKark4k4+6AGQdtuM81k2kg@mail.gmail.com>
Subject: Re: [OOPS] Linux 5.14.19 crashes and burns!
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Yes, 5.14.20 fixes the boot problem in 5.14.19. Thank you. However,
this WARNING is still present, as with every other 5.14.x kernel I
have been able to test:

[   95.796055] ------------[ cut here ]------------
[   95.819648] WARNING: CPU: 3 PID: 1 at
drivers/gpu/drm/ttm/ttm_bo.c:409 ttm_bo_release+0x1c/0x266 [ttm]
[   95.827805] Modules linked in: nf_nat_ftp nf_conntrack_ftp cfg80211
af_packet nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct
nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat
ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_mangle
iptable_raw iptable_security nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter bnep it87 hwmon_vid dm_mod
dax snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio
snd_hda_codec_hdmi snd_hda_intel btusb uvcvideo btbcm btintel
videobuf2_vmalloc bluetooth videobuf2_memops videobuf2_v4l2
videobuf2_common videodev ecdh_generic rfkill ecc snd_usb_audio
snd_usbmidi_lib snd_intel_dspcfg snd_hda_codec mc snd_hwdep coretemp
snd_virtuoso snd_oxygen_lib kvm_intel snd_hda_core input_leds
snd_mpu401_uart kvm snd_rawmidi led_class r8169 snd_seq joydev
irqbypass snd_seq_device snd_pcm
[   95.827905]  snd_hrtimer snd_timer realtek gpio_ich mxm_wmi
iTCO_wdt mdio_devres snd libphy wmi soundcore lpc_ich
tiny_power_button psmouse pcspkr i2c_i801 i2c_smbus button i7core_edac
acpi_cpufreq nfsd auth_rpcgss nfs_acl binfmt_misc lockd grace sunrpc
fuse configfs zram zsmalloc ip_tables x_tables ext4 crc32c_generic
crc16 mbcache jbd2 hid_microsoft usbhid sr_mod cdrom sd_mod amdgpu
uhci_hcd drm_ttm_helper ttm mfd_core gpu_sched i2c_algo_bit
drm_kms_helper cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt
fb_sys_fops cfbcopyarea cec xhci_pci rc_core ehci_pci drm ehci_hcd
firewire_ohci pata_jmicron xhci_hcd ahci libahci crc32c_intel
firewire_core libata crc_itu_t serio_raw scsi_mod usbcore usb_common
drm_panel_orientation_quirks ipmi_devintf ipmi_msghandler msr
sha256_ssse3 sha256_generic ipv6 crc_ccitt
[   95.986940] CPU: 7 PID: 1 Comm: systemd Tainted: G          I
5.14.20 #1
[   95.993114] Hardware name: Gigabyte Technology Co., Ltd.
EX58-UD3R/EX58-UD3R, BIOS FB  05/04/2009
[   96.001000] RIP: 0010:ttm_bo_release+0x1c/0x266 [ttm]
[   96.004945] Code: 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 56
41 55 41 54 4c 8d a7 90 fe ff ff 55 53 83 7f 4c 00 48 89 fb 48 8b 6f
e8 74 02 <0f> 0b 80 7b 18 00 48 8b 43 88 0f 85 ac 00 00 00 4c 8d 6b 90
49 39
[   96.023154] RSP: 0018:ffffc90000023e00 EFLAGS: 00010202
[   96.027128] RAX: 0000000000000001 RBX: ffff888105ac0dc8 RCX: 00000000000=
00292
[   96.033077] RDX: 0000000000000420 RSI: ffffffffa03010db RDI: ffff888105a=
c0dc8
[   96.039021] RBP: ffff88810bd05308 R08: 0000000000000001 R09: 00000000000=
00003
[   96.045104] R10: ffff8881274e5e00 R11: ffff8881274e5e00 R12: ffff888105a=
c0c58
[   96.051172] R13: ffff888135fe0ff8 R14: ffff88812693d540 R15: 00000000000=
00000
[   96.057195] FS:  00007ff7c578cb40(0000) GS:ffff888343dc0000(0000)
knlGS:0000000000000000
[   96.064276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   96.068851] CR2: 00007f2f9152e948 CR3: 00000001008de000 CR4: 00000000000=
006e0
[   96.074936] Call Trace:
[   96.076091]  <TASK>
[   96.076903]  amdgpu_bo_unref+0x15/0x1e [amdgpu]
[   96.080419]  amdgpu_gem_object_free+0x2b/0x45 [amdgpu]
[   96.084505]  drm_gem_dmabuf_release+0x11/0x1a [drm]
[   96.088205]  dma_buf_release+0x36/0x7d
[   96.090760]  __dentry_kill+0xf5/0x12f
[   96.093250]  dput+0xfc/0x136
[   96.094913]  __fput+0x16a/0x1bc
[   96.096820]  task_work_run+0x64/0x75
[   96.099202]  exit_to_user_mode_prepare+0x88/0x112
[   96.102679]  syscall_exit_to_user_mode+0x14/0x1f
[   96.105996]  do_syscall_64+0x7a/0x80
[   96.108276]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   96.112030] RIP: 0033:0x7ff7c62c2fdb
[   96.114309] Code: 03 00 00 00 0f 05 48 3d 00 f0 ff ff 77 41 c3 48
83 ec 18 89 7c 24 0c e8 33 81 f8 ff 8b 7c 24 0c 41 89 c0 b8 03 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 81 81 f8 ff
8b 44
[   96.131760] RSP: 002b:00007fff0b56d3f0 EFLAGS: 00000293 ORIG_RAX:
0000000000000003
[   96.138100] RAX: 0000000000000000 RBX: 00007ff7c578c8f0 RCX: 00007ff7c62=
c2fdb
[   96.143944] RDX: 0000000000000000 RSI: 0000000556cdb0cc RDI: 00000000000=
00069
[   96.149859] RBP: 0000000000000069 R08: 0000000000000000 R09: 00000000000=
0007f
[   96.155751] R10: 0000000000000000 R11: 0000000000000293 R12: 00000000000=
00000
[   96.161679] R13: 0000556cda037680 R14: 0000556cd9ff0719 R15: 0000556cdb0=
cb480
[   96.167643]  </TASK>
[   96.168544] ---[ end trace 9ff3687327d73ce2 ]---

Cheers,
Chris

On Thu, 18 Nov 2021 at 14:04, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 18, 2021 at 10:29:14AM +0100, Greg KH wrote:
> > On Thu, Nov 18, 2021 at 10:15:23AM +0100, Thorsten Leemhuis wrote:
> > > Hey Greg!
> > >
> > > On 18.11.21 09:57, Thorsten Leemhuis wrote:
> > > > Lo! CCing stable and regressions list. FWIW, I have a Fedora 34 VM =
that
> > > > stopped booting with 5.14.19 as well. More inline:
> > > >
> > > > On 18.11.21 01:55, Chris Rankin wrote:
> > > >>
> > > >> I have tried to boot a vanilla 5.14.19 kernel, but it crashes when
> > > >> "switching root" away from the initramfs. ("Unable to handle page
> > > >> fault...)
> > > >>
> > > >> Google's "copy text from image" feature has managed to scrape this
> > > >> information from my phone camera:
> > > >>
> > > >> 1tch Noo
> > > >> BUG: unable to handle page fault for address: ffffc980006cfeDS
> > > >> #PF: supervisor read access in kernel mode #PF: error_code (8x8888=
) -
> > > >> not-present page
> > > >> PGD 100000067 P4D 100000067 PUD 18885e867 PMD 104486867 PTE 8
> > > >> Oops: 0888 [#1] PREEMPT SMP PTI
> > > >> CPU: 6 PID: 1 Comm: systemd Tainted: G Hardware name: Gigabyte
> > > >> Technology Co., Ltd. EX58-UD3R/EX58-UD3R, BIOS FB 05/04/2009
> > > >> 5.14.19 #1
> > > >> RIP: 0010: __unwind_start+8xb5/8x15f
> > > >> Code: 48 8d 8d 88 88 88 88 48 89 e2 48 89 e8 48 89 4d 48 48 89 55 =
38
> > > >> 48 RSP: 0018:ffffc90088823bf0 EFLAGS: 00010006
> > > >> RAX: ffffc900006efde8 RBX: 0000000000000000 RCX: 08 RDX:
> > > >> ffffc900006efe18 RSI : ffff88818a9f6c80 RDI: ffffc
> > > >> RBP: ffffc90808823c18 R08: 00000000000001de R89: R10: ffff888107d2=
0000
> > > >> R11: ffff888183b4ba88 R12: ffffc900006ef dell
> > > >> R13: ffff88810a9f73bc R14: ffff888103c58480 R15: FS: 00007f528fd19=
b40
> > > >> (0800) GS:ffff888343488808 (0888) knl6S:
> > > >> CS: 0818 DS: 0000 ES: 0000 CRO: 0888000088858833
> > > >> CR2: ffffc900006efe88 CR3: 088080818186a888 CR4: 8888
> > > >> Call Trace:
> > > >> <TASK>
> > > >> get_wchan+8x42/8x8f
> > > >> get_wchan+8x45/8x59
> > > >> do_task_stat+0x3ab/0x38
> > > >> proc_single_show+8x1e/8x68
> > > >> seq_read_iter+0x151/8x342 seq_read+8xf1/8x117
> > > >> uf's_read+Bxa3/8x183
> > > >> ksys_read+8x71/8xb9 do_syscal1_64+8x6d/8x88
> > > >> entry_SYSCALL_64_after_huframe+8x11/8xne
> > > >> RIP: 8033:8x7f529884f832
> > > >> Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 2e Bc 80 68 65 =C2=A39 01 0=
0 0f 16 44 000
> > > >> RSP: 082b:00087ffed3b91f18 EFLAGS: 88888246 ORIG RAX:
> > > >> RAX: ffffffffffffffda RBX: 8888559462036658 RCX: 000071529084/83
> > > >> RDX: 0000000000000100 RSI: 8088559462c90b78 RDI:
> > > >> RBP: 000071529894a300 BAR:
> > > >> te fa
> > > >>
> > > >> And also this:
> > > >>
> > > >> do_syscall_64+0x6d/0x80
> > > >> entry_SYSCALL_64_after_huframe+0x44/0xae
> > > >> RIP: 8033:0x7f529884f832
> > > >> Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea Ze Bc 80 e8 b5 f9 01 00 0f =
1f
> > > >> 44 00 00 f3 Bf 1e fa 64 8b 84 25 18 88 RSP: 082b:00087ffed3b91f 18
> > > >> EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> > > >> RAX: ffffffffffffffda RBX: 0000559462c36650 RCX: 000071529084f832 =
RDX:
> > > >> 0000000000000400 RSI: 0000559462c90b70 RDI: 0000000000000006
> > > >> RBP: 000071529094a3a0 R08: 0000000000000006 RO9: 0000000000000001 =
R18:
> > > >> 0000000000001000 R11: 0000000000000246 R12: 00007f528fd198f0
> > > >> R13: 0000000000000168 R14: 00007f52909497a0 R15: 00000000000001468
> > > >> </TASK>
> > > >> Modules linked in: ext4 crc32c_generic crc16 mbcache jbd2 sr_mod
> > > >> sd_mod cdrom hid_microsoft usbhid amdgpu uh ci drm_kms_helper ehci=
_hcd
> > > >> cf bf illrect syscopyarea cfbimgblt sysfillrect sysimgblt xhci pci
> > > >> xhci_hcd fb_sys_ mod usb_common drm_panel_orientation_quirks
> > > >> ipmi_devintf ipmi_msghandler msr sha256_ssse3 sha256_generic ipu C=
RZ:
> > > >> ffffc900006efe08
> > > >> --- end trace 9771b79967a8dd89 ]--- RIP: 8010:_unwind_start+8xb5/0=
x15f
> > > >> Code: 48 8d 8d 00 00 00 00 48 89 e2 48 89 e8 48 89 4d 48 48 89 55 =
38
> > > >> 48 89 45 40 eb 29 48 8b 86 98 Ba 80 00 RSP: 0818:ffffc90000023bf0
> > > >> EFLAGS: 00010006 RAX: ffffc900006efde0 RBX: 0000000000000000 RCX:
> > > >> 0000000000000000
> > > >> RDX: ffffc900006efe18 RSI: ffff88810a9f6c00 RDI: ffffc90000023c78 =
RBP:
> > > >> ffffc98800023c18 R08: 00000000000001de R09: 00000000005b20c6
> > > >> R10: ffff888107120000 R11: ffff888103b4ba80 R12: ffffc900006ef de
> > > >> R13: ffff88818a9f73bc R14: ffff888103c50480 R15: 0000000000000000 =
FS:
> > > >> 00007f528fd19b40(8000) GS:ffff888343180000 (0800)
> > > >> knlGS:0000000000000000 CS: 0810 DS: 0000 ES: 0000 CRO:
> > > >> 0000000080050033
> > > >> CR2: ffffc908806efe88 CR3: 000000010186a000 CR4: 00000000000006e0
> > > >> note: systemd [1] exited with preempt_count 1
> > > >> Kernel panic - not syncing: Attempted to kill init!
> > > >> exitcode=3D0x00000009 Kernel Offset: disabled
> > > >> --- [ end Kernel panic not syncing: Attempted to kill initf
> > > >> exitcode=3D0x00000009 1--- -
> > > >>
> > > >> I cannot capture the exact oops via any other means, although I ca=
n
> > > >> send the original camera pictures that I captured the text from, o=
n
> > > >> request.
> > > >
> > > > By default I didn't get to see any messages,
> > >
> > > BTW: that was a stupid error on my side, I get them now.
> > >
> > > > the VM just hangs when
> > > > switching to root. Did anyone else already report or even track thi=
s
> > > > down already? Guess otherwise I need to take a closer look and mayb=
e
> > > > start bisecting...
> > >
> > > On a quick looks above problems seems to be similar to the one alread=
y
> > > reported wrt to WCHAN:
> > > https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/
> > >
> > > Greg, is there any reason why you didn't drop them from 5.14.y as wel=
l,
> > > as you did for 5.15.y:
> > > https://lore.kernel.org/all/YZYLC9D6zpUneYtn@kroah.com/
> > >
> > > Should I try reverting these three and see if the situations improves=
?
> >
> > I will push out a new 5.14 release in a few hours with those commits
> > reverted, as yes, you are right, they should not be there if I have
> > dropped them from 5.15.y
>
> Should be resolved in 5.14.20.
>
> If not, please let me know.
>
> thanks,
>
> greg k-h

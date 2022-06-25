Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A294655AB2B
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 17:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiFYPBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 11:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiFYPBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 11:01:35 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903912D1B
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 08:01:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id jb13so4535052plb.9
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 08:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=A4MimPKLAaUUiI7JlGtOwtZIufjoLIs76GM0f8eaHBo=;
        b=Z+aCDunKQj7WpbGMe4hZnnaXK6ifXDyo4xiFoRJ8/iit3XnvbdEndmm9P7Sa6TMrvb
         nMJ6d8T+kucgW/HFOSuq5IBNo8CcDmNxWwfEJRYCMYaT7varkUF3DNMJYpMvHrRRhNrG
         jST8tt/sAOt2RzIrj7RG0kY4MfBKy6sveR0vUVVYV4DGaxba1o/orwj4eQ6ShCLa/Ve0
         vLaLt5UDJfEWGQgLKdPKBbBYu0XWNhOhIDIxNqtSGfz4WF1oYswGUQrsVq6YuCzQ7l4s
         scP9/KPRIrZQ/V9z2LDSz9twBhm0lnd+VwGpoS18CeSD1OfXStZOXTdJjMkGKeZcGiXY
         RhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=A4MimPKLAaUUiI7JlGtOwtZIufjoLIs76GM0f8eaHBo=;
        b=59OrBNqyFEr/VZmyFy0TS0td/vrUm6K/MxvH/A84qY495Gh5grqH6+TJCFG0MYseO8
         ssMY4uMpiOk6+ke94OKaVRVonDtLZdLOkX+sfAPfJ1psUfIARg5KF62OY8jwQjVjvTBd
         rJOAXizoO7F7csOPd1vR8aE9P7wfYd76PKBPfB/PiwcBMObRmtYVkK8HdcEnyZ8IwCYG
         oMiSYJSNBjPGVZYBSymqv/EfRAM1hr60anq/UPS+SSI8uyzVntUcINoQhmlV4JyprmBD
         Oofoau74CyBGP45fNuitZWiYuSFCx4b+4txeGj/vtyHoCVvwDGA9dBjMQhTlloX4dCEH
         xqHg==
X-Gm-Message-State: AJIora+0N9fY5at1lY+o/A/veZJA/WP2OBT/OG8xPm6WxaQtlemcLgR3
        kgEcuCx0DAdv3EbFXJvtBp6Xge1C/8hoMgGNqQMj3HYJrPSD5A==
X-Google-Smtp-Source: AGRyM1sFZ9K/fjvcVqcHvh617sXxcRRskeieADik2/XuYSNXbe9YgKRNJkQ/4W7nGQOimGzcFglYjiBQTE4189qpOdc=
X-Received: by 2002:a17:902:f609:b0:168:dcbe:7c4d with SMTP id
 n9-20020a170902f60900b00168dcbe7c4dmr4643814plg.169.1656169294518; Sat, 25
 Jun 2022 08:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <CADs9LoMEF86Fp2-0ji7d9CNA5F=8ArwPWnj09h_Cwo6poNsWVA@mail.gmail.com>
 <YqMdS+3qpYHfWN9f@kroah.com>
In-Reply-To: <YqMdS+3qpYHfWN9f@kroah.com>
From:   Alex Natalsson <harmoniesworlds@gmail.com>
Date:   Sat, 25 Jun 2022 18:01:22 +0300
Message-ID: <CADs9LoMAgCNU6Rx2y0t7kRMmLw-Qd06Ayq19qM2-PkOJUgdxig@mail.gmail.com>
Subject: Re: echo mem > /sys/power/state write error "Device or resource busy"
 on Amlogic A311D device
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

New kernels freezing after resume only when scaling governor is
"conservative". Yes, I using this because my solar battery produce a
few of electricity. When scaling governor is performance system not
freezing after resume.
However, sometimes I received "Device or resource busy" error after
echo mem > /sys/power/state.
Later I found out what this was related with another bug:
pipewire-media-session is <defunct>, nosound and many processes which
using audio as mplayer, ffplay, alsamixer and etc was not responding
and not terminating even throught kill -9.
The log after alsamixer launch:
[  103.786358] Internal error: Oops: 96000004 [#1] SMP
[  103.786509] Modules linked in: snd_seq_dummy snd_hrtimer snd_seq
snd_seq_device bnep nls_utf8 mt7601u mac80211 hci_uart libarc4 joydev
brcmfmac btbcm panfrost bluetooth meson_vdec(C) brcmutil gpu_sched
cfg80211 dwmac_generic videobuf2_dma_contig v4l2_mem2mem
videobuf2_memops videobuf2_v4l2 videobuf2_common drm_shmem_helper
ecdh_generic dwmac_meson8b stmmac_platform dw_hdmi_i2s_audio stmmac
ecc ir_nec_decoder videodev pcs_xpcs rc_khadas phylink ptp
meson_saradc meson_ir rc_core snd_soc_meson_axg_frddr
snd_soc_meson_axg_toddr snd_soc_meson_axg_sound_card
snd_soc_meson_card_utils snd_soc_meson_axg_fifo ao_cec_g12a
snd_soc_meson_axg_tdmin snd_soc_meson_axg_tdm_interface
snd_soc_meson_axg_tdmout snd_soc_meson_axg_tdm_formatter rfkill
meson_gxbb_wdt fuse crypto_user uas usb_storage adc_keys
gpio_keys_polled industrialio
[  103.857778] CPU: 3 PID: 530 Comm: pipewire-media- Tainted: G
 C        5.16.0-ARCH+ #8
[  103.857791] Hardware name: Khadas VIM3 (DT)
[  103.857795] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  103.857801] pc : dpcm_be_connect+0xd0/0x2d0
[  103.881758] lr : dpcm_add_paths.isra.0+0xcc/0x1e0
[  103.881763] sp : ffff800009f4b870
[  103.881765] x29: ffff800009f4b870 x28: ffff000003b944c0 x27: 0000000000000001
[  103.881772] x26: 0000000000000001 x25: 0000000000000340 x24: 00000000000002a0
[  103.881777] x23: 0000000000000001 x22: 0000000000000000 x21: ffff000005b18080
[  103.881782] x20: ffff000005b183c0 x19: ffff000005b1c080 x18: 0000000000000000
[  103.881787] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  103.881792] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  103.881797] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
[  103.881801] x8 : ffff000012020400 x7 : 0000000000000000 x6 : 000000000000003f
[  103.881806] x5 : 0000000000000040 x4 : 0000000000000000 x3 : ffff000002822000
[  103.881811] x2 : ffff000002861b50 x1 : ffff00000282f800 x0 : ffff000002861800
[  103.881817] Call trace:
[  103.881819]  dpcm_be_connect+0xd0/0x2d0
[  103.881823]  dpcm_add_paths.isra.0+0xcc/0x1e0
[  103.881826]  dpcm_fe_dai_open+0x80/0x194
[  103.881831]  snd_pcm_open_substream+0xa4/0x174
[  103.881838]  snd_pcm_open.part.0+0xd8/0x1dc
[  103.881843]  snd_pcm_capture_open+0x64/0x94
[  103.992730]  snd_open+0xac/0x1d0
[  103.992739]  chrdev_open+0xe0/0x2d0
[  103.999389]  do_dentry_open+0x12c/0x3a0
[  103.999397]  vfs_open+0x30/0x3c
[  103.999401]  do_open+0x204/0x414
[  103.999405]  path_openat+0x10c/0x27c
[  103.999408]  do_filp_open+0x80/0x130
[  103.999412]  do_sys_openat2+0xb4/0x170
[  103.999414]  __arm64_sys_openat+0x64/0xb0
[  103.999416]  invoke_syscall+0x48/0x114
[  103.999426]  el0_svc_common.constprop.0+0xd4/0xfc
[  103.999429]  do_el0_svc+0x28/0x90
[  103.999432]  el0_svc+0x28/0x80
[  103.999440]  el0t_64_sync_handler+0xa4/0x130
[  103.999442]  el0t_64_sync+0x1a0/0x1a4
[  103.999451] Code: 8b000020 f9406841 f9406816 f9400020 (f94002c1)
[  103.999457] ---[ end trace e01b673b8147057d ]---


After I removed pipewire software "Device or resource busy" error was
disappear. But the sound and media still doesn't working and alsamixer
cannot change sound card to my usb audio device after commit
bbf7d3b1c4f40eb02dd1dffb500ba00b0bff0303.

> On Fri, Jun 10, 2022 at 01:18:56PM +0300, Alex Natalsson wrote:
> > Hello friends.
> > Suspend to RAM on Amlogic A311D chip (Khadas VIM3 SBC) was broken with
> > 5.17.13 and with 5.18.2 it also presents.
> >
> > When I trying do this I recieve error message:
> > VIM3 ~ # LANG=C echo mem > /sys/power/state
> > [  952.824117] PM: suspend entry (deep)
> > [  952.828333] Filesystems sync: 0.003 seconds
> > [  952.829473] Freezing user space processes ...
> > [  972.833509] Freezing of tasks failed after 20.003 seconds (1 tasks
> > refusing to freeze, wq_busy=0):
> > [  972.841178] task:mplayer         state:D stack:    0 pid:  779
> > ppid:   736 flags:0x00000205
> > [  972.849457] Call trace:
> > [  972.851868]  __switch_to+0xf8/0x150
> > [  972.855315]  __schedule+0x1f8/0x570
> > [  972.858758]  schedule+0x48/0xc0
> > [  972.861856]  schedule_preempt_disabled+0x10/0x20
> > [  972.866417]  __mutex_lock.constprop.0+0x158/0x590
> > [  972.871071]  __mutex_lock_slowpath+0x14/0x20
> > [  972.875296]  mutex_lock+0x5c/0x70
> > [  972.878573]  dpcm_fe_dai_open+0x44/0x194
> > [  972.882456]  snd_pcm_open_substream+0xa4/0x174
> > [  972.886857]  snd_pcm_open.part.0+0xd8/0x1dc
> > [  972.890994]  snd_pcm_playback_open+0x64/0x94
> > [  972.895223]  snd_open+0xac/0x1d0
> > [  972.898411]  chrdev_open+0xdc/0x2c4
> > [  972.901861]  do_dentry_open+0x12c/0x380
> > [  972.905652]  vfs_open+0x30/0x3c
> > [  972.908758]  do_open+0x1e4/0x3a0
> > [  972.911948]  path_openat+0x10c/0x280
> > [  972.915486]  do_filp_open+0x80/0x130
> > [  972.919019]  do_sys_openat2+0xb4/0x170
> > [  972.922731]  __arm64_sys_openat+0x64/0xb0
> > [  972.926700]  invoke_syscall+0x48/0x114
> > [  972.930421]  el0_svc_common.constprop.0+0xd4/0xfc
> > [  972.935070]  do_el0_svc+0x28/0x90
> > [  972.938347]  el0_svc+0x34/0xb0
> > [  972.941367]  el0t_64_sync_handler+0xa4/0x130
> > [  972.945595]  el0t_64_sync+0x18c/0x190
> >
> > [  972.950674] OOM killer enabled.
> > [  972.953781] Restarting tasks ... done.
> > -bash: echo: write error: Device or resource busy
> > VIM3 ~ :( #
> >
> > With 5.16.2 kernel version suspend to RAM is working, but system very
> > slow after resume.
> >
>
> Can you use 'git bisect' to track down the offending commit?
>
> And does 5.19-rc1 also have this issue?
>
> thanks,
>
> greg k-h

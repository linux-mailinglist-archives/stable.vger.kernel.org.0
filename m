Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8E4595B49
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 14:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiHPMHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 08:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiHPMGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 08:06:01 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE3543E5C;
        Tue, 16 Aug 2022 04:55:57 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-33365a01f29so46412917b3.2;
        Tue, 16 Aug 2022 04:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=K+jKTxBtB34dJbEeQDbAxdx9y/8BOn6K6NiBKXkNSVQ=;
        b=o9+6ql53h7uy/TYpb8mAW8Nhsf6CLUGjMKHyid3Bqdn4TDFlc0VpOY/d1KYEEnJ22a
         Tgm6xuvgbllhDhcvLDN+ekMf8v15llZcO5/joI0N1Mqtgr6eHuwfTgUzvSBV4OPeU8lN
         Xlv6m3+v7/aqDBzQA+vQY0XQUoShw/pX9wTy+cgFj+01FuaG579QdXKP8s8A4hlb86MH
         MjHJiuOjiXhY4ZjRbjwr/CNYohLyUZZ8NSPssGtVl/OuNhSSG903A5g/f/0zkNyDLOXM
         SUhjncRSMZ2ycNinknzSGAZoaSJrpXUDw6ekexqfZrNxrQJ8sniadn61y0YncElPyno0
         SqeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=K+jKTxBtB34dJbEeQDbAxdx9y/8BOn6K6NiBKXkNSVQ=;
        b=u7QJiGCoEfGk9bppB++QnziC6wkrb2j8Syr8ACrEy/mNoHQOLGOL84dgx44iHBvJPZ
         xjWg603Oi9zx9hS+XPXmA7VcXXEIe7gxWZ0BF+koPBk3TwwRzOgUSNjdp6LMbMi/4/ZN
         a5izSYstF9OHzaWlf5hHUQAP+oLukG9wWtmWDbbLmzjtmGhGVh4E+x7/e/Zoefa8oCDE
         DyBwzWfi+jge+ttlf4q8q1hR2kFfRFicDIwWYdB7HC/brBekyY8XkgABD+hc5WwjcOIG
         zw94DE+/A0r/rUqYID/h+RcDskRYb//drQyHe6U/GDPqiqEyHo6hMS7zxroy3CMPamUk
         KF2A==
X-Gm-Message-State: ACgBeo2/cv+BmTs0zfDuIsPp9pQjFKLH/DjdVydRi4C/mrgLygyVfAbe
        pLr4Gvnf1OfKe1FUPFgl9GozxUspaCJ82hQeClY=
X-Google-Smtp-Source: AA6agR42kEOgRrV4vDCgdX8LJvJQNFONTnVrlZf/JvUgdjBz5PMSCW22zmNspocNMjZS+tPUfL0VJqTar/NpKOsQMcs=
X-Received: by 2002:a5b:845:0:b0:683:6ed7:b3b6 with SMTP id
 v5-20020a5b0845000000b006836ed7b3b6mr13278868ybq.183.1660650956514; Tue, 16
 Aug 2022 04:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220815180429.240518113@linuxfoundation.org>
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 16 Aug 2022 12:55:20 +0100
Message-ID: <CADVatmMw55_ZsfYbyrZL9vdfkCLsmkVS2+gZ1Ljp8BmVz7u4DA@mail.gmail.com>
Subject: Re: [PATCH 5.18 0000/1095] 5.18.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
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

Hi Greg,

On Mon, Aug 15, 2022 at 7:55 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.18 release.
> There are 1095 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.

Both v5.18.18-rc1 and v5.15.61-rc1 has hung task in RPI4B causing a
huge delay in bootup.

This is from  v5.18.18-rc1.
[  846.815074] INFO: task systemd-udevd:192 blocked for more than 724 seconds.
[  846.822452]       Tainted: G        WC        5.18.18-rc1 #1
[  846.828961] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  846.837557] task:systemd-udevd   state:D stack:    0 pid:  192
ppid:   177 flags:0x00000009
[  846.837582] Call trace:
[  846.837589]  __switch_to+0xf8/0x150
[  846.837611]  __schedule+0x3cc/0xa0c
[  846.837623]  schedule+0x68/0x104
[  846.837634]  schedule_preempt_disabled+0x30/0x4c
[  846.837646]  __mutex_lock.constprop.0+0x168/0x55c
[  846.837658]  __mutex_lock_slowpath+0x1c/0x30
[  846.837669]  mutex_lock+0x50/0x60
[  846.837680]  usb_udc_uevent+0x58/0xf0 [udc_core]
[  846.837718]  dev_uevent+0x134/0x2e0
[  846.837732]  kobject_uevent_env+0x298/0x764
[  846.837744]  kobject_uevent+0x14/0x20
[  846.837753]  device_add+0x398/0x8a0
[  846.837764]  usb_add_gadget+0x110/0x1bc [udc_core]
[  846.837791]  usb_add_gadget_udc+0x7c/0xc0 [udc_core]
[  846.837817]  dwc2_driver_probe+0x5e0/0x7a0 [dwc2]
[  846.837869]  platform_probe+0x74/0xd0
[  846.837880]  really_probe+0x180/0x3cc
[  846.837893]  __driver_probe_device+0x11c/0x190
[  846.837905]  driver_probe_device+0x44/0xf4
[  846.837917]  __driver_attach+0xd8/0x1b0
[  846.837930]  bus_for_each_dev+0x7c/0xe0
[  846.837941]  driver_attach+0x30/0x40
[  846.837953]  bus_add_driver+0x154/0x240
[  846.837964]  driver_register+0x84/0x140
[  846.837977]  __platform_driver_register+0x34/0x40
[  846.837987]  dwc2_platform_driver_init+0x2c/0x1000 [dwc2]
[  846.838035]  do_one_initcall+0x50/0x2c0
[  846.838047]  do_init_module+0x50/0x260
[  846.838061]  load_module+0x2298/0x2720
[  846.838074]  __do_sys_finit_module+0xac/0x12c
[  846.838087]  __arm64_sys_finit_module+0x2c/0x40
[  846.838099]  invoke_syscall+0x50/0x120
[  846.838113]  el0_svc_common.constprop.0+0x6c/0x1a0
[  846.838126]  do_el0_svc+0x30/0x90
[  846.838138]  el0_svc+0x30/0xd0
[  846.838147]  el0t_64_sync_handler+0x10c/0x140
[  846.838158]  el0t_64_sync+0x1a0/0x1a4
[  846.838179] INFO: task udevadm:964 blocked for more than 362 seconds.
[  846.845473]       Tainted: G        WC        5.18.18-rc1 #1
[  846.851891] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  846.860543] task:udevadm         state:D stack:    0 pid:  964
ppid:     1 flags:0x00000000
[  846.860555] Call trace:
[  846.860560]  __switch_to+0xf8/0x150
[  846.860569]  __schedule+0x3cc/0xa0c
[  846.860576]  schedule+0x68/0x104
[  846.860582]  schedule_preempt_disabled+0x30/0x4c
[  846.860589]  __mutex_lock.constprop.0+0x168/0x55c
[  846.860596]  __mutex_lock_slowpath+0x1c/0x30
[  846.860603]  mutex_lock+0x50/0x60
[  846.860610]  usb_udc_uevent+0x58/0xf0 [udc_core]
[  846.860629]  dev_uevent+0x134/0x2e0
[  846.860637]  uevent_show+0x98/0x124
[  846.860643]  dev_attr_show+0x2c/0x6c
[  846.860649]  sysfs_kf_seq_show+0x98/0x110
[  846.860656]  kernfs_seq_show+0x38/0x44
[  846.860664]  seq_read_iter+0x170/0x48c
[  846.860674]  kernfs_fop_read_iter+0x198/0x1d4
[  846.860681]  new_sync_read+0xd8/0x15c
[  846.860689]  vfs_read+0x19c/0x1e4
[  846.860697]  ksys_read+0x78/0x110
[  846.860704]  __arm64_sys_read+0x28/0x34
[  846.860711]  invoke_syscall+0x50/0x120
[  846.860719]  el0_svc_common.constprop.0+0x6c/0x1a0
[  846.860727]  do_el0_svc+0x30/0x90
[  846.860734]  el0_svc+0x30/0xd0
[  846.860740]  el0t_64_sync_handler+0x10c/0x140
[  846.860746]  el0t_64_sync+0x1a0/0x1a4

Apart from the call trace from the hung task I can also see another warning.

[   14.841402] ------------[ cut here ]------------
[   14.845855] Bluetooth: HCI UART protocol ATH3K registered
[   14.851200] WARNING: CPU: 0 PID: 184 at
drivers/gpu/drm/vc4/vc4_hdmi_regs.h:450 vc5_hdmi_reset+0x1f4/0x234
[vc4]
[   14.867061] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   14.876900] Modules linked in: brcmfmac(+) hci_uart(+) brcmutil
btqca bcm2835_v4l2(C) btrtl btbcm btintel bcm2835_mmal_vchiq(C)
videobuf2_vmalloc vc4(+) raspberrypi_hwmon cfg80211 cec
videobuf2_memops videobuf2_v4l2 drm_cma_helper videobuf2_common
bluetooth xhci_pci(+) drm_kms_helper drm dwc2(+) udc_core ecdh_generic
snd_soc_core snd_bcm2835(C) i2c_brcmstb roles videodev ecc ac97_bus
snd_pcm_dmaengine snd_pcm pwm_bcm2835 mc snd_timer xhci_pci_renesas
snd fb_sys_fops syscopyarea sysfillrect crct10dif_ce phy_generic
uio_pdrv_genirq sysimgblt uio aes_neon_bs aes_neon_blk
[   14.934380] CPU: 0 PID: 184 Comm: systemd-udevd Tainted: G
C        5.18.18-rc1 #1
[   14.942761] Hardware name: Raspberry Pi 4 Model B (DT)
[   14.947969] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   14.955031] pc : vc5_hdmi_reset+0x1f4/0x234 [vc4]
[   14.959837] lr : vc5_hdmi_reset+0x38/0x234 [vc4]
[   14.964548] sp : ffff80000a7b3640
[   14.967902] x29: ffff80000a7b3640 x28: 0000000000000000 x27: ffff000056c35080
[   14.975140] x26: ffff80000136db78 x25: ffff80000136e078 x24: 0000000000000000
[   14.976233] Bluetooth: HCI UART protocol Intel registered
[   14.982376] x23: ffff000058479000 x22: ffff0000fb836da0 x21: ffff000056c35c90
[   14.982383] x20: 0000000000000000 x19: ffff000056c35080 x18: 0000000000000014
[   14.982389] x17: 00000000f19a3ea9 x16: 00000000b24d2d64 x15: 000000006490e735
[   14.982396] x14: 0000000000000000 x13: 00000000d43c985e x12: 00000000f1020f23
[   14.982402] x11: 00000000d1b738e5 x10: ffff8400035fbc7f x9 : ffff800001357768
[   14.982408] x8 : 0101010101010101 x7 : 0000000000000000 x6 : ffff000055ade180
[   14.982414] x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
[   14.982420] x2 : 0000000000000001 x1 : 0000000000000002 x0 : ffff80000136f7f0
[   15.026130] Bluetooth: HCI UART protocol Broadcom registered
[   15.031261]
[   15.031263] Call trace:
[   15.031265]  vc5_hdmi_reset+0x1f4/0x234 [vc4]
[   15.041432] Bluetooth: HCI UART protocol QCA registered
[   15.045761]  vc4_hdmi_runtime_resume+0x74/0x2d0 [vc4]
[   15.045798]  vc4_hdmi_bind+0x244/0xa60 [vc4]
[   15.074641]  component_bind_all+0x114/0x26c
[   15.078887]  vc4_drm_bind+0x1d8/0x2c0 [vc4]
[   15.083159]  try_to_bring_up_aggregate_device+0x200/0x2d4
[   15.085085] Bluetooth: HCI UART protocol AG6XX registered
[   15.088635]  component_master_add_with_match+0xcc/0x110
[   15.088639]  vc4_platform_drm_probe+0xc8/0x100 [vc4]
[   15.104457]  platform_probe+0x74/0xd0
[   15.108169]  really_probe+0x180/0x3cc
[   15.111881]  __driver_probe_device+0x11c/0x190
[   15.114311] Bluetooth: HCI UART protocol Marvell registered
[   15.116384]  driver_probe_device+0x44/0xf4
[   15.116390]  __driver_attach+0xd8/0x1b0
[   15.116396]  bus_for_each_dev+0x7c/0xe0
[   15.116401]  driver_attach+0x30/0x40
[   15.116406]  bus_add_driver+0x154/0x240
[   15.116410]  driver_register+0x84/0x140
[   15.116416]  __platform_driver_register+0x34/0x40
[   15.116419]  vc4_drm_register+0x60/0x1000 [vc4]
[   15.154701]  do_one_initcall+0x50/0x2c0
[   15.158590]  do_init_module+0x50/0x260
[   15.162391]  load_module+0x2298/0x2720
[   15.166189]  __do_sys_finit_module+0xac/0x12c
[   15.170604]  __arm64_sys_finit_module+0x2c/0x40
[   15.175196]  invoke_syscall+0x50/0x120
[   15.178995]  el0_svc_common.constprop.0+0x6c/0x1a0
[   15.183851]  do_el0_svc+0x30/0x90
[   15.187208]  el0_svc+0x30/0xd0
[   15.190301]  el0t_64_sync_handler+0x10c/0x140
[   15.194715]  el0t_64_sync+0x1a0/0x1a4
[   15.198424] ---[ end trace 0000000000000000 ]---
[   15.203150] ------------[ cut here ]------------

I can see similar trace with hung task of systemd-udevd in
v5.15.61-rc1 also, but not the other warning.

I am on holiday, might not be able to bisect to find the offending commit.


-- 
Regards
Sudip

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1381E2426
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 16:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgEZOdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 10:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgEZOdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 10:33:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF88C03E96D
        for <stable@vger.kernel.org>; Tue, 26 May 2020 07:33:18 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q2so24735528ljm.10
        for <stable@vger.kernel.org>; Tue, 26 May 2020 07:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XNs/z+HzuB59iVLQSidnn2zWHlhMfuK3vNWUtRr6ws=;
        b=AJNSGDSfNLMhfW8MR4WMSxN7shbZzwvsA+SgXkvOo9gLJlrq/DvslmSb3llnMoHN+2
         N07foBDeOt5oRmNg5k5/a4ShmiPB3Q6DsA+3nLPAniHEdspTxJ53jt4oeuS/X35T5BNX
         Id2psjRd0f7exkYRf0M7MfCw3R9B6yQjRINOyIBI9yWRptDxCq/h/NimyA7hfW5P918O
         upR2l+WMr4Y0BG85jYPVIuGe0K1wGOq0RlbLnt1+2ZVhRXSl4uzx9+AbVDWFg9jZnExm
         QaPcayNeEuKyDBCxGLPetjvs4yL7AwOF0yy6g1gVjVUiVC08IYZHLbIGiSg/F65c1Xs8
         4aWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0XNs/z+HzuB59iVLQSidnn2zWHlhMfuK3vNWUtRr6ws=;
        b=XyCvGDGNfrJbKFK00II9LgzdQqYwAUOIO5hxSfiO6iaI8pLbQPDQmKcdfaluXaqMxN
         mboEFAP61VYWfxVt72WNcl2lhmmiAGnfdFW5U0+m9HR90yIMaQ6GD8mthgW+py6qyDla
         Tp08a31DoycrtwwN6On5/1F15Gboojr91cURcqEuk0idEnoDfKCy5+hZA2J2ckglcSF5
         yYS0XTR2JIN4P6mmyWZccWAVovQCbqP7fZBeGe4FL6h22Rw+HP1NlViIuLBDgT84/lF8
         Sc5hVshxD14ssfm9hT0zaRiBWDOHDiliU2hc8zxlydss8eJ5rgs8l/vCXNvhrp6VLP7d
         xwtg==
X-Gm-Message-State: AOAM533kOY2PqSsHnDEarXnjffZGMk9Fxxy020C4isLMq+mRLLmcLYSW
        Xl+iYCBQdhLwlOZomt36osCng9vVlNosYGKGmLaxZQ==
X-Google-Smtp-Source: ABdhPJy0M6RjEyOLU2xO6uFHuus18qBN6s4gGcKzjgHFed2Oc1kL0YHpAX+ZT7CNHuAUNct3HxtD8lY7RTBQrIYFabk=
X-Received: by 2002:a2e:9b4f:: with SMTP id o15mr709223ljj.358.1590503596476;
 Tue, 26 May 2020 07:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115508.284500414@linuxfoundation.org> <20200411115513.709554942@linuxfoundation.org>
 <OSAPR01MB366788E02572D95F246D6DEC92DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
 <20200413082137.GB2792388@kroah.com> <CA+G9fYsq5uADdbUG9RnVYOpmbGX+uEVRC-R6wfPCNtCgTyrj8w@mail.gmail.com>
 <OSAPR01MB36677B25C6FE12897832B3DD92D20@OSAPR01MB3667.jpnprd01.prod.outlook.com>
In-Reply-To: <OSAPR01MB36677B25C6FE12897832B3DD92D20@OSAPR01MB3667.jpnprd01.prod.outlook.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 20:03:04 +0530
Message-ID: <CA+G9fYs2gucSrOanDB=CPm+RYH=QOaPeuExGmq0Qcrh5sVaciw@mail.gmail.com>
Subject: Re: [PATCH 4.19 50/54] drm/msm: stop abusing dma_map/unmap for cache
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, swboyd@chromium.org,
        jcrouse@codeaurora.org, Rob Clark <robdclark@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Lee Jones <lee.jones@linaro.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Apr 2020 at 05:03, <nobuhiro1.iwamatsu@toshiba.co.jp> wrote:
<trim>
>
> I think the following patch is needed for this.
>
> 9f614197c744002f9968e82c649fdf7fe778e1e7
> 3de433c5b38af49a5fc7602721e2ab5d39f1e69c
>
> But I have no environment to check this now.

The above suggested two patches already in stable-rc 4.19 branch
but i still notice Internal error: Oops: 96000144 [#1] PREEMPT SMP
on arm64 qualcomm dragonboard-410c device while booting.

[    7.906343] msm 1a00000.mdss: bound 1a98000.dsi (ops dsi_ops [msm])
[    7.912697] adreno 1c00000.gpu: 1c00000.gpu supply vdd not found,
using dummy regulator
[    7.918567] adreno 1c00000.gpu: Linked as a consumer to regulator.0
[    7.926521] adreno 1c00000.gpu: 1c00000.gpu supply vddcx not found,
using dummy regulator
[    7.932759] msm 1a00000.mdss: A306: using IOMMU
[    7.941207] Unable to handle kernel paging request at virtual
address ffffffff80000000
[    7.945375] Mem abort info:
[    7.953353]   ESR = 0x96000144
[    7.956034]   Exception class = DABT (current EL), IL = 32 bits
[    7.970501]   EA = 0, S1PTW = 0
[    7.970516] Data abort info:
[    7.972485]   ISV = 0, ISS = 0x00000144
[    7.975577]   CM = 1, WnR = 1
[    7.979169] swapper pgtable: 4k pages, 48-bit VAs, pgdp = (____ptrval____)
[    7.982295] [ffffffff80000000] pgd=0000000000000000
[    7.989099] Internal error: Oops: 96000144 [#1] PREEMPT SMP
[    7.993802] Modules linked in: msm(+) crc32_ce adv7511 cec
mdt_loader drm_kms_helper drm drm_panel_orientation_quirks fuse
[    7.999367] Process systemd-udevd (pid: 2849, stack limit =
0x(____ptrval____))
[    8.010474] CPU: 1 PID: 2849 Comm: systemd-udevd Not tainted
4.19.125-rc1-00077-g0708fb235b9c #1
[    8.017677] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    8.026703] pstate: 80000005 (Nzcv daif -PAN -UAO)
[    8.033390] pc : __clean_dcache_area_poc+0x20/0x38
[    8.037998] lr : __swiotlb_sync_sg_for_device+0x74/0xa0
[    8.038001] sp : ffff00000e313490
[    8.038004] x29: ffff00000e313490 x28: 0000000000000001
[    8.038009] x27: ffff000000d56e40 x26: ffff800036301000
[    8.038013] x25: ffff80003c108410 x24: ffff000009069998
[    8.038018] x23: ffff80003c108810 x22: 0000000000000000
[    8.038023] x21: 0000000000000001 x20: 0000000000000001
[    8.038027] x19: ffff80003acd4480 x18: ffff0000092298c8
[    8.038032] x17: 0000000000000000 x16: 0000000000000000
[    8.038036] x15: 0000000000000010 x14: ffffffffffffffff
[    8.038042] x13: ffff0000893987d7 x12: 0000000000000000
[    8.038046] x11: 0000800036c56000 x10: ffff8000362ef368
[    8.038050] x9 : 0000000000001000 x8 : ffff7e0000e71640
[    8.038055] x7 : 0000000000000001 x6 : 0000000000000000
[    8.038059] x5 : 0000000000000000 x4 : ffffffff80000000
[    8.038064] x3 : 000000000000003f x2 : 0000000000000040
[    8.038068] x1 : ffffffff80001000 x0 : ffffffff80000000
[    8.038072] Call trace:
[    8.038078]  __clean_dcache_area_poc+0x20/0x38
[    8.038204]  get_pages+0x1cc/0x240 [msm]
[    8.038327]  msm_gem_get_iova+0x94/0x138 [msm]
[    8.141741]  _msm_gem_kernel_new+0x40/0xb0 [msm]
[    8.145989]  msm_gem_kernel_new+0x10/0x18 [msm]
[    8.150759]  msm_gpu_init+0x300/0x568 [msm]
[    8.155004]  adreno_gpu_init+0x14c/0x268 [msm]
[    8.159171]  a3xx_gpu_init+0x7c/0x108 [msm]
[    8.163682]  adreno_bind+0x144/0x238 [msm]
[    8.167676]  component_bind_all+0x110/0x278
[    8.171939]  msm_drm_bind+0x104/0x760 [msm]
[    8.175921]  try_to_bring_up_master+0x14c/0x1b0
[    8.180086]  component_master_add_with_match+0xc0/0x100
[    8.184697]  msm_pdev_probe+0x280/0x320 [msm]
[    8.189810]  platform_drv_probe+0x50/0xa0
[    8.194322]  really_probe+0x1f4/0x290
[    8.198314]  driver_probe_device+0x54/0xe8
[    8.201960]  __driver_attach+0xe0/0xe8
[    8.205952]  bus_for_each_dev+0x70/0xb8
[    8.209685]  driver_attach+0x20/0x28
[    8.213417]  bus_add_driver+0x1a0/0x210
[    8.217237]  driver_register+0x60/0x110
[    8.220797]  __platform_driver_register+0x44/0x50
[    8.224717]  msm_drm_register+0x54/0x68 [msm]
[    8.229479]  do_one_initcall+0x54/0x154
[    8.233819]  do_init_module+0x54/0x1c8
[    8.237463]  load_module+0x1bf4/0x2190
[    8.241282]  __se_sys_finit_module+0xb8/0xc8
[    8.245016]  __arm64_sys_finit_module+0x18/0x20
[    8.249445]  el0_svc_common+0x70/0x168
[    8.253695]  el0_svc_handler+0x2c/0x80
[    8.257514]  el0_svc+0x8/0xc
[    8.261250] Code: 9ac32042 8b010001 d1000443 8a230000 (d50b7e20)
[    8.264290] ---[ end trace 2effae58ca65f06b ]---

on stable-rc 4.19 branch git log show this info,
$ git log  --oneline drivers/gpu/drm/msm/msm_gem.c | head
05fe33cad985 drm/msm: Use the correct dma_sync calls harder
39718d086d9b drm/msm: Use the correct dma_sync calls in msm_gem
9c23e00804f8 drm/msm: stop abusing dma_map/unmap for cache
a5f74ec7d3cb gpu: drm: msm: Change return type to vm_fault_t
3976626ea3d2 drm/msm: Fix possible null dereference on failure of get_pages()
d71b6bd80d96 drm/msm/dsi: fix direct caller of msm_gem_free_object()
dc9a9b32053e drm/msm: Replace gem_object deprecated functions
62e3a3e342af drm/msm: fix leak in failed get_pages
7a88cbd8d65d Backmerge tag 'v4.14-rc7' into drm-next
fad33f4b1073 drm/msm: add special _get_vaddr_active() for cmdstream dumps

link to full boot log,
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.124-77-g0708fb235b9c/testrun/1450572/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.124-77-g0708fb235b9c/testrun/1450572

Kernel config:
https://builds.tuxbuild.com/Xp5Fh9e52QxohQeW6nazPA/kernel.config

>
> Best regards,
>   Nobuhiro
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C422292785
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 14:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgJSMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 08:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgJSMks (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 08:40:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695B5C0613CE;
        Mon, 19 Oct 2020 05:40:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f21so10132222wml.3;
        Mon, 19 Oct 2020 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KD+BMUqlL8wKcvAQHjeqQa4AlxPbqLKdwN0aw33PDWE=;
        b=ZuKx3pskOFIhNVzrkDHvjM49ZIGxQ76XGRnQWJmbTBXZfYiX1LDzdRcdCPFKE1++f+
         Sp96erK2VvPAg7tm4VHmdIP8kxJzZDhU+93j2iB1u2YDLpphjMnYgx6aNIdRkM3/8WoB
         svK9c2enlSaP81dcmJbtt7R3ZHXvu+Niu9Hma6oA29KSaFmhCIvs90tbN+WKwWbFAxmu
         wSTQzpujp6HuB5qp9tcfeG4xME3lLSa5TQWS/fz0YEs8SNBzE5V0FVWavzbiZLAEBMqF
         81lJI1Gv/fA5FotsOS4j+3XMTIf4dXzfWILCwn89429kUNNYEEOCUzUK3sBOjvxhzksZ
         xkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KD+BMUqlL8wKcvAQHjeqQa4AlxPbqLKdwN0aw33PDWE=;
        b=SUI0BqCmmRcvJk03BuevJ+7QngdtKUcAHhAqSCZ6jvXZnMjK1AsWJ6tn4AKyjqug9E
         +/gdNA5VFWkcjbxXYairVMaLda/VDL6422PobNUFRgm+1Y2ZhYplivZ4T4sCFZ/a2+7U
         +X4dbNb8/JjKvMQxdA+7rD4qr0YhhjdoimGvUZB/K4hSBa5HQXsHDkCRuPl3pJkoAZLX
         CmIWTOX8AecdDnL+sgvX6ZBPEfa2UeUDRaHQpl1kdtU4YFdG1AW+D6urpeaWAcoJHDvK
         Cgj6gCRNYSRcTFv+0dzKgIm8i+s4sqjUHD4OYYJVf7aN7hWyIgUgtMyi82wmzVS3bOO4
         G5Xw==
X-Gm-Message-State: AOAM531+3fKQIAET/Y8xxIN7dAxQ7o9R1y4Fqv7B0RJ7YZoKq9GdRQiV
        2AwThKG8OLGxsAXmuxJ0sKXtxvsjZpN/ikwTuXo=
X-Google-Smtp-Source: ABdhPJz8b4JCtuKc4oS7EITtuMlo5x0b6+dBRcrE7oyGxznW6BSmG1BTTBjwCyZGUZlhONL0O17463CJLalJFiDsqns=
X-Received: by 2002:a1c:4b05:: with SMTP id y5mr2614165wma.56.1603111247144;
 Mon, 19 Oct 2020 05:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201018191807.4052726-1-sashal@kernel.org> <20201018191807.4052726-90-sashal@kernel.org>
In-Reply-To: <20201018191807.4052726-90-sashal@kernel.org>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 19 Oct 2020 08:40:36 -0400
Message-ID: <CADnq5_PeOWc_=w4aChDX=SyYH+kFggn2wrJZOzxbnGOTobZ3EQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.9 090/111] drm/amd/display: Fix a list corruption
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "for 3.8" <stable@vger.kernel.org>,
        xinhui pan <xinhui.pan@amd.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Feifei Xu <FeifeiXu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 18, 2020 at 3:19 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: xinhui pan <xinhui.pan@amd.com>
>
> [ Upstream commit 1545fbf97eafc1dbdc2923e58b4186b16a834784 ]
>
> Remove the private obj from the internal list before we free aconnector.
>
> [   56.925828] BUG: unable to handle page fault for address: ffff8f84a870a560
> [   56.933272] #PF: supervisor read access in kernel mode
> [   56.938801] #PF: error_code(0x0000) - not-present page
> [   56.944376] PGD 18e605067 P4D 18e605067 PUD 86a614067 PMD 86a4d0067 PTE 800ffff8578f5060
> [   56.953260] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
> [   56.958815] CPU: 6 PID: 1407 Comm: bash Tainted: G           O      5.9.0-rc2+ #46
> [   56.967092] Hardware name: System manufacturer System Product Name/PRIME Z390-A, BIOS 1401 11/26/2019
> [   56.977162] RIP: 0010:__list_del_entry_valid+0x31/0xa0
> [   56.982768] Code: 00 ad de 55 48 8b 17 4c 8b 47 08 48 89 e5 48 39 c2 74 27 48 b8 22 01 00 00 00 00 ad de 49 39 c0 74 2d 49 8b 30 48 39 fe 75 3d <48> 8b 52 08 48 39 f2 75 4c b8 01 00 00 00 5d c3 48 89 7
> [   57.003327] RSP: 0018:ffffb40c81687c90 EFLAGS: 00010246
> [   57.009048] RAX: dead000000000122 RBX: ffff8f84ea41f4f0 RCX: 0000000000000006
> [   57.016871] RDX: ffff8f84a870a558 RSI: ffff8f84ea41f4f0 RDI: ffff8f84ea41f4f0
> [   57.024672] RBP: ffffb40c81687c90 R08: ffff8f84ea400998 R09: 0000000000000001
> [   57.032490] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000006
> [   57.040287] R13: ffff8f84ea422a90 R14: ffff8f84b4129a20 R15: fffffffffffffff2
> [   57.048105] FS:  00007f550d885740(0000) GS:ffff8f8509600000(0000) knlGS:0000000000000000
> [   57.056979] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   57.063260] CR2: ffff8f84a870a560 CR3: 00000007e5144001 CR4: 00000000003706e0
> [   57.071053] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   57.078849] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   57.086684] Call Trace:
> [   57.089381]  drm_atomic_private_obj_fini+0x29/0x82 [drm]
> [   57.095247]  amdgpu_dm_fini+0x83/0x170 [amdgpu]
> [   57.100264]  dm_hw_fini+0x23/0x30 [amdgpu]
> [   57.104814]  amdgpu_device_fini+0x1df/0x4fe [amdgpu]
> [   57.110271]  amdgpu_driver_unload_kms+0x43/0x70 [amdgpu]
> [   57.116136]  amdgpu_pci_remove+0x3b/0x60 [amdgpu]
> [   57.121291]  pci_device_remove+0x3e/0xb0
> [   57.125583]  device_release_driver_internal+0xff/0x1d0
> [   57.131223]  device_release_driver+0x12/0x20
> [   57.135903]  pci_stop_bus_device+0x70/0xa0
> [   57.140401]  pci_stop_and_remove_bus_device_locked+0x1b/0x30
> [   57.146571]  remove_store+0x7b/0x90
> [   57.150429]  dev_attr_store+0x17/0x30
> [   57.154441]  sysfs_kf_write+0x4b/0x60
> [   57.158479]  kernfs_fop_write+0xe8/0x1d0
> [   57.162788]  vfs_write+0xf5/0x230
> [   57.166426]  ksys_write+0x70/0xf0
> [   57.170087]  __x64_sys_write+0x1a/0x20
> [   57.174219]  do_syscall_64+0x38/0x90
> [   57.178145]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Signed-off-by: xinhui pan <xinhui.pan@amd.com>
> Acked-by: Feifei Xu <Feifei Xu@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This ended up getting reverted.  Please drop this one.

Alex


> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index a717a4904268e..57ad6450e20b2 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -4882,6 +4882,7 @@ static void amdgpu_dm_connector_destroy(struct drm_connector *connector)
>         struct amdgpu_device *adev = connector->dev->dev_private;
>         struct amdgpu_display_manager *dm = &adev->dm;
>
> +       drm_atomic_private_obj_fini(&aconnector->mst_mgr.base);
>  #if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) ||\
>         defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
>
> --
> 2.25.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

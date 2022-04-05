Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5224D4F47D0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244055AbiDEVV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445473AbiDEPnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80E23EFF99
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 07:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649167738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mhz+GXQ+F2knkdpN0pkRBKF5Bk9810pqXm8/F3H4YU=;
        b=dhEXXXCvo/xMkwHm+pqquQWeVnXp5VeenkQWWwDhhESyLAQEdKZ4pUPEMJuMWLoeZSUpQm
        qrgJKIZHXALdLRvnzkXur4CLuajNHfhlJGpF4yFWWHf41dgU1G3G9/NRrBpAv8hnlS8r6e
        lAwksdS3fA68U78S0fGi1kfWlxHlH5A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-Ir47hOxKNUC8zit5qaAQ1Q-1; Tue, 05 Apr 2022 10:08:57 -0400
X-MC-Unique: Ir47hOxKNUC8zit5qaAQ1Q-1
Received: by mail-wr1-f72.google.com with SMTP id j67-20020adf9149000000b00203e6b7d151so2500605wrj.13
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 07:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8mhz+GXQ+F2knkdpN0pkRBKF5Bk9810pqXm8/F3H4YU=;
        b=taQJ2euxV+ggax1/jPMVjAhDk2u9KxTpBfVHMfzrVaU34qcdisytcc48qutc3OYngQ
         E7vN3ifwUMk4fAptav8mX77H0uKeA/AXIu4QX5ObZi3v6hWR1cY8Oh5wAza65RIYShEf
         6zxvy9hdlwmoelLLES+H0pWZpduJAsja30vkJs7jwOFwU5J36eEz5OMWlvUx90C3Ea2Y
         ZkpQgbXHB3/nbT+9Qx0XUzCNiRe1jNoCRL1GzNrPIzKfDHzM4KUixkCO3dcMv51dNNr5
         Wyeg358EzeWjTBxalKM/ABRjNuQbUMTwmFwfywP1O29DJAjmiDKmbb+HYLZnvWgSiuwa
         LObg==
X-Gm-Message-State: AOAM530qQXz2PFetsHPtL2sk1Aq2eZwHRIoZ32ADqnLxY1sAZyuFNKsT
        Je7QiskdMJTIlUVN5ngzJDeb2mnVvHfBgTEedPr4aDYMu21/LZUYJgzE9PaaTJjOCeN7IbmZH8t
        LWqyweOxOVK3ICBRu
X-Received: by 2002:a1c:f009:0:b0:387:6fea:8ebc with SMTP id a9-20020a1cf009000000b003876fea8ebcmr3392251wmb.84.1649167735840;
        Tue, 05 Apr 2022 07:08:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/wWlhf9Si4RyvlIN45Pe3xd7Dy+0JTdGwgBD+8q6PFh7Firoxt7BiM/k5LjLGK5Ogtt0T1Q==
X-Received: by 2002:a1c:f009:0:b0:387:6fea:8ebc with SMTP id a9-20020a1cf009000000b003876fea8ebcmr3392230wmb.84.1649167735553;
        Tue, 05 Apr 2022 07:08:55 -0700 (PDT)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id h10-20020adf9cca000000b002061b07f6f8sm2856521wre.88.2022.04.05.07.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:08:55 -0700 (PDT)
Message-ID: <d843bbb8-8632-62a7-4447-719dcd3a0582@redhat.com>
Date:   Tue, 5 Apr 2022 16:08:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] fbdev: Fix unregistering of framebuffers without device
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        deller@gmx.de, sudipm.mukherjee@gmail.com, sam@ravnborg.org,
        zackr@vmware.com, hdegoede@redhat.com
Cc:     linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zheyu Ma <zheyuma97@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Guenter Roeck <linux@roeck-us.net>
References: <20220404194402.29974-1-tzimmermann@suse.de>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220404194402.29974-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Thomas,

On 4/4/22 21:44, Thomas Zimmermann wrote:
> OF framebuffers do not have an underlying device in the Linux
> device hierarchy. Do a regular unregister call instead of hot
> unplugging such a non-existing device. Fixes a NULL dereference.
> An example error message on ppc64le is shown below.
> 
>   BUG: Kernel NULL pointer dereference on read at 0x00000060
>   Faulting instruction address: 0xc00000000080dfa4
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
>   [...]
>   CPU: 2 PID: 139 Comm: systemd-udevd Not tainted 5.17.0-ae085d7f9365 #1
>   NIP:  c00000000080dfa4 LR: c00000000080df9c CTR: c000000000797430
>   REGS: c000000004132fe0 TRAP: 0300   Not tainted  (5.17.0-ae085d7f9365)
>   MSR:  8000000002009033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 28228282  XER: 20000000
>   CFAR: c00000000000c80c DAR: 0000000000000060 DSISR: 40000000 IRQMASK: 0
>   GPR00: c00000000080df9c c000000004133280 c00000000169d200 0000000000000029
>   GPR04: 00000000ffffefff c000000004132f90 c000000004132f88 0000000000000000
>   GPR08: c0000000015658f8 c0000000015cd200 c0000000014f57d0 0000000048228283
>   GPR12: 0000000000000000 c00000003fffe300 0000000020000000 0000000000000000
>   GPR16: 0000000000000000 0000000113fc4a40 0000000000000005 0000000113fcfb80
>   GPR20: 000001000f7283b0 0000000000000000 c000000000e4a588 c000000000e4a5b0
>   GPR24: 0000000000000001 00000000000a0000 c008000000db0168 c0000000021f6ec0
>   GPR28: c0000000016d65a8 c000000004b36460 0000000000000000 c0000000016d64b0
>   NIP [c00000000080dfa4] do_remove_conflicting_framebuffers+0x184/0x1d0
>   [c000000004133280] [c00000000080df9c] do_remove_conflicting_framebuffers+0x17c/0x1d0 (unreliable)
>   [c000000004133350] [c00000000080e4d0] remove_conflicting_framebuffers+0x60/0x150
>   [c0000000041333a0] [c00000000080e6f4] remove_conflicting_pci_framebuffers+0x134/0x1b0
>   [c000000004133450] [c008000000e70438] drm_aperture_remove_conflicting_pci_framebuffers+0x90/0x100 [drm]
>   [c000000004133490] [c008000000da0ce4] bochs_pci_probe+0x6c/0xa64 [bochs]
>   [...]
>   [c000000004133db0] [c00000000002aaa0] system_call_exception+0x170/0x2d0
>   [c000000004133e10] [c00000000000c3cc] system_call_common+0xec/0x250
> 
> The bug [1] was introduced by commit 27599aacbaef ("fbdev: Hot-unplug
> firmware fb devices on forced removal"). Most firmware framebuffers
> have an underlying platform device, which can be hot-unplugged
> before loading the native graphics driver. OF framebuffers do not
> (yet) have that device. Fix the code by unregistering the framebuffer
> as before without a hot unplug.
>

I believe the assumption that all firmware fb would have an underlying
device was a reasonable one and it's a pity that offb doesn't...

But that is how things are and your patch is the least intrusive fix.
 
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat


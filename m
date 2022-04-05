Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46324F3F4A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbiDEOfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 10:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384976AbiDEOSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 10:18:37 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119DB90CF3;
        Tue,  5 Apr 2022 06:05:50 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1604718wmz.4;
        Tue, 05 Apr 2022 06:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OoGrDH7nK9oFjsVTIEbOFtr4JmfdoVI2IyJ2wjIRyw=;
        b=bwrq0C1ajirhKSzPeBMF9M4xumTAECxTEkjAVIr9N/f/e13Ws70HiJje2vSD+LozFa
         WUKJttLtri9u8/VPFQ2yn2Kkj0BQy1trEq672pajS5zZ/h1OQ6nKRlGo0D03FrtkyN4H
         Y0bN8C0MwXLOOCzJf+mdEvBEreMuYHq2M+zd0TjqMEAcIwaUmgwUV6GfFt9qt+tzpHxQ
         9gUZLRS0Fk5mCX7CEFWx7sVga6DYaeYUQxz4S4fcCrhGOy+RdDXIbu6N9B5MQQguGj1m
         zKgbRV3tdh3m78Oo3Qi0QwtP8oq301EPtUHMoYxmcZ9W7sNBWZSEljuxnga2xR+tUrBU
         2DAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OoGrDH7nK9oFjsVTIEbOFtr4JmfdoVI2IyJ2wjIRyw=;
        b=zf+BPAt4X7IdBIOf+l3NHv+JKYGsFy3H6CEd3lVL2yl0c4JzIoAf3EE+aUkThidlEs
         BFHkTZzGKNZY2H3J1Bbu22ZrNQBkmtFsOvcre35FcHEnkH3mbBLVWY/fx33gz4xfuJrs
         zuHOKGZSxPlcUKIpocP5jO3IWO3U+QfjrryTOWHDCTwKvjpbUSAxCzSNvmlFtaXSpWts
         TCZ7uDIGvzws5NFvV/reV0DV2zDzEEhHwiDG8wdD8kW2puM4Jm7/lSXmkLlJ+QC16qwr
         MGJGZZ8aSjyXmt5v/eR4dXPIqV+zX/v3+yQNGvaA8eKBM3ex8mJ86jHt/Zc8MuFKUhhj
         pJ/A==
X-Gm-Message-State: AOAM533XS/NqRYmr1whMYbaAl7V7+R8Q+Nwmhz3E6eamnWHNDFJ40UPc
        A9aWrseiFDM8sHrBHmMq83Y=
X-Google-Smtp-Source: ABdhPJwlDd/JO2QncqV+Qg7YsvFj5rwcuVsPA18gfL0PHrdH/061R20sU1lTWEubutb8Zv6bVjYCWg==
X-Received: by 2002:a05:600c:4e92:b0:38c:73e8:7dcd with SMTP id f18-20020a05600c4e9200b0038c73e87dcdmr3141891wmq.196.1649163948642;
        Tue, 05 Apr 2022 06:05:48 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id b8-20020a05600c4e0800b0038c6c37efc3sm2099463wmq.12.2022.04.05.06.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:05:48 -0700 (PDT)
Date:   Tue, 5 Apr 2022 14:05:46 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, deller@gmx.de, sam@ravnborg.org,
        javierm@redhat.com, zackr@vmware.com, hdegoede@redhat.com,
        linux-fbdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Zheyu Ma <zheyuma97@gmail.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: fbdev: Fix unregistering of framebuffers without device
Message-ID: <Ykw+qlW+bjWcy4BR@debian>
References: <20220404194402.29974-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404194402.29974-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 09:44:02PM +0200, Thomas Zimmermann wrote:
> OF framebuffers do not have an underlying device in the Linux
> device hierarchy. Do a regular unregister call instead of hot
> unplugging such a non-existing device. Fixes a NULL dereference.
> An example error message on ppc64le is shown below.
> 

<snip>

> 
> Tested with 5.17 on qemu ppc64le emulation.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 27599aacbaef ("fbdev: Hot-unplug firmware fb devices on forced removal")
> Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Cc: Zack Rusin <zackr@vmware.com>
> Cc: Javier Martinez Canillas <javierm@redhat.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: stable@vger.kernel.org # v5.11+
> Cc: Helge Deller <deller@gmx.de>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Zheyu Ma <zheyuma97@gmail.com>
> Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-fbdev@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Link: https://lore.kernel.org/all/YkHXO6LGHAN0p1pq@debian/ # [1]
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

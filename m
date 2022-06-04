Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED5B53D831
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbiFDSy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbiFDSyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:54:53 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C364D9C0;
        Sat,  4 Jun 2022 11:54:52 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id r14-20020a056830418e00b0060b8da9ff75so7816165otu.11;
        Sat, 04 Jun 2022 11:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8g0AYziHM2oNW5FeTAwJ8iGrpGUV2WZjWfUeVr1dzi0=;
        b=TVx9QF1ECzZsUNRlxWD5jFJSm6/3bOlIs9aeKrVSikDMGAP2YlMteE2DvhpR7VWZYj
         zCmDkH8sTNM4Ne1b/PRuO2/aI64dKFnqyYBp4XSjO4DrMk9G9M4KfBX8Dd7/cvTLb7dC
         axlpXcW3u9HleqC4KJXftZjV7gFNKe62ej+idh+qZuJU/YDE40oykEu+vlPM/tmtxh6n
         H9MH/G3R/KKz+IHhE7+i9UkfVklniP1fDrFwIO1aRkgf6KwVPKCGsu0kJNBPQAVd5re4
         b7QZc0OrQg2JNjl9ef1ZMV88iHLaOge3xmaj5hiCX5x1Pn0wjpmrou5tdlZ4VKHALeI+
         ypJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8g0AYziHM2oNW5FeTAwJ8iGrpGUV2WZjWfUeVr1dzi0=;
        b=cuwMmWhVAWB9la7ll2z1Ve0SlL8yYT61+vHxaBhaSuKCGymgzuYTAYNi9jzAtGepOX
         RLG8PxdK4bYuz9tmIKuh0EukA/Pj5iNcPkiaoRxs516ZLC4hbC4xTpsrCul5bwU8s/0w
         DMUqzDCNfpKL7axRRLomRkHM987A8PesV5JMbiKQVobTADcQS9FjEF3Q++ANMkob6C5h
         HgFyCCxDxlHZRatUh4CcoZGOb+/m3uIMe4CR2jKTWQ8mNsYXw1O3rYbDKKtupoLPkkqL
         PYqmoPITx2Af7jfJ4RwV5XHNHDT6wt9VqdLpwOixCuyeFfyo/7eAcjxlCQRmMACZnMd8
         Vk3w==
X-Gm-Message-State: AOAM530xfIGr33MxX0zn2Swsea9r4+/8O6IFwxAljWMKL9SUTbCzEbhz
        rxVd0Ibdjf7CeQX8B+J4l7I=
X-Google-Smtp-Source: ABdhPJy2xsUDOOfncaBxNeg0imEXPxO/TSUOqlSLzW2bbdj+1QGzk/fUyXYyJBN3Dx5nbbCbr3PNtA==
X-Received: by 2002:a05:6830:40c5:b0:60a:feb3:4986 with SMTP id h5-20020a05683040c500b0060afeb34986mr6623916otu.251.1654368891951;
        Sat, 04 Jun 2022 11:54:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fo10-20020a0568709a0a00b000f342d078fasm5384693oab.52.2022.06.04.11.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:54:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:54:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/34] 5.4.197-rc1 review
Message-ID: <20220604185450.GD3955081@roeck-us.net>
References: <20220603173815.990072516@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:42:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.197 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

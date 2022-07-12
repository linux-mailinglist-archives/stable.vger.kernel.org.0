Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610AC5712E3
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 09:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiGLHOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 03:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiGLHOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 03:14:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB6B6EEB6
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:14:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p9so6844400pjd.3
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 00:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KMreW5eGuFVvOYr05yXN/MmRKeCw6m+Yo80wN8GeX2g=;
        b=Y0NLuwIaUmmT9xp6Aj1li2W+gPligTJllQnBREwnfOaCF1octg2rwTpCoMUjN6rTua
         s0efPXxeseIBb8WOW+mIlA35ns4qrzHL0GjhYLuNW/glGCOK1Xz7WrEx0ZX6gVe4dtL/
         5cvBZEt4ywK5EODgHtrF9Nu/jq3oXwIAKrxMg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KMreW5eGuFVvOYr05yXN/MmRKeCw6m+Yo80wN8GeX2g=;
        b=T1ehS6dEz0yiHr433D4jIaV+R+ilrz0TtU8L2zIcqmNjQFwVbUOATHzQXoTtsWLjyo
         UVPiC94qS+G/fEbp1lZN3YGvX1GEZ1Xch8oMnBB2Etyg0huuN67SMKSpPsCVopdCrRuf
         q42FMn1GM0/JSMZy8Ij24iCDXyDPs8EA5hVWmsUIVy+xpzr3CNpk5/cWK2HA5Fot2AzV
         HIKJxInpwEOGfEVtaPx5VBooYvqrWxGGF7tuphzVklWQgDDBT52ooKqQVdm8jd8iw/RN
         uD7FVyWLe6V0o/mpP6BCm/Gv7ZovIaQetHh3U5YDKaVtsYTAFW9w0WH5gCmbnSOaI8DM
         SVvQ==
X-Gm-Message-State: AJIora/9pOO2D7ZhQMRt4aPGLZjkj0ycd2qjOxY8/16k4xPNw64ivnOZ
        QchiQOpOf4G9O0QDFLc1f2eQjA==
X-Google-Smtp-Source: AGRyM1vQ0OIKy/h8usrtTKp3KzhRbevhNvjMlpSWVoEX/9ilPzC45+YahgzZ4+tgR3vzHRsZv2BN1w==
X-Received: by 2002:a17:90a:6741:b0:1ef:7f62:6cd1 with SMTP id c1-20020a17090a674100b001ef7f626cd1mr2590182pjm.89.1657610056397;
        Tue, 12 Jul 2022 00:14:16 -0700 (PDT)
Received: from 84a0fe815f2e ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id y22-20020a170902d65600b0016be8d6fc15sm5982822plh.104.2022.07.12.00.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 00:14:15 -0700 (PDT)
Date:   Tue, 12 Jul 2022 07:14:08 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Message-ID: <20220712071408.GA8@84a0fe815f2e>
References: <20220711090549.543317027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:06:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.11-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi

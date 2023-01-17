Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9536E66D862
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 09:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbjAQIkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 03:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbjAQIkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 03:40:37 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C609527D50
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 00:40:35 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c6so32831611pls.4
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 00:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AST8wGQKJArsqYW0kCGPhdVZT3sTkTmujS4WjL+NxjI=;
        b=NgpjJG/PXpBxQj62UCoL4HVIcqRe2KNPmjaQBsKSBPDKMCyRJT7uRiJM0uhkPPyvgT
         +OxRJk/Uczyh4GdZA4gdx9N5hv46pSwLdLXV4r0soC8kyD/TWDnugUWdrgdjhBLUi3Zq
         4RrJvg+Iaw7r2Rt3aKf2zTs+22fZLsaV304H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AST8wGQKJArsqYW0kCGPhdVZT3sTkTmujS4WjL+NxjI=;
        b=QrxWhUzRzEr9y8d6ggxO94Y+oeO9EByfTK3ZPcK6pUiBj6ECaURDhOyk/VFWe/qMGb
         02Wvbp2C3plnxMef9rdw46O1q6iF6rXOWnXNSqw8Bkyi3ZFyx8U/UBk3ohF4ydoB8APN
         WvrpPmNfUGT+CT1mlpUyNAW9YfMfO5lINFns+vy6vemOWdwKhS5nrRpA4ho28Xf32/p+
         ZFW38hyXjPa2fBLQBHR3885bp7Hzjc/SfYhLHbutStuF3kGk9zzHrnK5N+FxLYGYP8G6
         P0HCeArmmz36nAJla1RqlBu9XIgKwyGBL8Z0lmRt9DxPgJOziZBWdfpFOa7K4j4/mWuP
         TpbA==
X-Gm-Message-State: AFqh2kp4CssxHi8zQc6Vrt097H1iNuNpNl1EfsOvKb4PKOhk7e9wVlpD
        iN8PEDEmN6NtN1wEfbmlEX7AHA==
X-Google-Smtp-Source: AMrXdXuPpQNF/nPCZyv4sWaHWIsXo4q/4J5nG2Vi04UxUG6u+WPIGskqjdNLXMuFW2uCNIbn10Gl3A==
X-Received: by 2002:a17:90a:cb84:b0:229:7110:712d with SMTP id a4-20020a17090acb8400b002297110712dmr2303896pju.45.1673944835035;
        Tue, 17 Jan 2023 00:40:35 -0800 (PST)
Received: from 80aa54ac8722 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id fy11-20020a17090b020b00b00219cf5c3829sm248105pjb.57.2023.01.17.00.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 00:40:34 -0800 (PST)
Date:   Tue, 17 Jan 2023 08:40:26 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <20230117084026.GA10@80aa54ac8722>
References: <20230116154803.321528435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.7-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

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

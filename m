Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B1768EF3F
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBHMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 07:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbjBHMnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 07:43:22 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836D849011
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 04:43:19 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mi9so18251129pjb.4
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 04:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O+Wh65jPwZ2iDPb66Pml9WSpf/i3Bn1WviFQSAOELT4=;
        b=Y4ur5YRYEXujDSJhVCJwpIz3CAjiott1io5LCS3/AwwJrwlLDCu1FoLhxV6bWlsOun
         512JfBadYS/fMg0nXIHuc35yHLVGH3tDdeJJQ/IA+ExP2h5VK1RpsP9vS2vXpOH8jFvM
         +7uhedfGNQJNWgFGWaVZW8C+fdCRUHa1sJsXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O+Wh65jPwZ2iDPb66Pml9WSpf/i3Bn1WviFQSAOELT4=;
        b=bIswpXpcCnU17P8FnGUfmI3rAPoDRcXSQPS6s7D4SXNW0bSe2tcHIHhT2fjTal1W7F
         iwXQ55R/klBchXLym34R22N/ughLBQkuUYJYUKBviEsH2U8naPclz2t1Lj1XfZaZQPok
         LNZB0b74qoFZqFGeqLa9R9H+VsImQ0+T+tnM7L8zzyDFx8Zo0LPDn6YdkWjCm2T3DTWD
         FVljrl+K5LXgqW4XoDRciCZDYkRx7QMB6DabuO0iTNHhR/Yd91RHNnpCEUIs9UBaCUwC
         45TmtcSxpDU5uCeEYabDKPMvYqMvBr4EaT3jqF9j8MFb4a8I22oDKrtd2MSnSsKCy9Ms
         CHIw==
X-Gm-Message-State: AO0yUKUUz84UO6rdtZtAfna15YtqNH8UlpgDI5usK5xo3dbpKFG7anR2
        V00RCGzP5ozA97qxcu6kOxw6cA==
X-Google-Smtp-Source: AK7set+QT0GP0bBUPF4ShuI0zGxWoOq0+tBWzazN3oEPqceoWb4lucXU/DFyNSI8XvZmcpxMp+xpww==
X-Received: by 2002:a17:902:e809:b0:198:e4bd:86b6 with SMTP id u9-20020a170902e80900b00198e4bd86b6mr8504271plg.67.1675860198807;
        Wed, 08 Feb 2023 04:43:18 -0800 (PST)
Received: from c5da58673b58 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b00186a2dd3ffdsm10873478plc.15.2023.02.08.04.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 04:43:17 -0800 (PST)
Date:   Wed, 8 Feb 2023 12:43:10 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <20230208124310.GA1940401@c5da58673b58>
References: <20230207125634.292109991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.11-rc1 tested.

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

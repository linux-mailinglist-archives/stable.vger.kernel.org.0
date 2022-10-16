Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A405FFE0B
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 10:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJPIDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 04:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJPIDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 04:03:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC307D91
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 01:02:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i3so8560366pfc.11
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 01:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qBO/QfmaDFqgY4hMMg3RgVZMeyFTpMBn/+nytmYeRzA=;
        b=b4qkaAl19YC0J671p22iv4knuAsPE/xKcMkRLe5d6+Q4M7eBeAY1w7LrDo8JmlpLr/
         JRC7dC3bQvsb7HcM6IqT+i1bjmTStIYHic0AjtGn65VBtt+ANaB9V31701wTzz9txUaZ
         gEqI2sUjTF8pe1BqT58VXtBl5NWqfqRVS8cZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBO/QfmaDFqgY4hMMg3RgVZMeyFTpMBn/+nytmYeRzA=;
        b=JGtl6QVqWEjU68ZOmlRYsm5Lpq12YMntvaXuWJwujBV1AogulBDwKLiTyhR5Hteo/E
         uy+3ArluMsXEoheGjwKjaW4DzuDZtapMgGDx8/rY9B9FaQcjkVwAKsvhrfblVBt/YWpi
         0ghL+X+RhbiKOJpKoKGtTLwMIix3RPRGl+YB9t0CNoMdaZFHdKqE1btH+NQY4XL0fV0l
         X/J+LqRsflWdlssBIfs5qxc1c6BkpK/m0v5Mu/69ZLBzK+2pPtYCCORIN1Lr3tPjiLzM
         OjsyTqCMjnioQ8tsUBBvfjXsbniJFA5pJCKPIveXfsyL9k3uyb8MTmfbvEp1N7+KP1W4
         oUmg==
X-Gm-Message-State: ACrzQf2i1mcrNrNxbKqOblaLKS1Zps3XjkZT4a6LDdH09uKiKYbbe/8a
        PX/++yl/+zh8/QeneJ68p3SVMA==
X-Google-Smtp-Source: AMsMyM59Ji0qViGGQkkJ3ifUZCsmXUfrPLiGWVa1lSuacH5JHa5sznitlewrdwffx8BWM1TtapCZjg==
X-Received: by 2002:a63:4a41:0:b0:452:bab5:156a with SMTP id j1-20020a634a41000000b00452bab5156amr5577957pgl.486.1665907378143;
        Sun, 16 Oct 2022 01:02:58 -0700 (PDT)
Received: from b6e4f220cd61 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id w186-20020a6262c3000000b00561d79f1064sm4614846pfb.57.2022.10.16.01.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 01:02:56 -0700 (PDT)
Date:   Sun, 16 Oct 2022 08:02:49 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
Message-ID: <20221016080249.GA1514195@b6e4f220cd61>
References: <20221016064454.382206984@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 08:46:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.149-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi

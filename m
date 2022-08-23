Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7559EF4F
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 00:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiHWWix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 18:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiHWWiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 18:38:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF295D12C
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:38:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g18so15337489pju.0
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 15:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5DFJelRh8hAibdIhoMcbXDL+2DULmlurhTcXUJAe61U=;
        b=Gh592xm6YznjkVATkRVypJ58c4FBvmtNYI3K1Mp2jR37aBg+Zy/ni4ikRiA1J5KaqZ
         sPgxur3Fi3Fj4pUcvG8gg0wzv6WqgTRQqABErIyEWt5SnktfAnKGXgCesXyu2/7AVfPK
         icQvq5ZmHdieE8yqh2FfprkQdYJcxbzCSNNng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5DFJelRh8hAibdIhoMcbXDL+2DULmlurhTcXUJAe61U=;
        b=y4TU2LCVS47oH6Utsrb0MLpGip15lR3G3gRO1QJUZS7FuFWIrKeVDwGjMBPLA97zx/
         YlZPVpPboo7KFx5MWbeiCPufGm7O10+gNLZ3xzS4EkoBRnfQZXfXbADmfCPCv2oz0PR1
         9DOqi09G4c59U0n2kBN5skluvmsb/lvV+Kx5YkQaW9gXhv8c8UGdBTdfCnbgxy6DEX3y
         EqMkuBWoZ1j5YJB3wcsdvBW9I0WnUsLiyaZ654kUWtmI1j2SBpwrrfFzNsTzKQ/b9g0l
         rkp9Cvs0oQe4SNcbg+Qc3e2R0amNuyeHByo7wGpF27aELWQs7UxkgmgtC71u0M5OEMnE
         RxdA==
X-Gm-Message-State: ACgBeo19BqtCT1fQVDHw8fIp7V1Kok66SWQ/W/mSstv/advKf8Jf+vH5
        u3p1D4kyD7N4hgd7bqzfpVA5Gw==
X-Google-Smtp-Source: AA6agR7m/Kqo8Gdqd6vut3JCmGoK/kH1SvTx0YpevY8mgORzyC0lEpa+RAj0K31TJNZ4f/r/8gWj8w==
X-Received: by 2002:a17:902:c102:b0:172:ce4b:870c with SMTP id 2-20020a170902c10200b00172ce4b870cmr18016683pli.155.1661294326737;
        Tue, 23 Aug 2022 15:38:46 -0700 (PDT)
Received: from b09580aaaea0 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id q4-20020a17090311c400b0016bc947c5b7sm11046533plh.38.2022.08.23.15.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 15:38:46 -0700 (PDT)
Date:   Tue, 23 Aug 2022 22:38:38 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/365] 5.19.4-rc1 review
Message-ID: <20220823223838.GA345371@b09580aaaea0>
References: <20220823080118.128342613@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 09:58:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.4 release.
> There are 365 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Aug 2022 08:00:15 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.19.4-rc1 tested.

Run tested on:
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
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

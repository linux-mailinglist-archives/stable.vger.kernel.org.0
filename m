Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90965559E40
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 18:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiFXQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiFXQHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 12:07:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA28255350
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 09:07:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p5so3225198pjt.2
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 09:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rzqAuoWV3USzxHFuutQ3yIsWUpm5115CLajT1d2mIl4=;
        b=IzUakGXSjYyU0QmuLqEXMF41x3FCabMgcH3I/JltyKtDc2K/e3mvUNIrCDSrs5WZ/w
         SV8eQEljMWHF1SiJsMLP085Na4tfAziUNXW1XEyq2rl2tPzf6dxKfPDhZc0vFZ0+oVBF
         YhPvp8bVBGN/DVmDTg/+/ZNLsPTKfmz/K7Qj0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rzqAuoWV3USzxHFuutQ3yIsWUpm5115CLajT1d2mIl4=;
        b=5BAL7EvybTdiFwG2rrOlFo5LSZ4QKrDUfXbtpGoQjyJvvFf9o/yRLu5D+gt3WwM+Df
         AnyQvT6A3cyKRsEswDptkB7lOnWTY0ql0bFklp/oeK8XwPn4704lPW70cVDEq8HebtLn
         feI1ouL2zzvYXobyrd+rvwA9CaYQ0Kz1+9zZlWIjEqajoAA91UVKiwQizSNfGvABxQso
         R9NaMrz6aksC6n/zNb3ZLvvNP2PoID7RlQDuXkNBd4YvokkcizDUmaYtIdqHDr3nWOnx
         Cmp1iYNVwtX81oOWqSxkYQ467JMO/rr8HMrA2lywVq6M9kIIWjRggaXkwub8cobUj74O
         8Qmg==
X-Gm-Message-State: AJIora8ii9dRBL5SVBJxF+JY9u67VBiLXs8M+LBteQyIE3NnTSaA133M
        eFBZuPP36qNoi9HAtEimjWGNgw==
X-Google-Smtp-Source: AGRyM1trnL+TCF4KBWZPd8kIHvY5gdVVEHSJskPgHg2yowNrFAgES8RtXJZZwey5Qo4Kp6v0Mt2pqw==
X-Received: by 2002:a17:90b:1e06:b0:1ec:b396:7468 with SMTP id pg6-20020a17090b1e0600b001ecb3967468mr4975822pjb.63.1656086846991;
        Fri, 24 Jun 2022 09:07:26 -0700 (PDT)
Received: from 14b1b8af28dc ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id i4-20020a17090332c400b0016a214e4afasm2024671plr.125.2022.06.24.09.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 09:07:26 -0700 (PDT)
Date:   Fri, 24 Jun 2022 16:07:18 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Message-ID: <20220624160718.GA2731020@14b1b8af28dc>
References: <20220623164322.315085512@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 06:45:12PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.7-rc1 tested.

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

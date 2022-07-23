Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3598557ECCC
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 10:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiGWIjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 04:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiGWIjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 04:39:52 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187D948EA4
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 01:39:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id g17so6373844plh.2
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 01:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uyq5TDHOhmXVHPsTps68pWtBrecXqocdN1+EdXeAXOo=;
        b=MERh7izAsRIX18mDFg6bC7iTHjlIYdu6+VE2YpFSk72x0eEQNzW0ZFHO8sH005FD72
         JT2uaPxVQpytSjnTCPOOjatLPPlMhB9zQkFjHHBp6VM5POgzz7LEuujKwjH1SC6W4cnl
         tZ3mz2zR9dqG26rXkATGseyloJa0V9r/2llpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uyq5TDHOhmXVHPsTps68pWtBrecXqocdN1+EdXeAXOo=;
        b=E0DTZvJLlxNYmqbYA5HhyeLJd8gS0AH/GVgpn+4ONy9ywcrY7+m763/9XJjeYE0CSN
         lcWkuECiyg9dp6GNAlsl1KxGkylrpSvcc/OaI+ys/x1PZpmxXg2yDnBFuf62RBgTo196
         /pyx1aNNl21OakGf9UFGa9h+WHV+PJL7tSo+1+9gi6FOLk/ffnKFBH9kQ7rTWAIOFZHi
         26HV+TOuMK3e84kH7FXoI5odaNKHWp93+0wblSkPmlgSqDGVcLqsLFTPWRlgbW5kdnwG
         3LQZmj5to4Oa748V6Fl02k1O9NKrZH/TGwa5gchy8hVcerWIDMw3h++dbhTEZcFzHVEZ
         C1UQ==
X-Gm-Message-State: AJIora9jUD5ncj5hPsRh1DWEiLO0+y9UK9RdZgu2vONRYZ7UaxBIVaQx
        kWk6DIGff6z18Rhgq0qtG6geOA==
X-Google-Smtp-Source: AGRyM1ugWPYoVdDs0ya49oV/J1k37aM0Tuj/KkJXpAibl+cTZlGmcZX4paVLUETPaMVnBbpLQq5Zwg==
X-Received: by 2002:a17:902:e1d3:b0:16d:be5:4b3c with SMTP id t19-20020a170902e1d300b0016d0be54b3cmr3372447pla.8.1658565589403;
        Sat, 23 Jul 2022 01:39:49 -0700 (PDT)
Received: from 65aba7cb18f8 ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id y14-20020aa79e0e000000b0052a8128699fsm5326769pfq.207.2022.07.23.01.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 01:39:48 -0700 (PDT)
Date:   Sat, 23 Jul 2022 08:39:40 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
Message-ID: <20220723083940.GA22@65aba7cb18f8>
References: <20220722090650.665513668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 11:06:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:06:00 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.14-rc1 tested.

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

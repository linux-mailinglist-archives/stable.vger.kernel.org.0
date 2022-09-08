Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22A5B158B
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 09:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiIHHXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 03:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiIHHXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 03:23:13 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD96481D7
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 00:23:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id jm11so16913951plb.13
        for <stable@vger.kernel.org>; Thu, 08 Sep 2022 00:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4ATJ0k7KtoLKHz24ma687N0bV6rG4dmH0nTzWuRiGiI=;
        b=eQoGDF65VNt3JfPPjWROgm3RLsX/GDgBdw8MfXmOGgm1MNIN37j4gvGK6CQGunr1VH
         1OWMQl3VTD/wZODwCMtNnMiaS8e3EDptVNhgMjE119PQikIqu4z1oLIloAbGdywUcijB
         sRgN9ZQDihMd6kaY6k96YjGHq3vc6Wek7TAlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4ATJ0k7KtoLKHz24ma687N0bV6rG4dmH0nTzWuRiGiI=;
        b=CfzhRQP3ZWOc1/leCQxBLiH6jwUPxqSUBgpDUhwQ2mUeFb+bWqTYh56WI5tnZ9B0Bl
         IGjwxdgDzT1EZAiyMSmqwUZrgHXMZCTSpRmo4UVJD/YFXtckD4rUSNsVT1W1wW9bmuVz
         KhNmaPazA7izthDCQXIts8kOVg1UCz61igxYk+RLIhZ10o0ivBm/WqOlODdDWhqzUGPK
         j3/Uj0A5tJjzg9LzVliappOUwYoWsL53qz9SLGekDcaLUgGodT12qIJ1vHnRGC3BP4RJ
         nRgddWRj0fXuBuJlbx5i7cfZF+2v9am4LK8LJziCX6R8x0zNVZ+0IEoIujhCznUTqmnI
         Kjug==
X-Gm-Message-State: ACgBeo1/sREKVbpPL07LXT2iQBQJFuLDQWyAqdrhd02bCOp+JdCXp3mm
        gq/j2+zbZAvUeUdBTcv4NuQeiA==
X-Google-Smtp-Source: AA6agR5auJnsVYbI8XVsTcE1glBPnHXMCGp6adMtpDI/c6F7cTxjtmcMRWtLiBREO1LlP0SFUmgHZQ==
X-Received: by 2002:a17:90b:388f:b0:1f5:7748:9667 with SMTP id mu15-20020a17090b388f00b001f577489667mr2773667pjb.158.1662621789506;
        Thu, 08 Sep 2022 00:23:09 -0700 (PDT)
Received: from 9c4a42ebaaae ([203.220.223.63])
        by smtp.gmail.com with ESMTPSA id u195-20020a6279cc000000b00537eb00850asm14091177pfc.130.2022.09.08.00.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 00:23:07 -0700 (PDT)
Date:   Thu, 8 Sep 2022 07:22:58 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Message-ID: <20220908072258.GA1830588@9c4a42ebaaae>
References: <20220906132829.417117002@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 03:29:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.19.8-rc1 tested.

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
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi

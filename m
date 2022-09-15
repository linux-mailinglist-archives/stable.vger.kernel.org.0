Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259D15B91D3
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 02:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiIOAiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 20:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiIOAiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 20:38:51 -0400
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.50.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9B911C
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 17:38:50 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 9B442799CC
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 19:15:04 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YcX2o8V7qCE4UYcX2ozqHt; Wed, 14 Sep 2022 19:15:04 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RdFJ9iCSUUjTqUmiSvFxf1BsORkwWwDknSu7u+3cmdw=; b=SZ21UEQdjnUEpbmw9qqOKnqOT+
        mOdcag0a5njs0zMOFy9FgdvvmjBEiIAoWy2BGc4lCxKAMH7ObFd1Mjkoag6coSC3OSBfdoeVXDcFy
        9FRS3EY/qFtVZ1a9kugGY9FRiA2gGjEEL+3nK8qHkOLa+t7TULK9q0H+MzM08UA1anAObk3PHK/vC
        YLd4ssQpL4PSmiAiFPqv485sXYcFeZygeqKtharOZAKpEmiNWKQUTY+6bxlfZxiZPpRWpObzAihBV
        tK9LLnDQALzccQa6QZMnpoVmGMB23v1iHNeqGLH4pFNdpE6KnfoIuIFNsGDDstljhu17j8mf+KULc
        R5ZVYWqw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:55530 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oYcX1-003MWG-Ih;
        Thu, 15 Sep 2022 00:15:03 +0000
Date:   Wed, 14 Sep 2022 17:14:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/79] 4.19.257-rc1 review
Message-ID: <20220915001458.GE603793@roeck-us.net>
References: <20220913140348.835121645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oYcX1-003MWG-Ih
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:55530
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 63
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 04:06:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.257 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

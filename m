Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745C24F60A5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiDFNyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbiDFNxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:53:47 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 19:00:04 PDT
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.69.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F0FA5E8B
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 19:00:04 -0700 (PDT)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 00771400CC8CB
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 20:10:22 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id bu9lniis69AGSbu9lnJWMx; Tue, 05 Apr 2022 20:08:21 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BM53CkdiWE9/AyefGVVmcfgwA9TziGoeOzw36GMhF68=; b=0+uXrFiSoJ6r2JBUjoEKRQoewo
        WNv4IAttvm2qLAE2IB4xxBtJl9Yw7BC1ngCDRF0i6CM3JgZNyNRB7RxECcFETvXbjtYV/flU7Ur1s
        k8aKpKfrXGkCzYXTArIKFVNiwl9WTUcZSRhq7ABnDFzhpAPWgdy9WkKt0nJEiIiXAvCxowaBeSury
        tjcrDrbogKFpXyN0moVHB6/QULHPJ3Gj4tm0H/8RXALWitD0kZ7Cvum+uGram3T4IO4FIEhjdDhyK
        q0vawtktx+GEGu1Zen4VeOJy6DGymMzcaa1sLbJTHxCUHRxJm2g46h7JK5AWfCdFgLhM9qsKSx2Pk
        qEEBjvGQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57876 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nbu9l-001L2s-8Y; Wed, 06 Apr 2022 01:08:21 +0000
Date:   Tue, 5 Apr 2022 18:08:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
Message-ID: <20220406010820.GB1133386@roeck-us.net>
References: <20220405070339.801210740@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nbu9l-001L2s-8Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57876
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 24
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 09:17:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.33 release.
> There are 913 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

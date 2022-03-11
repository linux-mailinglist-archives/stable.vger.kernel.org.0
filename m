Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CE04D5736
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbiCKBOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345275AbiCKBOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:14:17 -0500
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.146.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C793101F1B
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:13:14 -0800 (PST)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 2C8AEE2D88
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:13:14 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id STqEnuDtR9AGSSTqEn8RUj; Thu, 10 Mar 2022 19:13:14 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ptqhbdSIAkswnv1vvpaSe9fe4Nc7RZuQ0NO+VmTLSaI=; b=MOIRv4Y/MgpluJOUQKEmEJbWWh
        pdgloEivcFFxILJlgyNaKXPpv8CvRuuzcdaaTxeF2Tied2aqVKrTsuCI7HoIeVUwvHWPj97h4SRXW
        8TYHqrjBM08YYaVfBbT9O9nLnO/BE5J9p/l7yWZrehKFNqX7NIuvshGoV4q1pmWUQvpDXISYdTC2C
        hbj6rHaxLUMs/MtOkxx5moNXbteJbKKIh41PbahPre/TwA8KTNbPmIL1ru+apdRPz/o2VsafQ09VF
        whK1uqmZo55LAbOoDYa1aOqPUxk2IGfUZFIZWM3IdzMdXahn8Wfugt/pGsOcDfLoNp19dqwaEbLzP
        4+o6GKBg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57438 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nSTqD-001w0T-7p; Fri, 11 Mar 2022 01:13:13 +0000
Date:   Thu, 10 Mar 2022 17:13:11 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/38] 4.9.306-rc2 review
Message-ID: <20220311011311.GA3882329@roeck-us.net>
References: <20220310140808.136149678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nSTqD-001w0T-7p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57438
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 96
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

On Thu, Mar 10, 2022 at 03:13:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

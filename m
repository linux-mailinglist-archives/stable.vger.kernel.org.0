Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45E84DD301
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 03:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiCRCVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 22:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiCRCVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 22:21:21 -0400
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.147.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A1A15B3E9
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 19:20:04 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id ABF7C6EBE
        for <stable@vger.kernel.org>; Thu, 17 Mar 2022 21:20:03 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id V2Djnn2bzb6UBV2Djn9HhZ; Thu, 17 Mar 2022 21:20:03 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CWPWrj5HG3+Bnw5nHi6uhe3Ns0Np5GFg1iIVJmkSqSU=; b=i8N+wccqcGb6rvfCrsRfollJGs
        nS/yMGhf0ZfBPbbv6OYcnVHqnAbQGVGQGd/RnswijIbL53UOz5YyPxluDxGwkPeUn5puJtHF+qnHM
        XLUMwCloVDHguHc6+fL1j4DCPtlYmmH6+cXoaXHS55Q5Q2Q0Ms9H1WZGjCH+MgMxoN5N2yGtSitXI
        4bWkG1sDU3xs2Mq8uhtvoHULM7aKWH1MW2XUJZ+dP4RteJu6qAprvqr6wJhmSI9besDe0Va6+adrN
        FxFId8qQ7BWBZz51u1d15Iw4y+fRnQhMMVKfxQDD0NcvXBg0futX+mbMhfY3YZvH6+B0ZdGioe9xW
        rhIfQ3NQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57534 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nV2Di-003p9y-Lj; Fri, 18 Mar 2022 02:20:02 +0000
Date:   Thu, 17 Mar 2022 19:20:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
Message-ID: <20220318022001.GD2113234@roeck-us.net>
References: <20220317124526.768423926@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nV2Di-003p9y-Lj
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57534
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 50
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

On Thu, Mar 17, 2022 at 01:45:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

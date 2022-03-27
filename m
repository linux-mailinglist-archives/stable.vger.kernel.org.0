Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8C4E84D2
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 01:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiC0AxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 20:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiC0AxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 20:53:01 -0400
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.49.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254625E16C
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 17:51:23 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id AEF1C679B
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 19:51:22 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YH7qn6gneHnotYH7qn3Yv7; Sat, 26 Mar 2022 19:51:22 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O+qLVmcGVTOW3N2eOwDNmIQ/wBtdrrl/+OSV4gApHEo=; b=Ze2BotUittIFdyrFuqmkaaVlkU
        kqI3rXy6yt5a202OXfFRAmcguPRdz1C++pbxFDtKTuZ6zXjHueO0HHH/KnxyhTUm8N88rO+4EWwUo
        Gu/sflo7R095pFX1he29dfaCKxYVJSoNEkOiotZFDqUxR7OAraFLg3bE18GoBA5U8RsO4UUARK91a
        40t+3FweN0J6DTXTk6z12i4+Sb7McNJZsr7Waqq/tjOS+ndeBxYPbuJJ7zAVSUvZ5BAvQgqr3Np3G
        fbi+FBtW7ffw7XFvUXP77dS6efxcDzn2lsO9RyVW3q43SIfAbBES64h75zwkqipoXQIRizSNDF6M+
        UNQpwaow==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57686 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nYH7p-001FON-UN; Sun, 27 Mar 2022 00:51:22 +0000
Date:   Sat, 26 Mar 2022 17:51:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/29] 5.4.188-rc1 review
Message-ID: <20220327005120.GD1645909@roeck-us.net>
References: <20220325150418.585286754@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nYH7p-001FON-UN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57686
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

On Fri, Mar 25, 2022 at 04:04:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.188 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

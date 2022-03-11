Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A4E4D5751
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345335AbiCKB1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiCKB1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:27:20 -0500
X-Greylist: delayed 1383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 17:26:18 PST
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.66.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FC0105AA4
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:26:18 -0800 (PST)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 268F8400C7A0E
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:03:15 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id STgZnJoJ3b6UBSTgZnraSP; Thu, 10 Mar 2022 19:03:15 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QIieMucQTK2vp+QJSfXhhNbv1QuN0u3ptYhg6lFIqHs=; b=J2uF1id9ekbqa1PyeqKE88ERF9
        Ng1ht0KrlpgbaUYmG8cuclDkozihJM8SJTfeZfHsC8+l3mCqHiK946xsZrfhxB7zUN4vMfRXpd+FS
        hXQfUlh7aPDFVkJwM9aawK9rd9Eqhf/+w32U3ZaygNxre8R5laAYJcSmtxOqc+l2t+2s5S2Wrj2BY
        SX+5WLUmQc4x42PeZSlZaFEAuOzUhIVY7Tukq6krsEYaxXGhFCACV0xy2EBjJYl2KVLJGFE10Cixn
        t64lrOvPEKIUmUkGvXrxbAMdQNb0ebvR37xxLu45fkdDowF4QJ1X55JcEc917P46Cbn6yJvwR3vuF
        SuoVWRBA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57432 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nSTgY-001my3-Bu; Fri, 11 Mar 2022 01:03:14 +0000
Date:   Thu, 10 Mar 2022 17:03:13 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
Message-ID: <20220311010313.GD3881529@roeck-us.net>
References: <20220310140812.983088611@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nSTgY-001my3-Bu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57432
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 57
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

On Thu, Mar 10, 2022 at 03:18:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.  There
> are 58 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 156 pass: 155 fail: 1
Failed builds:
	mips:allmodconfig
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

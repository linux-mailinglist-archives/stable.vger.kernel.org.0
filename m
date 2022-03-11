Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627394D571F
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiCKBF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345263AbiCKBF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:05:57 -0500
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.144.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF31662C0
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:04:53 -0800 (PST)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 5C4C27012
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:04:53 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id STi9ndqhsXvvJSTi9nxJda; Thu, 10 Mar 2022 19:04:53 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SqDO2ZUZk8kifGQzpxWjAQlGNI2XFgmlcIdncpnvD0E=; b=3eVthBUzKxa222FNZFqYi6m4q3
        /c+Up0oj2TPN1QZJBXBaCtPyBRtUzQNTcgIchfdCs6VaMjkDZUxAVO7ioIocoS4yYfXtuPM0n9o8n
        CfdROb2pjniR5pDnQOaeB110RggayjBoFyIjlQTyenXStdMsfFcn6BYo8nT8qJ6cj+L4Scn44fehO
        FuYMcSfoAZlrPpKKWtqSRmC6QbxETXxBC4bIsC3huJADDpAZ9qOKU2lkahXEcZTSuULa9Ry14NPMX
        O2jPefS9v1wcRvmcP7ClEOW+lSQuvlepMrFKdNnB3YfUaiqNbr5vCpd6uzbnE1GMbkxSSajmQSXSu
        XLBYfslg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57436 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nSTi8-001nuC-JZ; Fri, 11 Mar 2022 01:04:52 +0000
Date:   Thu, 10 Mar 2022 17:04:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/58] 5.10.105-rc2 review
Message-ID: <20220311010451.GA3881707@roeck-us.net>
References: <20220310140812.869208747@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nSTi8-001nuC-JZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57436
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 83
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

On Thu, Mar 10, 2022 at 03:18:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

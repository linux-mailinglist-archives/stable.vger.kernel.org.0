Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA874D5719
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 02:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345257AbiCKBEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 20:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345245AbiCKBEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 20:04:44 -0500
Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.146.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75637C683C
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 17:03:42 -0800 (PST)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 89E377E7377
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 19:03:40 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id STgxnu45A9AGSSTgyn8ID0; Thu, 10 Mar 2022 19:03:40 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TBl8RkU0SSyTC7YLjQ+wO3qPkU6xhDa8xE6oGx5JCLM=; b=z+ekStB1OzauDDb4TXaFcWXCWB
        N+tdNLQjZTeI68JOP3z14++3uDDIq/KCsfEQmVmF1SNtaKxN5RoNg7M9EO+IGp95twri1fkUe90A4
        Kx1a+Y31/Azeh72rWfe3Qm44dqBMzptnUPZyhiEOXD6TPUZ8PobKdFznydomSxs1BcAHlL85y6iVm
        WVSsPS6R8j80VstFW3z53VXomZWoesLEdYeqvaf4iBLJFqAcWGumz0mlf47ir9XG01ZTGoumx4CU1
        U01ySas0vwquEZIH6ZOUoJSsW4PjBYa17dalC85mJmCAEm5QLq7RijIiskYiHO6HI1HF53fIVehQ9
        vmEHjGdA==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57434 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nSTgx-001n9x-8j; Fri, 11 Mar 2022 01:03:39 +0000
Date:   Thu, 10 Mar 2022 17:03:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
Message-ID: <20220311010337.GE3881529@roeck-us.net>
References: <20220310140811.832630727@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nSTgx-001n9x-8j
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57434
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 70
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

On Thu, Mar 10, 2022 at 03:09:05PM +0100, Greg Kroah-Hartman wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as there
> has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.  There
> are 53 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

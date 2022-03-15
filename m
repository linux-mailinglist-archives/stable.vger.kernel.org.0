Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38294D91CB
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 01:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbiCOAyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 20:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiCOAya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 20:54:30 -0400
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.50.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7F8100B
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 17:53:17 -0700 (PDT)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 25E80197E6
        for <stable@vger.kernel.org>; Mon, 14 Mar 2022 19:53:17 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id TvR6nUHYRXvvJTvR7nhflu; Mon, 14 Mar 2022 19:53:17 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=l4HlY2A3RyIuVlIUqMI8DA5II9OGtAKGgEJS/9G/IU8=; b=UwM7+/k4b9G+zTM9P+s4t/+waM
        RSu9TZkFaJMsAsaT8CMjfM8VIoNHGKFNUbZwZYWCilHaOAAah8JHiqL7SFMExaNGrC/gobeJUEDyN
        MfPE8Dy9Z8BwoDodIIPDmM1ft9VHDDq0jbD6qQxoZe2lSq6+9E6baOAM2W8B6ofILC6WrFMex34SY
        AI+MRwzB9DYOAKvZaMiE9qCNRJrpgRC0OGFO3y2Ismv0eR4Zg7nzCFbAMR1RN+jqig3ocbYAH6VrM
        nunNhzaLObduIvah6s5uzAdS4ZzFVpF+IDVOmTPwKjYO30aOaxY4rdeH2ZygMg9oPIzLovjkB9sHT
        VObWTeww==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57474 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nTvR6-003rYa-6X; Tue, 15 Mar 2022 00:53:16 +0000
Date:   Mon, 14 Mar 2022 17:53:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/71] 5.10.106-rc1 review
Message-ID: <20220315005315.GE1943350@roeck-us.net>
References: <20220314112737.929694832@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nTvR6-003rYa-6X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57474
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 63
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

On Mon, Mar 14, 2022 at 12:52:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.106 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 11:27:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

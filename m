Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5554D3A5F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbiCIT1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiCIT1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:27:39 -0500
X-Greylist: delayed 1281 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 11:26:40 PST
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.51.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEF8B0EBA
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:26:39 -0800 (PST)
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 71903AD1D
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:05:18 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id S1ccnHvz29AGSS1ccnYGhN; Wed, 09 Mar 2022 13:05:18 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=en7m1+CRbmjrhxJoGwb18dUJTu8IAG17F03NTg7F3T8=; b=Hc7tjH45SgN1jipbwVbpR7TTEn
        pxV0oDwUk4lrKSy0jMJAAelyIpr7oNrLYlifz/coqqJSSZCERXkLFOYPn62iuF+wKZGpzX1fqUZ1c
        pDla/g9/p8Sm/e3GeeB2K1VA0iSDg25VXOeHc0Mc6Uqe4JGHIwiDdU1znRj1pyMkd3ObR2UA+5Pxy
        cF16v6JPN0IUD8AUlXQb5N//Ci7ij1mjwZ5DMsuOsjrM9KNLkzsot5LgMdY/8UXoWhWmDqoky6GjS
        qj+KJuN0ucjX0GsODEOAKPMmrV2JRnbuE5dstGY08Jw6dFdFYG67qyH6kNcSl8V8mQV4ygBnBMgDP
        tf8Y60gQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54200)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nS1cb-0023qO-KB; Wed, 09 Mar 2022 19:05:17 +0000
Message-ID: <37efd441-7fe4-1aa4-a41b-19d30b652c5c@roeck-us.net>
Date:   Wed, 9 Mar 2022 11:05:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 00/37] 5.16.14-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155859.086952723@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nS1cb-0023qO-KB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54200
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 11
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 08:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 

Almost all arm builds, all branches from 4.9.y to 5.16.y:

Error log:
arch/arm/common/secure_cntvoff.S: Assembler messages:
arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'

bisect log:

# bad: [3416254dac79ea26e08dffde371ab1fd3130223c] Linux 5.16.14-rc1
# good: [6273c309621c9dd61c9c3f6d63f5d56ee2d89c73] Linux 5.16.13
git bisect start 'HEAD' 'v5.16.13'
# bad: [4403d69931dbc17659845d2d710602bbe35b4398] KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A
git bisect bad 4403d69931dbc17659845d2d710602bbe35b4398
# good: [6f0cf3a1eb8b46a5d652a395ba25a59c32a86692] ARM: report Spectre v2 status through sysfs
git bisect good 6f0cf3a1eb8b46a5d652a395ba25a59c32a86692
# bad: [87e96a363eb4a62b65bb974a46d518a87153cd1c] arm64: add ID_AA64ISAR2_EL1 sys register
git bisect bad 87e96a363eb4a62b65bb974a46d518a87153cd1c
# good: [654f0a73f042662a36155a0cafa30db846ccb5a9] ARM: use LOADADDR() to get load address of sections
git bisect good 654f0a73f042662a36155a0cafa30db846ccb5a9
# bad: [91bdae56c40ee6de675fba6ac283311c92c437ce] ARM: include unprivileged BPF status in Spectre V2 reporting
git bisect bad 91bdae56c40ee6de675fba6ac283311c92c437ce
# bad: [95ff4cb3b696a581d6166f0d754771bf9af5e27b] ARM: Spectre-BHB workaround
git bisect bad 95ff4cb3b696a581d6166f0d754771bf9af5e27b
# first bad commit: [95ff4cb3b696a581d6166f0d754771bf9af5e27b] ARM: Spectre-BHB workaround

Guenter

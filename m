Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA414F47C0
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbiDEVU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385598AbiDEPPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:15:13 -0400
X-Greylist: delayed 1381 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 06:31:49 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.48.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8C4262F
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 06:31:48 -0700 (PDT)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 05620151BF82
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 08:08:47 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id bivOnHqWxRnrrbivOnJRtm; Tue, 05 Apr 2022 08:08:46 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xz6VufNI4MnHhml5UwvXhoCvcF0yDshQWHa/HM/YqoA=; b=GqIHGIW2UMCJm1lZnmUjI7G1KT
        5236zPjF59olbyzrTlyR57lC81eHcbU4XrSyA4o67ts9zDsg+y9lxc7tc/bcl4C+YIva53hNcLIMp
        dSFv785YbqteL/2ibwlp7W3Z6qgFfEcGOTlrH7tsUxhAh33G+7iGE04TOABvusVHyQMebpb5f8hfZ
        IhQ6I2QD3YFezPkSA5AGGTHMxruDvPqYQcBf4NGKno7TQVKkhcRHWUn8oE/NjBfe/5mvsCQiNwtFt
        J6tPe7l6QiZOuObL2N4eKAb/MFi1Lpsxu8zj+IrSp0BQcgD4WYPUIRwZiEBmVgLUGPQgNElDMD2qe
        rLqeUkQQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54728)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nbivO-002i6Y-7O; Tue, 05 Apr 2022 13:08:46 +0000
Message-ID: <e80a3eb4-335c-5f8c-dc22-e33176b225da@roeck-us.net>
Date:   Tue, 5 Apr 2022 06:08:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220405070258.802373272@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
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
X-Exim-ID: 1nbivO-002i6Y-7O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54728
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 11
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 00:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 599 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 

Building um:defconfig ... failed
Building csky:defconfig ... failed
Building microblaze:mmu_defconfig ... failed
------
Error log:

fs/binfmt_elf.c: In function 'fill_note_info':
fs/binfmt_elf.c:2050:45: error: 'siginfo' undeclared (first use in this function)
  2050 |                 sz = elf_dump_thread_status(siginfo->si_signo, ets);
       |                                             ^~~~~~~
fs/binfmt_elf.c:2050:45: note: each undeclared identifier is reported only once for each function it appears in
fs/binfmt_elf.c:2056:53: error: 'regs' undeclared (first use in this function)
  2056 |         elf_core_copy_regs(&info->prstatus->pr_reg, regs);
       |                                                     ^~~~

Build just started, so there are likely going to be more failures.

Guenter

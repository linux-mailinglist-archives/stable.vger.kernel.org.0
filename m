Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EF64D3A72
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiCITfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237764AbiCITfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:35:33 -0500
X-Greylist: delayed 1496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 11:34:33 PST
Received: from gateway22.websitewelcome.com (gateway22.websitewelcome.com [192.185.47.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6772398
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:34:33 -0800 (PST)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 33033BE21
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:09:37 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id S1gmnNTsF22u3S1gnn7Tu5; Wed, 09 Mar 2022 13:09:37 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=42Utu4gnmkMmOJJbchL1IlgfBtsrUDKQbabDZXt78bw=; b=EuFBNVqbW5FWzXSGqHYpZdGJdG
        zxUWDrsv1LXP8aBUgIjRQ5Rm/sXVMBB/pGoJ7bOrC5mfm2YTgQz5z5Zt1NP2Zp8l584Fp73ikhG3l
        n8uUQ1Nn7Kh83LVI0xU+MSz840eZMgFR6u7j6hQU/15EvLCbgjry9bTvZbmqfjw1n8bCSPiLeJFGw
        y3HAaNPS9PWjUSUj/hRZcpfjfvwItEKxYlAM7ASvqq0rMUFCUpeD0l/jsbNUrBmJN4DHszQ7dO56K
        horm5DvJPUip+hfktYFl8WTD7XG2GFienOFVZrUBv3j9Y5aq3QgqMyPiHxkw/hYlCf62cnt6DWsrD
        Ghdu7qug==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54202)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nS1gm-0028nE-9J; Wed, 09 Mar 2022 19:09:36 +0000
Message-ID: <ff46226a-d519-595b-cbb7-cf1af3f657e5@roeck-us.net>
Date:   Wed, 9 Mar 2022 11:09:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
Content-Language: en-US
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
References: <20220309155856.155540075@linuxfoundation.org>
 <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
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
X-Exim-ID: 1nS1gm-0028nE-9J
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54202
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 23
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 10:08, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.234 release.
>> There are 18 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
>> Anything received after that time might be too late.
> 
> My tests are still running, but just an initial result for you,
> 
> x86_64 defconfig fails with:
> arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> function 'unprivileged_ebpf_enabled'
> [-Werror=implicit-function-declaration]
>    973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
> 
> 

# bad: [be15501ac1fff96964cb8880d44736bd1653295b] Linux 4.19.234-rc1
# good: [c2ea16582cfb89c5e3457a680d018f165cfdc208] Linux 4.19.233
git bisect start 'HEAD' 'v4.19.233'
# bad: [69a4715b821de4cf973df10a935a0e3bcada38f5] x86/speculation: Warn about Spectre v2 LFENCE mitigation
git bisect bad 69a4715b821de4cf973df10a935a0e3bcada38f5
# good: [e2982efb00a54d8f5e682cbf68ef9844040b5811] x86/speculation: Add eIBRS + Retpoline options
git bisect good e2982efb00a54d8f5e682cbf68ef9844040b5811
# bad: [b799f7ac596fff0c36321428de9fd7c9aa8c4008] x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting
git bisect bad b799f7ac596fff0c36321428de9fd7c9aa8c4008
# good: [ba81977a470c874ce83bdc96f1749c6d36ccfefd] Documentation/hw-vuln: Update spectre doc
git bisect good ba81977a470c874ce83bdc96f1749c6d36ccfefd
# first bad commit: [b799f7ac596fff0c36321428de9fd7c9aa8c4008] x86/speculation: Include unprivileged eBPF status in Spectre v2 mitigation reporting

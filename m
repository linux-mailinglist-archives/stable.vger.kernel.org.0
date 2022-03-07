Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8737A4D04BE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 17:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244346AbiCGQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 11:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiCGQ7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 11:59:09 -0500
X-Greylist: delayed 1397 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Mar 2022 08:58:11 PST
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.45.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005662A25E
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 08:58:09 -0800 (PST)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id C7262400CDA52
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 10:34:51 -0600 (CST)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id RGJvnZqMKb6UBRGJvnDSFu; Mon, 07 Mar 2022 10:34:51 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E3pGPPNNo3xRbfhh9om7nduDNuHsQN8qJ8ZnQHI78oM=; b=PKU8IHHYksUu32410/3p7aJtl+
        TX7XfJiOYCqH49Wd6csXN8FmUZhUhuIEQUfWrCZxi+H2t86BNw0KagraxPR9HEw31Lzf8MvdNOT45
        gZhMRolX9w9aBIiHjPQi9YbwJWhdVeJVAASwC7tvRglrvJmTkPh6tQ76XI29w0lpkjkcmZKjknb9m
        adlmDYyv6kCb9TyxO4Cwq40+7wnP8E4SK+lX2P+i+KgBzi40z8XZ4ws7zt+Hpd/UePz6YULvDCmGD
        aRF3pKd+Wxq3fv9PqaIzI4mH+qmP0QmHZBUvdgFDNFKFBKgXuGiFxKPLFFCUc7NpwC+YSIiqqZa+Q
        /5KaVYCQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:38096)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nRGJu-003jbN-V3; Mon, 07 Mar 2022 16:34:51 +0000
Message-ID: <e23ebf8b-5227-cc97-d166-797a4e852cd2@roeck-us.net>
Date:   Mon, 7 Mar 2022 08:34:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220307091702.378509770@linuxfoundation.org>
 <24c54a05-bb80-a128-d0ba-a78c6d5d101c@roeck-us.net>
 <YiYw3hV2r8DTa7fb@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/262] 5.15.27-rc1 review
In-Reply-To: <YiYw3hV2r8DTa7fb@kroah.com>
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
X-Exim-ID: 1nRGJu-003jbN-V3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:38096
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 11
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

On 3/7/22 08:20, Greg Kroah-Hartman wrote:
> On Mon, Mar 07, 2022 at 06:36:22AM -0800, Guenter Roeck wrote:
>> On 3/7/22 01:15, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.15.27 release.
>>> There are 262 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> In addition to other reported build errors:
>>
>> Building mips:allmodconfig ... failed
>> --------------
>> Error log:
>> drivers/net/hamradio/mkiss.c:35: error: "END" redefined
> 
> That is odd, I don't see any changes to that driver, nor any MIPS
> changes that touch "END".
> 
> I don't even see "END" in the diff anywhere.
> 
> Any chance you can bisect?
> 

git bisect start 'HEAD' 'v5.15.26'
# bad: [20ab3ebe56f306d821cf1c6858cf29f4d2e0075a] drm/amd/display: Fix stream->link_enc unassigned during stream removal
git bisect bad 20ab3ebe56f306d821cf1c6858cf29f4d2e0075a
# bad: [2f01eec30992529350bae197f73d71136b35e3b1] Input: ti_am335x_tsc - fix STEPCONFIG setup for Z2
git bisect bad 2f01eec30992529350bae197f73d71136b35e3b1
# good: [d369b344b4fb5a6ab9f72bacece674526761b885] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
git bisect good d369b344b4fb5a6ab9f72bacece674526761b885
# good: [46f46f14bd45acdabcfb1d9f3b648f4a27d18c08] bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
git bisect good 46f46f14bd45acdabcfb1d9f3b648f4a27d18c08
# bad: [5b0c543b875e976e74c347b2d009c6519a6d2939] KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
git bisect bad 5b0c543b875e976e74c347b2d009c6519a6d2939
# bad: [58452f46ddb11fbe5b5f31d93a979d57efdad4b1] PCI: rcar: Check if device is runtime suspended instead of __clk_is_enabled()
git bisect bad 58452f46ddb11fbe5b5f31d93a979d57efdad4b1
# bad: [d6ab8da0cb6234fbc4fd240b9d7470b4c03d5df9] signal: In get_signal test for signal_group_exit every time through the loop
git bisect bad d6ab8da0cb6234fbc4fd240b9d7470b4c03d5df9
# bad: [53863a048566989e87f8bb306e835f940a10ed73] MIPS: fix local_{add,sub}_return on MIPS64
git bisect bad 53863a048566989e87f8bb306e835f940a10ed73
# first bad commit: [53863a048566989e87f8bb306e835f940a10ed73] MIPS: fix local_{add,sub}_return on MIPS64

The problem is the innocent looking

  #include <linux/atomic.h>
+#include <asm/asm.h>
  #include <asm/cmpxchg.h>

in that patch. Reverting it fixes the problem. Alternatively, you could apply
commit 16517829f2e0 ("hamradio: fix macro redefine warning").

Guenter

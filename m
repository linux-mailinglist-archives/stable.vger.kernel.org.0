Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4F44F85BE
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiDGRWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 13:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDGRWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 13:22:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BF2EE90;
        Thu,  7 Apr 2022 10:20:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D34912FC;
        Thu,  7 Apr 2022 10:20:39 -0700 (PDT)
Received: from [10.1.196.218] (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F6CA3F718;
        Thu,  7 Apr 2022 10:20:33 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/43] 4.9.310-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220406182436.675069715@linuxfoundation.org>
 <20220407093238.GA3041848@roeck-us.net> <Yk67rfu4XQSl5j6c@kroah.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <c87bb36b-ed87-58d8-0276-b06771fd41d2@arm.com>
Date:   Thu, 7 Apr 2022 18:20:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <Yk67rfu4XQSl5j6c@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 07/04/2022 11:23, Greg Kroah-Hartman wrote:
> On Thu, Apr 07, 2022 at 02:32:38AM -0700, Guenter Roeck wrote:
>> On Wed, Apr 06, 2022 at 08:26:09PM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.310 release.
>>> There are 43 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 08 Apr 2022 18:24:27 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 163 pass: 161 fail: 2
>> Failed builds:
>> 	arm64:allnoconfig
>> 	arm64:tinyconfig
>> Qemu test results:
>> 	total: 397 pass: 397 fail: 0
>>
>> arch/arm64/kernel/cpu_errata.c: In function 'is_spectrev2_safe':
>> arch/arm64/kernel/cpu_errata.c:829:39: error: 'arm64_bp_harden_smccc_cpus' undeclared 
>>
>> arch/arm64/kernel/cpu_errata.c: In function 'spectre_bhb_enable_mitigation':
>> arch/arm64/kernel/cpu_errata.c:839:39: error: '__hardenbp_enab' undeclared
>>
>> arch/arm64/kernel/cpu_errata.c:879:42: error: 'bp_hardening_data' undeclared
> 
> Ick, odds are James did not build with those two configs :(

I'm sure I tried allnoconfig - but evidently messed something up.


> James, any chance you can look into this and see what needs to be added
> or changed with your patch series?

Will do,...


Thanks,

James

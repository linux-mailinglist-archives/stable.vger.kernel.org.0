Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B024E99AC
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiC1Of0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 10:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiC1OfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 10:35:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92118473B5;
        Mon, 28 Mar 2022 07:33:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE70AD6E;
        Mon, 28 Mar 2022 07:33:42 -0700 (PDT)
Received: from [10.1.196.218] (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E621D3F73B;
        Mon, 28 Mar 2022 07:33:40 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/14] 4.9.309-rc1 review
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220325150415.694544076@linuxfoundation.org>
 <15268a27-5386-45d8-5c55-1095251331f7@gmail.com>
 <bc8caeac-ea75-f91a-5bb0-9195eb263914@gmail.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <1e508bfb-d275-9a3f-16bd-915d464f006b@arm.com>
Date:   Mon, 28 Mar 2022 15:33:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <bc8caeac-ea75-f91a-5bb0-9195eb263914@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Florian,

On 26/03/2022 00:00, Florian Fainelli wrote:
> On 3/25/22 14:31, Florian Fainelli wrote:
>> On 3/25/22 08:04, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.309 release.
>>> There are 14 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.309-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
>>
>> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>> PS: is there any reason why the Spectre BHB patches from here are not part of
>> linux-stable/linux-4.9.y?
> 
> Meant to provide this link, from here:
> 
> https://gitlab.arm.com/linux-arm/linux-jm/-/tree/bhb/v3/v4.9.302

These were from before the disclosure date. Since then the 'backport everything' approach
was investigated more, but we decided not to go that way.
These trees need the bugs we subsequently discovered fixing, retesting and reposting. I
was on holiday last week. I plan to get to it this week.


Thanks,

James

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9D34DB777
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 18:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350733AbiCPRj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350428AbiCPRj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 13:39:57 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E8C23AA66
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 10:38:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B20B1476;
        Wed, 16 Mar 2022 10:38:41 -0700 (PDT)
Received: from [10.57.92.127] (unknown [10.57.92.127])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 849C63F66F;
        Wed, 16 Mar 2022 10:38:40 -0700 (PDT)
Subject: Re: [stable:PATCH v5.4.184 00/22] arm64: Mitigate spectre style
 branch history side channels
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org
References: <20220315182415.3900464-1-james.morse@arm.com>
 <YjIFE8Abn7XI+4yW@sashalap>
From:   James Morse <james.morse@arm.com>
Message-ID: <ef06416c-4636-24cb-01e7-11caab365ed6@arm.com>
Date:   Wed, 16 Mar 2022 17:38:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YjIFE8Abn7XI+4yW@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 3/16/22 3:41 PM, Sasha Levin wrote:
> On Tue, Mar 15, 2022 at 06:23:53PM +0000, James Morse wrote:
>> Hi Greg,
>>
>> Here is the state of the current v5.4 backport. Now that the 32bit
>> code has been merged, it doesn't conflict when KVM's shared 32bit/64bit
>> code needs to use these constants.
>>
>> I've fixed the two issues that were reported against the v5.10 backport.
>>
>> I had a go at bringing all the pre-requisites in to add proton-pack.c
>> to v5.4. Its currently 39 patches:
>> https://git.gitlab.arm.com/linux-arm/linux-jm.git /bhb/alternative_backport/UNTESTED/v5.4.183
>> (or for web browsers:
>> https://gitlab.arm.com/linux-arm/linux-jm/-/commits/bhb/alternative_backport/UNTESTED/v5.4.183/
>> )
> 
> I've queued it up.

Just to clarify - you've queued this series that I posted, not the above 'UNTESTED' branch
where I tried (unsuccessfully) to bring in the prerequisites.

(The position of your comment made me jump!)


The background is Greg commented on the BHB list that he thought it would be better to bring
in the prerequisites, I said I'd have a go.
As described here, I think it just creates new problems.



Thanks,

James

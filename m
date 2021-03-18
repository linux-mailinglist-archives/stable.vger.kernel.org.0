Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17123401D9
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 10:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCRJUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 05:20:41 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44301 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229634AbhCRJUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 05:20:25 -0400
Received: from [192.168.0.3] (ip5f5aea9f.dynamic.kabel-deutschland.de [95.90.234.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7AAEF2064AF11;
        Thu, 18 Mar 2021 10:20:16 +0100 (CET)
Subject: Re: [PATCH] Revert "iommu/amd: Fix performance counter
 initialization"
To:     Alexander Monakov <amonakov@ispras.ru>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Tj <ml.linux@elloe.vision>,
        Shuah Khan <skhan@linuxfoundation.org>,
        David Coe <david.coe@live.co.uk>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <20210303121156.76621-1-pmenzel@molgen.mpg.de>
 <a803de32-eec8-a0b1-69e6-43259ba5c656@amd.com>
 <alpine.LNX.2.20.13.2103031648190.15170@monopod.intra.ispras.ru>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <0a910a80-5783-1f3d-a8ea-5e10cba0e206@molgen.mpg.de>
Date:   Thu, 18 Mar 2021 10:20:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.20.13.2103031648190.15170@monopod.intra.ispras.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Jörg, dear Suravee,


Am 03.03.21 um 15:10 schrieb Alexander Monakov:
> On Wed, 3 Mar 2021, Suravee Suthikulpanit wrote:
> 
>>> Additionally, alternative proposed solutions [1] were not considered or
>>> discussed.
>>>
>>> [1]:https://lore.kernel.org/linux-iommu/alpine.LNX.2.20.13.2006030935570.3181@monopod.intra.ispras.ru/
>>
>> This check has been introduced early on to detect a HW issue for
>> certain platforms in the past, where the performance counters are not
>> accessible and would result in silent failure when try to use the
>> counters. This is considered legacy code, and can be removed if we
>> decide to no longer provide sanity check for such case.
> 
> Which platforms? There is no such information in the code or the commit
> messages that introduced this.
> 
> According to AMD's documentation, presence of performance counters is
> indicated by "PCSup" bit in the "EFR" register. I don't think the driver
> should second-guess that. If there were platforms where the CPU or the
> firmware lied to the OS (EFR[PCSup] was 1, but counters were not present),
> I think that should have been handled in a more explicit manner, e.g.
> via matching broken CPUs by cpuid.

Suravee, could you please answer the questions?

Jörg, I know you are probably busy, but the patch was applied to the 
stable series (v5.11.7). There are still too many question open 
regarding the patch, and Suravee has not yet addressed the comments. 
It’d be great, if you could revert it.


Kind regards,

Paul

Could you please

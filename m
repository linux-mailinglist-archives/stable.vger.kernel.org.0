Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E359A18CDE1
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCTM37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 08:29:59 -0400
Received: from foss.arm.com ([217.140.110.172]:48390 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbgCTM36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 08:29:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E3A131B;
        Fri, 20 Mar 2020 05:29:58 -0700 (PDT)
Received: from [10.37.12.155] (unknown [10.37.12.155])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A6343F85E;
        Fri, 20 Mar 2020 05:29:55 -0700 (PDT)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] arm64: compat: Fix syscall number of compat_clock_getres
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200319141138.19343-1-vincenzo.frascino@arm.com>
 <20200319181203.GB29214@mbp>
Message-ID: <d9418e75-0136-4f56-6d82-3d509be0e414@arm.com>
Date:   Fri, 20 Mar 2020 12:30:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200319181203.GB29214@mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/19/20 6:12 PM, Catalin Marinas wrote:
> On Thu, Mar 19, 2020 at 02:11:38PM +0000, Vincenzo Frascino wrote:
>> The syscall number of compat_clock_getres was erroneously set to 247
>> instead of 264. This causes the vDSO fallback of clock_getres to land
>> on the wrong syscall.
>>
>> Address the issue fixing the syscall number of compat_clock_getres.
>>
>> Fixes: 53c489e1dfeb6 ("arm64: compat: Add missing syscall numbers")
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
> 
> Will left ARM about 8 months ago IIRC ;).
>

Nice ;) I typed it manually, it came by "instinct" I guess ;) Sorry Will!

>> Cc: stable@vger.kernel.org
>> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I think Will could take this as a fix.
> 
> Thanks,
> 
> Catalin
> 

-- 
Regards,
Vincenzo

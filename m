Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9B315098
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 14:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhBINnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 08:43:09 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38087 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231135AbhBINkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 08:40:41 -0500
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 9TEzlxyODfJJC9TF2lblLA; Tue, 09 Feb 2021 14:39:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1612877985; bh=wDKgogZmfV7JshEhGuqAk/26415rZeY12aI+VdHdmbk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=TMp21cuI1Mu94Zo4VdnvDAipJ5u1BCz7VPbfNqxdUqkwEgZ10ZR4drEK/648XVgIH
         USPKPKEgdOD3J/M2y7JtSsIXheg1ZCU68KuyDv5FKH5HiDalPnD+wkut3mvO1SbJpw
         SVpeGiaBnXf+WazLI8RXJoNNA6j5/mouJ/QNV8A9075kIC4YVg6GtoVXkIu2uA0T9Y
         wCb/oqYr8/kcNDLtNzE5tnV1Ap8N0rXNmq32LAMOAlqYQrSe9n9JOd6zHx4BNjjsBm
         Ih9hCmiN2wOEyhWVny6m9cGew4d3PY1A7MohQxMPnGcJhHima8u4TUOdzYBntGe1At
         ak70rDyLpM4vw==
Subject: Re: [PATCH AUTOSEL 5.10 14/36] media: rkisp1: uapi: change hist_bins
 array type from __u16 to __u32
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devel@driverdev.osuosl.org,
        Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
References: <20210208175806.2091668-1-sashal@kernel.org>
 <20210208175806.2091668-14-sashal@kernel.org>
 <12c8f50e-3bba-5936-6e67-55bd928a75c7@xs4all.nl>
 <e086d0f4-c5f0-e38c-8937-593852ac0b50@collabora.com>
 <YCKH0HvTxeYKg1xf@kroah.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <3413d0af-bc8e-4a9d-e0a2-eea98febd4e9@xs4all.nl>
Date:   Tue, 9 Feb 2021 14:39:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YCKH0HvTxeYKg1xf@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfB1UCHFFh/Ei5Mx3bDBWVch7Hs7bPP+TGm9rL8g9DcTqiZnMVRIAXXVymemK5/rft1wcwX7NFK4VP/ysfuNY2P7eTJB7XqxUb+QQDHem8QjOscUnsO27
 P3KAerXqMc+5J07IfE81LLeCngHJBv42cV/iFrbO3beqD/Yv+tTuC4kIWih+mQq3EJCTvRhkAOaO137DuO+HpDQSOgAhntAj7y184IBJWXzPzCrynqgiGuBf
 haCiaAvwNo6qf4mITC5QaTASdKMl5daa8ctXFC30LHyrKrq8ASsUdjB0WvmVD4zDrPGOFI7qYsxsO9pegszXZn3q9qZChHs7n9ElODXzsioIRjE0Vfn647Eg
 bNUVePmfUYGaAdwrTQeulumxi99zpHHbKtBugrJp68BPd683kNI+n6OWNXTsckmTa3ij1TfO09gpmTwjnwc1x9pGelKYM+yMqwwGJ6UdTVZzOe4M03AQlFbi
 zlIzIIJ6QubxPWR06rQinp6usR/9Xq5S78NQoA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/02/2021 14:02, Greg Kroah-Hartman wrote:
> On Tue, Feb 09, 2021 at 01:45:35PM +0100, Dafna Hirschfeld wrote:
>>
>>
>> Am 08.02.21 um 21:46 schrieb Hans Verkuil:
>>> On 08/02/2021 18:57, Sasha Levin wrote:
>>>> From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>>>>
>>>> [ Upstream commit 31f190e0ccac8b75d33fdc95a797c526cf9b149e ]
>>>>
>>>> Each entry in the array is a 20 bits value composed of 16 bits unsigned
>>>> integer and 4 bits fractional part. So the type should change to __u32.
>>>> In addition add a documentation of how the measurements are done.
>>>
>>> Dafna, Helen, does it make sense at all to backport these three patches to
>>> when rkisp1 was a staging driver?
>>>
>>> I would be inclined not to backport this.
>>
>> I also don't think it makes sense since this changes the uapi and it is not really a bug fix.
> 
> Why was it ok to change the uapi in a newer kernel and not an older one?

In the older kernels this was a staging driver and the driver API was not public.
It's debatable whether there is any benefit from trying to backport patches like
this to a staging driver like that.

Also, these backports are incomplete, there are other patches that would need to
be applied to make this work. Applying just these three patches without the other
three (commits 66d81de7ea9d, fc672d806bd7 and ef357e02b6c4) makes it very messy
indeed.

I'd just leave the staging driver in older kernels as-is. Certainly don't just
apply these three patches without the other three commits, that would make it
even worse.

Regards,

	Hans

> 
> thanks,
> 
> greg k-h
> 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B8A3807D3
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhENK71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 06:59:27 -0400
Received: from foss.arm.com ([217.140.110.172]:47334 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhENK7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 06:59:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA2F51713;
        Fri, 14 May 2021 03:58:13 -0700 (PDT)
Received: from [10.57.31.97] (unknown [10.57.31.97])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 891023F73B;
        Fri, 14 May 2021 03:58:12 -0700 (PDT)
Subject: Re: [STABLE][PATCH 4.4] thermal/core/fair share: Lock the thermal
 zone while looping over instances
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com
References: <20210514104916.19975-1-lukasz.luba@arm.com>
 <YJ5XTW9TYvv7wYr6@kroah.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <12419f82-3efa-7587-da50-4edf7eef99e1@arm.com>
Date:   Fri, 14 May 2021 11:58:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <YJ5XTW9TYvv7wYr6@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/14/21 11:56 AM, Greg KH wrote:
> On Fri, May 14, 2021 at 11:49:16AM +0100, Lukasz Luba wrote:
>> commit fef05776eb02238dcad8d5514e666a42572c3f32 upstream.
>>
>> The tz->lock must be hold during the looping over the instances in that
>> thermal zone. This lock was missing in the governor code since the
>> beginning, so it's hard to point into a particular commit.
>>
>> CC: stable@vger.kernel.org # 4.4
>> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
>> ---
>> Hi all,
>>
>> I've backported my patch which was sent to LKML:
>> https://lore.kernel.org/linux-pm/20210422153624.6074-2-lukasz.luba@arm.com/
>>
>> The upstream patch failed while applying:
>> https://lore.kernel.org/stable/16206371483193@kroah.com/
>>
>> This patch should apply to stable v4.4.y, on top of stable tree branch:
>> linux-4.4.y which head was at:
>> commit 47127fcd287c ("Linux 4.4.268")
> 
> What about 4.9, 4.14, 4.14, and 5.4 releases?  They need this fix as
> well, right?

s/4.14/4.19

Yes, I'm going to send them in next few hours after building and
testing.

Regards,
Lukasz

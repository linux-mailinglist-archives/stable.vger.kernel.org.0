Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D142905AE
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408015AbgJPNFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:05:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:47896 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408012AbgJPNFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:05:05 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id AFC3820B4905;
        Fri, 16 Oct 2020 06:05:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AFC3820B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602853504;
        bh=nuZ/p1WdEiSOUjKWD/g7k40UjrGaKvK2LE3VTJ0IsG4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pk8CrF0e/h7XQPlL2NNxFgl4vDr6s0UHOsNYtHnu9mzEHXULlfq3fC6AIW4EftRqP
         Aum+3oPlJ3bNhZUZ6CHPXF5BudnLaFMW/jA0imAgJCmRPtNfzWp2hecYfbnbWPnpxf
         VwqGtJwha0waybSbE2bSnga4QgHpgKnzJpW1UvQI=
Subject: Re: [PATCH v5.4 0/3] Update SELinuxfs out of tree and then swapover
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, stephen.smalley.work@gmail.com,
        paul@paul-moore.com, selinux@vger.kernel.org, jmorris@namei.org,
        sashal@kernel.org
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
 <20201016050036.GB461792@kroah.com>
From:   Daniel Burgener <dburgener@linux.microsoft.com>
Message-ID: <9aeaa66d-d369-a1eb-7a07-08d9244585f3@linux.microsoft.com>
Date:   Fri, 16 Oct 2020 09:05:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201016050036.GB461792@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 1:00 AM, Greg KH wrote:
> On Thu, Oct 15, 2020 at 03:29:53PM -0400, Daniel Burgener wrote:
>> This is a backport for stable of my series to fix a race condition in
>> selinuxfs during policy load:
>>
>> selinux: Create function for selinuxfs directory cleanup
>> https://lore.kernel.org/selinux/20200819195935.1720168-2-dburgener@linux.microsoft.com/
>>
>> selinux: Refactor selinuxfs directory populating functions
>> https://lore.kernel.org/selinux/20200819195935.1720168-3-dburgener@linux.microsoft.com/
>>
>> selinux: Standardize string literal usage for selinuxfs directory names
>> https://lore.kernel.org/selinux/20200819195935.1720168-4-dburgener@linux.microsoft.com/
>>
>> selinux: Create new booleans and class dirs out of tree
>> https://lore.kernel.org/selinux/20200819195935.1720168-5-dburgener@linux.microsoft.com/
>>
>> Several changes were necessary to backport.  They are detailed in the
>> commit message for the third commit in the series.  I also dropped the
>> original third commit from this because it was only a style change.
> As Sasha said, we want to take the original commits as much as possible
> to reduce the delta.  It is ok to take style changes if other patches
> depend on them, because every time we do something that is not upstream,
> we create bugs.
>
> So can you redo this series, and backport the original commits, and
> provide the ids for them as well?
>
> thanks,
>
> greg k-h

Yes, thank you.  I will fix up the series with the third commit 
included, and add commit ids.  Thanks.


-Daniel


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E0F29090A
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409105AbgJPQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 12:01:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43366 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408468AbgJPQBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 12:01:05 -0400
Received: from localhost.localdomain (c-73-172-233-15.hsd1.md.comcast.net [73.172.233.15])
        by linux.microsoft.com (Postfix) with ESMTPSA id B968A20B4905;
        Fri, 16 Oct 2020 09:01:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B968A20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602864064;
        bh=i8c5fwACQE58gLMxSruBYUXR1wlmpqOp3Ms+A1pWVPc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=b/Yda89GDhjxdXzLqiiWuNBHOuuIQX/lwWpSEPYDNHAWqm+y/Nj6aw6iTJ9AZDswn
         UYGDajlNjRcY4DC6tyRfFxbUQ0j9brA4SIn1qo2YgcKV7E2C/6wanwa6FEFsiUx5tT
         o1W9+1T96RwXgWd0i9yRKF6wNA2uUs8LGiZdMNwo=
Subject: Re: [PATCH v5.4 v2 0/4] Update SELinuxfs out of tree and then
 swapover
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, stephen.smalley.work@gmail.com,
        paul@paul-moore.com, selinux@vger.kernel.org, jmorris@namei.org
References: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
 <20201016150120.GB1807231@kroah.com> <20201016153823.GA2415204@sasha-vm>
 <20201016154443.GA1818291@kroah.com> <20201016154936.GB2415204@sasha-vm>
From:   Daniel Burgener <dburgener@linux.microsoft.com>
Message-ID: <213527b2-87ce-01bf-0699-b82fa65dc91e@linux.microsoft.com>
Date:   Fri, 16 Oct 2020 12:01:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201016154936.GB2415204@sasha-vm>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 11:49 AM, Sasha Levin wrote:
> On Fri, Oct 16, 2020 at 05:44:43PM +0200, Greg KH wrote:
>> On Fri, Oct 16, 2020 at 11:38:23AM -0400, Sasha Levin wrote:
>>> On Fri, Oct 16, 2020 at 05:01:20PM +0200, Greg KH wrote:
>>> > On Fri, Oct 16, 2020 at 09:48:31AM -0400, Daniel Burgener wrote:
>>> > > v2: Include all commits from original series, and include commit 
>>> ids
>>> > >
>>> > > This is a backport for stable of my series to fix a race 
>>> condition in
>>> > > selinuxfs during policy load:
>>> >
>>> > Has this race condition always been present, or is this a regression
>>> > that is being fixed from previously working kernels?
>>>
>>> So this issue has always been there, but:
>>>
>>> > If it's always been present, why not just use 5.9 to solve it?
>>>
>>> Because it was merged for 5.10 rather than 5.9, which is a few months
>>> out, so Daniel is looking to see if we can have it in 5.8/5.4 to close
>>> the gap.
>>
>> I would have to wait for 5.10-rc1 at the earliest, and get the selinux
>> maintainers ack for this :)
>
> No objections; if the selinux folks feel unhappy with this it'll just
> wait for 5.10.
>
Yes, that's fine from my end as well.  We can carry this series out of 
tree in the interim.  Thanks!

-Daniel


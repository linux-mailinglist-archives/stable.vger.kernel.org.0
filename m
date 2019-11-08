Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FDBF6170
	for <lists+stable@lfdr.de>; Sat,  9 Nov 2019 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfKIU3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 15:29:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfKIU3e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Nov 2019 15:29:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA8B114742051;
        Sat,  9 Nov 2019 12:29:33 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:35:27 -0800 (PST)
Message-Id: <20191108.113527.2242883926552730503.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     jwi@linux.ibm.com, sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 204/205] s390/qeth: limit csum offload
 erratum to L3 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108123416.GA732985@kroah.com>
References: <20191108120025.GM4787@sasha-vm>
        <4d8f1938-af6e-7e0e-4085-2f7c53390b2d@linux.ibm.com>
        <20191108123416.GA732985@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:34 -0800 (PST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 8 Nov 2019 13:34:16 +0100

> On Fri, Nov 08, 2019 at 01:16:26PM +0100, Julian Wiedmann wrote:
>> On 08.11.19 13:00, Sasha Levin wrote:
>> > On Fri, Nov 08, 2019 at 12:50:24PM +0100, Julian Wiedmann wrote:
>> >> On 08.11.19 12:37, Sasha Levin wrote:
>> >>> From: Julian Wiedmann <jwi@linux.ibm.com>
>> >>>
>> >>> [ Upstream commit f231dc9dbd789b0f98a15941e3cebedb4ad72ad5 ]
>> >>>
>> >>> Combined L3+L4 csum offload is only required for some L3 HW. So for
>> >>> L2 devices, don't offload the IP header csum calculation.
>> >>>
>> >>
>> >> NACK, this has no relevance for stable.
>> > 
>> > Sure, I'll drop it.
>> > 
>> > Do you have an idea why the centos and ubuntu folks might have
>> > backported this commit into their kernels?
>> > 
>> 
>> No clue, I trust they have their own reasons.
>> 
> 
> I cant see centos backporting anything unless they were asked to do so.
> And this really looks like a "bugfix" to me, why isn't this relevant for
> any older kernel versions?

Yeah seriously, this looks entirely legit.

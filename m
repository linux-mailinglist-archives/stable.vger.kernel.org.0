Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2792513BF3
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 21:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfEDT3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 15:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbfEDT3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 15:29:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF50205F4;
        Sat,  4 May 2019 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556998177;
        bh=6Mtl3ec/1a45U6UpdUTUU3V5MnWcc10Eo2KkzsWywR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W7kXwxMQ8jtxcha59Yfh6iBtR0q/neUplAFtswmtrXwA1g+B88NFBPauZ1Aw0NU5H
         s94vfYiu2pWsbmlEvotWaPEASdCkIVE7FlCJZjBcqRBrxPHqfds9q7aUbBnKpxg0Wu
         VGUegDxnNER654Tz2cCNmymF7JVty1yAeoRB+Ojk=
Date:   Sat, 4 May 2019 15:29:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>,
        stable@vger.kernel.org
Subject: Re: Commit 8c37f7c23c02f6ac020ffdc746026c2363b23a5a causes warnings
Message-ID: <20190504192935.GA1747@sasha-vm>
References: <4031e343-ab11-6b58-71b7-f6f8cf69b677@gmail.com>
 <20190504064159.GC26311@kroah.com>
 <21459a1b-907c-1ffd-472a-ba2443919c6a@gmail.com>
 <20190504071930.GB12815@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190504071930.GB12815@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 09:19:30AM +0200, Greg KH wrote:
>On Sat, May 04, 2019 at 08:57:28AM +0200, François Valenduc wrote:
>> Le 4/05/19 à 08:41, Greg KH a écrit :
>> > On Fri, May 03, 2019 at 10:17:39PM +0200, François Valenduc wrote:
>> >> Commit 8c37f7c23c02f6ac020ffdc746026c2363b23a5a ( workqueue: Try to
>> >> catch flush_work() without INIT_WORK().) causes the following warning
>> >> when mounting encrypted filesystems:
[...]
>> > Great, it did what it was trying to do :)
>> >
>> > Do you have this problem on 5.0.y or Linus's current tree?
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>>
>> It only occurs with the 4.19.y branch. On 5.0.11 and 5.1-rc7, I don't
>> have the problem.
>
>Thanks for letting us know, I'll dig through the tree on Monday to see
>if I can find the needed fix that happened between 4.19 and 5.0 for
>this.

Looks like it was fixed upstream with 2e3c18d0ada ("block: pass no-op
callback to INIT_WORK()."). It also looks like we're missing a few of
these kind of fixes in our various branches. I can queue them up when
the current -rc branches are released.

--
Thanks,
Sasha

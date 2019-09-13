Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4214B22C8
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390281AbfIMPBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 11:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388950AbfIMPBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 11:01:15 -0400
Received: from localhost (195-23-252-136.net.novis.pt [195.23.252.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CB82054F;
        Fri, 13 Sep 2019 15:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568386875;
        bh=d5LyY7lEBC5SV24eCUuLaBZ+kemQPetOKLdbtly1Mhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SyzHJxtY+DiAeTBBFqnKKVdTlRNhYA5/YA+nAgMJgirE71hpMhWU6ebQ/kg8+vWpM
         4cnlDLPdlrd6s0JsBhlc8hB6ZKcnhpr3l6Md54QBn7deDXGP8L5YjC99MPnOAPpXiM
         ZPbSRFuUWlSg3Zt0um7QIQ1FX5UrdNqPdKqsjeoc=
Date:   Fri, 13 Sep 2019 11:01:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ilia Mirkin <imirkin@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        "# 3.9+" <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 092/190] drm/nouveau: Dont WARN_ON VCPI allocation
 failures
Message-ID: <20190913150111.GI1546@sasha-vm>
References: <20190913130559.669563815@linuxfoundation.org>
 <20190913130606.981926197@linuxfoundation.org>
 <CAKb7UviY0sjFUc6QqjU4eKxm2b-osKoJNO2CSP9HmQ5AdORgkw@mail.gmail.com>
 <20190913144627.GH1546@sasha-vm>
 <20190913145456.GA456842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190913145456.GA456842@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 13, 2019 at 03:54:56PM +0100, Greg Kroah-Hartman wrote:
>On Fri, Sep 13, 2019 at 10:46:27AM -0400, Sasha Levin wrote:
>> On Fri, Sep 13, 2019 at 09:33:36AM -0400, Ilia Mirkin wrote:
>> > Hi Greg,
>> >
>> > This feels like it's missing a From: line.
>> >
>> > commit b513a18cf1d705bd04efd91c417e79e4938be093
>> > Author: Lyude Paul <lyude@redhat.com>
>> > Date:   Mon Jan 28 16:03:50 2019 -0500
>> >
>> >    drm/nouveau: Don't WARN_ON VCPI allocation failures
>> >
>> > Is this an artifact of your notification-of-patches process and I
>> > never noticed before, or was the patch ingested incorrectly?
>>
>> It was always like this for patches that came through me. Greg's script
>> generates an explicit "From:" line in the patch, but I never saw the
>> value in that since git does the right thing by looking at the "From:"
>> line in the mail header.
>>
>> The right thing is being done in stable-rc and for the releases. For
>> your example here, this is how it looks like in the stable-rc tree:
>>
>> commit bdcc885be68289a37d0d063cd94390da81fd8178
>> Author:     Lyude Paul <lyude@redhat.com>
>> AuthorDate: Mon Jan 28 16:03:50 2019 -0500
>> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CommitDate: Fri Sep 13 14:05:29 2019 +0100
>>
>>    drm/nouveau: Don't WARN_ON VCPI allocation failures
>
>Yeah, we should fix your scripts to put the explicit From: line in here
>as we are dealing with patches in this format and it causes confusion at
>times (like now.)  It's not the first time and that's why I added those
>lines to the patches.

Heh, didn't think anyone cared about this scenario for the stable-rc
patches.

I'll go add it.

But... why do you actually care?

--
Thanks,
Sasha

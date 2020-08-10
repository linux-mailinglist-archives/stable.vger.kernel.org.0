Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7676524072B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgHJOFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726888AbgHJOFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:05:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5464E20678;
        Mon, 10 Aug 2020 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597068353;
        bh=FXHBaU9NDYsmCg3OnYtZqLqvysGMtZ6nJiRU0WoHhYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PrHBZI2elKVlVQvRltrbVdyYVCuoxJngRooyKd0f33yuWpnQxln8T+JhwAMbXICYg
         cKoA68w0EDdpvEmhXI6ttrjfK2sLJw7lRKeSM+7gqHI6rukw4MO0/ixqA2VJzapfch
         XlZkSvATUzZgO76dcrL67nZGvhl9qqlON5syjOao=
Date:   Mon, 10 Aug 2020 10:05:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        stable@vger.kernel.org
Subject: Re: Base for <linux-stable-rc.git#queue/5.8>
Message-ID: <20200810140551.GH2975990@sasha-vm>
References: <CA+icZUW_f4d5_yDg0_Ox8nVd_6R=JNc8Bo9TgEzjLUy_1MdXOw@mail.gmail.com>
 <20200810100125.GA2405194@kroah.com>
 <20200810100149.GB2405194@kroah.com>
 <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+icZUWzsHect3v_31-PE_qRfXk7hbORY8JpSkjQmoEFqMykiQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 12:11:40PM +0200, Sedat Dilek wrote:
>On Mon, Aug 10, 2020 at 12:01 PM Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> On Mon, Aug 10, 2020 at 12:01:25PM +0200, Greg Kroah-Hartman wrote:
>> > On Mon, Aug 10, 2020 at 11:52:30AM +0200, Sedat Dilek wrote:
>> > > [ Hope I have the correct CC for linux-stable ML ]
>> > >
>> > > Hi Greg and Sasha,
>> > >
>> > > The base for <linux-stable-rc.git#queue/5.8> is Linux v5.7.14 where it
>> > > should be Linux v5.8.
>> >
>> > What exactly do you mean by "#queue/5.8"?
>> >
>> > Is that a branch name?  Ah, never seen those before, maybe they are
>> > something that Sasha creates?
>>
>> But yes, you are right, it seems to mirror queue/5.7 at the moment,
>> which isn't correct.
>>
>> thanks,
>
>[ CC correct stable ML ]
>
>Exactly.
>
>With <linux-stable-rc.git#queue/5.8> I mean [1].

Ah, thanks for pointing it out! I've fixed the script and pushed out a
correct queue-5.8 branch.

-- 
Thanks,
Sasha

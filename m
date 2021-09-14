Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA05340B57F
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhINRBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 13:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhINRBY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 13:01:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC889610E6;
        Tue, 14 Sep 2021 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631638807;
        bh=hS1exfsO/vm3VsEYE4ugaOM7uJwdq3UjZyE0YHXhwgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OG/Mz9o5qBfDDUlXuKjV6rKm7IkEmNiYTUpA18hai7e4dGOfZbqArwX4hGt7cLyWe
         s0khvvsFi8w6cX/eeu2HQzCOYUKg82g8aYop9YHDDn37Me9zQJTWmN7enjiSptqYpt
         BpAapXREg8eyEefy2xhVVZTcsn45giw/Ly82+5DIyTVJhlLDUTG4GMa/i+deESmENV
         pcswuHrdK0K/pruGWnXDssqz8qogvHJBWHO1UQJosPYmn+tzauUvLFJtCZ+UilzUMH
         kefw+F2A0Z7xlJWlhyrTrTD9FIhC14yeBdqfdfZtb9Mr2JahmYRQhWU3XoizclGDCK
         rMRtOWb2Z6IVQ==
Date:   Tue, 14 Sep 2021 13:00:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Widawsky <ben.widawsky@intel.com>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-doc@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 03/25] cxl: Move cxl_core to new directory
Message-ID: <YUDVFW3YjEC8tDVC@sashalap>
References: <20210913223339.435347-1-sashal@kernel.org>
 <20210913223339.435347-3-sashal@kernel.org>
 <20210914095623.00005306@Huawei.com>
 <20210914095749.0000151f@Huawei.com>
 <20210914150558.n3lbmmt7h6o2uz6a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210914150558.n3lbmmt7h6o2uz6a@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 08:05:58AM -0700, Ben Widawsky wrote:
>On 21-09-14 09:57:49, Jonathan Cameron wrote:
>> On Tue, 14 Sep 2021 09:56:23 +0100
>> Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:
>>
>> > On Mon, 13 Sep 2021 18:33:17 -0400
>> > Sasha Levin <sashal@kernel.org> wrote:
>> >
>> > > From: Ben Widawsky <ben.widawsky@intel.com>
>> > >
>> > > [ Upstream commit 5161a55c069f53d88da49274cbef6e3c74eadea9 ]
>> > >
>> > > CXL core is growing, and it's already arguably unmanageable. To support
>> > > future growth, move core functionality to a new directory and rename the
>> > > file to represent just bus support. Future work will remove non-bus
>> > > functionality.
>> > >
>> > > Note that mem.h is renamed to cxlmem.h to avoid a namespace collision
>> > > with the global ARCH=um mem.h header.
>> >
>> > Not a fix...
>> >
>> > I'm guessing this got picked up on the basis of the Reported-by: tag?
>> > I think that was added for a minor tweak as this went through review rather
>> > than referring to the whole patch.
>> Or possibly because it was a precursor to the fix in the next patch.
>>
>> Hmm.  Ben, Dan, does it make sense for these two to go into stable?
>>
>> Jonathan
>
>As of now, no, but having this will make future fixes much easier to cherry

It was picked because the next patch depends on it. I'll just drop
both if you don't want the next one. Thanks!

-- 
Thanks,
Sasha

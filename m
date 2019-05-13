Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1808E1B85F
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 16:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfEMOgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 10:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbfEMOgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 10:36:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60EA9208C3;
        Mon, 13 May 2019 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557758171;
        bh=+p1LL6a9YNO3VX+VkASTeNF/zz1LlHDeeWMvxhdrs9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ax1+o8VJoOoeAcDZcB2n9sg1i6iHgbfAS3ryPXOlPJ33tsilkA0aZQR+wrq5pyNU7
         JR1eJgDUTkdZFBmVjyHO/0c3uZJVouO+5sOmJXGA+uItzXKclUjHgdwHiSp9DoCZQk
         /dgvRQUGmqIbLVl96KBPkoQYIX/3/FSmbEvBE1+o=
Date:   Mon, 13 May 2019 10:36:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: Re: [PATCH AUTOSEL 4.14 79/95] x86/asm: Remove dead __GNUC__
 conditionals
Message-ID: <20190513143610.GD11972@sasha-vm>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-79-sashal@kernel.org>
 <d18bba8c-0d2c-03bd-0098-5f39ad726b01@rasmusvillemoes.dk>
 <20190507061503.GA20385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190507061503.GA20385@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 08:15:03AM +0200, Greg KH wrote:
>On Tue, May 07, 2019 at 07:57:01AM +0200, Rasmus Villemoes wrote:
>> On 07/05/2019 07.38, Sasha Levin wrote:
>> > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> >
>> > [ Upstream commit 88ca66d8540ca26119b1428cddb96b37925bdf01 ]
>> >
>> > The minimum supported gcc version is >= 4.6, so these can be removed.
>>
>> Eh, that bump happened for the 4.19 kernel, so this is not true for the
>> 4.14 branch. Has cafa0010cd51fb711fdcb50fc55f394c5f167a0a been applied
>> to 4.14.y? Otherwise I don't think this is appropriate.
>
>No, that commit is not in 4.14, so we still have to "support" older
>versions of gcc there :(
>
>Sasha, can you drop this?

Dropped, thanks!

--
Thanks,
Sasha

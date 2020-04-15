Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDB61AB3EE
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 00:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbgDOWtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 18:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgDOWtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 18:49:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880C42076D;
        Wed, 15 Apr 2020 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586990990;
        bh=IDwp/KvvmusXyTYpTl5uFNNVNlAXor0idQUJrdATD2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C5/Up3ooIQtlaYqxz/HXec2GhZBjrYHqqRcp09qAxkl2XxjF7IpOPEvgb7DegVNtP
         44QvtlGFXlU8McZw+MirmAkYR89eRzUloSU74vPcxiC3u6nyOlyF4iO8W2b+C+n84R
         +4IE6pUaLNB5l2YoV0yjm7cwhij+ucO8wg7jFdf8=
Date:   Wed, 15 Apr 2020 18:49:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, bhelgaas@google.com,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] XArray: Fix xa_find_next for large
 multi-index entries" failed to apply to 5.4-stable tree
Message-ID: <20200415224949.GK1068@sasha-vm>
References: <1586948677159164@kroah.com>
 <20200415150222.GD5820@bombadil.infradead.org>
 <20200415165122.GA3654762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415165122.GA3654762@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 06:51:22PM +0200, Greg KH wrote:
>On Wed, Apr 15, 2020 at 08:02:22AM -0700, Matthew Wilcox wrote:
>> On Wed, Apr 15, 2020 at 01:04:37PM +0200, gregkh@linuxfoundation.org wrote:
>> > The patch below does not apply to the 5.4-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> > >From bd40b17ca49d7d110adf456e647701ce74de2241 Mon Sep 17 00:00:00 2001
>>
>> Seems like it's already there as commit
>> 16696ee7b58101c90bf21c3ab2443c57df4af24e
>
>Ugh.
>
>Sasha, your scripts are applying patches to older kernels before newer
>ones for some odd reason again, which confuses mine to no end :(

/me scratches head

It's in 5.6, 5.5, and 5.4. I've also queued them all at the same time
and you've released them all at the same time (Apr 8th).

Yes, it's tagged for stable, but I've grabbed it for the Fixes: tag.

What am I missing?

-- 
Thanks,
Sasha

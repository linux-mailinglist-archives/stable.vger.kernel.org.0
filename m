Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B333616A6
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 02:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbhDPAG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 20:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234874AbhDPAGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 20:06:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA42610CB;
        Fri, 16 Apr 2021 00:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618531561;
        bh=PQbLuUBADs7YuIUAh9LJO+jAKvWguqlWjFXzCWrd638=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XYv5XPdcZf/3y4e8Ub+tCZz9aALj1xc7ZdzVshCzwKIBSG6j1AFaI3esttSTT831W
         Kj25t2YNJ5WQRdKyUji6ar7k7wZoqQklxXxn82SJKcidT4MCREbB/6P7QgbO8M+jro
         beoYiQG8tUTIoThhid9h29UsDZAyvKC3u9spYcBqalsegMnjQ4ch2tJWH4dPfIFyXZ
         Yo38BC20xw0aglLS3urDFNuNJxrd0RLPEfeqpSDvWgU9Q7ydpEFJEIPiI4ftKjGrTZ
         lqeUq0WhL3FUid7eaFiDSt1FiI3VmdDxDZqofUaS3MaQHZLoGbShp7U0I7AaD1pygm
         zzWUngOHU4Fsw==
Date:   Thu, 15 Apr 2021 20:06:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 12/25] radix tree test suite: Fix compilation
Message-ID: <YHjU6I4+AZkkU53d@sashalap>
References: <20210415144413.165663182@linuxfoundation.org>
 <20210415144413.551014173@linuxfoundation.org>
 <20210415151236.GA2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210415151236.GA2531743@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 04:12:36PM +0100, Matthew Wilcox wrote:
>On Thu, Apr 15, 2021 at 04:48:06PM +0200, Greg Kroah-Hartman wrote:
>> From: Matthew Wilcox (Oracle) <willy@infradead.org>
>>
>> [ Upstream commit 7487de534dcbe143e6f41da751dd3ffcf93b00ee ]
>>
>> Commit 4bba4c4bb09a added tools/include/linux/compiler_types.h which
>> includes linux/compiler-gcc.h.  Unfortunately, we had our own (empty)
>> compiler_types.h which overrode the one added by that commit, and
>> so we lost the definition of __must_be_array().  Removing our empty
>> compiler_types.h fixes the problem and reduces our divergence from the
>> rest of the tools.
>
>I don't see 4bba4c4bb09a backported to 5.10.y, so I think this will break
>compilation of the radix tree test suite.  The corresponding commit for
>5.11.y is good, since 5.11.y includes 4bba4c4bb09a.

I'll drop it from 5.10, thanks!

-- 
Thanks,
Sasha

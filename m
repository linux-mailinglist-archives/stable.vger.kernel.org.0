Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA64247BAA
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgHRAzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 20:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgHRAzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 20:55:38 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E36D20789;
        Tue, 18 Aug 2020 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597712137;
        bh=MyLBtOkx7MAh86cun2mYNwFMG7fn3zQ+n6TqXSjGeIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o2J1gd4XqlGYcZb90y5rRLrDFCfFtVicU5iebB9MB5qegXWippCwYNQzgjdlDBsxR
         HkPVVDfVa9ONxh3uyxn+eqijNQVnYBM7KquMapK+fwJ0ecMlamcFrHjNcTgaN0cXAv
         D1ic2QwnXTBuhz06InkT4Y2UtpFeEoawVVxyEdVM=
Date:   Mon, 17 Aug 2020 20:55:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Andreas =?iso-8859-1?Q?Gr=FCnbacher?= 
        <andreas.gruenbacher@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5.8 214/464] iomap: Make sure iomap_end is called after
 iomap_begin
Message-ID: <20200818005536.GG4122976@sasha-vm>
References: <20200817143833.737102804@linuxfoundation.org>
 <20200817143844.062314049@linuxfoundation.org>
 <CAHpGcMJPQjfabb0_9n=rVBZXQqdnhvcaA3rgbNBemb4OqSYYgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHpGcMJPQjfabb0_9n=rVBZXQqdnhvcaA3rgbNBemb4OqSYYgA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 09:56:02PM +0200, Andreas Grünbacher wrote:
>Gerg,
>
>Am Mo., 17. Aug. 2020 um 21:39 Uhr schrieb Greg Kroah-Hartman
><gregkh@linuxfoundation.org>:
>> From: Andreas Gruenbacher <agruenba@redhat.com>
>>
>> [ Upstream commit 856473cd5d17dbbf3055710857c67a4af6d9fcc0 ]
>>
>> Make sure iomap_end is always called when iomap_begin succeeds.
>>
>> Without this fix, iomap_end won't be called when a filesystem's
>> iomap_begin operation returns an invalid mapping, bypassing any
>> unlocking done in iomap_end.  With this fix, the unlocking will still
>> happen.
>>
>> This bug was found by Bob Peterson during code review.  It's unlikely
>> that such iomap_begin bugs will survive to affect users, so backporting
>> this fix seems unnecessary.
>
>this doesn't need to be backported.

Now dropped, thanks!

-- 
Thanks,
Sasha

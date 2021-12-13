Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3914732B6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 18:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbhLMRKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 12:10:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbhLMRKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 12:10:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 803FFB811E4;
        Mon, 13 Dec 2021 17:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE31C34600;
        Mon, 13 Dec 2021 17:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639415435;
        bh=kkvIpkmawwIjXx5mjnzb3Qo76kdaI6KWhL4+4TY6bKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EXsI3c7+a1htohJ6Zqc/U/zQ3Z2oj7DfhXjR/J4IdhPyun+3uDxK7ZeZUWkegRSjc
         mjr5bXeeXGvIDfVNEV/1yKsfebRGxH1W1E44UX/ndd4fJ/6WnXWwnlFqQy0VwwXfbX
         HB4YSNNngotXgTX4mRVKvvcHk2YxTHAtXjQAjOJz/FIXsOkLf8Os2XDyEXz9dCqvJl
         xgceRkHSyFu06wuXKgfnIR5KMe8vqlS7IIGZ484g7U1nMOoOAvngakVhi5dYqjvY7d
         zFU00EhqZBBStjxhmQX/6lRvspCNJWR/sPi0nw2RQ/Ijh1zkOM7oh3jAJU7SpfSsd3
         oBlh5s6GouEbQ==
Date:   Mon, 13 Dec 2021 12:10:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 13/24] tools: Fix math.h breakage
Message-ID: <Ybd+if4php4IoSjT@sashalap>
References: <20211206211230.1660072-1-sashal@kernel.org>
 <20211206211230.1660072-13-sashal@kernel.org>
 <Ya5+ckVw3ZYjdNDJ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Ya5+ckVw3ZYjdNDJ@casper.infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 09:19:46PM +0000, Matthew Wilcox wrote:
>On Mon, Dec 06, 2021 at 04:12:18PM -0500, Sasha Levin wrote:
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>
>> [ Upstream commit d6e6a27d960f9f07aef0b979c49c6736ede28f75 ]
>>
>> Commit 98e1385ef24b ("include/linux/radix-tree.h: replace kernel.h with
>> the necessary inclusions") broke the radix tree test suite in two
>> different ways; first by including math.h which didn't exist in the
>> tools directory, and second by removing an implicit include of
>> spinlock.h before lockdep.h.  Fix both issues.
>
>I'm confused.  Was 98e1385ef24b backported to v5.15?  I don't see it
>in linux-5.15.y, and I don't know why it would be considered a stable
>backport candidate.  If not, why would this patch be needed?

Yup, I can drop this one. Thanks!

-- 
Thanks,
Sasha

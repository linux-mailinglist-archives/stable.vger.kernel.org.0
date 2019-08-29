Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600D9A2128
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 18:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfH2QmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 12:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbfH2QmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 12:42:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 031752070B;
        Thu, 29 Aug 2019 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567096938;
        bh=bRpqTp3EjTmLNhGd3WmD0wtWWTzJRaoQEOOaMMh/9qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KtLG/S2tSMFYc5IJeMsFlWVsyXjpRehwx+Mw4Cy0TBEsERF1DhBJvMZRxuTwnvkp1
         uVRPCVZrPmtgecc0hldS6Ie+52Q28fIDUhduZu7Z/L0nV18MC9bRH2qqx/a27YBkx6
         YQdw+rvueX/1l73Y6Gri7rMc/Vc/YyKvYOP05VCA=
Date:   Thu, 29 Aug 2019 12:42:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tyler Hicks <tyhicks@canonical.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Todd Kjos <tkjos@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 4.14 05/14] binder: take read mode of mmap_sem in
 binder_alloc_free_page()
Message-ID: <20190829164217.GJ5281@sasha-vm>
References: <20190829105043.2508-1-sashal@kernel.org>
 <20190829105043.2508-5-sashal@kernel.org>
 <20190829151052.GB27650@elm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829151052.GB27650@elm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 10:10:52AM -0500, Tyler Hicks wrote:
>Hello, Sasha!
>
>On 2019-08-29 06:50:34, Sasha Levin wrote:
>> From: Tyler Hicks <tyhicks@canonical.com>
>>
>> [ Upstream commit 60d4885710836595192c42d3e04b27551d30ec91 ]
>>
>> Restore the behavior of locking mmap_sem for reading in
>> binder_alloc_free_page(), as was first done in commit 3013bf62b67a
>> ("binder: reduce mmap_sem write-side lock"). That change was
>> inadvertently reverted by commit 5cec2d2e5839 ("binder: fix race between
>> munmap() and direct reclaim").
>>
>> In addition, change the name of the label for the error path to
>> accurately reflect that we're taking the lock for reading.
>>
>> Backporting note: This fix is only needed when *both* of the commits
>> mentioned above are applied. That's an unlikely situation since they
>> both landed during the development of v5.1 but only one of them is
>> targeted for stable.
>
>This patch isn't meant to be applied to 4.14 since commit 3013bf62b67a
>("binder: reduce mmap_sem write-side lock") was never brought back to
>4.14.
>
>My backporting note above isn't helpful for AUTOSEL purposes. Do you
>have a suggestion for what I could have done in the patch tags to convey
>that guidance to AUTOSEL?

Hey Tyler,

No, this is just me messing up. AUTOSEL actually handled this well.

What happened here you ask? This series is basically a set of patches
that fix a different fix that went into stable. It didn't go through the
regular AUTOSEL flow and I goofed up manually. Sorry for the noise, I've
dropped the patch.

--
Thanks,
Sasha

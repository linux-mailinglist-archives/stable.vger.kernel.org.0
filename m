Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87102B7F28
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgKROJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 09:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKROJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 09:09:56 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF6921D40;
        Wed, 18 Nov 2020 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605708595;
        bh=XaoMyPznMWDK/EOZjQkHKMaMWhsHDD9HrZoAO1RXHcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LkO+4DRsdaGssHF+IYYUU2YB5Dt17B/tEK0BzfLw3jQiwj6CXu5l7QYSsn8/ShKfO
         bBk0U3yBqqoZqCUDHuEuoqXEHjbuQEG/nYFCJ+m67Hg+MFhbqjrtqrAJFLIY13B+DH
         hB0CgpCVf23uF2F8S48GGG+mf9GGKKN3Z1T42HGk=
Date:   Wed, 18 Nov 2020 09:09:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     Hussam Al-Tayeb <ht990332@gmx.com>, stable@vger.kernel.org
Subject: Re: Suggestion: Lengthen the review period for stable releases from
 48 hours to 7 days.
Message-ID: <20201118140953.GC629656@sasha-vm>
References: <17c526d0c5f8ed8584f7bee9afe1b73753d1c70b.camel@gmx.com>
 <20201117080141.GA6275@amd>
 <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
 <1605651898@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1605651898@msgid.manchmal.in-ulm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 11:29:16PM +0100, Christoph Biedl wrote:
>On the other hand the pace of the stable patches became fairly high¹, so
>during a week of -rc review a *lot* of them will queue up and I predict
>we'll see requests for fast-laning some of them. Also, a release would
>immediately be followed by the next -rc review period, a procedure that
>gives me a bad feeling.

Keep in mind that the stable tree derives itself from Linus's tree -
it's not a development tree on it's own and we don't control how many
fixes flow into Linus's tree (and as a result into the stable tree).

This means that it doesn't matter how long the review window is open
for, you'll be getting the same time to review a single patch - whether
we do 200 patches twice a week or 400 patches once a week. We can't
create time by moving review windows around.

-- 
Thanks,
Sasha

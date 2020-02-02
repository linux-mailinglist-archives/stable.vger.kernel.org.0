Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916ED14FF91
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 23:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBBWXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 17:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgBBWXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Feb 2020 17:23:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33AB420658;
        Sun,  2 Feb 2020 22:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580682231;
        bh=3Cft4eQS49oSTdTofx8DWKRfBJSDJvnwbgQgE+wYwAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QqzbW6CJ+KG+F9LiJ5zEaNi1syd1KtwVwVHYrMFx5xg4Kc7GSld/2v9MOADFhPTDs
         COh6Bhegzhq/U1rN+3UuHB/kG2zkHege1IjdJ9nBU4+C1QmKcCor0vFlNBzRNBagsq
         Vbwzh677kCIPgWrSdqAvPL+hFOJe6kkEqsaxqehU=
Date:   Sun, 2 Feb 2020 17:23:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Michael <fedora.dm0@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Patch fd24a86 ("KVM: PPC: Book3S PR: Fix -Werror=return-type
 build failure") for 5.5
Message-ID: <20200202222350.GD1732@sasha-vm>
References: <CAEvUa7=e9RKmb71NTU-uvyEVYC2CzdagUgwj4k=Tg97F5jWMfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEvUa7=e9RKmb71NTU-uvyEVYC2CzdagUgwj4k=Tg97F5jWMfA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 09:45:08PM -0500, David Michael wrote:
>Hi,
>
>Can you please apply the following trivial patch to the next 5.5
>stable release?  It corrects a build failure for a PowerPC KVM
>configuration.
>
>https://github.com/torvalds/linux/commit/fd24a8624eb29d3b6b7df68096ce0321b19b03c6

Queued up for 5.5, thanks!

-- 
Thanks,
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E89051C22
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 22:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfFXUR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 16:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfFXUR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 16:17:26 -0400
Received: from localhost (unknown [167.220.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A78B20645;
        Mon, 24 Jun 2019 20:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561407445;
        bh=V5CX1ldDiziORU4wtHIlX3WC7pmIIArB1gRa+JVxG2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vFEzqPncGMYeYqi2GzJ6NCpWua/9rvy3zjT7ciFLkgbLNUixN7ir2aZXD6Gk78l8F
         Y7YBlNaYkd+7rJeD2kAhHvBDa7zYZqniSJL4FvNA8aeYNAFZ6/a0IZqxqQt3LNUHKr
         M/LHSCkKVrtyypUjLr6/3xDQJI6tGFJ0VbjkH6f8=
Date:   Mon, 24 Jun 2019 16:17:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc:     stable@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable-commits@vger.kernel.org
Subject: Re: [PATCH] IB/hfi1: Avoid hardlockup with flushlist_lock
Message-ID: <20190624201724.GA3881@sasha-vm>
References: <20190624161428.17461.31880.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190624161428.17461.31880.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 12:14:29PM -0400, Mike Marciniszyn wrote:
>commit cf131a81967583ae737df6383a0893b9fee75b4e upstream.
>
>Heavy contention of the sde flushlist_lock can cause hard lockups at
>extreme scale when the flushing logic is under stress.
>
>Mitigate by replacing the item at a time copy to the local list with
>an O(1) list_splice_init() and using the high priority work queue to
>do the flushes.
>
>Ported to linux-4.14.y.

I've queued this one for 4.19 and 4.14, thank you.

--
Thanks,
Sasha

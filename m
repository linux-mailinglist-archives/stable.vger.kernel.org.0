Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6062C44A5
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 01:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfJAXzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 19:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfJAXzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 19:55:11 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F29020818;
        Tue,  1 Oct 2019 23:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569974111;
        bh=3r7lqDy55hUu7wNov+llLPThtmifXV8BQoHziy6iHg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lDkxCsWAal/Y2SDjC8n6TCR6vjobk+ORHB8Vt+Y06ISDen3gebxvOpFMhqqVMrnYQ
         A8KvPXzzvTdByEd4AE6Y5IGVdBwEcf/cpgVdltIILrFSfKHXXwnLLDMsw704JZRoBe
         x4kCKcYhlPR0Yf5wMH6R85kWbJxfDxTozDN70N5o=
Date:   Tue, 1 Oct 2019 19:55:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, bvanassche@acm.org,
        emilne@redhat.com, hare@suse.com, hch@lst.de, snitzer@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: implement .cleanup_rq callback"
 failed to apply to 4.19-stable tree
Message-ID: <20191001235509.GG17454@sasha-vm>
References: <1569949365193105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1569949365193105@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 07:02:45PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I saw that it was also dropped from 5.3/5.2 for build errors. To resolve
those I took 226b4fc75c78 ("blk-mq: add callback of .cleanup_rq") which
is also tagged for stable.

For 4.19 there were some context changes due to the removal of the
legacy IO code (6a23e05c2fe3c ("dm: remove legacy request-based IO
path") et al).

--
Thanks,
Sasha

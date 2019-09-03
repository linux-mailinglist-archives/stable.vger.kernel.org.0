Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD46BA75ED
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 23:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfICVHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 17:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfICVG7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 17:06:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F7DE2087E;
        Tue,  3 Sep 2019 21:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567544818;
        bh=okV0J7lHMBoJGVCQQxOr4no4JSTVrQt3MhrQlO6q8Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXPtM6pnOzLs46IxzBGssBPeYFFt+KB7DgnLIT0HLOP98mqtruw5pio5f+2DW2P4d
         wIU9a+b/nicPocTgsq2FnR472K2aJW5psr2iyH51+sw025imxc+gtXBlnoj/sC7cmb
         8UvsgVyB6iBEf5yHo5W/dDdksEgWjXVAyD8aEqjg=
Date:   Tue, 3 Sep 2019 17:06:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     trond.myklebust@hammerspace.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] NFSv4/pnfs: Fix a page lock leak in
 nfs_pageio_resend()" failed to apply to 4.4-stable tree
Message-ID: <20190903210657.GQ5281@sasha-vm>
References: <1567537135131165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1567537135131165@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 08:58:55PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've fixed it up and queued it for 4.19, 4.14, 4.9, and 4.4. I ended up
taking 078b5fd92c491 ("NFS: Clean up list moves of struct nfs_page")
just because it made the backport cleaner (and it's indeed a nice
cleanup).

--
Thanks,
Sasha

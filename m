Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736AA162BC6
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgBRRLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgBRRLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 12:11:38 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 250DB207FD;
        Tue, 18 Feb 2020 17:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582045898;
        bh=bwT9OhkcTfBxbUQP4ZHEvaaSm8+JAJVYWRgG536fzBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lu9mxBMBEot/jM33/c2PzLd5BvEp0EmhnsenTVJqMrcXxzr8FtI2hVS8wgczwZykP
         x0keDTnxrZyvcRZFhMvDHzA33LlyWhlAGfPToFxYJO5W83TOw2se7bnDsJwDMLPbWq
         G0PXGdcPk5J0ZZxEB6pAHI9E0QjIZs70QOwoiD4Q=
Date:   Tue, 18 Feb 2020 12:11:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     axboe@kernel.dk, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io-wq: add support for inheriting ->fs"
 failed to apply to 5.5-stable tree
Message-ID: <20200218171137.GS1734@sasha-vm>
References: <1581966726127197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581966726127197@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:12:06PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 9392a27d88b9707145d713654eb26f0c29789e50 Mon Sep 17 00:00:00 2001
>From: Jens Axboe <axboe@kernel.dk>
>Date: Thu, 6 Feb 2020 21:42:51 -0700
>Subject: [PATCH] io-wq: add support for inheriting ->fs
>
>Some work items need this for relative path lookup, make it available
>like the other inherited credentials/mm/etc.
>
>Cc: stable@vger.kernel.org # 5.3+
>Signed-off-by: Jens Axboe <axboe@kernel.dk>

It needed some context adjustment going back to 5.5 due to cccf0ee83455
("io_uring/io-wq: don't use static creds/mm assignments").

Do we actually need this on 5.4? I thought io-wq was a 5.5 thing?

-- 
Thanks,
Sasha

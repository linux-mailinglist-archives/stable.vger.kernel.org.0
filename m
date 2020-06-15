Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E29C1F8C7A
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 05:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgFODfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 23:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbgFODfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jun 2020 23:35:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08422078A;
        Mon, 15 Jun 2020 03:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592192106;
        bh=sqwWAsTpUEvF7cxlar/W7uWRQ6Ab32Y4P8GE28N3LD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iU4i3Ikz0NXiqOMj5xsFiq3ad/L/F2X3MwJHg2zpL65EdnFztGBSky+uBbvDrOtn6
         l/0z2pzv4lkQlZEEB4ZK1eaiGAn/NPMNNvHO0cuSJpirftJuGn1467Pp5TorgMsVSZ
         7uJWpGQ9DOKGjVvhsh0jT1SroVQtnl1tD2sT6lgY=
Date:   Sun, 14 Jun 2020 23:35:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     William Dauchy <wdauchy@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: backport status of two sctp commits
Message-ID: <20200615033504.GE5492@sasha-vm>
References: <CAJ75kXa6U1w2ahZ3avX5OdM+pRA-5CaudeLD30o0rMVSaJkKhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ75kXa6U1w2ahZ3avX5OdM+pRA-5CaudeLD30o0rMVSaJkKhg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 10:44:00PM +0200, William Dauchy wrote:
>Hello,
>
>I found the following sctp commits:
>
>582eea230536a6f104097dd46205822005d5fe3a ("sctp: fix possibly using a
>bad saddr with a given dst")
>backported in the following stable versions: v5.6.x, v5.5.x, v4.19.x,
>v4.14.x, v4.9.x, v4.4.x.
>
>5c3e82fe159622e46e91458c1a6509c321a62820 ("sctp: fix refcount bug in
>sctp_wfree")
>backported in the following stable versions: v5.6.x, v5.5.x, v4.19.x,
>v4.14.x, v4.9.x
>
>However I cannot find them in v5.4.x yet. I checked stable queue on
>netdev side (http://patchwork.ozlabs.org/bundle/davem/stable/?state=*)
>but also main stable queue
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
>
>I was wondering whether it was an oversight or was it expected?
>
>Sorry for the noise if I'm mistaken.

Looks like we missed these too (and a few more) which are now queued up,
thanks again!

-- 
Thanks,
Sasha

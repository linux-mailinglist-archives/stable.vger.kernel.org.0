Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7125235BAB7
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 09:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDLHUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 03:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236745AbhDLHUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 03:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40F2861206;
        Mon, 12 Apr 2021 07:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618211984;
        bh=dpZLQz4zZUWFnFbqrTt5XOnNDfXCUQ5fZ41UZSLzrlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IRvobsxcAmZDbJDkhX1yI9giod2wI0s+bkkQJIZ3lVZNEx/20d/NYq78b7OyeiEur
         vutc10IQCNH5LQPFrphhQrMHbRnGjRc5t8PStS3mkdKWS7XoxKSQghwCdKpUqctJ0W
         rpiaXLoMtfz0TtwGtlW8Jh/vytGc3XCymyagQoyM=
Date:   Mon, 12 Apr 2021 09:19:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     6f17ac98-5b23-3068-b6ec-4911273fe093@linuxfoundation.org
Cc:     skhan@linuxfoundation.org, tseewald@gmail.com,
        syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>,
        syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>,
        syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usbip: fix vudc usbip_sockfd_store races leading to gpf
Message-ID: <YHP0jVfzdFxsSg32@kroah.com>
References: <20210410004930.17411-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410004930.17411-1-tseewald@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 07:49:30PM -0500, Tom Seewald wrote:
> [backport of mainline commit 46613c9dfa96 ("usbip: fix vudc
> usbip_sockfd_store races leading to gpf") to 4.9 and 4.14]

Thanks, now queued up.

greg k-h

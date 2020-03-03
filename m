Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A93317825E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgCCSV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgCCSV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:21:59 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1487E2073B;
        Tue,  3 Mar 2020 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583259719;
        bh=WaOYtdjusO5LjN4fLUdSUvX/OO05WiiiZG2W5HfDd6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0STGFglROtzqLLT0agAR8tpGBRBelPtM0qneKIgugmMlyeufWgYpL2fFQaO/+84JH
         HnSxV30n2v3v7PIqi5xHKiVvk/lWT7nTjsyyriKtK7wd2KG7NezzjaLKoecd6FwN2S
         BD24Ysj+LiqeepqjvaRGQc0GHDLmjpz0tmBTK3Q8=
Date:   Tue, 3 Mar 2020 13:21:57 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     paul@paul-moore.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] audit: always check the netlink payload
 length in" failed to apply to 4.19-stable tree
Message-ID: <20200303182157.GL21491@sasha-vm>
References: <15831732722521@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15831732722521@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 07:21:12PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 756125289285f6e55a03861bf4b6257aa3d19a93 Mon Sep 17 00:00:00 2001
>From: Paul Moore <paul@paul-moore.com>
>Date: Mon, 24 Feb 2020 16:38:57 -0500
>Subject: [PATCH] audit: always check the netlink payload length in
> audit_receive_msg()
>
>This patch ensures that we always check the netlink payload length
>in audit_receive_msg() before we take any action on the payload
>itself.
>
>Cc: stable@vger.kernel.org
>Reported-by: syzbot+399c44bf1f43b8747403@syzkaller.appspotmail.com
>Reported-by: syzbot+e4b12d8d202701f08b6d@syzkaller.appspotmail.com
>Signed-off-by: Paul Moore <paul@paul-moore.com>

Worked around missing 626abcd13d4e ("audit: add syscall information to
CONFIG_CHANGE records") in older kernels, queued for 4.19-4.4.

-- 
Thanks,
Sasha

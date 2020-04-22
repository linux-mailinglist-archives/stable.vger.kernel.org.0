Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4631B33DE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 02:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDVARX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 20:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgDVARW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 20:17:22 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E41120575;
        Wed, 22 Apr 2020 00:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587514642;
        bh=IBPnJPfXD8ClyGxLbkdzTyRpElust0nkRQkdXmy+qug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eTR7Nx1zy5UDEsgWoyGp1THrYYJKpaxTTGYB+vv2nLvpqmnBQS9MsLhouDOgQrrMq
         o9THHfeFZMGULNPGxjS8OshQSzE8mdKU9AUMStiyzshes5mcxGw6K5dU5Euk3V9WAn
         DjG7eC+lCls9CNuE3+kNoiU9EHvauSokGjFxspzc=
Date:   Tue, 21 Apr 2020 20:17:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     magnus.karlsson@intel.com, daniel@iogearbox.net,
        minhquangbui99@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xsk: Add missing check on user supplied
 headroom size" failed to apply to 4.19-stable tree
Message-ID: <20200422001721.GO1809@sasha-vm>
References: <158748891372198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158748891372198@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 07:08:33PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 99e3a236dd43d06c65af0a2ef9cb44306aef6e02 Mon Sep 17 00:00:00 2001
>From: Magnus Karlsson <magnus.karlsson@intel.com>
>Date: Tue, 14 Apr 2020 09:35:15 +0200
>Subject: [PATCH] xsk: Add missing check on user supplied headroom size
>
>Add a check that the headroom cannot be larger than the available
>space in the chunk. In the current code, a malicious user can set the
>headroom to a value larger than the chunk size minus the fixed XDP
>headroom. That way packets with a length larger than the supported
>size in the umem could get accepted and result in an out-of-bounds
>write.
>
>Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
>Reported-by: Bui Quang Minh <minhquangbui99@gmail.com>
>Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=207225
>Link: https://lore.kernel.org/bpf/1586849715-23490-1-git-send-email-magnus.karlsson@intel.com

Conflict with 624676e78899 ("xdp: xdp_umem: replace kmap on vmap for
umem map") around 'i' going away. Fixed and queued for 4.19.

-- 
Thanks,
Sasha

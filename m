Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0311FA2B0
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgFOVVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 17:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgFOVVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 17:21:40 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63E420679;
        Mon, 15 Jun 2020 21:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592256100;
        bh=XxhXHsXm6DVZn5n0/lH3kJ6TKnJ/OFczrYxsyU3ttYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZc3OMG52cvsyRd0cA4uqXGpIjfGo2c5vJ5XdnA5cKUGALvdS5AZEgIUrBcUIan32
         MwaVw9xouYfysOpzRbFSi5Hy9oTe8ypxSiaipTJWX3biChNM6SrNNum7PHO/zas8MC
         zYcE+WWKKjb/FTx3MmKDiyfjGRuLr7jCfI1+7+UQ=
Date:   Mon, 15 Jun 2020 17:21:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     franck.lenormand@nxp.com, aisheng.dong@nxp.com,
        leonard.crestez@nxp.com, shawnguo@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] firmware: imx: scu: Fix corruption of
 header" failed to apply to 5.7-stable tree
Message-ID: <20200615212138.GC1931@sasha-vm>
References: <15922334107128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15922334107128@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:03:30PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
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
>From f5f27b79eab80de0287c243a22169e4876b08d5e Mon Sep 17 00:00:00 2001
>From: Franck LENORMAND <franck.lenormand@nxp.com>
>Date: Thu, 26 Mar 2020 00:00:05 +0200
>Subject: [PATCH] firmware: imx: scu: Fix corruption of header
>
>The header of the message to send can be changed if the
>response is longer than the request:
> - 1st word, the header is sent
> - the remaining words of the message are sent
> - the response is received asynchronously during the
>   execution of the loop, changing the size field in
>   the header
> - the for loop test the termination condition using
>   the corrupted header
>
>It is the case for the API build_info which has just a
>header as request but 3 words in response.
>
>This issue is fixed storing the header locally instead of
>using a pointer on it.
>
>Fixes: edbee095fafb (firmware: imx: add SCU firmware driver support)
>
>Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
>Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
>Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
>Cc: stable@vger.kernel.org
>Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
>Signed-off-by: Shawn Guo <shawnguo@kernel.org>

I've also grabbed f25a066d1a07 ("firmware: imx-scu: Support one TX and
one RX") for 5.7, 5.6, and 5.4.

-- 
Thanks,
Sasha

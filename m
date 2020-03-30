Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C4197C39
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgC3Ms2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 08:48:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbgC3Ms2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 08:48:28 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE6B206F6;
        Mon, 30 Mar 2020 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585572507;
        bh=x7TFFF3jEqeQif2ldU+S78OO5Af5QWf6bxWDLcb+d0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rzkNNLJQNqjpXXpuhRSm3lm3k+D6gvcP0wrpWnte81hQqIdwAawNqcMdgzwiDl5UK
         x5EfxffdYmIhS+tG+gFktN5usOnO/9N/xwk2VNFLI3rrAKegkTZUY/5ZchGK7s8hBi
         R+7R18R9V/C8N141rtDPpHmcaKid9SikYZrxLmTw=
Date:   Mon, 30 Mar 2020 08:48:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dan.carpenter@oracle.com, dmitry.torokhov@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Input: raydium_i2c_ts - fix error codes
 in" failed to apply to 4.14-stable tree
Message-ID: <20200330124826.GF4189@sasha-vm>
References: <15855617453276@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15855617453276@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 11:49:05AM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From 32cf3a610c35cb21e3157f4bbf29d89960e30a36 Mon Sep 17 00:00:00 2001
>From: Dan Carpenter <dan.carpenter@oracle.com>
>Date: Fri, 6 Mar 2020 11:50:51 -0800
>Subject: [PATCH] Input: raydium_i2c_ts - fix error codes in
> raydium_i2c_boot_trigger()
>
>These functions are supposed to return negative error codes but instead
>it returns true on failure and false on success.  The error codes are
>eventually propagated back to user space.
>
>Fixes: 48a2b783483b ("Input: add Raydium I2C touchscreen driver")
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>Link: https://lore.kernel.org/r/20200303101306.4potflz7na2nn3od@kili.mountain
>Cc: stable@vger.kernel.org
>Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I also took 6cad4e269e25 ("Input: raydium_i2c_ts - use true and false
for boolean values") to work around this conflict. Queued both for 4.14
and 4.9.

-- 
Thanks,
Sasha

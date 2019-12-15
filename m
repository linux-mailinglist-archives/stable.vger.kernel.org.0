Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996C311FAAE
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 20:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfLOTLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 14:11:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfLOTLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 14:11:47 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 173E624679;
        Sun, 15 Dec 2019 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576437107;
        bh=0MNPR4xFYvIu4z9YqYR7S+W/f8sXJZfpGoWN1dW+N8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0XBIaE0Klr5S82ViLuMey6cZPF+5QGynO3/moIfbKdsgKV4r9lU2/tlK3gAcdEmg6
         6UBFDZBz7K9IJ7w2fLhJFQO8m51jnS1kJfOLe4uX7KgSkZYeAdWlL430tDVLu7egyU
         PjluZ/e4tj1Pc60gJXt9qmHIp4Dm35xAmU4eAtWY=
Date:   Sun, 15 Dec 2019 14:11:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     krzk@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] pinctrl: samsung: Fix device node
 refcount leaks in S3C64xx" failed to apply to 4.9-stable tree
Message-ID: <20191215191145.GS18043@sasha-vm>
References: <1576416657206164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576416657206164@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 02:30:57PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.9-stable tree.
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
>From 7f028caadf6c37580d0f59c6c094ed09afc04062 Mon Sep 17 00:00:00 2001
>From: Krzysztof Kozlowski <krzk@kernel.org>
>Date: Mon, 5 Aug 2019 18:27:09 +0200
>Subject: [PATCH] pinctrl: samsung: Fix device node refcount leaks in S3C64xx
> wakeup controller init
>
>In s3c64xx_eint_eint0_init() the for_each_child_of_node() loop is used
>with a break to find a matching child node.  Although each iteration of
>for_each_child_of_node puts the previous node, but early exit from loop
>misses it.  This leads to leak of device node.
>
>Cc: <stable@vger.kernel.org>
>Fixes: 61dd72613177 ("pinctrl: Add pinctrl-s3c64xx driver")
>Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Fixed up context and queued for 4.9 and 4.4.

-- 
Thanks,
Sasha

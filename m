Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44722045F1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 02:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731803AbgFWAmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 20:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731442AbgFWAmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 20:42:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6E3206C1;
        Tue, 23 Jun 2020 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592872929;
        bh=lDG/JZDsuAf9acFjC7NDazsOUESIIp2StvHO75x/iNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qHBgiHW698HTcR5ESkds1pevRBUZWtgcLB7BaB9MvHuFR9TUu/7Mc7UwbS98pJo04
         fb1zuaIyb9QhIuEvdErIDRQ3tEpORUcsvDNu8oQBiQQzCc7v7Q/sVTCN84P/Z1Ija9
         /cvVKGzlLkSl6PqhrlYKP8QtV3evkhiwrkXMs1U8=
Date:   Mon, 22 Jun 2020 20:42:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     efremov@linux.com, saeedm@mellanox.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net/mlx5: DR, Fix freeing in
 dr_create_rc_qp()" failed to apply to 5.7-stable tree
Message-ID: <20200623004207.GR1931@sasha-vm>
References: <1592574342143235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592574342143235@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 03:45:42PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 47a357de2b6b706af3c9471d5042f9ba8907031e Mon Sep 17 00:00:00 2001
>From: Denis Efremov <efremov@linux.com>
>Date: Mon, 1 Jun 2020 19:45:26 +0300
>Subject: [PATCH] net/mlx5: DR, Fix freeing in dr_create_rc_qp()
>
>Variable "in" in dr_create_rc_qp() is allocated with kvzalloc() and
>should be freed with kvfree().
>
>Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
>Cc: stable@vger.kernel.org
>Signed-off-by: Denis Efremov <efremov@linux.com>
>Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Conflict due to quite a lot of refactoring around QP. I've fixed it up
and queued for 5.7 and 5.4.

-- 
Thanks,
Sasha

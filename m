Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00DD6C91
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 02:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfJOAnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 20:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfJOAnH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 20:43:07 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 407D32067B;
        Tue, 15 Oct 2019 00:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571100186;
        bh=WvQkNAtwJuRDs0ablfCEHWX/d8MBecjWYYbhy+b7mW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dOgXbAF0l6BYKwr8nI5c7l9V2YGy0u1Omi6Pa3nVCNRi62KZnNDVhCUIR0kWSDjEG
         3KU9hbKPngklZQ3TPf+326RZ8FEjvdpt65WxPjgkvoHokMD7Ib/stP+23lpppoM6A6
         k++EfcrOylA5E9E52pnfvKbqJa/dY5ro9MODAHgU=
Date:   Mon, 14 Oct 2019 20:43:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     navid.emamdoost@gmail.com, dan.carpenter@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Staging: fbtft: fix memory leak in
 fbtft_framebuffer_alloc" failed to apply to 4.14-stable tree
Message-ID: <20191015004305.GF31224@sasha-vm>
References: <1571065171233128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1571065171233128@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 04:59:31PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 5bdea6060618cfcf1459dca137e89aee038ac8b9 Mon Sep 17 00:00:00 2001
>From: Navid Emamdoost <navid.emamdoost@gmail.com>
>Date: Sun, 29 Sep 2019 22:09:45 -0500
>Subject: [PATCH] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc
>
>In fbtft_framebuffer_alloc the error handling path should take care of
>releasing frame buffer after it is allocated via framebuffer_alloc, too.
>Therefore, in two failure cases the goto destination is changed to
>address this issue.
>
>Fixes: c296d5f9957c ("staging: fbtft: core support")
>Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
>Reviewed-by: Dan Carpenter <dan.carpenter@gmail.com>
>Cc: stable <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/20190930030949.28615-1-navid.emamdoost@gmail.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Conflicts due to 333c7b940526b ("staging: fbtft: Fixes some alignment
issues - Style"). Fixed up and queued for 4.14-4.4.

-- 
Thanks,
Sasha

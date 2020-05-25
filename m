Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F461E155C
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 22:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390799AbgEYUxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 16:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390640AbgEYUxg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 25 May 2020 16:53:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A492071A;
        Mon, 25 May 2020 20:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440016;
        bh=4zu4opwE6LBY2GASiTIBQNhEvfz9DbyElMvvDfeoRh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XZJVXqL4AcgNdftIWWy0YZ/KZVIi4hb3XevrrQMVocRogmtS9fweur+G8pBEDvqE/
         xZ8NbZQqoYqKFX/tlRWUhk/epBKbyN6yhcNZrj1x/MbPf+NKjQLhClRJHBDc4PFcPF
         tUKZU+GGJCFlRIoRorihGR27BY7XCvprm+j/boRA=
Date:   Mon, 25 May 2020 16:53:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     christophe.jaillet@wanadoo.fr, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: sca3000: Remove an erroneous
 'get_device()'" failed to apply to 4.9-stable tree
Message-ID: <20200525205335.GB33628@sasha-vm>
References: <15904149497542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15904149497542@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 03:55:49PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 928edefbc18cd8433f7df235c6e09a9306e7d580 Mon Sep 17 00:00:00 2001
>From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>Date: Wed, 6 May 2020 05:52:06 +0200
>Subject: [PATCH] iio: sca3000: Remove an erroneous 'get_device()'
>
>This looks really unusual to have a 'get_device()' hidden in a 'dev_err()'
>call.
>Remove it.
>
>While at it add a missing \n at the end of the message.
>
>Fixes: 574fb258d636 ("Staging: IIO: VTI sca3000 series accelerometer driver (spi)")
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>Cc: <Stable@vger.kernel.org>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Back in 4.9 and 4.4 this code was in staging, I've fixed up the patch to
reflect the old path and queued it for 4.9 and 4.4.

-- 
Thanks,
Sasha

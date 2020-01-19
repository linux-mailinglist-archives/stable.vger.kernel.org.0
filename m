Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A07B141EE4
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgASPm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgASPm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 10:42:27 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5715620684;
        Sun, 19 Jan 2020 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579448546;
        bh=Oz6qsM+A/FkVSEiYdt1KrUVIQD4/tQUtyuX1n8LF41A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwiCMRempHpJN3LsWmhzHiDVeZvyDnP/sgqhXm7ArqHrV/4MGuLxeja8yoJnM26L2
         SaqdYFO+PCKON1veS0CZDGeACwzuV0Nw0ypaxX02lIZozM4/T1Y+pWQX4DFIUvPswc
         PQsFQHj+OuYZVXnwBV0XNID1aq+v38j0WkQ/o5zg=
Date:   Sun, 19 Jan 2020 10:42:25 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     johan@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: io_edgeport: handle unbound
 ports on URB" failed to apply to 4.14-stable tree
Message-ID: <20200119154225.GQ1706@sasha-vm>
References: <15794412294018@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15794412294018@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 02:40:29PM +0100, gregkh@linuxfoundation.org wrote:
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
>From e37d1aeda737a20b1846a91a3da3f8b0f00cf690 Mon Sep 17 00:00:00 2001
>From: Johan Hovold <johan@kernel.org>
>Date: Fri, 17 Jan 2020 10:50:23 +0100
>Subject: [PATCH] USB: serial: io_edgeport: handle unbound ports on URB
> completion
>
>Check for NULL port data in the shared interrupt and bulk completion
>callbacks to avoid dereferencing a NULL pointer in case a device sends
>data for a port device which isn't bound to a driver (e.g. due to a
>malicious device having unexpected endpoints or after an allocation
>failure on port probe).
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Cc: stable <stable@vger.kernel.org>
>Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Signed-off-by: Johan Hovold <johan@kernel.org>

I also took dd1fae527612 ("USB: serial: io_edgeport: use irqsave() in
USB's complete callback") as a fix on it's own, and queued both for
4.14-4.4.

-- 
Thanks,
Sasha

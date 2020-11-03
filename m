Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE92A4501
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 13:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgKCMYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 07:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbgKCMYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 07:24:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5790922243;
        Tue,  3 Nov 2020 12:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604406292;
        bh=DXOlk/Mk2EpUpOBBV1lQqjJrZqyr7Xqhlbr7VFsPP4s=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HiAJ4it5OQdpGHo80VpkakThLRuOpvYKOg81hvNqwjMJkGJdYctTryfWZ+RdYBhj+
         8WTadJ3WwGfXic5vwqDyHul4y72DPlWd066HYLwCaV2isPG8yGM0+YSkjoG4R9jqZr
         2TOFift1oxO1LVXhKAhswIzU+LFJi3GD647qSIww=
Date:   Tue, 3 Nov 2020 13:25:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     martin.fuzzey@flowbird.group, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] w1: mxc_w1: Fix timeout resolution
 problem leading to bus" failed to apply to 4.19-stable tree
Message-ID: <20201103122545.GA1512802@kroah.com>
References: <1604405490163203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604405490163203@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 01:11:30PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From c9723750a699c3bd465493ac2be8992b72ccb105 Mon Sep 17 00:00:00 2001
> From: Martin Fuzzey <martin.fuzzey@flowbird.group>
> Date: Wed, 30 Sep 2020 10:36:46 +0200
> Subject: [PATCH] w1: mxc_w1: Fix timeout resolution problem leading to bus
>  error

Sorry, no, this patch is fine, no problems with it.

greg k-h

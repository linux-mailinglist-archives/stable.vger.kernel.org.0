Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E503807C8
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhENK53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 06:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhENK52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 06:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC43361407;
        Fri, 14 May 2021 10:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620989776;
        bh=YhVqfPK50ur1e6gFJYV0eJ9Sg4Ott3azGKVWD1lV+tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZdANlN2iZa1IBNEZnmlfTKCJVhLBftbZuOOb8QJZpENO0KA3p0QFMFik22t6sAWVc
         9TGV8URRlLlirEj2++8ajvRrnGtdnWGWbyf8+Q9NJxXLqVR6z1GQhreZ2/jKTRbbJt
         KZrn+wwsk0S+A3xq1ZyVWYbFMUJ6418Xo48dJQIM=
Date:   Fri, 14 May 2021 12:56:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukasz Luba <lukasz.luba@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com
Subject: Re: [STABLE][PATCH 4.4] thermal/core/fair share: Lock the thermal
 zone while looping over instances
Message-ID: <YJ5XTW9TYvv7wYr6@kroah.com>
References: <20210514104916.19975-1-lukasz.luba@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514104916.19975-1-lukasz.luba@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 11:49:16AM +0100, Lukasz Luba wrote:
> commit fef05776eb02238dcad8d5514e666a42572c3f32 upstream.
> 
> The tz->lock must be hold during the looping over the instances in that
> thermal zone. This lock was missing in the governor code since the
> beginning, so it's hard to point into a particular commit.
> 
> CC: stable@vger.kernel.org # 4.4
> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> ---
> Hi all,
> 
> I've backported my patch which was sent to LKML:
> https://lore.kernel.org/linux-pm/20210422153624.6074-2-lukasz.luba@arm.com/
> 
> The upstream patch failed while applying:
> https://lore.kernel.org/stable/16206371483193@kroah.com/
> 
> This patch should apply to stable v4.4.y, on top of stable tree branch:
> linux-4.4.y which head was at:
> commit 47127fcd287c ("Linux 4.4.268")

What about 4.9, 4.14, 4.14, and 5.4 releases?  They need this fix as
well, right?

thanks,

greg k-h

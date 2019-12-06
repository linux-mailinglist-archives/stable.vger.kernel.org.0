Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2EB115213
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 15:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfLFOLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 09:11:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfLFOLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 09:11:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6302464E;
        Fri,  6 Dec 2019 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575641492;
        bh=sc/85t8+YSiBpvxlBgm8L0KeL4CoWmNFdnx5Lt1ZcUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V7jwmf+941C5Lt2wXkC3EbMW2ct1ZvXKuiDYSAxqC4AUiRPzSC0Kw0zDMLJvo7M/k
         P4sZZHgRLDGOKPPT2qmbvlgTwTY/5DeLDKYr+4oYfnLE5rMyPmJ+M6+opgl3gxnsKX
         7zo+HunPLWN0DFIHg1KPW7re4QzVZiaF/jkjJQjY=
Date:   Fri, 6 Dec 2019 15:11:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuewei Zhang <xueweiz@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
Message-ID: <20191206141129.GA9376@kroah.com>
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com>
 <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 03:30:05PM -0800, Xuewei Zhang wrote:
> Backport patch that cleanly applies for 4.19, 4.14, 4.9, 4.4 stable trees:

Did you send this twice?

And the patch is totally corrupted:

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f77fcd37b226..f0abb8fe0ae9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4868,20 +4868,28 @@ static enum hrtimer_restart
> sched_cfs_period_timer(struct hrtimer *timer)
>   if (++count > 3) {
>   u64 new, old = ktime_to_ns(cfs_b->period);
> 
> - new = (old * 147) / 128; /* ~115% */
> - new = min(new, max_cfs_quota_period);
> -
> - cfs_b->period = ns_to_ktime(new);
> -

All of your leading whitespace is gone.

You can't use the web client of gmail to send patches inline, sorry.

Can you fix this up and resend all of the backports, none of these
worked :(

greg k-h

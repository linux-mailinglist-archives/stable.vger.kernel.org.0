Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BBC2CB5EA
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 08:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgLBHub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 02:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgLBHua (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 02:50:30 -0500
Date:   Wed, 2 Dec 2020 08:51:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606895390;
        bh=bHBlIp6/6bYR2DZlcmjkccGcs7LLQN4wYoeb0vik4Ao=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=0jq8eRs+mIqdWi/DvOBQtKDLzEUhm825U1gwCfN3k2faM3R0/1oQrfcg3XIcSNh1x
         uLWxzlQ81/kW07IT1Jgca+NkxBmjAJwibf8SDvRs/S3nA+CmcRYf6k1HH1yCH+sATa
         g2EJYYSA8iTAIu0UiptwcMQOvRI+gv7ipi2WKfBE=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        bsegall@google.com, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, pauld@redhat.com,
        zohooouoto@zoho.com.cn, stable@vger.kernel.org,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <X8dHZP78hCVlb3n9@kroah.com>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <e87e517b-7f97-66ba-4f17-718330910a7b@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e87e517b-7f97-66ba-4f17-718330910a7b@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 12:03:18PM -0300, Guilherme G. Piccoli wrote:
> Hey Sasha, sorry to annoy again, but maybe Peter is very busy - wouldn't
> be possible maybe to get that merged after a review from Ben or Ingo? I
> see them in the MAINTAINERS file, specially Ben as CONFIG_CFS_BANDWIDTH
> maintainer.
> 
> I understand the confidence in this patch is relatively high, since it's
> a backport from the author, right?

I still want to see an ack from the maintainer please.

thanks,

greg k-h

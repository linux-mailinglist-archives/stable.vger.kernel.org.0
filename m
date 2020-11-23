Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962AD2C048C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 12:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgKWL3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 06:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726529AbgKWL3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 06:29:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC2020738;
        Mon, 23 Nov 2020 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606130945;
        bh=/bDMxu/XhoL7jTadFOVfSuS4hIsANusbWwjaP4eGXGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WEVJb8U6ZmUDl5zBOPbs+OMMIO5V0/EKPcZzoBZMTpez0rMeTaEHRFKIk/4tB2Js5
         /hnwYFIiqCapHQ512q9znQDorY3aD04ARhkDBVwHCA++AtsL9EUFx8cznxcB+ey94V
         11AHHW2nxNAndtmGuc4Y2ie9a1gqA7Oh1vDOkS/w=
Date:   Mon, 23 Nov 2020 12:30:15 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Quentin Perret <qperret@google.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Rick Yiu <rickyiu@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH 5.4] sched/fair: Fix overutilized update in
 enqueue_task_fair()
Message-ID: <X7udR7EupRVR8IF/@kroah.com>
References: <20201123101827.451304-1-qperret@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123101827.451304-1-qperret@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 10:18:27AM +0000, Quentin Perret wrote:
> [ Upstream commit 8e1ac4299a6e8726de42310d9c1379f188140c71 ]
> 
> enqueue_task_fair() attempts to skip the overutilized update for new
> tasks as their util_avg is not accurate yet. However, the flag we check
> to do so is overwritten earlier on in the function, which makes the
> condition pretty much a nop.
> 
> Fix this by saving the flag early on.

Now queued up, thanks.

greg k-h

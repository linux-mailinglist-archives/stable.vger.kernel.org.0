Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34980A7365
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfICTOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfICTOx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:14:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE5B5206BB;
        Tue,  3 Sep 2019 19:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567538092;
        bh=7sEOV673oFO8l4CmRtVcKS4YMcOs5mJAeAce8k0Y2sc=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=iIfPmASwChsOLbrmvGChZ5ojXK6Dt/uK8VE5XdPn0fj0LEPpixQ9EsdFuxigf3aSX
         NR6yBIdGukrVVmN3dzS/rrTCona/C0mcq7k7wirrAgmv0zzcn8jzlduaODz4SWbIo9
         3eY3C2p+zA3NH0QNhP+2c5HRcSExEAJoZJCoIo04=
Date:   Tue, 3 Sep 2019 21:14:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     shakeelb@google.com, akpm@linux-foundation.org, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm: memcontrol: fix percpu vmstats and
 vmevents flush" failed to apply to 5.2-stable tree
Message-ID: <20190903191450.GA25676@kroah.com>
References: <156753769868234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156753769868234@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 09:08:18PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Nevermind, I fixed it up...

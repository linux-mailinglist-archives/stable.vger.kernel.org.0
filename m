Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CEC283633
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 15:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJENFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 09:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJENFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 09:05:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C60207BC;
        Mon,  5 Oct 2020 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601903134;
        bh=Llv1KFY2t2NggOiKKeTQ7Gdj4zlqKlUMuTYlOVjt760=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBBhUUacjyol5e5fQV9rSqkr2ox/iIhODPWoRgkVV1VUZErq3pS0JoY/k8cGIn+Bo
         bRm+gkgGDn14s/lSxu9+P82Q6SBukkNT+JNOoTEtv7/Pl5Pq1wyPH2LbulYyadENAd
         pRdQvoQyiebFWfEThWOfvslDFhyFcdQdlBY6ucbQ=
Date:   Mon, 5 Oct 2020 15:06:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Scott Cheloha <cheloha@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20201005130619.GC827657@kroah.com>
References: <20200929162250.67282-1-ldufour@linux.ibm.com>
 <20200929162250.67282-2-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929162250.67282-2-ldufour@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 06:22:50PM +0200, Laurent Dufour wrote:
> Backport version to the 4.19-stable tree of:
> [ Upstream commit f85086f95fa36194eb0db5cd5c12e56801b98523 ]

Both series, now queued up, thanks!

gre gk-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03183179685
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCDRRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 12:17:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgCDRRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 12:17:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34E9121775;
        Wed,  4 Mar 2020 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583342237;
        bh=9SOwh6tiXke4ADGABVHNeMcWR2SB1NZku+zHX5kktoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sINCAxI9TCk0yNSFmOWYAZrCSU61w759KFN+oLnuvWTIDLSx6s36vY1zMl2luMWHU
         n8JTP+7Dzu+ufOIbWj8k7r5dhAd5HcQk/vsGAKfWoj5AOZ19BRq0tnl/Gx560HLvd+
         jvql+5Bc+3ZIckpEKSZBqBaAIXkpgdt3f8gS7oog=
Date:   Wed, 4 Mar 2020 18:17:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Scott Wood <swood@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 05/87] sched/core: Dont skip remote tick for idle
 CPUs
Message-ID: <20200304171715.GB1852712@kroah.com>
References: <20200303174349.075101355@linuxfoundation.org>
 <20200303174349.478213998@linuxfoundation.org>
 <20200304151559.GB2367@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304151559.GB2367@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 04:15:59PM +0100, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 488603b815a7514c7009e6fc339d74ed4a30f343 ]
> > 
> > This will be used in the next patch to get a loadavg update from
> > nohz cpus.  The delta check is skipped because idle_sched_class
> > doesn't update se.exec_start.
> 
> I don't see the next patch queued for 4.19-stable. AFAICT this does
> not fix anything without the subsequent patch?

Ah, good catch, that patch only made it into 5.4.y and 5.5.y, I'll drop
this from the 4.19 queue, thanks.

greg k-h

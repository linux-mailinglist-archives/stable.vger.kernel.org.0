Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49AF4954C8
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 20:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243669AbiATTQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 14:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243610AbiATTQF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 14:16:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3550C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 11:16:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5955B81E1D
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 19:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2A3C340E3;
        Thu, 20 Jan 2022 19:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642706161;
        bh=12h4hERyqF/hXSyc5i5v6ZJ7cdtBiogVlxJQ2daQHEY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Y0V6ARsRKnIaNJayMaAP+TayolqHH1iYrUpIctVBLYKcSwsvth3qTUUmgs++UYeDW
         19OWsKp1uAd1cK22O9pZYhFiFh/+3hjDwCKfZYH/EaN0HiYEyooSn5faopU6xGyo5X
         me31yNBVbxHtrLwXOY8A1izIi62vfuXKJhTF7sm3ff5a7IS82GI316Oo9LeeYyP74u
         fxzOlqpHD37W0cAzulRoo224YA8n4VI1piAFm7wC9epYYvWWwnFqzfj2Hp+GIFVqv+
         dKAAVrFggJ2OzQe5hMs60tCcEoiyh0X2rRIu6pmf21nxiLZl+EPc1j6qzULe/kJ6cx
         NK/xtkZCE247Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 3EBF55C0367; Thu, 20 Jan 2022 11:16:00 -0800 (PST)
Date:   Thu, 20 Jan 2022 11:16:00 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YemwBdpmBeC03JeT@bender.morinfr.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 07:55:01PM +0100, Guillaume Morin wrote:
> Paul,
> 
> I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
> 5.17) should be queued for all 5.4+ stable branches as it fixes a
> serious lockup bug. FWIW I have verified it applies cleanly on all 4
> branches.
> 
> Does that make sense to you?

From a quick glance at v5.4, it looks quite plausible to me.

I do suggest that you try building and testing, given that the hardware's
idea of what is plausible overrides that of either of us.  ;-)

							Thanx, Paul

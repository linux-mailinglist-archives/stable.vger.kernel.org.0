Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953434954DD
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 20:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbiATT05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 14:26:57 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:13286 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237666AbiATT04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jan 2022 14:26:56 -0500
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id 74911B0055A;
        Thu, 20 Jan 2022 20:26:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=21sBtuyePJbWfcW6KiPhYr5jyeub4XwYhGbbHyacV/I=; b=vSmBI1ckY1CTR/gMoylH+NFMjW
        3T6fytmXB2wXTT3k2dstkfM0Zv0bJivhEKE9oUH28xAFonJ2oksTc85NKe1wPRhK0BkEYy25PqNi4
        YlQgW5ybxfjPH2EgYrWI3yIuQ1jU9dYBBAZ/cmM+11t+nuatJe53pP2IeTisx4lTom0Q=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1nAd5C-0001qC-NG; Thu, 20 Jan 2022 20:26:54 +0100
Date:   Thu, 20 Jan 2022 20:26:54 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <Yem3fsHWahJEvjsk@bender.morinfr.org>
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20 Jan 11:16, Paul E. McKenney wrote:
> On Thu, Jan 20, 2022 at 07:55:01PM +0100, Guillaume Morin wrote:
> > I believe commit 614ddad17f22a22e035e2ea37a04815f50362017 (slated for
> > 5.17) should be queued for all 5.4+ stable branches as it fixes a
> > serious lockup bug. FWIW I have verified it applies cleanly on all 4
> > branches.
> > 
> > Does that make sense to you?
> 
> From a quick glance at v5.4, it looks quite plausible to me.
> 
> I do suggest that you try building and testing, given that the hardware's
> idea of what is plausible overrides that of either of us.  ;-)

We've had a few dozens lockups on 5.4 and 5.10 due to this bug (what
lead me to write to you back in Sep). The original bugzilla report is on
5.4 as well, see https://bugzilla.kernel.org/show_bug.cgi?id=208685. So
I am positive that the issue is reachable in both kernels.

Also I do know for sure it fixes the problem for 5.10. I don't have a
test rig anymore for 5.4. But considering we know it's reachable with
5.4, I think the patch should be applied for 5.4+. Obviously, you're the
expert here though.

-- 
Guillaume Morin <guillaume@morinfr.org>

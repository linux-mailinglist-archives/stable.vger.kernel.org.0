Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBCF4987FB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiAXSM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:12:59 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:40948 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235811AbiAXSM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 13:12:58 -0500
Received: from bender.morinfr.org (unknown [82.65.130.196])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id 83560B005AE;
        Mon, 24 Jan 2022 19:12:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7igT4t0X/3asKLyDV+jQ6y0zs62AiDcmInL6fJhRrQE=; b=4E5kWezDUiLlG8F0FQbVMCJeUw
        OKC9oY+/k+SaisfZqAZo4352CvwjaT86eBt1Nwp10ZXf7Zxu6MzqyR9lU6JdxUUqsH8PTGh+Zb0Sj
        mtc5KbIzXwfmeGyVgpolS4OHuCMSSn+cbSipfSiKoBsisxhz8Srx/mrtYOFdTQeKjb4U=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.94.2)
        (envelope-from <guillaume@morinfr.org>)
        id 1nC3pn-001liM-R0; Mon, 24 Jan 2022 19:12:55 +0100
Date:   Mon, 24 Jan 2022 19:12:55 +0100
From:   Guillaume Morin <guillaume@morinfr.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Guillaume Morin <guillaume@morinfr.org>,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        neelx@redhat.com
Subject: Re: [PATCH for stable 5.x] rcu: Tighten rcu_advance_cbs_nowake()
 checks
Message-ID: <Ye7sJ+7szTW0mKYd@bender.morinfr.org>
References: <YemwBdpmBeC03JeT@bender.morinfr.org>
 <20220120191600.GP947480@paulmck-ThinkPad-P17-Gen-1>
 <Yem3fsHWahJEvjsk@bender.morinfr.org>
 <20220120205705.GQ947480@paulmck-ThinkPad-P17-Gen-1>
 <YengcErT48sYK0yL@bender.morinfr.org>
 <20220120233331.GS947480@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120233331.GS947480@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20 Jan 15:33, Paul E. McKenney wrote:
> > ---- TREE01 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> > ---- TREE04 8: Kernel present. Thu 20 Jan 2022 05:03:55 PM EST
> > ---- Starting kernels. Thu 20 Jan 2022 05:03:55 PM EST
> > ---- All kernel runs complete. Thu 20 Jan 2022 05:14:05 PM EST
> > ---- TREE01 8: Build/run results:
> >  --- Thu 20 Jan 2022 05:02:37 PM EST: Starting build
> >  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> > CPU-hotplug kernel, adding rcutorture onoff.
> > Monitoring qemu job at pid 46081
> > Grace period for qemu job at pid 46081
> > ---- TREE04 8: Build/run results:
> >  --- Thu 20 Jan 2022 05:03:16 PM EST: Starting build
> > :CONFIG_HOTPLUG_CPU: improperly set
> >  --- Thu 20 Jan 2022 05:03:55 PM EST: Starting kernel
> > CPU-hotplug kernel, adding rcutorture onoff.
> > Monitoring qemu job at pid 45847
> > Grace period for qemu job at pid 45847
> > 
> > 
> >  --- Thu 20 Jan 2022 05:02:37 PM EST Test summary:
> > Results directory: /usr/scratch/kernel/tools/testing/selftests/rcutorture/res/2022.01.20-17:02:37
> > tools/testing/selftests/rcutorture/bin/kvm.sh --cpus 60 --duration 10 --configs TREE01 TREE04
> > TREE01 ------- 12719 GPs (21.1983/s) [rcu: g94609 f0x0 ]
> > TREE04 ------- 3128 GPs (5.21333/s) [rcu: g23621 f0x0 ]
> > :CONFIG_HOTPLUG_CPU: improperly set
> 
> This run was successful, so good!

Greg, so could you please queue up
614ddad17f22a22e035e2ea37a04815f50362017 for 5.4+ stable branches?

Thank you

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>

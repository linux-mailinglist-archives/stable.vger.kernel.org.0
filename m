Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116FC65D180
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 12:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjADLeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 06:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239059AbjADLeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 06:34:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449351D0C0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 03:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8EEBB80E65
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 11:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD33C433D2;
        Wed,  4 Jan 2023 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672832059;
        bh=kXGihEOnbm+xGkiLWNwSRA+dOwbUD/E3bSFcvTpw2z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGiJco2GPlj4qZjjMRk4S8+ZOXIxpBi0MwdSHG3/M2il3VNVxNQZO65IpPnqksx6/
         jaJJt242yMRNY7SvQ+y/3yEDPo5oAYxkfiNH4j0/nn1x9J99WmVBtBTytC5/kAdmbH
         5EYETyfuPokUPDmf3fdPTSwzJpUOBpJG2BHTStJs=
Date:   Wed, 4 Jan 2023 12:34:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     jack@suse.cz, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rtmutex: Add acquire semantics for
 rtmutex lock acquisition" failed to apply to 5.15-stable tree
Message-ID: <Y7VkM1IhXbvX3TlL@kroah.com>
References: <167265568418742@kroah.com>
 <20230103093937.enoobqqkdoumdmcc@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103093937.enoobqqkdoumdmcc@techsingularity.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 09:39:37AM +0000, Mel Gorman wrote:
> On Mon, Jan 02, 2023 at 11:34:44AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > 1c0908d8e441 ("rtmutex: Add acquire semantics for rtmutex lock acquisition slow path")
> > ee042be16cb4 ("locking: Apply contention tracepoints in the slow path")
> > d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more consistent")
> > 7cdacc5f52d6 ("locking/rwsem: Disable preemption for spinning region")
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Hi Greg,
> 
> I don't plan to backport this to -stable. It's PREEMPT_RT-specific so
> anyone how needs it are managing their own OOT patches. The prerequisites
> are not -stable material so ideally anyone backporting would be functionally
> verifying their target workloads still works ok and meets deadlines. Normal
> users of stable kernels are not impacted by the bug this patch fixes.

Thanks for the info!

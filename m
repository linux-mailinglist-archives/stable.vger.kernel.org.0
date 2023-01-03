Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD12B65BD6B
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 10:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbjACJsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 04:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbjACJrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 04:47:42 -0500
X-Greylist: delayed 479 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Jan 2023 01:47:39 PST
Received: from outbound-smtp25.blacknight.com (outbound-smtp25.blacknight.com [81.17.249.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DA9E0DE
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 01:47:39 -0800 (PST)
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp25.blacknight.com (Postfix) with ESMTPS id 30700CAC7C
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:39:39 +0000 (GMT)
Received: (qmail 10971 invoked from network); 3 Jan 2023 09:39:39 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.198.246])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 3 Jan 2023 09:39:38 -0000
Date:   Tue, 3 Jan 2023 09:39:37 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     gregkh@linuxfoundation.org
Cc:     jack@suse.cz, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rtmutex: Add acquire semantics for
 rtmutex lock acquisition" failed to apply to 5.15-stable tree
Message-ID: <20230103093937.enoobqqkdoumdmcc@techsingularity.net>
References: <167265568418742@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <167265568418742@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 11:34:44AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 1c0908d8e441 ("rtmutex: Add acquire semantics for rtmutex lock acquisition slow path")
> ee042be16cb4 ("locking: Apply contention tracepoints in the slow path")
> d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more consistent")
> 7cdacc5f52d6 ("locking/rwsem: Disable preemption for spinning region")
> 
> thanks,
> 
> greg k-h
> 

Hi Greg,

I don't plan to backport this to -stable. It's PREEMPT_RT-specific so
anyone how needs it are managing their own OOT patches. The prerequisites
are not -stable material so ideally anyone backporting would be functionally
verifying their target workloads still works ok and meets deadlines. Normal
users of stable kernels are not impacted by the bug this patch fixes.

-- 
Mel Gorman
SUSE Labs

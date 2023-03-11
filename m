Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552D26B6071
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 21:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCKUR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 15:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKUR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 15:17:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2574F4EDB;
        Sat, 11 Mar 2023 12:17:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D1D9B802C8;
        Sat, 11 Mar 2023 20:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79158C433EF;
        Sat, 11 Mar 2023 20:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678565872;
        bh=zAct4A8dmYLb2tq1YcKZbZIBN7UDdczcn/skD8kSt3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=owmTL6eeeugcG1J/n/MoUyt8Bg8zWaLBFBI5LC0ucS0KQ+vDZgJDlROR+ARetbyl5
         /pIgnCJiquebkzjtev1wfPFkgiWZKWexbr0zt9Gd5g4BOcBRpjzf6saZ4BYx5AgT4p
         MGiat+kGTjZbqeHMvDWUn2AVDtfOzx2siR89LIVrFOO5Aha17s+2be+7gOrwed1DGs
         ZkkmWf6QqlqHiYWEipjFD1SsiXWp9cQd0NU4b3ql5l11vFD9U58izjb6eVsKh337Ta
         2DAdpDmbq5IJ5tLLpZsZbJ7RP9IKMGaajRtEhyVtkc/O3Z/fdNvAICPpPvp/HTzga7
         1MhmvvPpZ1mHQ==
Date:   Sat, 11 Mar 2023 12:17:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <ZAzh7l8qWtkeh/KK@sol.localdomain>
References: <Y/y70zJj4kjOVfXa@sashalap>
 <Y/zswi91axMN8OsA@sol.localdomain>
 <Y/zxKOBTLXFjSVyI@sol.localdomain>
 <ZATC3djtr9/uPX+P@duo.ucw.cz>
 <ZAewdAql4PBUYOG5@gmail.com>
 <ZAwe95meyCiv6qc4@casper.infradead.org>
 <ZAyK0KM6JmVOvQWy@sashalap>
 <20230311161644.GH860405@mit.edu>
 <ZAy+3f1/xfl6dWpI@sol.localdomain>
 <ZAzH8Ve05SRLYPnR@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAzH8Ve05SRLYPnR@sashalap>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 01:26:57PM -0500, Sasha Levin wrote:
> I'm getting a bunch of suggestions and complaints that I'm not implementing
> those suggestions fast enough on my spare time.

BTW, the "I don't have enough time" argument is also a little frustrating
because you are currently insisting on doing AUTOSEL at all, at the current
sensitivity that picks up way too many commits.  I can certainly imagine that
that uses a lot of your time!  But, many contributors are telling you that
AUTOSEL is actually *worse than nothing* currently.

So to some extent this is a self-inflicted problem.  You are *choosing* to spend
your precious time running in-place with something that is not working well,
instead of putting AUTOSEL on pause or turning down the sensitivity to free up
time while improvements to the process are worked on.

(And yes, I know there are many stable patches besides AUTOSEL, and it's a lot
of work, and I'm grateful for what you do.  I am *just* talking about AUTOSEL
here.  And yes, I agree that AUTOSEL is needed in principle, so there's no need
to re-hash the arguments for why it exists.  It just needs some improvements.)

- Eric

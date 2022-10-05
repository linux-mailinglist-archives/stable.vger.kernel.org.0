Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0ED5F4FA6
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 08:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJEGGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 02:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJEGGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 02:06:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89CE24BCE;
        Tue,  4 Oct 2022 23:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91B14B81C3E;
        Wed,  5 Oct 2022 06:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B778DC433C1;
        Wed,  5 Oct 2022 06:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664949968;
        bh=MpLFCaVwerEpjS+mtbJKzuyrWSfiHKNoLWl6NtGY0AE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nkO12Tv+2bfy1FzCbOMncHv3KMRdlPtYdCCeFkSl7gNXRc1b7BOJBePeJwRhXyYDS
         wgV5Y7WfQs6XP6ti5ffEOcHF27K2HXWjPIpXGsyTOW1KV+UzGj141aPcc1BpSik/yv
         sUFPGhL4hCXBazTyFNep7sfABmh3itnh6BWzBGos=
Date:   Wed, 5 Oct 2022 08:06:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Slade Watkins <srw@sladewatkins.net>
Cc:     Carl Dasantas <dasantas2020@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: New Longterm Kernel before 6.1 Rust?
Message-ID: <Yz0e+LF0F7wIfgvR@kroah.com>
References: <CANNVxH9biW6OYNFbF7ZVvSBCk4+1RAWmgjXA9Z55uCntrRasbQ@mail.gmail.com>
 <3034898c-a6ab-6982-aea3-656a09398ffb@sladewatkins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3034898c-a6ab-6982-aea3-656a09398ffb@sladewatkins.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 05, 2022 at 01:05:08AM -0400, Slade Watkins wrote:
> On 10/3/22 at 9:35 AM, Carl Dasantas wrote:
> > 
> > I was wondering if a new longterm kernel will be made prior to 6.1
> > being released with Rust support added? As the kernel.org page
> > https://www.kernel.org/category/releases.html states "Longterm kernels
> > are picked based on various factors -- major new features...". In my
> > opinion, adding Rust support is a major new feature. Of course it goes
> > on to say new longterm kernels are dependent on time, etc so I thought
> > I would inquire. No harm in that, right? I'm sure there are a lot of
> > others in our community that are hesitant as I am with Rust and want
> > to see where it goes. It would be nice to have a recent longterm
> > kernel so we can see how this Rust stuff plays out. Possibly from 6.0
> > or 5.19?
> 
> Not sure if a decision has been made yet. IMHO, it may be _a bit_ before we
> see this year's longterm release picked.

I try to make the LTS release the "last kernel of the year" unless that
turns out to have major issues (i.e. people use the LTS release as an
excuse to throw a lot of crap into it, which has happened in the past,
and almost happened here again for 6.1).

Rust has nothing at all to do with this decision, sorry.  For 6.1 it is
only a "hello world" type thing, not like you would be using Rust for
anything else in the kernel at this point in time.

hope this helps,

greg k-h

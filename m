Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764674E396D
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 08:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbiCVHOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 03:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiCVHOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 03:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21FA47048;
        Tue, 22 Mar 2022 00:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813CA614B3;
        Tue, 22 Mar 2022 07:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2D9C340EC;
        Tue, 22 Mar 2022 07:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647933165;
        bh=yxwU7CsJOCNbdkgv4B/ZBXEicx3XwqOv3MwlaB6taR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UzUxnCQQ+GbsBzK+1XSgGzkDKkZWeLRDbg5/QJ1pZW8r9bET5RhhEvUwztTwnbt7J
         UaDFlEMo1PD6qt5qxsVTRjDkxdofEp5PW3RqCD4zv2EMGVvgltgLOUA31slsLNObSN
         s/kOa5yRc2IOmi0z1Vo6Tk5+wMKKbNZmlo6Ny5lg=
Date:   Tue, 22 Mar 2022 08:12:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jirka Hladky <jhladky@redhat.com>
Cc:     stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        regressions@lists.linux.dev
Subject: Re: PANIC: "Oops: 0000 [#1] PREEMPT SMP PTI" starting from 5.17 on
 dual socket Intel Xeon Gold servers
Message-ID: <Yjl26QqwU1L2XWoh@kroah.com>
References: <CAE4VaGDZr_4wzRn2___eDYRtmdPaGGJdzu_LCSkJYuY9BEO3cw@mail.gmail.com>
 <CAE4VaGDKXnQJKdayeNsAD5RcqsKu5XG2UeweLvgZoFO-pn-t9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE4VaGDKXnQJKdayeNsAD5RcqsKu5XG2UeweLvgZoFO-pn-t9Q@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 12:37:37AM +0100, Jirka Hladky wrote:
> Cc: regressions@lists.linux.dev stable@vger.kernel.org
> 
> On Tue, Mar 22, 2022 at 12:29 AM Jirka Hladky <jhladky@redhat.com> wrote:
> >
> > Starting from kernel 5.17 (tested with rc2, rc4, rc7, rc8) we
> > experience kernel oops on Intel Xeon Gold dual-socket servers (2x Xeon
> > Gold 6126 CPU)
> >
> > Bellow is a backtrace and the dmesg log.
> >
> > I have trouble creating a simple reproducer - it happens at random
> > places when preparing the NAS benchmark to be run. The script creates
> > a bunch of directories, compiles the benchmark a start trial runs.
> >
> > Could you please help to narrow down the problem?

Can you use 'git bisect' to track down the kernel commit that caused
this problem?

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1966B74A5
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 11:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCMKvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 06:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCMKvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 06:51:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D261C599;
        Mon, 13 Mar 2023 03:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF198B80E54;
        Mon, 13 Mar 2023 10:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBACC4339B;
        Mon, 13 Mar 2023 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678704670;
        bh=arjhNEJif7Gby8nt/uBqMK1A3gA2DXsuGriAjBJMOBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIlXmtjS4W80ulFXE3H89/AQWEnkBYBgXuncxKaH/g+SzNHK7ySt3jzKubTQ+fOtZ
         fVgHU+HKyA5vdnOSzmyDA5XzbneUiLUBGVGMtOO7l3tBhKmDHLxBGAcFkL0l7L83a+
         2eggI6Dwm0sHKL/hCgZ5I++mJ/E738Kxxd5l322A=
Date:   Mon, 13 Mar 2023 11:51:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HID: Stable backport request (all viable versions)
Message-ID: <ZA8AHD0sO783zXRz@kroah.com>
References: <CAHk-=wii6BZtVKYfvQCQqbE3+t1_yAb-ea80-3PcJ4KxgpfHkA@mail.gmail.com>
 <20230313090834.GA1217438@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313090834.GA1217438@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 09:08:34AM +0000, Lee Jones wrote:
> Dear Stable,
> 
> On Sun, 12 Mar 2023, Linus Torvalds wrote:
> 
> > It's another Sunday afternoon. which must mean another rc release.
> >
> > This one looks fairly normal, although if you look at the diffs, they
> > are dominated by the removal of a staging driver (r8188eu) that has
> > been superceded by a proper driver. That removal itself is 90% of the
> > diffs.
> >
> > But if you filter that out, it all looks normal. Still more than two
> > thirds in drivers, but hey, that's pretty normal. It's mostly gpu and
> > networking as usual, but there's various other driver fixes in there
> > too.
> >
> > Outside of that regular driver noise (and the unusual driver removal
> > noise) it's a little bit of everything: core networking, arch fixes,
> > documentation, filesystems (btrfs, xfs, and ext4, but also some core
> > vfs fixes). And io_uring and some tooling.
> >
> > The full shortlog is appended, for the adventurous souls that want to
> > get that kind of details. The release feels fairly normal so far, but
> > it's early days. Please keep testing and reporting any issues,
> >
> >                  Linus
> >
> > ---
> 
> > Lee Jones (2):
> >       HID: core: Provide new max_buffer_size attribute to over-ride the default
> >       HID: uhid: Over-ride the default maximum data buffer value with our own
> 
> These 2 are now in Mainline:
> 
>   b1a37ed00d790 HID: core: Provide new max_buffer_size attribute to over-ride the default
>   1c5d4221240a2 HID: uhid: Over-ride the default maximum data buffer value with our own
> 
> Please could you add them to Stable, as far bask as they'll go please.

Applied to 6.1.y and 6.2.y, anything older than that will need
backports.

thanks,

greg k-h

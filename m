Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B35C59BEF9
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiHVLxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiHVLxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:53:32 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 518B560DA;
        Mon, 22 Aug 2022 04:53:29 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 27MBrQVM019212;
        Mon, 22 Aug 2022 13:53:26 +0200
Date:   Mon, 22 Aug 2022 13:53:26 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <20220822115326.GD17080@1wt.eu>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com>
 <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com>
 <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
 <20220822080456.GB17080@1wt.eu>
 <4c42af33-dc05-315a-87d9-be0747a74df4@gmx.com>
 <20220822083044.GC17080@1wt.eu>
 <9aa83875-0a05-6b28-b4df-4071ba8ee343@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa83875-0a05-6b28-b4df-4071ba8ee343@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 07:07:19PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/8/22 16:30, Willy Tarreau wrote:
> > On Mon, Aug 22, 2022 at 04:19:49PM +0800, Qu Wenruo wrote:
> > > > Regardless, if you need an older compiler, just use these ones:
> > > > 
> > > >      https://mirrors.edge.kernel.org/pub/tools/crosstool/
> > > > 
> > > > They go back to 4.9.4 for x86, you'll surely find the right one for your
> > > > usage. I've long used 4.7.4 for kernels up to 4.9 and 6.5 for 4.19 and
> > > > above, so something within that area will surely match your needs.
> > > 
> > > BTW, it would be way more awesome if the page can provide some hint on
> > > the initial release date of the compilers.
> > > 
> > > It would help a lot of choose the toolchain then.
> > 
> > It wouldn't help, if you look closely, you'll notice that in the "other
> > releases" section you have the most recent version of each of them. That
> > does not preclude the existence of the branch earlier. For example gcc-9
> > was released in 2019 and 9.5 was emitted 3 years later. That's quite an
> > amplitude that doesn't help.
> 
> Maybe I'm totally wrong, but if GCC10.1 is released May 2020, and even
> 10.4 is released 2022, then shouldn't we expect the kernel releases
> around 2020 can be compiled for all GCC 10.x releases?
> 
> Thus the initial release date should be a good enough hint for most cases.

If you speak about initial release, yes that should generally be a valid
assumption.

> If go this method, for v4.14 I guess I should go gcc 7.x, as gcc 7.1 is
> released May 2017, even the latest 7.5 is released 2019.

Then it should definitely work. But I think you're spending way too much
time comparing dates and discussing on the subject. By the time it took
to check these dates, you could already have downloaded one such compiler
and built a kernel to verify it did build correctly ;-)

Willy

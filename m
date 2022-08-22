Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F55359BADD
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiHVIFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbiHVIFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:05:02 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C12B10AE;
        Mon, 22 Aug 2022 01:04:59 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 27M84u0h017804;
        Mon, 22 Aug 2022 10:04:56 +0200
Date:   Mon, 22 Aug 2022 10:04:56 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <20220822080456.GB17080@1wt.eu>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com>
 <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
 <YwMxRAfrrsPE6sNI@kroah.com>
 <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aff5c17-d414-2412-7269-c9d15f574037@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 03:49:51PM +0800, Qu Wenruo wrote:
> Yeah, I'm pretty sure my toolchain is too new for v4.14.0. But my distro
> only provides the latest and mostly upstream packages.

Then there's something odd in your use case. Old kernels are aimed at
those who need to have systems on which nothing changes. It's particularly
strange to be stuck in the past for the kernel but to continually upgrade
userland. Most often it's the opposite that's seen.

Regardless, if you need an older compiler, just use these ones:

   https://mirrors.edge.kernel.org/pub/tools/crosstool/

They go back to 4.9.4 for x86, you'll surely find the right one for your
usage. I've long used 4.7.4 for kernels up to 4.9 and 6.5 for 4.19 and
above, so something within that area will surely match your needs.

> It may be a even worse disaster to find a way to rollback to older
> toolchains using my distro...

No, using a prebuilt toolchain like those above is quite trivial and
it will avoid messing up with your local packages. That's the best
solution I can recommend.

Willy

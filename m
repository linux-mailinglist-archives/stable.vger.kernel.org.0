Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7800226C03E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIPJOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:14:38 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:41884 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgIPJOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 05:14:38 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 08G9EKvE013790;
        Wed, 16 Sep 2020 11:14:20 +0200
Date:   Wed, 16 Sep 2020 11:14:20 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jikos@suse.cz,
        vojtech@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yuan Ming <yuanmingbuaa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
Message-ID: <20200916091420.GF13670@1wt.eu>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140636.861676717@linuxfoundation.org>
 <20200916075759.GC32537@duo.ucw.cz>
 <20200916082510.GB509119@kroah.com>
 <20200916090723.GA4151@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916090723.GA4151@duo.ucw.cz>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Wed, Sep 16, 2020 at 11:07:23AM +0200, Pavel Machek wrote:
> I believe it will need to be reverted in Linus' tree, too. In fact,
> the patch seems to be a way for Linus to find a maintainer for the
> code, and I already stated I can do it. Patch is so new it was not
> even in -rc released by Linus.

I can honestly see how it can be missed from fbcon, but using vgacon
myself for cases like you described, I still benefit from the hw scroll
buffer which is OK.

> > See the email recently on oss-devel for one such reason why this was
> > removed...
> 
> Would you have a link for that?

Here it is:

  https://www.openwall.com/lists/oss-security/2020/09/15/2

Willy

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E56B51393A
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349698AbiD1QBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 12:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349224AbiD1QBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 12:01:44 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79694AD136;
        Thu, 28 Apr 2022 08:58:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 107)
        id DBF9368C4E; Thu, 28 Apr 2022 17:58:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
Received: from blackhole.lan (p5b33fd5a.dip0.t-ipconnect.de [91.51.253.90])
        by verein.lst.de (Postfix) with ESMTPSA id D92C567373;
        Thu, 28 Apr 2022 17:58:05 +0200 (CEST)
Date:   Thu, 28 Apr 2022 17:57:59 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Geyer <harald@ccbib.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/bridge: fix anx6345 power up sequence
Message-ID: <20220428175759.13f75c21@blackhole.lan>
In-Reply-To: <CA+E=qVdEtx8wVbcrMQYGB1ur1ykvNRp1L174mVSMkB0zeOPYNQ@mail.gmail.com>
References: <20220417181538.57fa1303@blackhole>
        <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
        <CA+E=qVdEtx8wVbcrMQYGB1ur1ykvNRp1L174mVSMkB0zeOPYNQ@mail.gmail.com>
Organization: LST e.V.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022 17:25:57 -0700
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> On Sun, Apr 17, 2022 at 11:52 AM Vasily Khoruzhick
> <anarsoul@gmail.com> wrote:

> > The change looks good to me, but I'll need some time to actually
> > test it. If you don't hear from me for longer than a week please
> > ping me.
> 
> Your change doesn't fix the issue for me. Running "xrandr --output
> eDP-1 --off; xrandr --output eDP-1 --auto" in a loop triggers the
> issue pretty quickly even with the patch.

Nope, even that works fine here. Side question: how do you initially
power on the eDP bridge? Could there be any leftovers from that
mechanism? I use a hacked-up U-Boot with a procedure similar to the
kernel driver as fixed by this change.

But the main question is: does this patch in any way worsen the
situation on the pinebook?

	Torsten

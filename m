Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A656E3305
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 20:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDOSCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 14:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDOSCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 14:02:36 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20A31FDE
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 11:02:35 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pnkEG-0004OG-1S;
        Sat, 15 Apr 2023 20:02:28 +0200
Date:   Sat, 15 Apr 2023 19:02:26 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     stable@vger.kernel.org, linux-mtd <linux-mtd@lists.infradead.org>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        chengzhihao1 <chengzhihao1@huawei.com>,
        Nicolas Schichan <nschichan@freebox.fr>,
        George Kennedy <george.kennedy@oracle.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        yi zhang <yi.zhang@huawei.com>
Subject: Request to pick "ubi: Fix failure attaching when vid_hdr offset
 equals to (sub)page size"
Message-ID: <ZDrmsnX5BHxtBNwf@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please pick

 1e020e1b96afd ("ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size")

from linux-next to stable trees.
The commit fixes a problem with another recent commit

 1b42b1a36fc94 ("ubi: ensure that VID header offset ... size")

which has already made it to stable trees and thereby broke attaching
UBI and hence renders devices unbootable.

As a temporary fix I have applied this patch downstream in OpenWrt.


Thank you!


Best regards


Daniel

----- Forwarded message from Daniel Golle <daniel@makrotopia.org> -----

Date: Sat, 15 Apr 2023 00:12:46 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Richard Weinberger <richard@nod.at>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>, chengzhihao1 <chengzhihao1@huawei.com>, Nicolas Schichan <nschichan@freebox.fr>, George Kennedy <george.kennedy@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd
	<linux-mtd@lists.infradead.org>, Sascha Hauer <s.hauer@pengutronix.de>, yi zhang <yi.zhang@huawei.com>
Subject: Re: [PATCH -next v3] ubi: Fix failure attaching when vid_hdr offset equals to (sub)page size

Hi Richard,

On Wed, Mar 29, 2023 at 11:33:40PM +0200, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Von: "Miquel Raynal" <miquel.raynal@bootlin.com>
> >> Thanks for testing.
> >> 
> >> > Tested-by: Nicolas Schichan <nschichan@freebox.fr>
> > 
> > Same here.
> > 
> > Tested-by: Miquel Raynal <miquel.raynal@bootlin.com> # v5.10, v4.19
> 
> Applied to next, PR will follow soon.

As stable linux trees are affected I wonder when this will hit
linux-stable, ie. will it be part of 5.15.108, for example?


Cheers


Daniel

----- End forwarded message -----

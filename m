Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6715A49823D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbiAXO3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:29:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238549AbiAXO3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:29:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52FF3B81059;
        Mon, 24 Jan 2022 14:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCA7C340E1;
        Mon, 24 Jan 2022 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643034562;
        bh=wM6dq5JYKAC/xsOtX29ndceFMgecyE5AD5Ktxf69ZVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zc8vphqew11LXKyNPYzGUD+3ajt5GlBKNKr2lV4BStUSnILil08sDD1f2ruPHQ1h4
         FNyL+8QllqINAvxkNz2MNF8PxttYuCYyMstYFDXzu48nlovDDqciJ/XByZ4uyNkisM
         8XMo72tbWAuomPw3aIOt3yYpUA2iqCFtzbtH+ebg=
Date:   Mon, 24 Jan 2022 15:29:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        sashal@kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, vigneshr@ti.com,
        miquel.raynal@bootlin.com,
        Yoshio Furuyama <ytc-mb-yfuruyama7@kioxia.com>, richard@nod.at,
        Stoll Eberhard <Eberhard.Stoll@kontron.de>
Subject: Re: [PATCH v2 1/2] Fix corner case in bad block table handling.
Message-ID: <Ye63v1ypd0H7FYyD@kroah.com>
References: <cover.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
 <774a92693f311e7de01e5935e720a179fb1b2468.1616635406.git.ytc-mb-yfuruyama7@kioxia.com>
 <9af5a4ae-e919-a545-809d-451217cf40f5@kontron.de>
 <ccc99c80-6771-4f04-11d9-752b7b13a5a4@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccc99c80-6771-4f04-11d9-752b7b13a5a4@kontron.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 03:11:14PM +0100, Frieder Schrempf wrote:
> Hi Greg, Sasha,
> 
> just a gentle ping for the backport request below.
> 
> Thanks!
> 
> Am 11.01.22 um 16:33 schrieb Frieder Schrempf:
> > Hi stable maintainers,
> > 
> > On 06.04.21 03:47, Yoshio Furuyama wrote:
> >> From: "Doyle, Patrick" <pdoyle@irobot.com>
> >>
> >> In the unlikely event that both blocks 10 and 11 are marked as bad (on a
> >> 32 bit machine), then the process of marking block 10 as bad stomps on
> >> cached entry for block 11.  There are (of course) other examples.
> >>
> >> Signed-off-by: Patrick Doyle <pdoyle@irobot.com>
> >> Reviewed-by: Richard Weinberger <richard@nod.at>
> > 
> > We have systems on which this patch fixes real failures. Could you
> > please add the upstream patch fd0d8d85f723 ("mtd: nand: bbt: Fix corner
> > case in bad block table handling") to the stable queues for 4.19, 5.4, 5.10?
> > 
> > Thanks!
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 9c3736a3de21 ("mtd: nand: Add core infrastructure to deal with
> > NAND devices")

Odd, I did not see this anywhere in my inbox.

Now queued up, thanks.

greg k-h

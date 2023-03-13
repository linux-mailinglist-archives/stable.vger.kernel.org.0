Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20236B771C
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 13:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCMMCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 08:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCMMCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 08:02:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2AB4AFD7
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 05:02:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F0A2611DB
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE47C433D2;
        Mon, 13 Mar 2023 12:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678708971;
        bh=yQTYsMEs9xtWImxmPOWospGT4Cem8CMi9J2FdltE7mQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMT9a/zMuL9a787BUAWGQnd8jpNmk4CC3AjDnnZP2cUCk+P3jYU97cKb6VExsy6Ex
         c/hRuSafuCIJyGpfNxXP8UV2LBDdA1g2aE/PVDf/vc0LwauXlROsL3skPxrZb2I6Ig
         LTb9KiWpdFQRxP+Va9KwP5Veguz5GQ9VSsqBRgH3wDjcSNRi5z4tajFPUipLeRoqOZ
         vepe5/AaB3pV+NFmL/CR9Yg7NkMLFfQcP1A8NJhOYcvbrzAXWCbCzUH5Kf/QWlkw6x
         Up/0/1xKsU8eYFuLQ/wfWbMrx1z9zG8QRNrn4xD5lqhSG3WSKn+8Ti7N2iiadcYxGW
         f2baI3r0xQd8Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgu8-0006mT-HW; Mon, 13 Mar 2023 13:03:52 +0100
Date:   Mon, 13 Mar 2023 13:03:52 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] irqdomain: Refactor
 __irq_domain_alloc_irqs()" failed to apply to 5.15-stable tree
Message-ID: <ZA8RKCdqE6hdUE15@hovoldconsulting.com>
References: <1678128515101149@kroah.com>
 <ZA8G3/5Ujsl2/Sc6@hovoldconsulting.com>
 <ZA8Hvr//VOQS/4zU@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA8Hvr//VOQS/4zU@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 12:23:42PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 13, 2023 at 12:19:59PM +0100, Johan Hovold wrote:
> > On Mon, Mar 06, 2023 at 07:48:35PM +0100, Greg Kroah-Hartman wrote:
> > > 
> > > The patch below does not apply to the 5.15-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > To reproduce the conflict and resubmit, you may use the following commands:
> > > 
> > > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
> > > git checkout FETCH_HEAD
> > > git cherry-pick -x d55f7f4c58c07beb5050a834bf57ae2ede599c7e
> > > # <resolve conflicts, build, test, etc.>
> > > git commit -s
> > > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678128515101149@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..
> > > 
> > > Possible dependencies:
> > > 
> > > d55f7f4c58c0 ("irqdomain: Refactor __irq_domain_alloc_irqs()")
> > 
> > The below commit applies fine to 5.15.y. Could you try cherry-picking it
> > again?
> 
> patching file kernel/irq/irqdomain.c
> Hunk #1 succeeded at 1464 (offset 23 lines).
> Hunk #2 succeeded at 1488 (offset 23 lines).
> Hunk #3 FAILED at 1486.
> 1 out of 3 hunks FAILED -- rejects in file kernel/irq/irqdomain.c
> 
> And doesn't look to apply properly as the EXPORT_SYMBOL_GPL(... line is
> not in 5.15.y

Ok, I only tried cherry picking which worked fine. I've posted a
backport of this one and the follow-on fix now.

They should be applied in order to avoid a build failure so you should
drop the second patch which you already applied ("irqdomain: Fix
mapping-creation race") in favour of that series.

Johan

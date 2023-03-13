Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6EA6B75E4
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCMLX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCMLX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:23:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB8D303DD
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 04:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E83AEB80FF2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 11:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F2AC433D2;
        Mon, 13 Mar 2023 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678706624;
        bh=AQzex0ZcUgV+6iz+CFaDftt+pUZv9JpAAE1kEjnyFuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qBk5JQVJeb2fuK3piC9qa3O12J/v2BgwmPyBeFR9oMH650W5RhlNNitHZU+yzbYgY
         yfEQD0M5TG80mCfVBJxup1YE39oCVQzJg7u/8wxXgykdERW93AmxGoBJU4/YfppRZq
         Hk0dqSiIluGK/cUIrDPuotaitZdYnjmP8e1FBDm8=
Date:   Mon, 13 Mar 2023 12:23:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     johan+linaro@kernel.org, hsinyi@chromium.org,
        mark-pk.tsai@mediatek.com, maz@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] irqdomain: Refactor
 __irq_domain_alloc_irqs()" failed to apply to 5.15-stable tree
Message-ID: <ZA8Hvr//VOQS/4zU@kroah.com>
References: <1678128515101149@kroah.com>
 <ZA8G3/5Ujsl2/Sc6@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA8G3/5Ujsl2/Sc6@hovoldconsulting.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 13, 2023 at 12:19:59PM +0100, Johan Hovold wrote:
> On Mon, Mar 06, 2023 at 07:48:35PM +0100, Greg Kroah-Hartman wrote:
> > 
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > To reproduce the conflict and resubmit, you may use the following commands:
> > 
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
> > git checkout FETCH_HEAD
> > git cherry-pick -x d55f7f4c58c07beb5050a834bf57ae2ede599c7e
> > # <resolve conflicts, build, test, etc.>
> > git commit -s
> > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678128515101149@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..
> > 
> > Possible dependencies:
> > 
> > d55f7f4c58c0 ("irqdomain: Refactor __irq_domain_alloc_irqs()")
> 
> The below commit applies fine to 5.15.y. Could you try cherry-picking it
> again?

patching file kernel/irq/irqdomain.c
Hunk #1 succeeded at 1464 (offset 23 lines).
Hunk #2 succeeded at 1488 (offset 23 lines).
Hunk #3 FAILED at 1486.
1 out of 3 hunks FAILED -- rejects in file kernel/irq/irqdomain.c

And doesn't look to apply properly as the EXPORT_SYMBOL_GPL(... line is
not in 5.15.y

thanks,

greg k-h

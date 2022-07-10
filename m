Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F6A56CF64
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 16:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiGJOPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 10:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGJOPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 10:15:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F49B841
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 07:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84D92B80882
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 14:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC60FC3411E;
        Sun, 10 Jul 2022 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657462544;
        bh=rFvtPqAHLjL+ZcthBwxAXCnyK96ahi1IIrdSaNFZsXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jNzYvxEd5vyKOuadoCmEMMtG/ireYZcg9NRuZJkHtdAdz0hdlm1n1GhywD3Lhws3J
         i/iIGCsrCWiTbPTZmEWeFa4h2gPJgCHQbNm6I9GyevLI4udkNmqkoWdsNY21RlW4th
         iFjAcgJpzp0UzM/fgmmKB2LjlpbkmhCYZMoh2+FA=
Date:   Sun, 10 Jul 2022 16:15:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
Message-ID: <YsrfDfe3urGkepvJ@kroah.com>
References: <20220710131055.12934-1-theflamefire89@gmail.com>
 <YsrTlX6MHQWazszI@kroah.com>
 <YsrT3AjiVaK4oCi/@kroah.com>
 <cbc4d668-819e-26e9-52c6-01ea4b62892e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbc4d668-819e-26e9-52c6-01ea4b62892e@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 10, 2022 at 04:08:00PM +0200, Alexander Grund wrote:
> On 10.07.22 15:27, Greg KH wrote:
> >> What kernel version(s) are you wanting this applied to?
> 
> That should go onto 4.9, I see I should have used `--subject-prefix`.
> 
> >> And your email send address does not match your signed-off-by
> >> name/address, so for obvious reasons, we can't take this.
> 
> My 2nd email (from GMail) is much easier to setup but I'd like to keep my usual signed-off tag.
> Would `--from=git@grundis.de --reply-to=theflamefire89@gmail.com` be acceptable?

I can't see reply-to when reviewing a patch, can you?

What would you want to see if you had to review this to verify it was
sane?

> > And of course, why is this needed in any stable kernel tree?  It isn't
> > fixing a bug, it's adding a new feature.  Patch 2/2 also doesn't fix
> > anything, so we need some explaination here.  Perhaps do that in your
> > 0/X email that I can't seem to find here?
> 
> Good point, so I need to use `--cover-letter` even for backports. Makes sense.
> The previous discussion can be found at [1].
> The essence is that this adds security hardening by disallowing writes to LSM hooks after initialization.
> Additionally included here to reduce divergence with mainline to ease application of further (backported) commits.

We can't add new features to older kernel versions, as you know that's
not allowed as per the stable kernel rules.  If you want newer security
features, just move to a newer kernel version.

And without any context here,  or the "further" commits, how are we
supposed to know any of this?

thanks,

greg k-h

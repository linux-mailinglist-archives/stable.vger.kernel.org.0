Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB335F74BE
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 09:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJGHfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 03:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJGHfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 03:35:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8752EF2E
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 00:35:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986F961BF3
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 07:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B75C433C1;
        Fri,  7 Oct 2022 07:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665128106;
        bh=3KjS5WxjzNKEVGj3A5jdJUwlhYN7TmaplvR8O6z6Lrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YdYMyhr1cKM3FLcNDPGfqHtpiRhUuNM8EOKF480GQWqPFu7VDCEhp4ovqht1OpZLN
         fFwKAk8HLWIdBOTJbxf1Sz/jp8zEQnHaSw6sGi+Q95fUIDGM3qE0TVhh7Rj/GXn0Wu
         Sc5TI4AFr940esgZBq4iaN5NYn7/nmkZDuBeIyuE=
Date:   Fri, 7 Oct 2022 09:35:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux@roeck-us.net, stable@vger.kernel.org, ulf.hansson@linaro.org
Subject: Re: FAILED: patch "[PATCH] mmc: core: Terminate infinite loop in
 SD-UHS voltage switch" failed to apply to 5.19-stable tree
Message-ID: <Yz/W05psUlTkrD+f@kroah.com>
References: <16647043801297@kroah.com>
 <Yz8oMnK1WHrUUvtf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz8oMnK1WHrUUvtf@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 06, 2022 at 12:10:42PM -0700, Brian Norris wrote:
> On Sun, Oct 02, 2022 at 11:53:00AM +0200, Greg Kroah-Hartman wrote:
> > 
> > The patch below does not apply to the 5.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > e9233917a7e5 ("mmc: core: Terminate infinite loop in SD-UHS voltage switch")
> > e42726646082 ("mmc: core: Replace with already defined values for readability")
> 
> I think it would be most readable and least error prone to just backport
> commit e42726646082 (it's trivial) along with $subject. I've confirmed
> that together, these two patches apply cleanly to 4.14.y..5.19.y, and
> the appropriate definitions are available.
> 
> 4.9.y has some other conflicts, due to missing this:
> 
> 09247e110b2e mmc: core: Allow UHS-I voltage switch for SDSC cards if supported
> 
> I'd personaly just skip $subject for 4.9.y too, although I could be
> convinced to rewrite and submit a backport if someone feels strongly.
> 
> I'll assume Greg can pick the quoted two commits up (that more or less
> fits Documentation/stable_kernel_rules.txt option 2), but I can submit a
> proper patchset if needed.

A proper patchset would be great so I know exactly what to do.

thanks,

greg k-h

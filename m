Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E435F0E5F
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 17:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiI3PDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiI3PDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 11:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240312EF32
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 08:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5F3962382
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 15:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9E3C433D6;
        Fri, 30 Sep 2022 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664550144;
        bh=T6FiqdMep748yXvI5CONSjuxDxr1LADx4NBVpN7SLAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wyL4u2x1rmAXexFxrjyPalUBK/0ftnKp5NyT/irG32ZWsLlj5mzGAPsQ8A+68U5JH
         RxisN4clTMWxbkt4Tri+ABURoWpQPaVwO/FOjsGBqO+6/DcVXqHkm8XgXt9A4o1MIJ
         mjRYvehDZMMg6SQg3T/Fev5L+4OIXiNGNSNKlOms=
Date:   Fri, 30 Sep 2022 17:02:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jerry Ling <jiling@cern.ch>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Message-ID: <YzcE/YEKcUDzuES/@kroah.com>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <b85bc2cf-5ea5-c5fb-465c-cd6637f6d30f@leemhuis.info>
 <36d318f0-9fc4-d5d9-9dc2-26145c963f0f@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36d318f0-9fc4-d5d9-9dc2-26145c963f0f@cern.ch>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 30, 2022 at 09:05:31AM -0400, Jerry Ling wrote:
> > If it is, simply starting with "i915.enable_psr=0" might already help.
> 
> unfortunately this didn't help.

Ick.  Ok, can you test your own kernel build out?  If I provide a patch
that reverts the what I think are offending commits, can you test it?

Also, does 6.0-rc7 also have this same problem?  That should be tested
first here, and if that's a problem, then we can get the i915 developers
involved.

thanks,

greg k-h

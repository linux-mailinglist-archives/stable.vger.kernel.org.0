Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530B2592EA7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiHOMEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHOMEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98597255AB
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 05:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58706B80E59
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 12:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08AAC433C1;
        Mon, 15 Aug 2022 12:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660565073;
        bh=fMQ0T2B6cXIuhg1f1r9P5tm1eXz6wghN2CFs8QrCrqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRpwerUYNAdvHgFcoI4/a4DiE8116hitdLQTChjvDs3OVg4QrcIBOSCghRmE8K93s
         TKpCiYwrwNnlHrOsfBU0kMoNZ2tGW2qPc88ZFKsMqbfhhcZZwCa996RFdBaqZzv75w
         fsB7bsh5/D4y2zkHKYCgeYtJ7/K21ps4PzdRyQE4=
Date:   Mon, 15 Aug 2022 14:04:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH 4.9 1/1] LSM: Initialize security_hook_heads upon
 registration.
Message-ID: <Yvo2TnrUGoLKEY+v@kroah.com>
References: <20220811115340.137901-1-theflamefire89@gmail.com>
 <20220811115340.137901-2-theflamefire89@gmail.com>
 <YvTzZM499PnOTMZD@kroah.com>
 <da7d4c6f-0010-6f77-e64e-20f3ebfb57dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da7d4c6f-0010-6f77-e64e-20f3ebfb57dd@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 12, 2022 at 12:50:42PM +0200, Alexander Grund wrote:
> On 11.08.22 14:17, Greg KH wrote:
> > As this fixes no bug or real issue that anyone is having with 4.9, why
> > is this needed?
> 
> This makes it easier to maintain the kernel by removing error-prone code.

Not really, we only add commits that we have to add.  We don't add
things that are "just nice".  Don't do work you don't have to do for a
task right now please.

> I mentioned this patch earlier and you seemed to be interested to at least
> have a look at [1].

Sure, for real bugfixes.  That's not what this patch is.

> The 4.9.y branch is also used by the Civil Infrastructure Project (CIP) to maintain
> a SLTS (Super Long Term Support) 4.4.y branch which is e.g. used by a community
> maintaining alternative Android builds for devices no longer supported by their
> vendors.

Yes, again, I know all about the crazy plans of CIP and my statements on
why it is looney and not a good idea are quite public.  It also has
nothing to do with how we currently maintain the stable/LTS kernel
trees, so it's not relevant to us at all.

thanks,

greg k-h

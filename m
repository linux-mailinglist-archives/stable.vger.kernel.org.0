Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F753CC3D
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 17:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiFCPXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 11:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiFCPXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 11:23:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDED924968
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 08:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82E2AB82239
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6650C385A9;
        Fri,  3 Jun 2022 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654269785;
        bh=HP3jcHA4mgW8XTWibwTBo0HOQrhhN9/pjBeTWdOBLOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bUrI1ZvcHioJR2rAlOaIABmEflXXT3pXjTvNFgmiqso5XwT3MBAa/wpu94TmGoVTU
         TmWZfDcrFzftX3BJB5g8ev87NjruX3xJFXEHtvCkdbQ3Co9V+XkU/Xi2NqmGDCdVE2
         C8HuIcjRchIX4EVV7yxFd9bQTKjOMhk3GPo9naL8=
Date:   Fri, 3 Jun 2022 17:23:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 5.15.y 0/5] missing random.c-related stable patches
Message-ID: <YponVllTJncuOh+N@kroah.com>
References: <20220602202327.281510-1-Jason@zx2c4.com>
 <YpofLWgbLysxkgb3@kroah.com>
 <YpolaDt+5doc7cOz@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpolaDt+5doc7cOz@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 05:14:48PM +0200, Jason A. Donenfeld wrote:
> On Fri, Jun 03, 2022 at 04:48:13PM +0200, Greg KH wrote:
> > On Thu, Jun 02, 2022 at 10:23:22PM +0200, Jason A. Donenfeld wrote:
> > > Hi Greg,
> > > 
> > > I forgot two things when doing the 5.15 backport. The first is a patch
> > > from Justin fixing a bug in some of the lib/crypto Kconfig changes,
> > > which Pablo (CC'd) pointed out was missed. The second is that the
> > > backport of 5acd35487dc9 ("random: replace custom notifier chain with
> > > standard one") isn't quite right without Nicolai's patches there too,
> > > since the drbg module is removable.
> > > 
> > > I'll continue to monitor all the channels I possibly can for chatter
> > > about problems, but so far this is all I've run into.
> > 
> > All now queued up, thanks.
> 
> Thanks. Note that the 5.10 patchset I posted is identical to this one,
> except I made sure patch 1/5 applies. Just cherry picking the 5.15 has a
> trivial conflict to fix up.

I took the 5.10 series as-you-sent-them so all should be good.

thanks,

greg k-h

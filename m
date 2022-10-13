Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB345FDE44
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJMQaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiJMQ37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:29:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B213A14C
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D349F604EF
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB927C433D6;
        Thu, 13 Oct 2022 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665678598;
        bh=MVIr2tKpprNhTifEp9j12LZQQyr4mziN7fBleirqUYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IQOzl0rXE6UDQagpAoKZwSg/xleiR0TnwU45/fqGkhvrtUJow2DUNJ1RALZqjquU1
         FUVA61tESsfefvKHiQFast5zONrght8ScqE50FHslWtBo4WZjq+EVZY5fzWY/j5i8J
         1zUV7TtXxgnDa/lReQCl7DB4IOWHUC0ykZjaNG4I=
Date:   Thu, 13 Oct 2022 18:30:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 0/3] recent failed backports for the rng
Message-ID: <Y0g9M7Zr+1gbC6d5@kroah.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
 <Y0g6bYnxyNNX5WC6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0g6bYnxyNNX5WC6@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 06:18:53PM +0200, Greg KH wrote:
> On Thu, Oct 13, 2022 at 09:36:51AM -0600, Jason A. Donenfeld wrote:
> > Hi Greg,
> > 
> > You just sent me an automated email about these failing, so here they
> > are backported. 
> 
> Backported where?  Patch 1 is already in 5.10 and newer, does this one
> work in older?
> 
> And 2 and 3 for all branches?

Ok, 2 and 3 are now queued up everywhere, only thing that didn't work is
patch 1 on the 4.9.y branch.  Can you provide a working backport for
there?

thanks,

greg k-h

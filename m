Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEF9591A81
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbiHMNOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239434AbiHMNOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:14:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADFA2656B;
        Sat, 13 Aug 2022 06:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 646B5B80159;
        Sat, 13 Aug 2022 13:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76FEC433D6;
        Sat, 13 Aug 2022 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660396441;
        bh=pyBTfDJT/lzSB4wz3O54NGZ8NRWMsTek/dYlSGUw/2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IIPmNlT4y8HJVdAEXEayExAQHvG6G33QzLJZgUoqTCL4FccIPmaDZzJVXmkZ9KoIo
         P5kYgnbpfQttPNhwFg1aPg2t61OaZMPZwqLy3R6C1jhK4nl2x094LrV1Bb/MAUj8Hm
         1f34QyXj5k7Mjxds9n8lWw1PoBHdYq0P1EscRWkw=
Date:   Sat, 13 Aug 2022 15:13:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.18 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Message-ID: <Yvejlr1Nds8wtyKj@kroah.com>
References: <cover.1659600630.git.wqu@suse.com>
 <YvESBmvjMqIXvqjp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvESBmvjMqIXvqjp@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 08, 2022 at 03:39:18PM +0200, Greg KH wrote:
> On Thu, Aug 04, 2022 at 04:10:57PM +0800, Qu Wenruo wrote:
> > Hi Greg and Sasha,
> > 
> > This two patches are backports for v5.18 branch.
> 
> I also need these for the 5.19.y branch if we were to take them into
> 5.18.y as you do not want anyone to suffer a regression when moving to
> the newer kernel release.
> 
> So I'll wait for those to be sent before taking any of these.

I've dropped all of these btrfs backports from my "to review" queue now.
Please fix them all up, get the needed acks, and then resend them and I
will be glad to reconsider them at that point in time.

thanks,

greg k-h

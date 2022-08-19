Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2C45995E6
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345642AbiHSHSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 03:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345958AbiHSHSs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 03:18:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE02F2F3BD;
        Fri, 19 Aug 2022 00:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 594086151C;
        Fri, 19 Aug 2022 07:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65323C433D7;
        Fri, 19 Aug 2022 07:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660893503;
        bh=w8r8m1L0hvfJ0afDAZSPizcR14TvrfcsIl14Zf9aw78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FtoyyrMc6fAvP8gL9k0fICuuVzsmkLVQ4gNfokVWuUju1vq5lcpfjS7Md66Tttj9R
         YtN5bZP/OzA5DRLhfMWQFPX3ipE+HtPku7D9KBiv135H67Sc1VO0LMV7p9+UA/ijzy
         15tTKXiV4jwS6s5cs22UBumfAOlWiBPXpkcJOsdA=
Date:   Fri, 19 Aug 2022 09:18:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH STABLE 5.19 0/2] btrfs: raid56: backports to reduce
 corruption
Message-ID: <Yv85PTBsDhrQITZp@kroah.com>
References: <cover.1660891713.git.wqu@suse.com>
 <ee7c8476-7c93-100d-a0ff-441b71f61e6a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee7c8476-7c93-100d-a0ff-441b71f61e6a@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 03:08:07PM +0800, Qu Wenruo wrote:
> BTW, since I have to re-run all the tests for every stable branch, for the
> stable branches and 5.18.x backports may be delayed a little.
> 
> In that case, I guess I should submit backports in the most recent stable
> branches first?

Yes please as we can not take patches only into older trees if the same
fix is not already in newer trees as you do not want someone to upgrade
and hit a regression.

thanks,

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D0565D9D1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbjADQ3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbjADQ3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:29:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC0844348
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:28:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09639B817B7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0604C433EF;
        Wed,  4 Jan 2023 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849691;
        bh=5zVtoihdulL00CUHStKIU1L8ar47jD2w6Vwiao0Uyyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATzX08r/XTcVLoMZwDO6iV6cSAEudtOaDhUd+xXmQijDvvRn80e7/bny8r+DVz/5P
         zMnASObbsocHSTnxmKqxqO8lgQwd1nO3Hk63cuGSYgvwyOyKPqkukLVV2YMYGVGQYq
         Vu+LGKL151CQugYLR0rZtfFTPXqs5x3Cww8d7fVs=
Date:   Wed, 4 Jan 2023 17:14:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc:     andrzej.hajda@intel.com, rodrigo.vivi@intel.com,
        tvrtko.ursulin@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: Never return 0 if not all
 requests retired" failed to apply to 5.10-stable tree
Message-ID: <Y7Wl8rDMIBFd1vNX@kroah.com>
References: <16728431552714@kroah.com>
 <13175047.uLZWGnKmhe@jkrzyszt-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13175047.uLZWGnKmhe@jkrzyszt-mobl1.ger.corp.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:02:10PM +0100, Janusz Krzysztofik wrote:
> Hi Greg,
> 
> On Wednesday, 4 January 2023 15:39:15 CET gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> 
> FYI, I can see it already added to v5.10.158, commit 
> 648b92e5760721fbf230e242950182d7e9222143.  The same for other stable trees 
> as well as my other fixes for which I received such failure reports from you 
> today.

Then why is it coming in with a different git id into Linus's tree?

This is really really annoying, as I have been saying for years.
There's no way for me to know the difference between "this didn't apply
for some reason" and "this did not apply because it is already in
Linus's tree and has been backported already".  So I end up with loads
of failures and you end up with an inbox full of junk.

And then the _real_ failures that we need backports for get lost in the
noise.

There's no reason why the DRM subsystem is somehow so special that it is
the only one broken this way...

{sigh}

greg k-h

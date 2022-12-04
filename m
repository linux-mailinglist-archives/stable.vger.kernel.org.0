Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B332E641DC5
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 17:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiLDQAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 11:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDQAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 11:00:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA70F11A17
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 08:00:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5584460EB3
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 16:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C913C433C1;
        Sun,  4 Dec 2022 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670169641;
        bh=zBz4FhF69o00bCEz4SpP4l0Fx0o7Xb4qT8uQ38DZ1wM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqXus0aDUhS0qXety3Lc8AOnwTl2A5PThWHgKdMMqBWn9oGEgcLlXyqsAfdYlCV1U
         RRL9YfZ04znbzHxGjbrRQGb0D2hTaPfVFKxtvmrTlgWq0W8imWwzvROl/KWjui1Mrt
         BbLDs6vXHIRPZX9jrwNFkHnj+GK9n2v/RNDP54E0=
Date:   Sun, 4 Dec 2022 17:00:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ulrich Hecht <uli+cip@fpond.eu>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 4.9] Revert "fbdev: fb_pm2fb: Avoid potential divide by
 zero error"
Message-ID: <Y4zEJtstFKn8f+8f@kroah.com>
References: <20221202044253.516827-1-uli+cip@fpond.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202044253.516827-1-uli+cip@fpond.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 05:42:53AM +0100, Ulrich Hecht wrote:
> This reverts commit 6577e903a9e193ad70f2db92eba57c4f335afd1a. It's a
> duplicate of a commit that is already in this tree
> (0f1174f4972ea9fad6becf8881d71adca8e9ca91).
> 
> Signed-off-by: Ulrich Hecht <uli+cip@fpond.eu>
> ---
>  drivers/video/fbdev/pm2fb.c | 5 -----
>  1 file changed, 5 deletions(-)

Now queued up, thanks.

greg k-h

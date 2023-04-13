Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B347C6E09E0
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 11:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjDMJPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 05:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjDMJPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 05:15:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C64183EA;
        Thu, 13 Apr 2023 02:15:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C8B263CCE;
        Thu, 13 Apr 2023 09:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B347DC433EF;
        Thu, 13 Apr 2023 09:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681377301;
        bh=h8Hh25Ui6V58p6esvnob3NJZuaFxv+XMWi99YnJ/r2I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1WOy4l743jhd6aR8JJe19VsNFQSOD3JMuUv4tJNn3vqD29MIk0VjOQr2zTBT80jj
         hfckysCMBORx7zddnFp+EBGLghDOVuyjPMm5YPg8KUHRIo0pjZBx10RX71GyscSNrG
         34KX26UiznfxRg6dCGyxjeGxCOOC7Fi2jzmU+ZRQ=
Date:   Thu, 13 Apr 2023 11:14:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sean Young <sean@mess.org>
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: bpf attach/detach requires write permission
Message-ID: <2023041345-colossal-geranium-c9fb@gregkh>
References: <20230413085032.709757-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413085032.709757-1-sean@mess.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 13, 2023 at 09:50:32AM +0100, Sean Young wrote:
> Note that bpf attach/detach also requires CAP_NET_ADMIN.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/bpf-lirc.c     | 6 +++---
>  drivers/media/rc/lirc_dev.c     | 5 ++++-
>  drivers/media/rc/rc-core-priv.h | 2 +-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114E9468AD7
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhLEMnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:43:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34102 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhLEMna (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:43:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71BC960FD3
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E01EC341C1;
        Sun,  5 Dec 2021 12:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638708002;
        bh=tDU8pgk4aSDNHlIenUvcirx04iwcRsmNbXT4MlSHIB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z9pBzvQZfKf+R8GWVUCu94EOHGXpXiDfOoUiShKi/6I96cL+DD6OCMgRKEZ96RZdI
         HKsOA9aT3abHP9Q9fy10DemSE+52ryI3go7kk3lcE7cky4D/k9elJr6Bkn5SA6yLmU
         pQAxx/NQrzJ2CqEoBtQlBANQZqVm7QQFc8SPSbIU=
Date:   Sun, 5 Dec 2021 13:39:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     ssuryaextr@gmail.com, dsahern@kernel.org, kuba@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] vrf: Reset IPCB/IP6CB when processing
 outbound pkts in vrf" failed to apply to 4.4-stable tree
Message-ID: <YayzH/JxsYmWXdLj@kroah.com>
References: <1638613684143163@kroah.com>
 <366a22ac-ab74-f4e5-55ab-10ca988a6f0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366a22ac-ab74-f4e5-55ab-10ca988a6f0f@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 04, 2021 at 09:09:31AM -0700, David Ahern wrote:
> On 12/4/21 3:28 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> 
> This patch is not needed in 4.4.
> 

Why not?  The two "Fixes:" tag show that those commits are in 4.4:

    Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
    Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")

193125dbd8eb showed up in 4.3, and 35402e313663 showed up in 4.4.

so why isn't this needed in 4.4.y?

thanks,

greg k-h


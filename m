Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0804F468ADF
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhLEM4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbhLEM4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:56:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D564CC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 04:53:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73FCC60F72
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 12:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A092C341C1;
        Sun,  5 Dec 2021 12:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638708786;
        bh=fijX4dPrz+X6oXkXkvOn1z4S6ET48e9YaKIxeQ6S9Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qWP8Mu+7kF4SeIYdWZcH7n2hwq/Z5Y9OPm5bt7VvXalwMdAVmbjnOr1OAEcdTPMaJ
         iPKueedNKg47Jq1oSJzIs6uwGzskNkJjHYQWlgJRgodUz0YosxcHX2zBRl97xLyhp4
         7YlToGXhBx3IX6quPbbr0W/399geezyZejdvw12s=
Date:   Sun, 5 Dec 2021 13:53:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     davem@davemloft.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: Save power by
 disabling SerDes" failed to apply to 5.15-stable tree
Message-ID: <Yay2LzNEkyFEjQfZ@kroah.com>
References: <16386137159777@kroah.com>
 <20211204115719.3315663b@thinkpad>
 <YayzZex0zXvDxg2V@kroah.com>
 <20211205134916.4fb5f8ca@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211205134916.4fb5f8ca@thinkpad>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 05, 2021 at 01:49:16PM +0100, Marek Behún wrote:
> On Sun, 5 Dec 2021 13:41:09 +0100
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Sat, Dec 04, 2021 at 11:57:19AM +0100, Marek Behún wrote:
> > > In fact it was a series of 6 patches, but the 2nd was without fixes tag:
> > > 
> > > 21635d9203e1cf2b73b67e9a86059a62f62a3563
> > > 8c3318b4874e2dee867f5ae8f6d38f78e044bf71 (without fixes tag)
> > > 7527d66260ac0c603c6baca5146748061fcddbd6 (didnt apply)
> > > 93fd8207bed80ce19aaf59932cbe1c03d418a37d
> > > 163000dbc772c1eae9bdfe7c8fe30155db1efd74
> > > ede359d8843a2779d232ed30bc36089d4b5962e4  
> > 
> > So what am I supposed to do here?  Apply all of them?  3 of them?  None
> > of them?
> 
> Sorry. All of them should be applied.
> 
> All but second have fixes tags. And second needs to be applied becaues
> third depends on it.
> 
> They also should be applies in that order.

That worked, all now queued up, thanks.

greg k-h

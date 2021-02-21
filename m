Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8415320AAF
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 14:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhBUNyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 08:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhBUNyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 08:54:51 -0500
X-Greylist: delayed 1428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Feb 2021 05:54:11 PST
Received: from target.luon.net (target.luon.net [IPv6:2a00:8240:5:10::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A11C061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 05:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=luon.net;
         s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j+LyGCJnAwzUToMYVbHzdVvRi/TeQTjLN6kA8gnysyY=; b=bpGAlFhKH2m2Z1NVQ6xbXpRBC+
        QXWsBCFnwQNLxapQqSgcBg1J3uCSr60VP3RbgozaxlPeKujOD9//wF2ZHm49REmMJlyhYK330HiSg
        F5RqOEDPSUjXS7E/V6JmPcwOWrt8x/16Yrqo8earE8Zno0dTe05Qh2yY+iDWT0TzLND542bcqNr41
        XzYpY6/80hBlBV1ruCUjXcTriuzolSl21GH8G9iA4ZoR6YYIdb87FAVvVahmSTyf/Fuh9e7SDAwWo
        qjskTg2MpRg4+9LLa4Ia8lhAHY9ual73SUuXvjTkD78qxKsLbwRb6S99B0MiuiP6PAZ62WD01qr+3
        CF+YtJb065zmg3TroopU2xHSu5wMbvNXKRNXKhMRKHCIW8nMJ7dz6P0bh6IoxVRED3xsYrjsFww9W
        5jI7aAyucFeqMjJQdu3wXsraw4xDeL1lYPg5EJpc7UhLznvQPe2hSp85HBsX5snHRyF1UDEbiY9a+
        qMh8gnXkE4s0vgIJn2xS825BKOEUVdn7AK/VW5cKVMWk4WFLYMsVwdBpx0Q9JMG9L8HodSQz+/D4B
        6YbGQTosH1lIs3KTIKZo1iepxlDpI5GKNS96jICvnRIc6yy8Ba/SUyAosbSP/ws+EThhmmaX0jjcw
        LO5cXKFUBit7DukFTiShnLSX+Nioh3+9VRKGZ/nJM=;
Received: from [2a00:bba0:114f:8c00:817a:dfe:9649:b9c1] (helo=dawn.luon.net)
        by target.luon.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sjoerd@luon.net>)
        id 1lDooV-0007mw-Uo; Sun, 21 Feb 2021 14:30:19 +0100
Received: by dawn.luon.net (Postfix, from userid 1000)
        id 51EB2C62B0F; Sun, 21 Feb 2021 14:30:15 +0100 (CET)
Date:   Sun, 21 Feb 2021 14:30:15 +0100
From:   Sjoerd Simons <sjoerd@luon.net>
To:     Trent Piepho <tpiepho@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always
 fallback to alt 1 for WBS") to back to v5.10.y
Message-ID: <YDJgZ/lxBNIiQJQG@dawn.lan>
References: <YDJWEh5qNUQbXcv2@eldamar.lan>
 <YDJXvYLSUQ3P0iMz@kroah.com>
 <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+7tXij-wK3-tswGx2sQMR60wbThZPg_C3yuVXFVfbgSSi7ecw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 05:03:34AM -0800, Trent Piepho wrote:
> On Sun, Feb 21, 2021 at 4:53 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sun, Feb 21, 2021 at 01:46:10PM +0100, Salvatore Bonaccorso wrote:
> > > Hi
> > >
> > > 517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
> > > was applied to mainline fixing (restoring) behaviour to pre 5.7. As
> > > the commit message describes in effect, WBS was broken for all USB-BT
> > > adapters that do not support alt 6.
> > >
> > > Can you consider it to apply it to back to 5.10.y?
> >
> > I do not see any such git commit id in Linus's tree, are you sure you
> > picked the right one?
> 
> Full hash is 517b693351a2d04f3af1fc0e506ac7e1346094de.
> 
> Looks like it should work as I intended on current 5.10.y, but I
> didn't test that kernel.

I've been using it for a while now on top of 5.10.y; It fixes issues for me with
both Intel and Broadcom based usb adapters. Fwiw i previously[0] suggested
adding fixes/tested-by tags but those didn't make it into the merged version.

Regards,
  Sjoerd

0: https://lore.kernel.org/lkml/YB68RUVLRGQKS+yH@dawn.lan/

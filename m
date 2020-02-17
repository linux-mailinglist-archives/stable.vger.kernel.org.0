Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB43161420
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgBQOGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 09:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgBQOGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 09:06:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8E8206F4;
        Mon, 17 Feb 2020 14:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581948411;
        bh=L9m7cKBlOgA3ifdDMIFdLINe2L4OqIcj76W5EAKZ+uY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sAC4N6uCmaRUPEnjJLpx6SocPC3ZKZ0N6DKRyCzVsYtHAZk1QTWcTNlOVdU8o0fjB
         fEy4hnPAkXk4ax7/wVSXQ+GXez7qlRej3T9qOSWlxhhTAA50mfiaDSxAXSbJNp8E/0
         POXtJUkf7fe66oKFhrPvrF7v4kYUObQdqKk/jVRs=
Date:   Mon, 17 Feb 2020 15:06:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alexander@tsoy.me, stable@vger.kernel.org, toszlanyi@yahoo.de
Subject: Re: FAILED: patch "[PATCH] ALSA: usb-audio: Add clock validity quirk
 for Denon" failed to apply to 5.4-stable tree
Message-ID: <20200217140648.GB996487@kroah.com>
References: <158194021723626@kroah.com>
 <s5hmu9hgw1t.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmu9hgw1t.wl-tiwai@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 02:53:02PM +0100, Takashi Iwai wrote:
> On Mon, 17 Feb 2020 12:50:17 +0100,
> <gregkh@linuxfoundation.org> wrote:
> > 
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Could you cherry-pick the commit
> 1d4961d9eb1aaa498dfb44779b7e4b95d79112d0
>     ALSA: usb-audio: sound: usb: usb true/false for bool return type
> 
> as prerequisite?  This is just a bool value replacement that conflicts
> with the given patch.

That worked, thanks!

greg k-h

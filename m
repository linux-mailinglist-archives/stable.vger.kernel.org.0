Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03B01322A6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 10:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgAGJjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 04:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727559AbgAGJjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 04:39:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE012073D;
        Tue,  7 Jan 2020 09:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578389955;
        bh=8LGG2GvAr97xY2zHS9OTa29aeE0GFABOsNsEiTZdb8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m59grw0FcUgwXlVRYEHrAsbuIHgj8YkNDrrB4Hvba0c7czcf14JlA5ULOleWef0Nt
         dg7vFFtmDWJq+BmfdnO9BZuR/HC0sezsHVydqL2Dmnsaxe1A6aPB5G5iX8eWO0YOAK
         52Hc/7y8tnzIpO0USO17e3je9ZLtwdBncrx3WSv8=
Date:   Tue, 7 Jan 2020 10:39:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     kailang@realtek.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek - Add Bass Speaker and
 fixed dac for bass" failed to apply to 5.4-stable tree
Message-ID: <20200107093912.GA1031189@kroah.com>
References: <1578312630193177@kroah.com>
 <s5hd0bwgwb8.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hd0bwgwb8.wl-tiwai@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 06, 2020 at 09:32:43PM +0100, Takashi Iwai wrote:
> On Mon, 06 Jan 2020 13:10:30 +0100,
> <gregkh@linuxfoundation.org> wrote:
> > 
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Hm, I could cherry-pick the commit e79c22695abd (also commit
> 48e01504cf53 at next) cleanly on linux-5.4.y branch.
> 
> Could you try again?

Ugh, my fault, seems Sasha already queued these patches up in the stable
tree and I didn't notice them.  When I tried to apply them they
rightfully complained :(

sorry for the noise, all is good here.

greg k-h

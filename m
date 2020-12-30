Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E342E7A60
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgL3PdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:33:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgL3PdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 10:33:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31233207B2;
        Wed, 30 Dec 2020 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609342351;
        bh=MxYmYt5Yr5XhBIwMqcVFCyZlqnMpEIt6lenrIBEL/uc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vQHu54eqbGi/UAuUlwpRhSQbyw3eEUAYp0qAvh40t3OShxQDU7au1pVcJ3GcGNDpa
         OtC5Sbjtz850Wx4NF5u41RBp39k7AbfHNz4IlSumENbZNyVsfa9j6ot1dlm5Iz4Prj
         y8YduFGXiJZIbzZVc9sDrZLL7qi+f/aF34VMDpbM=
Date:   Wed, 30 Dec 2020 16:33:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Alberto Aguirre <albaguirre@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>
Subject: Re: missing alsa fixes for 4.14-stable, 4.9-stable and 4.4-stable
Message-ID: <X+yd5m5C/ndogLrQ@kroah.com>
References: <20201228193904.o625t6ex7b52rpkd@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228193904.o625t6ex7b52rpkd@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 07:39:04PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> Few missing alsa fixes for 4.14-stable, 4.9-stable and 4.4-stable.
> 
> 42fb6b1d41eb ("ALSA: hda/ca0132 - Fix work handling in delayed HP detection")
> 
> 103e9625647a ("ALSA: usb-audio: simplify set_sync_ep_implicit_fb_quirk")
> only needed to make backporting of '5d1b71226dc4' easier otherwise the change
> had to done in all the separate error paths.
> 
> 5d1b71226dc4 ("ALSA: usb-audio: fix sync-ep altsetting sanity check")
> 
> fcc6c877a01f ("ALSA: hda/realtek - Support Dell headset mode for ALC3271")
> only needed for the backport of 'd5078193e56b'.
> 
> d5078193e56b ("ALSA: hda - Fix a wrong FIXUP for alc289 on Dell machines")
> 
> e1e8c1fdce8b ("ALSA: hda/realtek - Dell headphone has noise on unmute for
> ALC236")

All now queued up, thanks!

greg k-h

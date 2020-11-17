Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CF22B5EC8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 13:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgKQL77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbgKQL77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:59:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55F772462E;
        Tue, 17 Nov 2020 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605614398;
        bh=tsxmx1vtF1zeLKOw6pUV17oomzFwH/UYB3NCEt26dDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LfFCaZW0CTBEs3lhxyh7GtpDDzTeRXW6VDRMHpAMVF+pDSBapXrTBzoo2jMQ1XuZU
         Faga+K06vCxfwpgIarSKl2oswbEujdk5uf+MePv9cprKwnlvIdt3iAF4sGlx+/lAoz
         p2QSAh60qGIDdqUXAmGmTyi2fMUhRZ4unelM41NU=
Date:   Tue, 17 Nov 2020 13:00:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB
 devices
Message-ID: <X7O7bkHYJrN3wa7A@kroah.com>
References: <20201113153720.5158-1-joakim.tjernlund@infinera.com>
 <07339bc75af562945e431b9bba23b0fa0ac303e5.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07339bc75af562945e431b9bba23b0fa0ac303e5.camel@infinera.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 10:40:43AM +0000, Joakim Tjernlund wrote:
> 
> Ping ?
> 
> On Fri, 2020-11-13 at 16:37 +0100, Joakim Tjernlund wrote:
> > Found one more Logitech device, BCC950 ConferenceCam, which needs
> > the same delay here. This makes 3 out of 3 devices I have tried.
> > 
> > Therefore, add a delay for all Logitech devices as it does not hurt.
> > 
> > Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> > CC: stable@vger.kernel.org (4.19, 5.4)
> > 
> > ---
> >  sound/usb/quirks.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)

$ ./scripts/get_maintainer.pl --file sound/usb/quirks.c
Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND)
Takashi Iwai <tiwai@suse.com> (maintainer:SOUND,commit_signer:26/27=96%,authored:4/27=15%,added_lines:39/245=16%,removed_lines:18/59=31%)
Alexander Tsoy <alexander@tsoy.me> (commit_signer:6/27=22%,authored:5/27=19%,added_lines:63/245=26%,removed_lines:22/59=37%)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:2/27=7%,authored:2/27=7%,removed_lines:12/59=20%)
Nick Kossifidis <mickflemm@gmail.com> (added_lines:36/245=15%)
Dmitry Panchenko <dmitry@d-systems.ee> (added_lines:27/245=11%)
Chris Wulff <crwulff@gmail.com> (added_lines:14/245=6%)
Jesus Ramos <jesus-ramos@live.com> (removed_lines:4/59=7%)
Joakim Tjernlund <joakim.tjernlund@infinera.com> (removed_lines:3/59=5%)
alsa-devel@alsa-project.org (moderated list:SOUND)
linux-kernel@vger.kernel.org (open list)


Try sending it to the people who can actually apply the thing...

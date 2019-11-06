Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78B2F10B4
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 09:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfKFIBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 03:01:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:39306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729878AbfKFIBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 03:01:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05EFFAFBB;
        Wed,  6 Nov 2019 08:01:04 +0000 (UTC)
Message-ID: <1573026302.3090.2.camel@suse.com>
Subject: Re: [PATCH 4.9 37/62] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
From:   Oliver Neukum <oneukum@suse.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 06 Nov 2019 08:45:02 +0100
In-Reply-To: <20191106001102.GI4787@sasha-vm>
References: <20191104211901.387893698@linuxfoundation.org>
         <20191104211940.713506931@linuxfoundation.org>
         <1572964268.2921.19.camel@suse.com> <20191106001102.GI4787@sasha-vm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Dienstag, den 05.11.2019, 19:11 -0500 schrieb Sasha Levin:
> On Tue, Nov 05, 2019 at 03:31:08PM +0100, Oliver Neukum wrote:
> > Am Montag, den 04.11.2019, 22:44 +0100 schrieb Greg Kroah-Hartman:
> > >         All the host controllers capable of SuperSpeed operation can
> > >         handle fully general SG;
> > > 
> > >         Since commit ea44d190764b ("usbip: Implement SG support to
> > >         vhci-hcd and stub driver") was merged, the USB/IP driver can
> > >         also handle SG.
> > 
> > Not in 4.9.x. AFAICT the same story as 4.4.x
> > The patch is not strictly needed, but breaks UAS over usbip.
> 
> It's in 4.9 since April this year... Same story for 4.4.

Hi,

now I am confused. Neither looking at the logs nor the source
I can see the commit. Top commit is
9e48f0c28dd505e39bd136ec92a042b311b127c6
of git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

I am sorry for being obnoxious here and it is entirely possible that
I am stupid, but this is a discrepancy that needs to be resolved.

	Regards
		Oliver


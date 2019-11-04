Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68100EE1BF
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 15:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfKDOAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 09:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbfKDOAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 09:00:15 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D25821655;
        Mon,  4 Nov 2019 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572876014;
        bh=kVsVomKOKk8T99pfEGc5r5TRfNaApoitx4PrR1+QhFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x8wpacDIlsxFl6+3v7kYJo506wwEz1cllIx7ga5jyD8s8VpnE2kmnVvnrix6X1OuA
         h/6gLUZ/QdIpGXZW2eadawkyRk0e3Nu8CwCbszKuXUwOpkXnsVbCqpxnFUntUfK0bl
         iDXXCdFM7o1Z0N593TWqN68ny6ZMbMLNm/twzqyM=
Date:   Mon, 4 Nov 2019 09:00:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     flyingecar@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: usb-audio: Add DSD support for
 Gustard U16/X26 USB" failed to apply to 5.3-stable tree
Message-ID: <20191104140013.GD4787@sasha-vm>
References: <1572802898108163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1572802898108163@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 03, 2019 at 06:41:38PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From e2995b95a914bbc6b5352be27d5d5f33ec802d2c Mon Sep 17 00:00:00 2001
>From: Justin Song <flyingecar@gmail.com>
>Date: Thu, 24 Oct 2019 12:27:14 +0200
>Subject: [PATCH] ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB
> Interface
>
>This patch adds native DSD support for Gustard U16/X26 USB Interface.
>Tested using VID and fp->dsd_raw method.
>
>Signed-off-by: Justin Song <flyingecar@gmail.com>
>Cc: <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/CA+9XP1ipsFn+r3bCBKRinQv-JrJ+EHOGBdZWZoMwxFv0R8Y1MQ@mail.gmail.com
>Signed-off-by: Takashi Iwai <tiwai@suse.de>

For 5.3 and 4.19 I took the following as dependencies:

eb7505d52a2f ("ALSA: usb-audio: DSD auto-detection for Playback Designs")
0067e154b11e ("ALSA: usb-audio: Update DSD support quirks for Oppo and Rotel")

For older kernels it was becoming too long of a list, and I don't have a
way to test it so I didn't do anything about it there. Backports are
more than welcome.

Note: yes, patching it up to apply on 4.14 is easy, but if this patch is
needed there then there are quite a few more needed so I didn't want to
take just this one.

-- 
Thanks,
Sasha

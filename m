Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC31132EE6
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 20:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgAGTA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 14:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAGTA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 14:00:57 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 444032081E;
        Tue,  7 Jan 2020 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578423656;
        bh=O7i9Fz/dWTzPDLPRviVCWFiQlYgFrzdb/rIzbENYKy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPrGsCQ8gnrVY+GZuNCJJbefJXgtuoxBTjlU44bep4Emyjlu42Gy7hWmDCNOWWrLi
         ABHEeRByHFD6CAHho8FaLkH6/bCyWewaWsS++pbTLbnna4sqVr96BX2jT+49OUpFQY
         wy3xHyC2So4KHFC2Z/F9iaihN4Lvnb4es0034Io0=
Date:   Tue, 7 Jan 2020 14:00:55 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     chiu@endlessm.com, jian-hong@endlessm.com, stable@vger.kernel.org,
        tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek - Enable the bass
 speaker of ASUS UX431FLC" failed to apply to 5.4-stable tree
Message-ID: <20200107190055.GD1706@sasha-vm>
References: <157831263714182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157831263714182@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 06, 2020 at 01:10:37PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 48e01504cf5315cbe6de9b7412e792bfcc3dd9e1 Mon Sep 17 00:00:00 2001
>From: Chris Chiu <chiu@endlessm.com>
>Date: Mon, 30 Dec 2019 11:11:18 +0800
>Subject: [PATCH] ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC
>
>ASUS reported that there's an bass speaker in addition to internal
>speaker and it uses DAC 0x02. It was not enabled in the commit
>436e25505f34 ("ALSA: hda/realtek - Enable internal speaker of ASUS
>UX431FLC") which only enables the amplifier and the front speaker.
>This commit enables the bass speaker on top of the aforementioned
>work to improve the acoustic experience.
>
>Fixes: 436e25505f34 ("ALSA: hda/realtek - Enable internal speaker of ASUS UX431FLC")
>Signed-off-by: Chris Chiu <chiu@endlessm.com>
>Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
>Cc: <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/20191230031118.95076-1-chiu@endlessm.com
>Signed-off-by: Takashi Iwai <tiwai@suse.de>

This one has been queued up in all relevant trees, thanks!

-- 
Thanks,
Sasha

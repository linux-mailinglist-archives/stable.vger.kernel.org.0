Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984E622ED4D
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgG0N3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgG0N3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 09:29:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED242070A;
        Mon, 27 Jul 2020 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595856559;
        bh=fzY3EDhenJxJ5B3W5+RSAB/NbOO14b8bG5JjNNPXmdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=02LJ86cssijbd4K0TLlOj2hNeCZteoY5XA/73M30+s9ahOrCz428NyRyQYVjCcJzJ
         faGKeY1Z5mWLQczNQ/3RX2q7l0PnuCKnnYYRaYxqpRNNTuQU5qo4MGC7UEZ+5zjFhr
         f9Y2FRrOOQo5LqB6Vf8kHU2dNxI3NmMCaskn6tFg=
Date:   Mon, 27 Jul 2020 15:29:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Viktor =?iso-8859-1?Q?J=E4gersk=FCpper?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>,
        Mark O'Donovan <shiftee@posteo.net>,
        Roman Mamedov <rm@romanrm.net>
Subject: Re: Please apply "ath9k: Fix general protection fault in
 ath9k_hif_usb_rx_cb" and the corresponding fix to all stable kernels
Message-ID: <20200727132914.GA3982320@kroah.com>
References: <81f07366-59e4-bfc9-c7a6-95c8e686c5e1@freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81f07366-59e4-bfc9-c7a6-95c8e686c5e1@freenet.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 01:20:11PM +0200, Viktor Jägersküpper wrote:
> Hi Greg, Sasha and all the others,
> 
> Hans de Goede requested to revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
> from all stable and longterm kernels because this commit broke certain devices
> with Atheros 9271 and at that time it seemed that reverting the commit would be
> done in the mainline kernel. The revert was done in kernel 5.7.9 etc., however
> Mark O'Donovan found a fix for the original commit - which avoided the revert in
> the mainline kernel - and this fix is now included in 5.8-rc7 with commit
> 
> 92f53e2fda8bb9a559ad61d57bfb397ce67ed0ab ("ath9k: Fix regression with Atheros 9271").
> 
> To be consistent with the mainline kernel, please apply the original commit
> again (or re-revert it, whatever is appropriate for stable kernels) and then
> apply Mark's fix. I have tested this with the current 5.7.10 kernel to confirm
> that it works because I was affected by the bug.
> 
> All relevant people are CC'ed if someone wants to object.

I've now queued both up, thanks!

greg k-h

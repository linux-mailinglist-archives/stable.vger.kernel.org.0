Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87F5215FB1
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 21:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgGFTzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 15:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgGFTzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 15:55:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2408207D0;
        Mon,  6 Jul 2020 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594065323;
        bh=bgpzOSjX9GVaY9onoQwHcv3Pysfo/Zwq3IztNJwlD/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zXqeNYPi3jQcXv4g6h6rDI9h4rQ/pufzm8EQ8QbwBt0T53EsSx8QubeR8rnlhDYFu
         H2j5MD+KPSv3oOqPXQsLLc1W7Xxhk5T4Odfp48OLAn0kd5YwDAZS/g1TxIpKsSggaY
         jhAM45zdcPG/Fs+r3NiDAiOzmVYeKrv/MRNEn+H8=
Date:   Mon, 6 Jul 2020 21:55:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     qiang.zhang@windriver.com
Cc:     balbi@kernel.org, colin.king@canonical.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: function: fix missing spinlock in
 f_uac1_legacy
Message-ID: <20200706195520.GA93712@kroah.com>
References: <20200705124027.30011-1-qiang.zhang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705124027.30011-1-qiang.zhang@windriver.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 05, 2020 at 08:40:27PM +0800, qiang.zhang@windriver.com wrote:
> From: Zhang Qiang <qiang.zhang@windriver.com>
> 
> Add a missing spinlock protection for play_queue, because
> the play_queue may be destroyed when the "playback_work"
> work func and "f_audio_out_ep_complete" callback func
> operate this paly_queue at the same time.

"play_queue", right?

> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>

Because you do not have a Fixes: tag in here, how far back do you want
the stable patch to go to?  That's why, if you can, it's always good to
have a "Fixes:" tag in there to show what commit caused the problem you
are fixing here.

So, what commit caused this?

thanks,

gre gk-h

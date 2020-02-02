Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464BD14FFFF
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 00:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgBBXTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 18:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgBBXTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Feb 2020 18:19:52 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A88D420643;
        Sun,  2 Feb 2020 23:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580685591;
        bh=NcGwMPjbj2NTQU308Mo1hCCwmRBQTDcplWTju5yMm/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JwpvRrhMr9vF/sQp/AUVPIEAdbLddoQcW90jlEo682VKi+o6AVkuI5/um3QefdLiA
         DxQn0Fbpe/dsu5dPpYDOa6y6cxC4nx2xFhAM9M5XcK7InQUjK4R6XBdjcRNVajotnc
         4HD73Nrpn8/kY4LjdzVmDeiQ9XiQ7xrnhIThFd+8=
Date:   Sun, 2 Feb 2020 18:19:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     johan@kernel.org, amit.karwar@redpinesignals.com,
        fariyaf@gmail.com, kvalo@codeaurora.org, prameela.j04cs@gmail.com,
        siva.rebbagondla@redpinesignals.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] rsi: fix use-after-free on failed probe
 and unbind" failed to apply to 4.14-stable tree
Message-ID: <20200202231950.GF1732@sasha-vm>
References: <1580395053117151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1580395053117151@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 03:37:33PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From e93cd35101b61e4c79149be2cfc927c4b28dc60c Mon Sep 17 00:00:00 2001
>From: Johan Hovold <johan@kernel.org>
>Date: Thu, 28 Nov 2019 18:22:00 +0100
>Subject: [PATCH] rsi: fix use-after-free on failed probe and unbind
>
>Make sure to stop both URBs before returning after failed probe as well
>as on disconnect to avoid use-after-free in the completion handler.
>
>Reported-by: syzbot+b563b7f8dbe8223a51e8@syzkaller.appspotmail.com
>Fixes: a4302bff28e2 ("rsi: add bluetooth rx endpoint")
>Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
>Cc: stable <stable@vger.kernel.org>     # 3.15
>Cc: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>Cc: Fariya Fatima <fariyaf@gmail.com>
>Signed-off-by: Johan Hovold <johan@kernel.org>
>Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Conflicts around support for suspend/resume. I've also queued up
cbde979b33fa ("rsi: add hci detach for hibernation and poweroff") for
4.19 and 4.14.

-- 
Thanks,
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A1156BFF
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 19:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgBISQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 13:16:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727419AbgBISQv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 13:16:51 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4500320715;
        Sun,  9 Feb 2020 18:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581272211;
        bh=V/PmZX/dVxiR62aVeOodZwwCimjGvCoClxYTs1tC6W8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sTFmBYTb5ls3blQ8mooGEKKPSVCDXqVjAAZuws5oB8e83g/WR41xlUnXcDwqC2Kqp
         1QXdH+vfMuCPpedvl5LhXKZdGPMAhQV83pOsctqxXAVWbWVle2dNQDyplcDsIV6JQw
         dQFXqVwuotDxfnuvjHieseTxKcxUGjXQK6kOuM3g=
Date:   Sun, 9 Feb 2020 13:16:50 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: pulse8-cec: fix lost
 cec_transmit_attempt_done() call" failed to apply to 5.5-stable tree
Message-ID: <20200209181650.GN3584@sasha-vm>
References: <158124886014060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158124886014060@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 12:47:40PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From c4e8f760581b8607a1989acb8925be25d6628760 Mon Sep 17 00:00:00 2001
>From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Date: Sat, 7 Dec 2019 23:43:23 +0100
>Subject: [PATCH] media: pulse8-cec: fix lost cec_transmit_attempt_done() call
>
>The periodic PING command could interfere with the result of
>a CEC transmit, causing a lost cec_transmit_attempt_done()
>call.
>
>Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>Cc: <stable@vger.kernel.org>      # for v4.10 and up
>Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Another duplicate commit:

e5a52a1d15c7 ("media: pulse8-cec: fix lost cec_transmit_attempt_done() call")
c4e8f760581b ("media: pulse8-cec: fix lost cec_transmit_attempt_done() call")

-- 
Thanks,
Sasha

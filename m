Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B032045EE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 02:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgFWAkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 20:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbgFWAkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 20:40:15 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF902075A;
        Tue, 23 Jun 2020 00:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592872784;
        bh=K1YMrX+vFfOdCRR7EhhoabWM5Dvqvkn449fKcgbMQZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ViK+UgQbFHkT/AA4sSel49q0GsRAr+Vc+fobflLROOKOmT0AlQg7PG0aobTd9iq39
         zhIyuaobzB6c2L86xHfAsZGV/Px+IS+nI7led+ktI2N2EFPk35/yofImtdOJIuzQ3f
         GjTqSKBQ2WHnpSHpsJt/bJl6sGrm+EAcgTNdCUR8=
Date:   Mon, 22 Jun 2020 20:39:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     paul@crapouillou.net, stable@vger.kernel.org,
        thierry.reding@gmail.com, u.kleine-koenig@pengutronix.de
Subject: Re: FAILED: patch "[PATCH] pwm: jz4740: Enhance precision in
 calculation of duty cycle" failed to apply to 5.4-stable tree
Message-ID: <20200623003943.GQ1931@sasha-vm>
References: <1592574307840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1592574307840@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 03:45:07PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 9017dc4fbd59c09463019ce494cfe36d654495a8 Mon Sep 17 00:00:00 2001
>From: Paul Cercueil <paul@crapouillou.net>
>Date: Wed, 27 May 2020 13:52:23 +0200
>Subject: [PATCH] pwm: jz4740: Enhance precision in calculation of duty cycle
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>Calculating the hardware value for the duty from the hardware value of
>the period resulted in a precision loss versus calculating it from the
>clock rate directly.
>
>(Also remove a cast that doesn't really need to be here)
>
>Fixes: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support")
>Cc: <stable@vger.kernel.org>
>Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>Signed-off-by: Thierry Reding <thierry.reding@gmail.com>

I suspect that the fixes tag should have been pointing to ce1f9cece057
("pwm: jz4740: Use clocks from TCU driver") instead.

-- 
Thanks,
Sasha

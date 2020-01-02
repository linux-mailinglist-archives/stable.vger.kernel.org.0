Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC112E160
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 01:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgABArb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 19:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbgABArb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jan 2020 19:47:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A042320842;
        Thu,  2 Jan 2020 00:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577926050;
        bh=SE5/wGjHPh7BLAMooA6wNt7LSZSzZZ3olTXBwNBkZas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vau2/0MWFB4Ao9HhJVByE339I9hNF00eQL6Qwr/gd82QcSpSGNVXJ0JovS8PT6swc
         pn1CWZOLrViBjq8YjBhHPg6OrKSzBs7J64WqT3KEYtQNEgJK6mv3gi7H3r0HxqkKDP
         jvGdeOxxwQp5w9HyXFApLG+WrYSAoM9lNIJSSy4k=
Date:   Wed, 1 Jan 2020 19:47:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     david.engraf@sysgo.com, ludovic.desroches@microchip.com,
        richard.genoud@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tty/serial: atmel: fix out of range clock
 divider handling" failed to apply to 4.19-stable tree
Message-ID: <20200102004729.GB16372@sasha-vm>
References: <1577634359228165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1577634359228165@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 04:45:59PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From cb47b9f8630ae3fa3f5fbd0c7003faba7abdf711 Mon Sep 17 00:00:00 2001
>From: David Engraf <david.engraf@sysgo.com>
>Date: Mon, 16 Dec 2019 09:54:03 +0100
>Subject: [PATCH] tty/serial: atmel: fix out of range clock divider handling
>
>Use MCK_DIV8 when the clock divider is > 65535. Unfortunately the mode
>register was already written thus the clock selection is ignored.
>
>Fix by doing the baud rate calulation before setting the mode.
>
>Fixes: 5bf5635ac170 ("tty/serial: atmel: add fractional baud rate support")
>Signed-off-by: David Engraf <david.engraf@sysgo.com>
>Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
>Acked-by: Richard Genoud <richard.genoud@gmail.com>
>Cc: stable <stable@vger.kernel.org>
>Link: https://lore.kernel.org/r/20191216085403.17050-1-david.engraf@sysgo.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fixed up context due to missing 377fedd1866a ("tty/serial: atmel: add ISO7816
support"), queued for 4.19-4.9.

-- 
Thanks,
Sasha

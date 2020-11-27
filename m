Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DA72C66C3
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgK0NX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 08:23:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730328AbgK0NX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 08:23:58 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C3CD2224D;
        Fri, 27 Nov 2020 13:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606483437;
        bh=wifXfvUaqgJEvVsKhD/m8Xxkoyfe8ESgqLgws1t6wD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mf3aD9vOsAzOZoePqK43r+F3tI5STy/9XIAb8dX2tChONzp4W4Yryib3TJHZm5Z22
         YzhjJD4Kw09OkZlH32leoO3KyM08iZkMSYOCEfrrmg7quUWzCd5FKF0BgX/sU8GKyq
         /TkiJ5oIafd1TpF4ce4JKajOHLJuGsP5RaXNujrA=
Date:   Fri, 27 Nov 2020 14:23:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Biwen Li <biwen.li@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: please add 35425bafc772 to 5.9-stable
Message-ID: <X8D96+jK1MnI2K/o@kroah.com>
References: <ef5b5f86-5d08-cb9b-c4f8-f6c09489ff4e@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef5b5f86-5d08-cb9b-c4f8-f6c09489ff4e@prevas.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 12:06:02PM +0100, Rasmus Villemoes wrote:
> Hi Greg
> 
> Can you add
> 
> commit 35425bafc772ee189e3c3790d7c672b80ba65909
> Author: Biwen Li <biwen.li@nxp.com>
> Date:   Tue Sep 15 15:32:09 2020 +0800
> 
>     rtc: pcf2127: fix a bug when not specify interrupts property
> 
> to the 5.9 stable queue? It fixes
> 
> commit 27006416be16b7887fb94b3b445f32453defb3f1
> Author: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Date:   Wed Aug 12 10:51:14 2020 +0200
> 
>     rtc: pcf2127: fix alarm handling
> 
> which is only in 5.9.

Now queued up, thanks.

greg k-h

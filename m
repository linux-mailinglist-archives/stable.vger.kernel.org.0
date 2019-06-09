Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCD3A47A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 11:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfFIJYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 05:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbfFIJYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 05:24:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDCE206C3;
        Sun,  9 Jun 2019 09:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560072239;
        bh=fmbEwiFPfBE/4ljvIMlu0PjPee4XYlS/QlhQ8WuALwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LdGuBiOdRRlu3mJtVwRY1EA4gEl7tZ2cNyaWWLhyI6Q7jvqiyZ4aGyui1TuocnFKm
         1+ewmNC+LI9dtKe6OBN3h53OAZ+7LO2aGwmnX/NiFJeL4by7LVJPXig2qIz2QpSOv+
         Bv+ti7aTSZ8x0G3scc40vMUWBMtfzcqx1tvUyjgQ=
Date:   Sun, 9 Jun 2019 11:23:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Stable <stable@vger.kernel.org>
Subject: Re: add "mtd: spinand: macronix: Fix ECC Status Read" to 4.19
Message-ID: <20190609092357.GA15619@kroah.com>
References: <3914666.MqBd33HHaW@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3914666.MqBd33HHaW@debian64>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 10:56:56AM +0200, Christian Lamparter wrote:
> Hello,
> 
> please add this patch
> 
> Subject: mtd: spinand: macronix: Fix ECC Status Read
> commit f4cb4d7b46f6409382fd981eec9556e1f3c1dc5d [0]
> Author: Emil Lenngren <emil.lenngren@gmail.com>
> Date:   Thu Dec 20 13:46:58 2018 +0100
> 
> to the stable release of 4.19.
> 
> Regards,
> Christian
> 
> [0] <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f4cb4d7b46f6409382fd981eec9556e1f3c1dc5d>
> 
> 

Now queued up, thanks!

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998BDEB36F
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 16:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfJaPJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 11:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbfJaPJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 11:09:32 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D36942083E;
        Thu, 31 Oct 2019 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572534572;
        bh=9tBCz/fylc7VVVgD21eF7T6KAra9agC6ZKRM9LyDwgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z8TnPqQT4tTuMQMa6dylinO6OKAdSfX2nsQZ4a3PLSgREOT+u/NMPEiozETqT21/8
         W+Yilb9SMOyw49j8YNr7Y6JnaB7j+55vh6tc8+FqFlFwKC0zktIACa3WAaceFp4eeX
         TzWO8rM1aqYeoI9oe5isljc5OgIsloqXzmcJBTOM=
Date:   Thu, 31 Oct 2019 15:09:27 +0000
From:   Will Deacon <will@kernel.org>
To:     linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andreyknvl@google.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH] media: uvc: Avoid cyclic entity chains due to
 malformed USB descriptors
Message-ID: <20191031150925.GA27535@willie-the-truck>
References: <20191016195800.22099-1-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016195800.22099-1-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 08:58:00PM +0100, Will Deacon wrote:
> Add a check before adding an entity to a chain list to ensure that the
> entity is not already part of a chain.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Link: https://lore.kernel.org/linux-media/CAAeHK+z+Si69jUR+N-SjN9q4O+o5KFiNManqEa-PjUta7EOb7A@mail.gmail.com/
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 
> Resending since I don't think any material changes are required to address
> the comments on the previous posting:
> 
> http://lkml.kernel.org/r/20191002112753.21630-1-will@kernel.org
> 
>  drivers/media/usb/uvc/uvc_driver.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Gentle nudge on this patch, since I don't see it in -next and I've not
received any comments on it for a while.

Cheers,

Will

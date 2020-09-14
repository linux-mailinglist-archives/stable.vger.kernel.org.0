Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA7426848F
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 08:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgINGMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 02:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgINGMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 02:12:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C1E206F4;
        Mon, 14 Sep 2020 06:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600063934;
        bh=ZKOHf2zMJ25tsrVOijUOnI9bZN2JzvoOq1izeZqL5m8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfMRweeL90HLKvDBprKOhF4+ELQkJXvlVWgLXVwzXa+x0lIL9WzLmpVuaKOTsey18
         Z8uzeR2+7Bx9clnefccjp3Chx4t0Q3Nv/MwA9cLBOgnIXsOr5VAZHUmbhdvc6Gtpd5
         lci0reQSkZFMeurt55H/3uqKpuqkj4asGPD0itlk=
Date:   Mon, 14 Sep 2020 08:12:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: bcm63xx_udc: fix up the error of undeclared
 usb_debug_root
Message-ID: <20200914061210.GA788192@kroah.com>
References: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600061930-778-1-git-send-email-chunfeng.yun@mediatek.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 01:38:50PM +0800, Chunfeng Yun wrote:
> Fix up the build error caused by undeclared usb_debug_root
> 
> Cc: stable <stable@vger.kernel.org>
> Fixes: a66ada4f241c("usb: gadget: bcm63xx_udc: create debugfs directory under usb root")

Nit, you need a ' ' before the '(' character...

thanks,

greg k-h

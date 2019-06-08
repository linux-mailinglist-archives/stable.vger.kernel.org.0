Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6FA639C21
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 11:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFHJaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 05:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfFHJaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 05:30:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF52212F5;
        Sat,  8 Jun 2019 09:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559986209;
        bh=NcZYKCVQCWiUfFTCXcWwFXNmG+KSUllMLcTNZmjLB9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSdBh689Xefbn9ihDCjIDi704ibEjphDT9ea/7Q64MFkwvxbhSpCn+YUe2rte/KBU
         b/KICFnUaog8UfI6eyf/yYEeniH0sB0S+Uu4pi94WXZfhhFLV0X1S9SScdLxoKMiv6
         UVinaH0rqVLhoKbELYMG2+mE/q4gN7+12LPa5n64=
Date:   Sat, 8 Jun 2019 11:30:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: Build failures in v4.9.y.queue, v4.4.y.queue
Message-ID: <20190608093007.GB19832@kroah.com>
References: <20190607163148.GA3723@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607163148.GA3723@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 09:31:48AM -0700, Guenter Roeck wrote:
> arm:allmodconfig, arm:multi_v7_defconfig:
> 
> drivers/gpu/drm/rockchip/rockchip_drm_drv.c: In function 'rockchip_drm_platform_shutdown':
> drivers/gpu/drm/rockchip/rockchip_drm_drv.c:486:3: error: implicit declaration of function 'drm_atomic_helper_shutdown'
> 
> Seen in both v4.4.y.queue and v4.9.y.queue.

Thanks, I've dropped the offending patch now.

greg k-h

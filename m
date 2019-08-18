Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8597C9190B
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfHRSsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 14:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbfHRSsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Aug 2019 14:48:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C517B206C1;
        Sun, 18 Aug 2019 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566154079;
        bh=ny4tT0ew0kuMgo1zIdncMm9GYDUjBKDABLZPoEDB78s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NVWlAsGllXUiXTn+YPrbnvJSrX/eHV9XA0vz/6n9nyPEcmu4KhrmaUy3ZWkZ0RGkX
         Am8IPIojh0fEoxEiIAvMaxpTiKS2V2kP6ei2HEEoKchl3XwnMTcC/3ba9NtLRJZIKz
         0zll7NZMz+aELRrdhx2Z5ov+0pmWSCCLiuLEWB0A=
Date:   Sun, 18 Aug 2019 20:47:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [4.19-stable][PATCH] KVM: arm/arm64: Sync ICH_VMCR_EL2 back when
 about to block
Message-ID: <20190818184756.GD2791@kroah.com>
References: <20190818170103.1707-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190818170103.1707-1-maz@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 06:01:03PM +0100, Marc Zyngier wrote:
> commit 5eeaf10eec394b28fad2c58f1f5c3a5da0e87d1c upstream.
> 
> Since commit commit 328e56647944 ("KVM: arm/arm64: vgic: Defer
> touching GICH_VMCR to vcpu_load/put"), we leave ICH_VMCR_EL2 (or
> its GICv2 equivalent) loaded as long as we can, only syncing it
> back when we're scheduled out.

Both now queued up, thanks.

greg k-h

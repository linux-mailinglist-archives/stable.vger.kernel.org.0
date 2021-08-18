Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9934D3EFD29
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 08:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbhHRGyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 02:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhHRGyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Aug 2021 02:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B6F46102A;
        Wed, 18 Aug 2021 06:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629269627;
        bh=CxMKsxDYqwUnqNCXrRnyuVGO9hHFKOKXba74zUHX6VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LT3d14VlL5m3/xFFEcyhWkHzF3xOsPsvMgs5mQQrLYQOWEMWIig3VKYHVRy/4RhdN
         W6KKMNg7WVHknSjV7swx7uEpQVlOgWKR/5b6Ja20QTdecUpZIMMC9fXjehNjS7tIp6
         CVEPPCmi/l92tXKhUe843iZamht9pQDfD+AOYCEI=
Date:   Wed, 18 Aug 2021 08:53:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 49/62] PCI/MSI: Enable and mask MSI-X early
Message-ID: <YRyuefFT4N/y0plX@kroah.com>
References: <20210816125428.198692661@linuxfoundation.org>
 <20210816125429.897761686@linuxfoundation.org>
 <20210817073655.GA15132@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817073655.GA15132@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 17, 2021 at 09:36:55AM +0200, Pavel Machek wrote:
> Hi!
> 
> I'm sorry to report here, but 4.4 patches were not yet sent to the
> lists (and it may be worth correcting before release).

Yes, they are known to not be complete and incorrect at the moment,
others have reported this to me.  I will be working on these later
today, thanks.

greg k-h

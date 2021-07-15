Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3314F3C9D33
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhGOKuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232055AbhGOKuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 06:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C590161396;
        Thu, 15 Jul 2021 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626346045;
        bh=qqKUPcI72NEtzzZk+5rDqKiz6H0TDb119r74V8UnhHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ic1k683bXy7lasbAfu+ZZaL8mIRjISwSDFIKos/Io3TLPYJYvMzhNthiLLGvFvG4P
         mfbgbvBV1tRiMqkXzdwhfywbNKMrObQ6IPvaqDZkpk+zwsEjk0bOxEs1egYi8MPe6F
         uzmm+ZLk5r1QCpqO4IfHY34CceofSYAh2kp0Cj9s=
Date:   Thu, 15 Jul 2021 12:47:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Vidya Sagar <vidyas@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: stable request: 5.12+: PCI: tegra194: Fix host initialization
 during resume
Message-ID: <YPASNrYeKq1Dcsbk@kroah.com>
References: <5add238b-aba3-33c6-87a9-85b0a60f5103@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5add238b-aba3-33c6-87a9-85b0a60f5103@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 10:55:44AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> Resume of the Tegra194 PCI controller was broken in Linux v5.11 but has
> now been fixed for Linux v5.14. Unfortunately, we have missed v5.11 now,
> but please can you pull the following commit into Linux v5.12.y and
> Linux v5.13.y stable branches?
> 
> c4bf1f25c6c1 PCI: tegra194: Fix host initialization during resume

Now queued up, thanks.

greg k-h

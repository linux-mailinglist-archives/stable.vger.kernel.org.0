Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893164508A4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhKOPjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:39:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236943AbhKOPiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E78AE61C12;
        Mon, 15 Nov 2021 15:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636990494;
        bh=Rte/PCL7VreDs5m4fUeo3wHWKQXvZdO1rDpLj+gdfqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmkqoH25Q+7LX2G4QXZrX6ebOpvKlxowRBVaMGgs51Sfp+oQkgHyJHUM7C/DulJZl
         YJOhrroZddPUT4RcoiwiZ71i6UcZNr51FfEw+75uTmw+zkksLD5OTjFJVUS+Bx8/K/
         35l+F1AHBPUSHJT7vpljpX4gCr51jIOfrEnQq5oc=
Date:   Mon, 15 Nov 2021 16:34:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Fix GPIO based wakeup on some AMD designs
Message-ID: <YZJ+G7K5+lCoqYOt@kroah.com>
References: <SA0PR12MB4510DE9675041E9DE26A9EDBE2939@SA0PR12MB4510.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA0PR12MB4510DE9675041E9DE26A9EDBE2939@SA0PR12MB4510.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 11:41:37PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> On designs that that GPIO controller has a dedicated IRQ, wakeups aren't working properly from s0i3.
> S0i3 is first supported on 5.14 on AMD, so it's a good idea to fix this there.
> 
> This is fixed by the following commits:
> 
> commit 7e6f8d6f4a42 ("pinctrl: amd: Add irq field data") # 5.14
> commit acd47b9f28e5 ("pinctrl: amd: Handle wake-up interrupt") #5.14
> 
> Other designs that the GPIO controller shares the IRQ with the ACPI SCI have other fixes that will be sent to stable once they're in 5.16.

Both now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC2F4CFC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 14:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKHNSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 08:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfKHNSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 08:18:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C1842178F;
        Fri,  8 Nov 2019 13:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573219095;
        bh=sP1OZrQAJIoqqZXO4RjJougxT+iTY/yOmxNYqofhWS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HkOHhitqqinFjzG4z8/bk24GJH8ncMbo9JHetCNe1zGMAqoWgjwH4k1Rib6glDagS
         1txlEfXm8XQnDeg1n3uaTf8xVezJ8gcFWB7ISRkND9FJisX9Cm7hdcWGnJZCks2ukb
         fM9UPdYEUsj8bNWxLZtHF/vQLibngervh6/LXoPI=
Date:   Fri, 8 Nov 2019 14:18:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] platform/x86: pmc_atom: Add Siemens SIMATIC IPC227E
 to critclk_systems DMI table
Message-ID: <20191108131813.GD761587@kroah.com>
References: <20191107170530.6115-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107170530.6115-1-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 07:05:30PM +0200, Andy Shevchenko wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> The SIMATIC IPC227E uses the PMC clock for on-board components and gets
> stuck during boot if the clock is disabled. Therefore, add this device
> to the critical systems list.
> 
> Fixes: 648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> 
> - resend for stable inclusion

What git id is this in Linus's tree, and what tree(s) is this backport
for?

thanks,

greg k-h

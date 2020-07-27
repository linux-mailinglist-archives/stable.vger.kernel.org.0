Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5317322F996
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 21:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgG0T4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 15:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0T4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 15:56:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 598A62072E;
        Mon, 27 Jul 2020 19:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879803;
        bh=8AzCarMRtNvpFmv6CLe9LN+iMyNxXBO5Qr1sPYzB+j8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=krsKeN2DScs85NMOxCVNvPD6miSBkNOFc9qD/hmUvr0yQ5XtEq6jCH0Bjoe84l0kr
         orvcrsnQE1mekBu3pKRGpuOsNWq1jonPpPstUDGvt2F4Did/2eCxaYDm04Sblx4HD4
         SgfEr+igyMWJzg8IlE9f4GAqWbPVpXT3cMFmNnDE=
Date:   Mon, 27 Jul 2020 21:56:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hminas@synopsys.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, marex@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH v3] usb: dwc2: Add missing cleanups when
 usb_add_gadget_udc() fails
Message-ID: <20200727195638.GA240997@kroah.com>
References: <20200727173801.792626-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727173801.792626-1-martin.blumenstingl@googlemail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 07:38:01PM +0200, Martin Blumenstingl wrote:
> Call dwc2_debugfs_exit() and dwc2_hcd_remove() (if the HCD was enabled
> earlier) when usb_add_gadget_udc() has failed. This ensures that the
> debugfs entries created by dwc2_debugfs_init() as well as the HCD are
> cleaned up in the error path.
> 
> Fixes: 207324a321a866 ("usb: dwc2: Postponed gadget registration to the udc class driver")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v2 at [1]:
> - add #if around the new label and it's code to prevent the following
>   warning found by the Kernel test robot:
>     unused label 'error_debugfs' [-Wunused-label]
> 
> Changes since v1 at [0]
> - also cleanup the HCD as suggested by Minas (thank you!)
> - updated the subject accordingly
> 
> 
> [0] https://patchwork.kernel.org/patch/11631381/
> [1] https://patchwork.kernel.org/patch/11642957/


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

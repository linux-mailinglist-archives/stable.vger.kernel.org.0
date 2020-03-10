Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB241803B5
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 17:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCJQjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 12:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCJQjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 12:39:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 996F2222C3;
        Tue, 10 Mar 2020 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583858379;
        bh=DAW7xTUed0FfcyKkaoTCpHE55I+ixoL7o21Jj1lUqZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CPMiHDgw4e/BVbFl+DIYaq0q+o+/Q1tF9JzU/U68B1NHU7qvT748iN3MQmm6B1yP8
         bObq+88sQqBKI+A0M6cCkbQnV5qGVwejvs3SvqlM41yDIxLjTaWUaiAe9hTzwkHz7j
         kU1Ignb00T9aZuUn0oAEaFLRPFxtDi5S/wy7+4Vg=
Date:   Tue, 10 Mar 2020 17:39:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Subject: Re: [PATCH 5.5 175/189] ARM: dts: imx6dl-colibri-eval-v3: fix sram
 compatible properties
Message-ID: <20200310163935.GA3430367@kroah.com>
References: <20200310123639.608886314@linuxfoundation.org>
 <20200310123657.443556491@linuxfoundation.org>
 <20200310150512.GC14211@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310150512.GC14211@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 04:05:12PM +0100, Johan Hovold wrote:
> On Tue, Mar 10, 2020 at 01:40:12PM +0100, Greg Kroah-Hartman wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > commit bcbf53a0dab50980867476994f6079c1ec5bb3a3 upstream.
> > 
> > The sram-node compatible properties have mistakingly combined the
> > model-specific string with the generic "mtd-ram" string.
> > 
> > Note that neither "cy7c1019dv33-10zsxi, mtd-ram" or
> > "cy7c1019dv33-10zsxi" are used by any in-kernel driver and they are
> > not present in any binding.
> > 
> > The physmap driver will however bind to platform devices that specify
> > "mtd-ram".
> > 
> > Fixes: fc48e76489fd ("ARM: dts: imx6: Add support for Toradex Colibri iMX6 module")
> > Cc: Sanchayan Maity <maitysanchayan@gmail.com>
> > Cc: Marcel Ziswiler <marcel.ziswiler@toradex.com>
> > Cc: Shawn Guo <shawnguo@kernel.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Reviewed-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> > Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This was never meant to go into stable so I didn't add a stable CC-tag.
> 
> It causes a driver to bind to the corresponding platform devices, which
> have so far been unbound and may therefore have unwanted side-effects.
> 
> I don't think it's stable material either way.

Thanks, now dropped from all kernel trees.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD2015044F
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 11:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgBCKcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 05:32:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgBCKcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 05:32:53 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E284420721;
        Mon,  3 Feb 2020 10:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580725973;
        bh=ApCdZROMbWHwnYNb29FMGtyRpx5V9PNc19Ze7FIFWMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1gmcUBtPUtUSE5kvkHUAwNqNNOc77jE8gjLCECavfQegwNWzz8ipVfs2ljDSMrvx+
         VNkHYsXdinM6l2zMCzhXMbOvRZTyQ2szPuGC2+ucbnD+UtEtZA9c89SL/XV4dpobJA
         spAukNMI1FRtiSUghOiumRyYhlumAc3OMPSg1QE4=
Date:   Mon, 3 Feb 2020 10:32:51 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>, kbuild-all@lists.01.org,
        philip.li@intel.com, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [lee:android-3.18-preview 136/224]
 drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference
 preceded by free on line 460 (fwd)
Message-ID: <20200203103251.GA3117936@kroah.com>
References: <alpine.DEB.2.21.2001311542130.2236@hadrien>
 <20200131150809.GF3548@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131150809.GF3548@dell>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 03:08:09PM +0000, Lee Jones wrote:
> On Fri, 31 Jan 2020, Julia Lawall wrote:
> 
> > The code on line 462 looks suspicious.
> 
> Thank you Julia.
> 
> Have you already reported this to the other Stable Maintainers?
> 
> This issue appears to affect; 4.4, 4.9, 4.14 and 4.19.

Ick :(

Can you send us a fix-up patch for this to be applied everywhere?

thanks,

greg k-h

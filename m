Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2325D42BB27
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 11:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhJMJKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 05:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233922AbhJMJKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 05:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F4CA60C4B;
        Wed, 13 Oct 2021 09:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634116131;
        bh=V9SHs1pFlQ8Ckyd1nb8iC3GmVVCRrFDVy+241rRafEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GYT+4jsG4ucfq88qirjbXKop87UQPURkrlFAFw0Cwza6LBiBA5bSu4nprBzuyReNS
         CH5m7U8incRlXR/Hq4ugcsGS5PMPEj+Qv53HjfVHRoIhWVhzmjBTs7H0G6+2w4wEoB
         exncPuGR2nyGosKa2Qko/0Flemc/CsM0vymdmzGI=
Date:   Wed, 13 Oct 2021 11:08:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     gor@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 STABLE] s390/pci: fix zpci_zdev_put() on reserve
Message-ID: <YWaiIVLJ5vksduHu@kroah.com>
References: <16338613385253@kroah.com>
 <20211011145624.3316395-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011145624.3316395-1-schnelle@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 04:56:24PM +0200, Niklas Schnelle wrote:
> commit a46044a92add6a400f4dada7b943b30221f7cc80 upstream.
> 
> Backport note: The original commit conflicted with the upstream commit
> 023cc3cb1e4b ("s390/pci: cleanup resources only if necessary") instead
> of separately backporting that its change is subsumed in this backport
> patch.

No, please submit the same patches that are upstream, we want to prevent
this type of stuff as much as possible.

thanks,

greg k-h

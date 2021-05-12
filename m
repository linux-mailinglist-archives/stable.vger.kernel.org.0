Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECF237BC18
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELL47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 07:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhELL46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 07:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37D3A61353;
        Wed, 12 May 2021 11:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620820549;
        bh=f5Ks/SPY96fa6w1+4ofeADyzQJoJjrbSN5dpCBj8jy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rcrzYTI3LTOb6Kqsr9SCmQwxX+aYFnLc9gWhGEfAEdC17GwCtloHyf+jgUjnapIbp
         Dw0POlU0OjLmIczCchWVEFB9QFiCKJkSlNYnOvMUcmgrIfyCcJxvC/4T/52GAsEYjR
         VGeLB25rA7KFObJJuJzmofJuYPVfavVqHawFn+0Q=
Date:   Wed, 12 May 2021 13:55:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     imbrenda@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: s390: split
 kvm_s390_logical_to_effective" failed to apply to 4.9-stable tree
Message-ID: <YJvCQ8h6O+Gpi1c0@kroah.com>
References: <1620814886253179@kroah.com>
 <6a509e34-9016-7250-9df5-027d967bb098@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a509e34-9016-7250-9df5-027d967bb098@de.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 01:44:21PM +0200, Christian Borntraeger wrote:
> On 12.05.21 12:21, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> 
> Please drop the other 3 kvm: s390: patches then for 4.9, as the kernel will not
> compile without this until we have a backport for this.

Ok, will do.


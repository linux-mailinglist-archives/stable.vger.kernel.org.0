Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1F739FAFF
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhFHPlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 11:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhFHPlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 11:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5306E61285;
        Tue,  8 Jun 2021 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623166754;
        bh=yPK/Uue7fAzulN8NUtY0rp/pmpMm771HhqumQ/or/go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W54PY8HY7zSpH8vaob4Lk9vNDwItYtpor1Au462QSok5H5yBJwdLJbcOppc8rqyUG
         4Pr76Oi43XWHItMDlMQtfcyc/Qt6BCHi7GoZNqJVnu1qgA/qatj1WkHrmHSB/tmXY4
         lrlG9TQ/guhRsvAyuSeNiO4xAoElGC2rkUVQogr8=
Date:   Tue, 8 Jun 2021 17:39:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and
 CR accesses in" failed to apply to 5.12-stable tree
Message-ID: <YL+PIO4+aHQkx0Vi@kroah.com>
References: <162081623353164@kroah.com>
 <YL6NWAqmcVqmbe8+@debian>
 <YL64TmEBjILbIXzu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL64TmEBjILbIXzu@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 08, 2021 at 12:22:38AM +0000, Sean Christopherson wrote:
> On Mon, Jun 07, 2021, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > On Wed, May 12, 2021 at 12:43:53PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.12-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Here is the backported patch.
> 
> All four backports look good, thanks!

All now queued up, thanks.

greg k-h

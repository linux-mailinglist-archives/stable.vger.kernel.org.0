Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E672F1A7F1B
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388831AbgDNODt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388386AbgDNODr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 10:03:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9C6A20578;
        Tue, 14 Apr 2020 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586873027;
        bh=w3ovK0GBed/1zqhbsl5N+BBtZSXyR/Mb6V1RiFQ175A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=beXUG9CE9SlE+bZO+84yls2Sw1IYX6qzf9N/mnYc0VHcuKdl3wF1QnVj735/gV+n5
         OzB83fbzETn0Om+dym+Xsz/9sSyYFtVxJNGoT6ciIGPo0Luc9ACzmV9qo4pGFFXLiY
         dQLB+A6z/+uEV4qplcwal+Gml0IZg75kQbqE86YA=
Date:   Tue, 14 Apr 2020 16:03:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     stable@vger.kernel.org, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: FAILED: patch "[PATCH] KVM: VMX: Always VMCLEAR in-use VMCSes
 during crash with" failed to apply to 4.4-stable tree
Message-ID: <20200414140345.GA841811@kroah.com>
References: <1586870222160177@kroah.com>
 <87blnuyygo.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blnuyygo.fsf@vitty.brq.redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 03:43:35PM +0200, Vitaly Kuznetsov wrote:
> <gregkh@linuxfoundation.org> writes:
> 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Personally, I don't think it is worth backportint to 4.4, however, if
> someone thinks differently please don't forget to also pick up
> 
> commit dbef2808af6c594922fe32833b30f55f35e9da6d
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Wed Apr 1 10:13:48 2020 +0200
> 
>     KVM: VMX: fix crash cleanup when KVM wasn't used
> 
> or things will regress.

Thanks for pointing that out, it also needs to go to all other kernel
trees, will go do that now.

greg k-h

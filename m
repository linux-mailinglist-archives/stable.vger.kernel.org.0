Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386C1433494
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 13:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhJSLYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 07:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhJSLYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 07:24:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE5260E8B;
        Tue, 19 Oct 2021 11:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634642531;
        bh=N9+zFCzvQ7Gjy4aNJ5xgoy+jim52LVDD5RVoWrvd4ZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uddzvnCtyF/JsKwA+1qOsyWnPLhapFiRlDqilmVf/mbFamWbr9xdwyLpiRyq0MHPv
         7ZFuD3m547Tj0BamBaJIMmizYrzJcdbF7y1I6t2Wkeqnph/s9OVJEuJ7KjBtnR2s+b
         3DyN7bd4kD1viHJZSJ2NrVlMaiW3SC4MjCpAYZUE=
Date:   Tue, 19 Oct 2021 13:22:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 060/151] KVM: PPC: Book3S HV: Fix stack handling in
 idle_kvm_start_guest()
Message-ID: <YW6qXwnmhv6vMVof@kroah.com>
References: <20211018132340.682786018@linuxfoundation.org>
 <20211018132342.644684017@linuxfoundation.org>
 <87a6j5cmif.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6j5cmif.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 09:55:04PM +1100, Michael Ellerman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > From: Michael Ellerman <mpe@ellerman.id.au>
> >
> > commit 9b4416c5095c20e110c82ae602c254099b83b72f upstream.
> >
> > In commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in
> > C") kvm_start_guest() became idle_kvm_start_guest(). The old code
> > allocated a stack frame on the emergency stack, but didn't use the
> > frame to store anything, and also didn't store anything in its caller's
> > frame.
> 
> Please drop this and the next patch.

All now dropped from all 3 queues, thanks!

greg k-h

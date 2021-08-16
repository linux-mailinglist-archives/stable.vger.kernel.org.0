Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFD13ED994
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 17:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhHPPMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 11:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhHPPMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 11:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0AEA60ED5;
        Mon, 16 Aug 2021 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629126710;
        bh=cmpeK/tYCAz9EzqH8xAUz3AtNaD490+bcyumZC/bL2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZEEpoEL/dDin5bCt/GmleCmvCHpIDrM0uOObsME22cJ7/giAO+KYsPV3V7LqSjBp
         jaS6B3Z1L/qOw2qQsykmxgoS/hmiRoMZ39YFK11aVC2tDmgWaXNImvlL8fsFS8ljD1
         elbE81RitdDK0v2u6+8ivnVDUFg7XWSj9HvHZO4k=
Date:   Mon, 16 Aug 2021 17:11:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 5.12.y] KVM: nSVM: avoid picking up unsupported bits from
 L2 in int_ctl (CVE-2021-3653)
Message-ID: <YRqAM3gTAscfmr60@kroah.com>
References: <20210816140240.11399-6-pbonzini@redhat.com>
 <YRp1bUv85GWsFsuO@kroah.com>
 <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97448bb5-1f58-07f9-1110-96c7ffefd4b2@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 05:04:58PM +0200, Paolo Bonzini wrote:
> On 16/08/21 16:25, Greg KH wrote:
> > > [ upstream commit 0f923e07124df069ba68d8bb12324398f4b6b709 ]
> > 
> > And 5.12.y is long end-of-life, take a look at the front page of
> > kernel.org for the active kernels.
> 
> Ok, sorry I didn't notice that... it wasn't end of life when the issue was
> discovered. O:)
> 
> (Damn, the one time that we prepare all the backports in advance, we end up
> doing too many of them!)

You didn't do a 5.13.y version :(

Will the 5.12.y patches work for that tree?

thanks,

greg k-h

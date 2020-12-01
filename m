Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0342C9E6C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387973AbgLAJ45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbgLAJ4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:56:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55972206C0;
        Tue,  1 Dec 2020 09:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606816574;
        bh=c3d+Osucubyb7TS3LxwtgE8nKYA4a/B+QY1zjRR3ToQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZhQQZxyRMGQfySjaXRtxmE6K7EzqpjzhhDRH52yJY4cBdSmD2Eo+8zjbIUXRVMxkB
         u38k5AN7ftOs3N0+YFrEomF62yrZLIsah16xPD+EPEC5s0vd1yK5c/DT1wPdsat6i4
         orspTrXg4LJph/ZoIypH0dMBsNnK9a26CLDbKyCk=
Date:   Tue, 1 Dec 2020 10:57:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <X8YThgeaonYhB6zi@kroah.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
 <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 10:06:54AM +0100, Paolo Bonzini wrote:
> On 01/12/20 09:53, Greg Kroah-Hartman wrote:
> > From: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > commit 71cc849b7093bb83af966c0e60cb11b7f35cd746 upstream.
> 
> Since you did not apply "KVM: x86: handle !lapic_in_kernel case in
> kvm_cpu_*_extint" to 4.19 or earlier, please leave this one out as well.

Isn't it patch 07 of this series?

confused,

greg k-h

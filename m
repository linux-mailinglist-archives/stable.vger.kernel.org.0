Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB732D625C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391320AbgLJQqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbgLJQqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 11:46:09 -0500
Date:   Thu, 10 Dec 2020 17:46:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607618729;
        bh=VlED3yGMu7lpSWGnJyAkaK8we53Fs771TCNDyWL0uf4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BbXJUQkXSMfdaUnd9eM9RiwRPVQkDJbL3T/We6DIkd0xZZexgGxS8xclH1Q0ZsK9D
         9oAbIGkyH0iYhX+ub3A9YIQLRUhU97i82tXJA7VnSTnW092g+XQZqO+gO/m0KX+xAo
         PG1eWYiIjn63ZalG4vh2dVoqax0lff47OGVXS47w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH 5.4 21/54] s390/pci: fix CPU address in MSI for directed
 IRQ
Message-ID: <X9JQ83HzuDBaGoLq@kroah.com>
References: <20201210142602.037095225@linuxfoundation.org>
 <20201210142603.083190701@linuxfoundation.org>
 <805f753f-f431-a032-383c-65130ef0b153@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805f753f-f431-a032-383c-65130ef0b153@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 05:34:08PM +0100, Niklas Schnelle wrote:
> Hi Greg,
> 
> sorry to bother you but I missed that the smp_cpu_get_cpu_address()
> address used here was only added with the
> commit 42d211a1ae3b77 ("s390/cpuinfo: show processor physical address")
> which landed in v5.7-rc1. This would therefore break if ever called
> (luckily it would not be called on any shipped hardware) and
> also causes a missing declaration warning as reported by
> Naresh Kamboju thanks!
> Since this is as of now just a spec fix, as on all known hardware
> the Linux CPU Id always matches the CPU Address, I would
> recommend to simply revert the commit.

Ok, will go drop it now, thanks.

greg k-h

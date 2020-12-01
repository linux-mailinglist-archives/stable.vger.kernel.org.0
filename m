Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5232CA0FC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 12:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgLALMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 06:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727694AbgLALMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 06:12:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55AB8206D8;
        Tue,  1 Dec 2020 11:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606821131;
        bh=PSDN/9XXALjgf3/EoCnShDW6wx5s39qZf6Let+cQcK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/5pk0MrBvuZwnfGIgaY2uifUYmd2KU2PYEoeTwd77Hy8Nmao7vuf5jt19fS/XWsZ
         aoMRMOMXvSVFBm/2EN174E4m2ht0ABvuHWe6Xngg/PqZf30GdJKISctbgQryVZf5DP
         CDICsXhYQ7yN9BMRVkAg2LAsdMEo7yTTlLSkIjBY=
Date:   Tue, 1 Dec 2020 12:13:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
Message-ID: <X8YlUlSXLH5/RckV@kroah.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org>
 <d29c4b25-33f6-8d99-7a45-8f4e06f5ade6@redhat.com>
 <X8YThgeaonYhB6zi@kroah.com>
 <fe3fa32b-fc84-9e81-80e0-cb19889fc042@redhat.com>
 <X8YY2qW3RQqzmmBl@kroah.com>
 <d3311713-013b-003c-248b-22ebf1e45c7c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3311713-013b-003c-248b-22ebf1e45c7c@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 11:55:55AM +0100, Paolo Bonzini wrote:
> On 01/12/20 11:20, Greg Kroah-Hartman wrote:
> > Ok, I will go drop this patch from 4.14, 4.9, and 4.4.  Or, should the
> > needed pre-requisite patch be properly backported there instead?
> 
> I would just drop it.  It was not reported in five years so it's quite
> unlikely that people will see the bug.

Ok, will go drop them.

> > And was it marked somewhere that this patch depended on that one and I
> > just missed it?
> 
> I don't see anything in stable-kernel-rules.rst about how to mark such
> semantic conflicts, so no, it wasn't marked.  (The commit message does say
> "thanks to the previous patch", but I don't expect you or your scripts to
> notice that!).

If you look at the section on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
that starts with "Additionally, some patches..." it will show that you
can add "#" comments on the cc: stable line to let me know pre-requsite
commits if you know them, and want to do that in the future.

thanks,

greg k-h

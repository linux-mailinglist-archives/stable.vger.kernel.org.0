Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67572C732
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 15:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfE1NA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 09:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726870AbfE1NA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 May 2019 09:00:26 -0400
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA712081C;
        Tue, 28 May 2019 13:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559048426;
        bh=rv9CNpVd70aK0MC0Elqehga8H+1qjAh7rJvH86w0Cks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5V/RLeekxmvSbCf2nKrAhTz5dWy1a462ML2CTYXeDBC0pRds/U85Nyz/rQ1R1Hcd
         pfusWem913q94UTF0R50aJsvYHFf5AwGBokBA8eGIe4L249etASowdW37ShC4j6w0+
         g4FLDDrIOih9zsrcjmIBoTWwn/bMxkarSj1mkvqw=
Date:   Tue, 28 May 2019 15:00:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Will Deacon <will.deacon@arm.com>
Cc:     catalin.marinas@arm.com, marc.zyngier@arm.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: errata: Add workaround for
 Cortex-A76 erratum #1463225" failed to apply to 4.14-stable tree
Message-ID: <20190528130017.GB6104@kroah.com>
References: <1558965280196247@kroah.com>
 <20190528114409.GF20809@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528114409.GF20809@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 28, 2019 at 12:44:09PM +0100, Will Deacon wrote:
> On Mon, May 27, 2019 at 03:54:40PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Urgh. I'm going to punt on this unless somebody requests a backport to
> a kernel prior to 4.19 explicitly. The issue is that our syscall entry
> code was moved to C after 4.14 and this workaround relies heavily on that
> work. A backport would therefore necessitate a rewrite of the workaround
> that hooks the assembly directly. Whilst do-able, I'd rather know that
> (a) somebody wants this (b) they plan to deploy it on real devices and
> (c) they can help to test.
> 
> Sound reasonable?

Sounds fine to me.  Thanks for the backports you did send, I've queued
them up now.

greg k-h

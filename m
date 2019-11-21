Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0DA105B61
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUUyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfKUUyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 15:54:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2341B20672;
        Thu, 21 Nov 2019 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574369645;
        bh=Gn/x+NMXh60YKd7R8DvLqLrditqSquvkrww70QfULdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gRQDZWLioWMyjItFNd1vfzIIzTh+LTiSbXZ8N0Z5lrNYNla5TXYzFD3YSSlyO801U
         xhybUFmGnSFKXBxli4rzPmYTetzZ/ucpAlmIdlh7T6vOBMj1kiPoo1f9uDL1GkFNMb
         DjP9nEt3zgTzlUCIoqZG9QsBNY5bvL8vIub6woqE=
Date:   Thu, 21 Nov 2019 21:54:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@users.sourceforge.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
Message-ID: <20191121205403.GB839951@kroah.com>
References: <20190805124924.788666484@linuxfoundation.org>
 <5D488D55.B84FC098@users.sourceforge.net>
 <20190805201847.GA31714@kroah.com>
 <5D490021.F1CCC042@users.sourceforge.net>
 <20190806051635.GA8525@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806051635.GA8525@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 07:16:35AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 06, 2019 at 07:20:49AM +0300, Jari Ruusu wrote:
> > Greg Kroah-Hartman wrote:
> > > On Mon, Aug 05, 2019 at 11:11:01PM +0300, Jari Ruusu wrote:
> > > > Peter Zijlstra's "x86/atomic: Fix smp_mb__{before,after}_atomic()"
> > > > upstream commit 69d927bba39517d0980462efc051875b7f4db185 seems to
> > > > be missing/lost from 4.9 and older stable kernels.
> > > 
> > > Can you send properly backported and tested patches?
> > 
> > linux-4.4 backport of "x86/atomic: Fix smp_mb__{before,after}_atomic()".
> > Tested.
> > 
> > Signed-off-by: Jari Ruusu <jari.ruusu@gmail.com>
> 
> Thanks for these, I'll review them after the next releases happen in a
> day or so.

Well that took a lot longer than expected, sorry, now both queued up.

greg k-h

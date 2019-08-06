Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907CC82ABF
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 07:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfHFFQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 01:16:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfHFFQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 01:16:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05242147A;
        Tue,  6 Aug 2019 05:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565068598;
        bh=o/TrSHzdSPhTYDkhxb6OehuJTgPmBqEkHNHSSX5LqfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qbdhTgRCp30p+7KwqPCnPTzvuDcBDxBPUkkoHcvcWmkSvv4FwzNk4RWGgbAzrUz8r
         RWAHd3mQgY3zOR93MJ8d8wnNvzkauY0IDJXbn2UGT4WmLhFlbbGaIVdUEBqBtDlBop
         l3gXUIobNA1Xu/r3o4n9KGa6mluy0/BNjqoTmtLA=
Date:   Tue, 6 Aug 2019 07:16:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jari Ruusu <jariruusu@users.sourceforge.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.188-stable review
Message-ID: <20190806051635.GA8525@kroah.com>
References: <20190805124924.788666484@linuxfoundation.org>
 <5D488D55.B84FC098@users.sourceforge.net>
 <20190805201847.GA31714@kroah.com>
 <5D490021.F1CCC042@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D490021.F1CCC042@users.sourceforge.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 07:20:49AM +0300, Jari Ruusu wrote:
> Greg Kroah-Hartman wrote:
> > On Mon, Aug 05, 2019 at 11:11:01PM +0300, Jari Ruusu wrote:
> > > Peter Zijlstra's "x86/atomic: Fix smp_mb__{before,after}_atomic()"
> > > upstream commit 69d927bba39517d0980462efc051875b7f4db185 seems to
> > > be missing/lost from 4.9 and older stable kernels.
> > 
> > Can you send properly backported and tested patches?
> 
> linux-4.4 backport of "x86/atomic: Fix smp_mb__{before,after}_atomic()".
> Tested.
> 
> Signed-off-by: Jari Ruusu <jari.ruusu@gmail.com>

Thanks for these, I'll review them after the next releases happen in a
day or so.

thanks,

greg k-h

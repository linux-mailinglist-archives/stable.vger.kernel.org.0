Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377FF1CA423
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 08:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgEHGie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 02:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgEHGie (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 02:38:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2FFC20735;
        Fri,  8 May 2020 06:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588919914;
        bh=QdUNDQQ9WYRs8wGhUIVb1h0rwxMrSfxItzMhT+O1Qmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vFgDSfBHKUuDhvb1ox9+HtZEie5wPLJmEB/sepcDgEXrjtNrmjGD786Gs7/egAVr0
         fJdVpztWKf63xKWZAPVWYGAaEZE9b5PbuIUEDMxn/F1zJgRKWNh1YBd+EIHb8TiQmi
         2hxHlCXGx80RVQD5J3QzBtLdO2oyb015jK9Aash8=
Date:   Fri, 8 May 2020 08:38:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tuowen Zhao <ztuowen@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        acelan.kao@canonical.com, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com, subdiff@gmail.com, hch@lst.de,
        akpm@linux-foundation.org, alexios.zavras@intel.com,
        allison@lohutok.net, bcain@codeaurora.org, boqun.feng@gmail.com,
        geert@linux-m68k.org, lee.jones@linaro.org, mcgrof@kernel.org,
        mingo@redhat.com, natechancellor@gmail.com,
        ndesaulniers@google.com, peterz@infradead.org, rfontana@redhat.com,
        tglx@linutronix.de, will@kernel.org
Subject: Re: Patch "lib: devres: add a helper function for ioremap_uc" has
 been added to the 4.19-stable tree
Message-ID: <20200508063832.GA3120556@kroah.com>
References: <20200508005104.CDBDD208CA@mail.kernel.org>
 <f86e1777b6ca07ea496079fe96c5e5934b9e3a99.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86e1777b6ca07ea496079fe96c5e5934b9e3a99.camel@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 07, 2020 at 07:47:44PM -0600, Tuowen Zhao wrote:
> Hi,
> 
> I believe some patches are needed to fix build issues on Hexagon:
> 
> ac32292c8552f7e8517be184e65dd09786e991f9 hexagon: clean up ioremap
> 7312b70699252074d753c5005fc67266c547bbe3 hexagon: define ioremap_uc
> 
> The same is for stable v5.4.

Thanks, both now queued up.

greg k-h

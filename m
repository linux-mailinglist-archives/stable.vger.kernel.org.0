Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A301252D0
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 21:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLRULZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 15:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfLRULZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 15:11:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CFC6227BF;
        Wed, 18 Dec 2019 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576699884;
        bh=QpeOzRz6bwwMW6VIx6Zh9uQFUXPxaZohhZIYXPEQGp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gSXW8mEL9R3/ObNja+neR8rkkKv7VO3S4Z7LVADRuXpqNZDD3Kv8Y1BiXTugUQ1mm
         x5XiHzfxiG85vTL1pkd82vUTC/IRSxjDmV8CwQngpnbuNaPWs3u7zzaxx+3L4Oofp1
         K3V1p3+vcG3Z9lEaTocdsXs9WYSnnPB6cZ8iYsn4=
Date:   Wed, 18 Dec 2019 21:11:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sasha Levin <sashal@kernel.org>, Will Deacon <will@kernel.org>,
        "kernelci.org bot" <bot@kernelci.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.19 031/219] arm64: preempt: Fix big-endian when
 checking preempt count in assembly
Message-ID: <20191218201122.GB913802@kroah.com>
References: <20191122054911.1750-1-sashal@kernel.org>
 <20191122054911.1750-24-sashal@kernel.org>
 <20191214021403.GA1357@home.goodmis.org>
 <20191216094523.GA9938@willie-the-truck>
 <20191218103830.3f396a6f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218103830.3f396a6f@gandalf.local.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 10:38:30AM -0500, Steven Rostedt wrote:
> On Mon, 16 Dec 2019 09:45:24 +0000
> Will Deacon <will@kernel.org> wrote:
> 
> > Yup, without 396244692232 this commit makes no sense. That's why I didn't CC
> > stable or add a Fixes tag :(
> 
> Yes, please have stable revert this change.

Now reverted, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E34222209
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 13:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgGPL6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 07:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgGPL6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 07:58:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C6B920739;
        Thu, 16 Jul 2020 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594900699;
        bh=9srEDBajR9p24JXNJ8Nyoxyn9WC5JbPe2lny+DUlt7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pu8X5C/5QsnFhDYwgMhuZLTAmv5Iqm3pbpC4uVRJj4m4dpHIfW2d8aQoHWl7fesKX
         itxj2q3KFriY/jQchrDds7xvxv0ktKU2nIU4F5CXZKR/PsKumfdtf6bXm8/ob6ZYIr
         +5AlXeyoDa123hOfnJb1XjLL+QBv3w1oaKyQfYFo=
Date:   Thu, 16 Jul 2020 13:58:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     stable@vger.kernel.org, arnd@arndb.de, sashal@kernel.org,
        naresh.kamboju@linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [Stable-5.4][PATCH 0/3] arm64: Allow the compat vdso to be
 disabled at runtime
Message-ID: <20200716115813.GB1668009@kroah.com>
References: <20200715125614.3240269-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715125614.3240269-1-maz@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 01:56:11PM +0100, Marc Zyngier wrote:
> This is a backport of the series that recently went into 5.8. Note
> that the first patch is more a complete rewriting than a backport, as
> the vdso implementation in 5.4 doesn't have much in common with
> mainline. This affects the 32bit arch code in a benign way.
> 
> It has seen very little testing, as I don't have the HW that triggers
> this issue. I have run it in VMs by faking the CPU MIDR, and nothing
> caught fire. Famous last words.

These are also needed in 5.7.y, right?  If so, I need that series before
I can take this one as we don't want people moving to a newer kernel and
suffer regressions :(

thanks,

greg k-h

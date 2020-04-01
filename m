Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965F419AC19
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 14:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbgDAMx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 08:53:26 -0400
Received: from ozlabs.org ([203.11.71.1]:33375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgDAMxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 08:53:25 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48smMl3sfDz9sTT; Wed,  1 Apr 2020 23:53:22 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: b1a504a6500df50e83b701b7946b34fce27ad8a3
In-Reply-To: <20200306150143.5551-2-clg@kaod.org>
To:     =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, Greg Kurz <groug@kaod.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: Re: [PATCH 1/4] powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configured IPIs
Message-Id: <48smMl3sfDz9sTT@ozlabs.org>
Date:   Wed,  1 Apr 2020 23:53:22 +1100 (AEDT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-03-06 at 15:01:40 UTC, =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= wrote:
> When a CPU is brought up, an IPI number is allocated and recorded
> under the XIVE CPU structure. Invalid IPI numbers are tracked with
> interrupt number 0x0.
> 
> On the PowerNV platform, the interrupt number space starts at 0x10 and
> this works fine. However, on the sPAPR platform, it is possible to
> allocate the interrupt number 0x0 and this raises an issue when CPU 0
> is unplugged. The XIVE spapr driver tracks allocated interrupt numbers
> in a bitmask and it is not correctly updated when interrupt number 0x0
> is freed. It stays allocated and it is then impossible to reallocate.
> 
> Fix by using the XIVE_BAD_IRQ value instead of zero on both platforms.
> 
> Reported-by: David Gibson <david@gibson.dropbear.id.au>
> Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
> Cc: stable@vger.kernel.org # v4.14+
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/b1a504a6500df50e83b701b7946b34fce27ad8a3

cheers

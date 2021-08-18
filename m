Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC43F0754
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 17:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhHRPCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 11:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238872AbhHRPCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 11:02:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E636C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 08:02:04 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629298922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N4EQWRnR07A+JeIPYVccYxDbr3rB/UQmGtInQLrcQQk=;
        b=vcBV4vppi/rBLIuwa++yH/4vopqdp2RyfGLq5hEjjOstJfwaPlncruPJmhfwqNiZhTPtgo
        Xj5M+Zb+BLzfwLmbOjbyqNMW3Ds0ooqwk6iTyde5UXVxinnIwkRzdHLcNDg6GyHitzJWD1
        zkMQGtNVqrg6fTORd6ToSL/8v6zVOm341AGXoI9aydUeHvHCXsq8BBJLTrionpqHlvFOJJ
        uruWuH9TtjKTCJM7lTciYaZNfSKdOZ86Liyd6ekFxNvyohrcHvdz014lMbxq6yozUPPDCj
        bu6X1CvERQ47L8gkgwMuEv1KguGZYWb3GgrG5+yLR6ceNjQnNC17+hPcXyDp1g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629298922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N4EQWRnR07A+JeIPYVccYxDbr3rB/UQmGtInQLrcQQk=;
        b=ZdlEj2FptYG+QGEJ5WWQORPNT8eDk2QkpktJSWn7l+GqQ/LyQAfV0zjn+A1sVnQ7pTW6rK
        t00JA/KlXxVCdnBg==
To:     gregkh@linuxfoundation.org, maz@kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] genirq: Provide
 IRQCHIP_AFFINITY_PRE_STARTUP" failed to apply to 4.14-stable tree
In-Reply-To: <16291010132168@kroah.com>
References: <16291010132168@kroah.com>
Date:   Wed, 18 Aug 2021 17:02:01 +0200
Message-ID: <87mtpe23va.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16 2021 at 10:03, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

That one is easy to backport, but the x86 fixes which require this
depend on other fixes which are not in 4.14, especially

  6f1a4891a592 ("x86/apic/msi: Plug non-maskable MSI affinity race")

So I leave that to the kernel necrophilia cult members to sort it out if
they care.

Thanks,

        tglx

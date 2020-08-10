Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BCE2411F2
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHJUzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 16:55:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53424 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHJUzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 16:55:01 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597092899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y0jtKoxhIcoiQ7gBdTS4dcYT9JXALMCiMed9vBdYRvs=;
        b=BIlnQaMn+bF0KBDMc4qRQe04Q+lzdEvxHQCt2elBT7BICxo6NxllhGjcqO9oHMPn4xLrqn
        cFjjmXOdcB5CGEzO9Jvr3tdfj4+TabeL15idXej7SzkvoWt8RVJa4gDvpa+WW0cEpyJD/t
        0INYublVzdmR4sF8AzbWyPl2R2rsQthB7IWOZ64aWx3hXULb3hskr46DauZNmA0CWlgcFI
        eoEpo2eEaw8W03lnqPrZz51QUw2/s3vgOlgVAU6D96ESvYXmNPY33jTqDVnDNBjFvbyjJC
        1nen2LHJgRs5WJwgPtCkOwWBoCRH6fLJb+oMvt52p3tbjMfbe0pJP8nICx1Gqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597092899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y0jtKoxhIcoiQ7gBdTS4dcYT9JXALMCiMed9vBdYRvs=;
        b=aui1JS9phL6pmtsOAc+qZc8+Fx6KCko7sSnwAb6p8dp7Mm5GxgwrS2ZWuLAr5RZVr3yB0g
        VFccFyGp58be68Bg==
To:     Frank van der Linden <fllinden@amazon.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 1/2] genirq/affinity: Handle affinity setting on inactive interrupts correctly
In-Reply-To: <20200810202012.GA20767@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
References: <20200810201144.20618-1-fllinden@amazon.com> <20200810202012.GA20767@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
Date:   Mon, 10 Aug 2020 22:54:59 +0200
Message-ID: <87imdqxluk.fsf@nanos>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Frank van der Linden <fllinden@amazon.com> writes:
> Forgot to Cc these to Thomas - let me forward them to ask his input.
>
> Thomas - do these look good to you? 4.14 is a little different in the sense
> that it didn't have the x86 set-affinity-before-activate workaround. It
> did have the same failure scenario that was seen on arm64, so the patches
> are necessary.
>
> The x86 irq allocation loop has some differences for 4.14 x86 too, but
> I don't see any problems there.

Me neither.

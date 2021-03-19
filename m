Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5473934284F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 23:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCSWB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 18:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhCSWBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 18:01:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A8C06175F;
        Fri, 19 Mar 2021 15:01:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616191297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=X/jl3IqM3RPJXsoGzP35c2Hq0o+sTNe2BHyzIqAca8w=;
        b=TX7HU4MFzSfE9xgCFKb4+EGtFN8Ep6mQJ9GVaojW+/16PHCtIeFJhG7zAuSBqlQe47rv6H
        LWyBbWm7r/8XTo3o8pLOFpAjibdn2kOD9Rel/6ylgi+CnYZ+u/dwWfvWZEd8IaMFf0Wa5D
        lFPDW2w53WlbS+Xl5je9nsjlO5EBWSbPtL+3gqVTHvzgey1xVjO369vWK3JMCwOA6QOYs2
        lt/j/JnNbvRDawBwUV7Linh34nTLH2L0iIDTKRbry4Jagh97kFeJbUoZN9qynnAktaes3T
        U1SimNdb5tOUIMEc8b8FIyYusAus68nFmiDaMDmF5gNCCFzp9gharEkqbBnNpw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616191297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=X/jl3IqM3RPJXsoGzP35c2Hq0o+sTNe2BHyzIqAca8w=;
        b=Q8/5ozMWqefM9cItADml1rB7JRw/RILH25LvibZQzdadttl/3KhkAuyyoNqtW7yES52t03
        efjxo6Uj6rk8wuCQ==
To:     Johan Hovold <johan@kernel.org>, x86@kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] x86/apic/of: Fix CPU devicetree-node lookups
In-Reply-To: <20210312092033.26317-1-johan@kernel.org>
Date:   Fri, 19 Mar 2021 23:01:37 +0100
Message-ID: <87mtuyby66.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12 2021 at 10:20, Johan Hovold wrote:
>  arch/x86/kernel/apic/apic.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> It's been over three months so resending.

Sorry, was probably lost in my post X-mas mark all mails read habit.

> Can someone please pick this up for 5.12 or -next?

Sure.

>  Changes in v2
>  - rewrite commit message
>  - add Fixes tag
>  - add stable tag for the benefit of out-of-tree users

I'm keeping it for correctness sake and not for this reason.

Thanks,

        tglx

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5206827176
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 23:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfEVVQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 17:16:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37203 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbfEVVQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 17:16:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id o7so4248837qtp.4;
        Wed, 22 May 2019 14:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IRDeg6juu9TInpGEUEsh12JdfkX4fbWASfCdn5kwEwo=;
        b=l/GM5KjopFjgbnIKVrkQBcZQ7sudlrvhjbQ4BC0yhixsuYYj3KZxqvREtYjHssMFvV
         c9zBIzzPTmU9Oz8V63hsEdABFGmxdYY6/QMb5DwdhcqEPBleWafiT7m32391zpKJHEPa
         wKKZ7BxqWO6+nmPPBpKokLXZa6ld4hjH4mb1vajY0vpWVqp8wWcQtrc8oqIsLWurnEsk
         DER9cebLKx3usmC4h0SxTAPh0gC4XmP9e/I4jN1qh3vUCYydiyoipWLzYQ9yRLQjgR4C
         EeX0DOLeeowoI/QsIuMzenvb+CbSPugImu8Uj9T50geezggMW3IZg/FMgldGoKIhT074
         RikQ==
X-Gm-Message-State: APjAAAVvynSpr4/Desi1FEh3TfHd1iHdn+snK9mqP25eD4R7eDDoqfT1
        Jk245gKmFIksvba66Qd8tqwQWmOs0TxkkfikrJI=
X-Google-Smtp-Source: APXvYqxRHIuj8C7LagjHY5o0vw8tutrohkTAg2q5dHo9HC3r8+VsVxO6QVsI0OWyf9koBryzkBEG0/AKdXcmD+aAbnk=
X-Received: by 2002:ac8:3319:: with SMTP id t25mr76253431qta.204.1558559781276;
 Wed, 22 May 2019 14:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190522132250.26499-1-mark.rutland@arm.com> <20190522132250.26499-4-mark.rutland@arm.com>
In-Reply-To: <20190522132250.26499-4-mark.rutland@arm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 22 May 2019 23:16:04 +0200
Message-ID: <CAK8P3a2jcXwyG2DRmKJfV5VF_R7c9H7L89ys-sx+qWEe_zBhCQ@mail.gmail.com>
Subject: Re: [PATCH 03/18] locking/atomic: generic: use s64 for atomic64
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        James Hogan <jhogan@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Matt Turner <mattst88@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Burton <paul.burton@mips.com>,
        Paul Mackerras <paulus@samba.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Richard Henderson <rth@twiddle.net>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 3:23 PM Mark Rutland <mark.rutland@arm.com> wrote:
>
> As a step towards making the atomic64 API use consistent types treewide,
> let's have the generic atomic64 implementation use s64 as the underlying
> type for atomic64_t, rather than long long, matching the generated
> headers.
>
> Otherwise, there should be no functional change as a result of this
> patch.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Will Deacon <will.deacon@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

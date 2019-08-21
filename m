Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEF498693
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 23:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfHUVYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 17:24:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57731 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfHUVYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 17:24:40 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i0Y5l-0005mc-Rl; Wed, 21 Aug 2019 23:24:29 +0200
Date:   Wed, 21 Aug 2019 23:24:28 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Neil MacLeod <neil@nmacleod.com>
cc:     John Hubbard <jhubbard@nvidia.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, gregkh@linuxfoundation.org,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/boot: Fix boot failure regression
In-Reply-To: <CAFbqK8=BodLiMr4pdHjdqsZtk8iHUC_9oyRRALJt0xLz4y_4sQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1908212323290.1983@nanos.tec.linutronix.de>
References: <CAFbqK8=RUaCnk_WkioodkdwLsDina=yW+eLvzckSbVx_3Py_-A@mail.gmail.com> <20190821192513.20126-1-jhubbard@nvidia.com> <CAFbqK8=BodLiMr4pdHjdqsZtk8iHUC_9oyRRALJt0xLz4y_4sQ@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Aug 2019, Neil MacLeod wrote:

> I can confirm 5.3-rc5 is booting again from internal M2 drive on
> Skylake i5 NUC with this commit - many thanks!

I've queued that in x86/urgent and it's en route for rc6 and stable.

Thanks!

	tglx

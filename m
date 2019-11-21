Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360A9104EBD
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 10:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfKUJHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 04:07:16 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:58027 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfKUJHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 04:07:16 -0500
Received: from mail-qk1-f180.google.com ([209.85.222.180]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MlwFp-1i7D7J1bXP-00j50B; Thu, 21 Nov 2019 10:07:14 +0100
Received: by mail-qk1-f180.google.com with SMTP id e2so2403491qkn.5;
        Thu, 21 Nov 2019 01:07:14 -0800 (PST)
X-Gm-Message-State: APjAAAX2EmKFiiT2rUJ9lXShvIUPJAH1iBGH8nV1Kl7H7iG5BZddrOlE
        Xs5UOcG+yX+XU44ZGRbsYLp35dKDT62dxAspoYM=
X-Google-Smtp-Source: APXvYqz0knwr27vOcmkkaREpSGNN31fRcZlHTsqa2yOgKtw6XKUZWtgvnf4DEi0F3uVGb6x4PGDYRjeb7NG71QvZYeU=
X-Received: by 2002:a37:58d:: with SMTP id 135mr6882097qkf.394.1574327233197;
 Thu, 21 Nov 2019 01:07:13 -0800 (PST)
MIME-Version: 1.0
References: <20191121000303.126523-1-dima@arista.com>
In-Reply-To: <20191121000303.126523-1-dima@arista.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 21 Nov 2019 10:06:57 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2ny7SBwQbNcn5nxYrZ9pX1Vh5P2PFXVpOFaquTcFguCA@mail.gmail.com>
Message-ID: <CAK8P3a2ny7SBwQbNcn5nxYrZ9pX1Vh5P2PFXVpOFaquTcFguCA@mail.gmail.com>
Subject: Re: [PATCH] time: Zerofy padding in __kernel_timespec on 32-bit
To:     Dmitry Safonov <dima@arista.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:+84/mLQW0Wd+nj8N7g/1lDbad3ei+9/DkUcK33umBC8TLCOF47B
 jl/hoWlC09Qa3G64HxmMlKXjo0YuoCextcIc1Mr5UHOx3fTACZWetCTrDC5rx/DYn1U9D0V
 5oRGE7CuoDTAdyR4rfGvqcewXbTDCIiGLQr4NWcYmrZWYfmF4QzwPp8yIICH7mRhjAZpQe8
 FYZSc3DZ9xKSVLmPVnsgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dRmdJ2KizgM=:sf3PrKnyuhy2+ZoLV/2ToI
 sCgzNzQG0lj1uKKffdv0x0b28aZvMuOqVpuZXzOugqWDOQN0gcc4g1NwYBDRYVSqGG78pGzke
 b8kqPEuNSJT+xLfNc4k+E0oYplvmeDRzFyLbYU6H2UrNEIwd7yU9KSztIHEdJrzEFP7nf+GN3
 wrTnvubQ7SYHNrfUKxLlYpPfm6Tu/UC4hQhiyMZSbs3jgA6wddPtUtTzxKatm1JSiy+dmb6SP
 3TGPPY5jwVAcavgL1R+5sOuFl3dAdIWjCGUw20zgpgwVOeIvcCGGXLHaqSAuPGiXq4YkuwHfU
 kx9dyq65q8xbc7xA/nTrNFtNiK4kdkuanqiBaIaqum9lh5WUdLRBLFvFqE6eCnD8dpXsYqi8r
 8J5JmAKr2i4kKbPn7nxrvQLJ3oLKoTeVM/YJZUJ2EPg+vTnfBG1Fbt3UXFDslYEUrEVwiiHq3
 olOsTkPynGYayrdpLmb5k2h09OxTJmxSV+8HkS4lVK1vnsad5BRwGHU3tGAX9lToV5L2u40fW
 FyaBq4YAsyCQrzT+MrcD5gPOP6h3qb9mb22xQoFJSiZjfhHrmIt+ju52KrgRxMuVyoSS6+PlM
 jnwV4CEiGXGhgSSg5TPD+IiRfArrnalm5POhbVH0KGS3c/qvwP0yEG24kNiOUXy3d2ta7/sH0
 8Z0mJxxRWNkKY3V2Dl2uVoKRXz/d17BTJjidstm/eWn7UdOKCkB/PKjr7ib60zXC6kEo9sPxG
 +TuDPjVcl2Y5ZNmnNenoqXSVP3lLEt2dOWFwVUK9dOKQCxnQA1JFGJ+NG4AC3v+gyVKV8Jo+T
 fuDrM4E01mHqVjOdreTm489U2GOoMDkVJ5jgoMDCFeZ2r8EDus2EOteOEeId40Okc3/B/Q4+v
 VKD21MarhfoAIpUinruA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 21, 2019 at 1:03 AM Dmitry Safonov <dima@arista.com> wrote:
>
> On compat interfaces, the high order bits of nanoseconds should
> be zeroed out. This is because the application code or the libc
> do not guarantee zeroing of these. If used without zeroing,
> kernel might be at risk of using timespec values incorrectly.
>
> Originally it was handled correctly, but lost during is_compat_syscall()
> cleanup. Revert the condition back to check CONFIG_64BIT.
>
> Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
> Fixes: 98f76206b335 ("compat: Cleanup in_compat_syscall() callers")

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

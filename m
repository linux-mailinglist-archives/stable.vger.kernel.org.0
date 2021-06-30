Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E617E3B8189
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 13:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhF3MBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbhF3MBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 08:01:21 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B675C061756;
        Wed, 30 Jun 2021 04:58:51 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p15so4531022ybe.6;
        Wed, 30 Jun 2021 04:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EoB32QbQ3pte8D0g3hxaB2ZapmzM19t9cU1a9ijg6c0=;
        b=lk3MSBC2Q39HUJKogdU4FCGZV7LBZZHy5y7CJAAHQ9Evp0XLYibQqvwDGpSm9OPGfY
         MzfhUWMbOPFmTR7vVemZLdcwGlCAba8gjh6JDRaA0Bmeerti55Ca8Wwr+4XAxpJJeHu4
         MZIrs6clEfSZkY0ov02PGi8Gr+ElBoT36F3gu8TAIP6W2PZBzRmADm0n6JMp2xvyduJr
         ozXKDKYHSc/KFxDqOEs5k6BRgcyJxrOJGSyE0t3q57ezOBUghoxTYyuspJCtszwp3Xtc
         ES5GuVEpUu6q2QS8Q03q51Lqvbs1aS86GDHPcP+Cz2uHxAoY8M2soBuPP0ffKM4WJXGJ
         049A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EoB32QbQ3pte8D0g3hxaB2ZapmzM19t9cU1a9ijg6c0=;
        b=RZXTkwKtB5re/kUwk+0cTaay/cz9oFlx5oXDWglMP+t5sgxZGMmFehwPhWb0I82tDm
         Brlo1h10/xch3StGcr80YFDhH4pl1hVK9ZrurPuI3MglzjIdXsKJBOsDXhlGCcWOxEIC
         0TuXIP26ThIkb4+nKGvWwG3uu2Ubh7tECMfMcMTjJNI7zn7XABaaAwj/dxEqccPog6Hy
         /AzAPHjtnfoZv/PNMrpWAw9RGQjf5qsV78g8Kg0oVld4pxzPSG61eyFw18WOxQmL+cRQ
         GXeWysl8nc/y1OFjVFW6Z84czFEY62mjmFW57k5w9KN7ZLAN/w3znxC3b2p9LESBdTiw
         BPSA==
X-Gm-Message-State: AOAM532GvKTUdlCK0dZHXg72vuel6juF2CJ7KJqaXiVN/QN7zSVbuGWX
        XcK9BqrkJm4yABwd1gIPs1JBSNsC1ccHjFnycUs=
X-Google-Smtp-Source: ABdhPJx0T9n/JTcxj2+m85UxkpSF62bTVpXOJ0ynahVA6xKjm0cwVmfFvSj5go+WHqQsjdGb2DR2yYyiGr8Ihw1G/X0=
X-Received: by 2002:a25:b701:: with SMTP id t1mr42905464ybj.517.1625054330916;
 Wed, 30 Jun 2021 04:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210627135117.28641-1-bmeng.cn@gmail.com> <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
 <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
 <aa1f027c-bbc7-92f8-80a6-fe290cd1cdf8@huawei.com> <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
In-Reply-To: <CAEUhbmXeqAsLxm+oCHRPHMZq2mQXPD6fJOFerwp_BRv1kCc7ow@mail.gmail.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Wed, 30 Jun 2021 19:58:39 +0800
Message-ID: <CAEUhbmUvDSocWobb26PcrV6vi6kHjg8o6pNomt9AnGWGbvAuhw@mail.gmail.com>
Subject: Re: [PATCH] riscv: Fix 32-bit RISC-V boot failure
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Atish Patra <atish.patra@wdc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 11:21 AM Bin Meng <bmeng.cn@gmail.com> wrote:
>
> On Mon, Jun 28, 2021 at 10:28 AM Kefeng Wang <wangkefeng.wang@huawei.com>=
 wrote:
> >
> >
> > On 2021/6/28 9:15, Bin Meng wrote:
> > > On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.c=
om> wrote:
> > >> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed by
> > >>
> > >> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefe=
ng.wang@huawei.com/
> > > What are we on the patch you mentioned?
> > >
> > > I don't see it applied in the linux/master.
> > >
> > > Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
> > > because 32-bit is broken since v5.12.
> >
> > https://kernel.googlesource.com/pub/scm/linux/kernel/git/riscv/linux/+/=
c9811e379b211c67ba29fb09d6f644dd44cfcff2
> >
> > it's on Palmer' riscv-next.
>
> Not sure riscv-next is for which release? This is a regression and
> should be on 5.13.
>
> >
> > Hi Palmer, should I resend or could you help me to add the fixes tag?

Your patch mixed 2 things (fix plus one feature) together, so it is
not proper to back port your patch.

Here is my 2 cents:

1. Drop your patch from riscv-next
2. Apply my patch as it is a simple fix to previous commit. This
allows stable kernel to cherry-pick the fix to v5.12 and v5.13.
3. Rebase your patch against mine, and resend v2

Let me know if this makes sense.

Regards,
Bin

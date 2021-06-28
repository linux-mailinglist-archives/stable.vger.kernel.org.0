Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDD93B5690
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 03:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhF1BSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 21:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhF1BSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 21:18:24 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BF7C061574;
        Sun, 27 Jun 2021 18:15:58 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id o139so7645533ybg.9;
        Sun, 27 Jun 2021 18:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UkMAHfuwy4T4nE/9j7AY6+wibmFtWQXZ1+xqS+q+V5g=;
        b=NiCCYiUWUhiAheTITykpwC+dxbmQnBiVsbXJeWf4dUKX2eI0lZUrhz9lUFWBcjrQGU
         +aWXbl5TV9GdjKY4+9o68L1u694oOKZL/SzN9nNH6Y4N7xNMQeNq6G10JRjDf35D6wTY
         F2rsufzPhXAHmZj0oeKCnUvCWITQrwhoiQ++WLpY/B+ixnOQE0qT7mbZfq0pCBMHDoIH
         iox3aeR24DjoMgweX/+KUATDThgS+IxPni54ORr/uRHhPUMxGpxjS5h2PeuNEuDlZh2z
         TqFiSaZI8B8XEMnVPZkW8mx01MVQQm/oEaaw8i4mX459Fm3hxGHIbfn9llruFHiK7FyG
         lSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UkMAHfuwy4T4nE/9j7AY6+wibmFtWQXZ1+xqS+q+V5g=;
        b=dyeisYhs+HWIKRZ3HlfbcG2LQy6qtmz5I+Z+qNJiinzv4IGbAcMUdw4Ht2IaeSMYA4
         OAJ3aOAaWFK12QLeo6sBNUFXKn2gMXXle32XTcctSqCtV/SaEwhNpipG0m/t+IGllZsi
         VCTZk9JMLF6KWcuGkX0CaJ/5fDmL7Cate9Rh1x0wxyOGiyeP+jom2WkBrdVVOObk3zM5
         YSM+Y2xYvr8EDZtipvKAPvrR0vbGV0bAw6yPxmJqCEbtu+dB2t9V8SfiMJuvIpoMwcQ+
         hps+vX8VzUy8Vy5pmg0Kl7nQ3USSkVQulhfBV/50HyAmS6RVo6On2G/P6Ro03I49wqwx
         l+Wg==
X-Gm-Message-State: AOAM533pqorM+K9kSTBfe8v/XMEwP/49N+nBIKNzdidriPKPaCmQfvM7
        83asVAAoZw5KgRskNYQWcvjJOLLSb4PDmmOh8EQ=
X-Google-Smtp-Source: ABdhPJwluPXetY+X6ZHjkQQfTC3XBMX2pKdbuji9mHu2sB5uWOFxPXFw9g3V7NBJI494uGJDv9k0gBK9KL5GAP4zZH0=
X-Received: by 2002:a25:ac86:: with SMTP id x6mr26783670ybi.314.1624842957907;
 Sun, 27 Jun 2021 18:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210627135117.28641-1-bmeng.cn@gmail.com> <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
In-Reply-To: <11706f7e-a53a-5640-d713-bc4562db71fa@huawei.com>
From:   Bin Meng <bmeng.cn@gmail.com>
Date:   Mon, 28 Jun 2021 09:15:46 +0800
Message-ID: <CAEUhbmV=h3nZ8Aa94_uyjrZ_NGe+9-xAorUMubSPJXu3y60PeQ@mail.gmail.com>
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

On Mon, Jun 28, 2021 at 8:53 AM Kefeng Wang <wangkefeng.wang@huawei.com> wr=
ote:
>
> Hi=EF=BC=8C sorry for the mistake=EF=BC=8Cthe bug is fixed by
>
> https://lore.kernel.org/linux-riscv/20210602085517.127481-2-wangkefeng.wa=
ng@huawei.com/

What are we on the patch you mentioned?

I don't see it applied in the linux/master.

Also there should be a "Fixes" tag and stable@vger.kernel.org cc'ed
because 32-bit is broken since v5.12.

Regards,
Bin

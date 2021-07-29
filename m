Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03193D9D3A
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 07:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhG2Frc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 01:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbhG2Frc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 01:47:32 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC28FC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 22:47:29 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id j21so5522673ioo.6
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 22:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w60/VELNDBnq6j43CmiV7Bx6nr6aPzyLJ2Noe+SivnU=;
        b=VuKnsO+XEmpG5oBRxRnV4vci8jUzDUJaY8oLacnkFTs1pQJf9EeWbGzarIi36gyTGd
         k+v0GMNZu+INYDyKSbwqC0mWrmrBLymIDpOOpIehPCXQ+Y6ZwbKBHsX3YbQBbhnfE4zP
         PQ8bi7V7Pf6pIxuHsl9EvhHrpPp6J5iaO9/Ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w60/VELNDBnq6j43CmiV7Bx6nr6aPzyLJ2Noe+SivnU=;
        b=A7jsaPtQRnREPFMa9Gg+7Oo/QDFSykotEk5zokgw5frolDpIxTBUCR3IbK0MQRoolg
         792avrajYOPPpUAFkjUxW1zw1kbUAzIo9OMhvZeSEaZE8lztGeqS/cMqU+mLVnJIBWjU
         WTtLKWWpVNOGrZkgEAwwaYuVBsgDyBwDoh0a9dQ5c1NT2nTryQWMHYAKLDWyEP8kqw22
         tIWmBZltrC0MwjVxPqAsTrqghO2yJCr0HrzFobFO+/e+cueH9Djr6PrwudL6uue88GVX
         KRI+yafOlIfaIV+g44/u1SRCzubpwIKfzEJyWHN0DmWD/0wVPo285TmZKOBVUDidvn2B
         X/fg==
X-Gm-Message-State: AOAM531sg7tYBuIrJBbeF5wzmk32FUY79w1Z1neIPsglbvpa75XJrvP0
        sWD+zFckWC2s0P8owO/kdv+2jcdq9JNHycIIva0k/A==
X-Google-Smtp-Source: ABdhPJwsKcPUZyLkIjwGaAUj8BpR75Su46CVaCo58W4CpPpfcjnsCOLGplNVhzoC+fkaqbXezwlnNhfwrLpJ1BoHuSs=
X-Received: by 2002:a02:6946:: with SMTP id e67mr3016189jac.4.1627537649171;
 Wed, 28 Jul 2021 22:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210727174025.10552-1-linux@fw-web.de> <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
 <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de>
In-Reply-To: <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de>
From:   Hsin-Yi Wang <hsinyi@chromium.org>
Date:   Thu, 29 Jul 2021 13:47:03 +0800
Message-ID: <CAJMQK-gQeMidjBZ1E=ReMmffC5G8oiFawB4Ey1PNb2ZWXw_1Bg@mail.gmail.com>
Subject: Re: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 1:40 PM Frank Wunderlich <linux@fw-web.de> wrote:
>
> Am 29. Juli 2021 05:15:23 MESZ schrieb Hsin-Yi Wang <hsinyi@chromium.org>:
>
> >This patch is breaking the mt8183 internal display. I think it's
> >because  ~routes[i].val; is removed?
> >Also what should the routes[i].mask be if it's not set in
> >mmsys_mt8183_routing_table?
> >
> >>                         writel_relaxed(reg, mmsys->regs +
> >routes[i].addr);
> >>                 }
> >>  }
> ><snip>
>
> The mask should reset the needed bits,maybe it needs to be adjusted for your ddp components...
>
> Can you add some debugs inside loops in mtk_mmsys_ddp_connect and mtk_mmsys_ddp_disconnect (show read val,mask and final mask before write) to show differences before and after the patch?
>
 struct mtk_mmsys_routes {
         u32 from_comp;
         u32 to_comp;
         u32 addr;
 +       u32 mask;
         u32 val;
  };
mask is not the last element, and mmsys_mt8183_routing_table = {
  {
    DDP_COMPONENT_OVL0, DDP_COMPONENT_OVL_2L0,
    MT8183_DISP_OVL0_MOUT_EN, MT8183_OVL0_MOUT_EN_OVL0_2L
  }
...
so the mask and val will be wrong. CK, do you know what mask we should
set for mt8183? Or can we just set a dummy 0 mask.

> regards Frank

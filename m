Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8756D3D9D60
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 07:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhG2F6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 01:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhG2F6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 01:58:46 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA00C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 22:58:43 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id a13so5578112iol.5
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 22:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QpDRWGFIK+Oln4PWA6QkkpVe40JSJ8McnR2s+RnmGkE=;
        b=mmEdZWH9QO6nTwu1Vap8c1ufo0haYzJ8+AoIt9koR+Oq6F9tciWkxYwiyOr/1kks/t
         +wKXMxFzePzvH3ebDbbHnYTXduaI5UNG9WqujvKrMq0oix+whigIbboTajwuo5SArw9r
         xA/96OufmolG8tE1YH1ypC4LDe3rKlEtDr8TE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QpDRWGFIK+Oln4PWA6QkkpVe40JSJ8McnR2s+RnmGkE=;
        b=XmOO//tV1jO4l8lI+oK2qKNOY7VgN562cBtTxWQEa9VL2s82QoPgHBmSMm5Q6+c5sy
         6DE2jlPUgVIGKowcZ0jt2jv2wNhAQxZeo7qo+ntkgy/JUad3y6j++ugH9ZbuVRwKtmRR
         qC5C/vvGJp90UkgEqVBo/sAByRFrEHJrD0Pr0Ft0ygoHaT5Dgp+AZWOn8FJ6I4F4cmJR
         YYOXDNcVacGlxBn+PPggi7w1LieKqFqpKToZ2Po3m5AMiyGpx+dUHYrQrOdJf9beRbIH
         aOuS2GxHEUanJPODYxpQVjo7dRmW5uJ5jisSgijKWPPT+xdF714tjTp9CClurO7s6kgO
         /XoA==
X-Gm-Message-State: AOAM532+f+Lgt5h7md1wTdbp1OqWlKAKO42DqwbDh1PSMOGxM+WhgjDJ
        vD0dejmS9eZqjFVHdwWF0jfyb8QKXDYqpd6GTO+vUQ==
X-Google-Smtp-Source: ABdhPJyuGOXvEqwUIs3qU6ruO+/WOCDkqKZfKJc8oEGOVFJCqgihZ7D+ruxIRmlxDQfsEfCMhexgtinohW6+4bJCHhU=
X-Received: by 2002:a6b:c9d3:: with SMTP id z202mr2669436iof.44.1627538323171;
 Wed, 28 Jul 2021 22:58:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210727174025.10552-1-linux@fw-web.de> <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
 <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de> <CAJMQK-gQeMidjBZ1E=ReMmffC5G8oiFawB4Ey1PNb2ZWXw_1Bg@mail.gmail.com>
 <6BFE13A3-6A42-455E-BDF7-CD285CC6C66D@fw-web.de>
In-Reply-To: <6BFE13A3-6A42-455E-BDF7-CD285CC6C66D@fw-web.de>
From:   Hsin-Yi Wang <hsinyi@chromium.org>
Date:   Thu, 29 Jul 2021 13:58:17 +0800
Message-ID: <CAJMQK-iHfJWnGQRq299pZ9B9ABMsXPEkptyCrGtQqkEyc=HNFg@mail.gmail.com>
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

On Thu, Jul 29, 2021 at 1:54 PM Frank Wunderlich <linux@fw-web.de> wrote:
>
> Am 29. Juli 2021 07:47:03 MESZ schrieb Hsin-Yi Wang <hsinyi@chromium.org>:
> >On Thu, Jul 29, 2021 at 1:40 PM Frank Wunderlich <linux@fw-web.de>
> >wrote:
> >>
> >
> >>
> > struct mtk_mmsys_routes {
> >         u32 from_comp;
> >         u32 to_comp;
> >         u32 addr;
> > +       u32 mask;
> >         u32 val;
> >  };
> >mask is not the last element, and mmsys_mt8183_routing_table = {
> >  {
> >    DDP_COMPONENT_OVL0, DDP_COMPONENT_OVL_2L0,
> >    MT8183_DISP_OVL0_MOUT_EN, MT8183_OVL0_MOUT_EN_OVL0_2L
> >  }
> >...
> >so the mask and val will be wrong. CK, do you know what mask we should
> >set for mt8183? Or can we just set a dummy 0 mask.
>
> Ahhh...mt8183 has own mmsys-table and
> i had only changed the default one,so
> value is now missing because value is now the mask. I have used same order as
> CK to avoid confusion and make it easier
> to review.
> Afaik you could use same value as value to reset same bits...did this in default routing table too.
>
Should I create another patch based on this or can you help update the
mt8183 table in this patch?

Thanks

> regards Frank

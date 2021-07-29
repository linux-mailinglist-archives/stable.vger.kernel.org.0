Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2C3D9DD1
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 08:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhG2Gru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 02:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbhG2Gru (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 02:47:50 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864D5C061765
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 23:47:46 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id 185so5680626iou.10
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 23:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z6s9EpghVG5yNilrzApeR2nfAN8bOtTXA63wcdEO850=;
        b=kiGq+5UGU2deXW3vRAKevmyylHfrtWnO+7+Sp7ynaKCzyk1wAtHDzzTSwqCFQIzhkK
         YF3tG+3+NLsQmqIY8E+9qulWBep6l6ZUPfsw75jG4gQvBx0ad5GvPNLUSqu49JUiXheP
         hQ5rYPrbK8iqrdPksGIlNVxeXs1uKgLYVTSf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z6s9EpghVG5yNilrzApeR2nfAN8bOtTXA63wcdEO850=;
        b=eFZZmcVGM/A1sm9280u0Hc9Sh3UDVTcIjXvyDhQMbdDvXIUh51shgru+Vmv92sqjg9
         kVsMxXtcYkI0kVqELLyj6ZFCYEY1KpcC0QaArPTRE1q3aFMe4BVe8d2uSycQnPG1Nrtb
         zvt0YK/YvyKhUUMDg3/rMdEKb5HWOk+OiSnEblE6UndoUwdbQdBYMDU4PA2BRjPZ18dN
         Tb6DsLj0IxqkMjckozmlG8eQvaqzUOyNu4JgGCYhPN9ulPNkc7Yp6PGcF6SnZa8cSaQB
         l+OOkIjTz6KIuZbLvZhgLP9AC9wMsBZPMebMTiGZ6SBSbGo/E71fEiPlJrgD6YvErd8T
         CcGA==
X-Gm-Message-State: AOAM533rrw8J5mbO3QxwjIqihW8teQQQizukovJhVkZaKmecPPkhz3u0
        jtOBhGhmTuz2oduD71bORzlXJId81TNoQbvtTY6Eig==
X-Google-Smtp-Source: ABdhPJzKzTRbqyo6jDgNh8D1SJeVmJ3fBGEpEycmPtYpz5QAyEju6aZXMpvg7LTUDAKQcGZlkxzvqFbTKNhp452opNY=
X-Received: by 2002:a02:6946:: with SMTP id e67mr3202611jac.4.1627541265887;
 Wed, 28 Jul 2021 23:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210727174025.10552-1-linux@fw-web.de> <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
 <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de> <CAJMQK-gQeMidjBZ1E=ReMmffC5G8oiFawB4Ey1PNb2ZWXw_1Bg@mail.gmail.com>
 <6BFE13A3-6A42-455E-BDF7-CD285CC6C66D@fw-web.de> <CAJMQK-iHfJWnGQRq299pZ9B9ABMsXPEkptyCrGtQqkEyc=HNFg@mail.gmail.com>
 <85C44C40-9238-49A2-B878-DEB189671324@fw-web.de>
In-Reply-To: <85C44C40-9238-49A2-B878-DEB189671324@fw-web.de>
From:   Hsin-Yi Wang <hsinyi@chromium.org>
Date:   Thu, 29 Jul 2021 14:47:20 +0800
Message-ID: <CAJMQK-gmO=Q=vxTyc7i-QXPHSuoHmNK1BWnPiqjWGGUovX7sRA@mail.gmail.com>
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

On Thu, Jul 29, 2021 at 2:45 PM Frank Wunderlich <linux@fw-web.de> wrote:
>
> Am 29. Juli 2021 07:58:17 MESZ schrieb Hsin-Yi Wang <hsinyi@chromium.org>:
>
> >Should I create another patch based on this or can you help update the
> >mt8183 table in this patch?
>
> I prepared a patch for mt8183 and it is
> reported as working. I send out v2 with
> the patch squashed ok? It adds only val
> again to each element so i take the
> review-tag,ok?
>
You can also add by review tag:

Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>

Thanks

> regards Frank

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0860E3D9DCA
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 08:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhG2GpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 02:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2GpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 02:45:24 -0400
Received: from mxout1.routing.net (mxout1.routing.net [IPv6:2a03:2900:1:a::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E95C061757;
        Wed, 28 Jul 2021 23:45:21 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout1.routing.net (Postfix) with ESMTP id A70AC3FC27;
        Thu, 29 Jul 2021 06:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1627541118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0SXPPo0VcEtFyVi5Gn0sJ9VFvQaS1vXTYsU5lQjSUw=;
        b=oFbGNazgU/cZbRAXZnVqNf6Cx1g19coGGvFMICpShzsI5qb/5adNyMbodOAu1fREOBn2/e
        mceerDV+ov4ewN6WSxvSo22vg6G162PPcuT0qAXM7rRaKvc2g7Ui2W26xJu8mSvGcCeLyB
        AmfMLsjG4fpq8ajhOnc3/9tlf+2Hiwc=
Received: from frank-s9 (fttx-pool-217.61.146.92.bambit.de [217.61.146.92])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id DE8263600A5;
        Thu, 29 Jul 2021 06:45:17 +0000 (UTC)
Date:   Thu, 29 Jul 2021 08:45:12 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <CAJMQK-iHfJWnGQRq299pZ9B9ABMsXPEkptyCrGtQqkEyc=HNFg@mail.gmail.com>
References: <20210727174025.10552-1-linux@fw-web.de> <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com> <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de> <CAJMQK-gQeMidjBZ1E=ReMmffC5G8oiFawB4Ey1PNb2ZWXw_1Bg@mail.gmail.com> <6BFE13A3-6A42-455E-BDF7-CD285CC6C66D@fw-web.de> <CAJMQK-iHfJWnGQRq299pZ9B9ABMsXPEkptyCrGtQqkEyc=HNFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] soc: mmsys: mediatek: add mask to mmsys routes
To:     Hsin-Yi Wang <hsinyi@chromium.org>
CC:     "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
From:   Frank Wunderlich <linux@fw-web.de>
Message-ID: <85C44C40-9238-49A2-B878-DEB189671324@fw-web.de>
X-Mail-ID: 13508637-946f-43e1-a8f6-3888b1e327ce
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 29=2E Juli 2021 07:58:17 MESZ schrieb Hsin-Yi Wang <hsinyi@chromium=2Eor=
g>:

>Should I create another patch based on this or can you help update the
>mt8183 table in this patch?

I prepared a patch for mt8183 and it is
reported as working=2E I send out v2 with
the patch squashed ok? It adds only val
again to each element so i take the
review-tag,ok?

regards Frank

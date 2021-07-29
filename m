Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA83D9D25
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 07:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhG2Fkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 01:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhG2Fkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 01:40:42 -0400
X-Greylist: delayed 129599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jul 2021 22:40:39 PDT
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5703BC061757;
        Wed, 28 Jul 2021 22:40:39 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout2.routing.net (Postfix) with ESMTP id 77C505FC17;
        Thu, 29 Jul 2021 05:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1627537236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jEsruzU+4ZgtOcGuhFC39Opvs7D5hrM/mEZ+uIBk0/g=;
        b=mUFYjuJzoy+38C6KLbFboT9kugZhO3AUS57Qtg6KO5HtMOoznN+urOykz6Ikh8mUHIZgGZ
        VZVN6RHYSTpNzbtEtiRKZrqYKiFXCT6oJPUmVGVMV2pWEEMGqekp+y7b7mKRLI+8BMR3E7
        YcZaDjq5KGhgp1aOn0ghwXbUIZd3uis=
Received: from [IPv6:2a01:598:a001:9235:1:2:c0e0:123a] (unknown [IPv6:2a01:598:a001:9235:1:2:c0e0:123a])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 971483600A5;
        Thu, 29 Jul 2021 05:40:35 +0000 (UTC)
Date:   Thu, 29 Jul 2021 07:40:30 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
References: <20210727174025.10552-1-linux@fw-web.de> <CAJMQK-g8g5QJbBkU-A6th1VSWafxVv2fGtym+enQa_hDVaVoBw@mail.gmail.com>
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
Message-ID: <97C4FA94-B28A-4F0E-9CD3-4E33B01BA353@fw-web.de>
X-Mail-ID: df228ebd-c9bf-4ff0-8dcf-16b80d1c6270
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 29=2E Juli 2021 05:15:23 MESZ schrieb Hsin-Yi Wang <hsinyi@chromium=2Eor=
g>:

>This patch is breaking the mt8183 internal display=2E I think it's
>because  ~routes[i]=2Eval; is removed?
>Also what should the routes[i]=2Emask be if it's not set in
>mmsys_mt8183_routing_table?
>
>>                         writel_relaxed(reg, mmsys->regs +
>routes[i]=2Eaddr);
>>                 }
>>  }
><snip>

The mask should reset the needed bits,maybe it needs to be adjusted for yo=
ur ddp components=2E=2E=2E

Can you add some debugs inside loops in mtk_mmsys_ddp_connect and mtk_mmsy=
s_ddp_disconnect (show read val,mask and final mask before write) to show d=
ifferences before and after the patch?

regards Frank

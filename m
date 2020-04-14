Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F821A70AD
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403863AbgDNBvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:51:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36813 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDNBvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:51:12 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200414015109epoutp04eb6b909cf013c7096a9d86433de2948a~FjKGVl1vr2389523895epoutp04f
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 01:51:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200414015109epoutp04eb6b909cf013c7096a9d86433de2948a~FjKGVl1vr2389523895epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586829069;
        bh=85ydXoswa+JGs0C+k+gJXkdls+j/Ok8SdZCRAcpoIf0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fFL4iPDQYF6xYKqyc/9GdD8cX/5BL75Tu9vhPtLUqQxPUteQ8J+A3PAQe9fn1I0gL
         BU6Mjt8FDDsA+h8uodH8mXvyCd/A9Mz2UFQGjcNlu9O3VasxwcG9fgtIWjdtDusaWI
         vwTHRRXvYVZf9AhE9/JkpqtiqquePOnAc46TDHjE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200414015108epcas2p176de43e629c68f54e8aa789770d084a7~FjKFw6OUX0168901689epcas2p1G;
        Tue, 14 Apr 2020 01:51:08 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 491T3Z6RBhzMqYkl; Tue, 14 Apr
        2020 01:51:06 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.12.04598.807159E5; Tue, 14 Apr 2020 10:51:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200414015104epcas2p3340ef8a5e262d2d774ec1b5b49f559d0~FjKBka5Aw0209402094epcas2p3X;
        Tue, 14 Apr 2020 01:51:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200414015104epsmtrp1cb8de0453b20d0166c9f09490185dee0~FjKBjiBVf1416714167epsmtrp1a;
        Tue, 14 Apr 2020 01:51:04 +0000 (GMT)
X-AuditID: b6c32a45-3f2e99e0000011f6-b4-5e95170aa335
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.9A.04024.807159E5; Tue, 14 Apr 2020 10:51:04 +0900 (KST)
Received: from KORDO025540 (unknown [12.36.182.130]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200414015104epsmtip127daad9a5ff5c7a8a1cbb5d23f9e5eab~FjKBZFmTt2729027290epsmtip1P;
        Tue, 14 Apr 2020 01:51:04 +0000 (GMT)
From:   "Gyeongtaek Lee" <gt82.lee@samsung.com>
To:     <stable@vger.kernel.org>
Cc:     <broonie@kernel.org>, <tiwai@suse.com>, <tkjung@samsung.com>,
        <hmseo@samsung.com>, <tkjung@samsung.com>, <kimty@samsung.com>
Subject: [PATCH 4/4] ASoC: topology: use name_prefix for new kcontrol
Date:   Tue, 14 Apr 2020 10:51:03 +0900
Message-ID: <000801d611ff$28105520$7830ff60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdYR/yKVEbiK/TT0QOmcRqw0f55jVg==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmqS6X+NQ4g7bFJhZTHz5hs5ixrZvF
        YvXVLUwWCzY+YrTY8H0to8WRxilMDmwem1Z1snn0bVnF6LF+y1UWj8+b5AJYonJsMlITU1KL
        FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
        lfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjIe/H/PWHCW
        reLY7musDYxnWLsYOTkkBEwkXh/fxtzFyMUhJLCDUaJnzQY2COcTo8T9BU1MEM43Ronfm3tZ
        YFpWvrgGVbWXUeL6qpWsEM5LRolv03YwgVSxCehKfLl3hxnEFhGQkZjeuhcszizQxCjR3OHT
        xcjBISzgKrHgPz9ImEVAVaJ76UuwEl4BS4lHx06wQ9iCEidnPmGBaJWX2P52DjPEEQoSP58u
        Y4UYrydx61MvM0SNiMTszjawfyQEjrBJbJv2gw2iwUXixvWDTBC2sMSr41vYIWwpiZf9bewQ
        Dc2MEu/O/oFKTGGU6OwWgrCNJbbMPcUEcjSzgKbE+l36IKaEgLLEkVtQt/FJdBz+yw4R5pXo
        aINqVJLYeOofE0RYQmLeBqjZHhI9XTdZJzAqzkLy5CwkT85C8swshLULGFlWMYqlFhTnpqcW
        GxUYIsf1JkZwutRy3cE445zPIUYBDkYlHt4XgVPihFgTy4orcw8xSnAwK4nwPimfGCfEm5JY
        WZValB9fVJqTWnyI0RQYBxOZpUST84GpPK8k3tDUyMzMwNLUwtTMyEJJnHcz980YIYH0xJLU
        7NTUgtQimD4mDk6pBsaF7AufCNdz2fsoNGzfGHfTJ/vbS2+V2kvnPms2Ld0hc6Voj0HviXsd
        dWeY505bGHv+5w4L3lRr/rAgu+vGr0/Gss6p/p3e4verx3adEdcP+2f7b64v0e9inaXPffsG
        J/fNqQWLlU9+yfrg/Mzny2RV2+iNwkzBFvcU15UX7jMrfZW5r8PrxgslluKMREMt5qLiRAAw
        /Vz2rQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnC6H+NQ4g8c32C2mPnzCZjFjWzeL
        xeqrW5gsFmx8xGix4ftaRosjjVOYHNg8Nq3qZPPo27KK0WP9lqssHp83yQWwRHHZpKTmZJal
        FunbJXBlPPj/nrHgLFvFsd3XWBsYz7B2MXJySAiYSKx8cY2ti5GLQ0hgN6NE/+nv7BAJCYkP
        889A2cIS91uOsEIUPWeUWHJ5EgtIgk1AV+LLvTvMILaIgIzE9Na9TCA2s0AXo8T6U2pdjBwc
        wgKuEgv+84OEWQRUJbqXvgQr4RWwlHh07AQ7hC0ocXLmExaQcmYBPYm2jYwQU+Qltr+dwwxx
        goLEz6fLWCE26Unc+tTLDFEjIjG7s415AqPgLCSTZiFMmoVk0iwkHQsYWVYxSqYWFOem5xYb
        FhjmpZbrFSfmFpfmpesl5+duYgRHgZbmDsbLS+IPMQpwMCrx8E7wnxInxJpYVlyZe4hRgoNZ
        SYT3SfnEOCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8T/OORQoJpCeWpGanphakFsFkmTg4pRoY
        a/sdGu73H9LoV2nN2OZd2Z4pmrTffpFDjHNxQsbbgLTdO3YVGhexewS1auR8UQuVzWRS4TfK
        5W4/bNJ1SKNxzsXyqby5W5Y+XnXovGdy+itPab+gkyX33Wbbz5//3O3hOa5H/ypex2xMjFa3
        OJapkvZiok+31TuJqo8n/tswmeeoH2lbs1eJpTgj0VCLuag4EQDTG9cSfgIAAA==
X-CMS-MailID: 20200414015104epcas2p3340ef8a5e262d2d774ec1b5b49f559d0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200414015104epcas2p3340ef8a5e262d2d774ec1b5b49f559d0
References: <CGME20200414015104epcas2p3340ef8a5e262d2d774ec1b5b49f559d0@epcas2p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current topology doesn't add prefix of component to new kcontrol.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Link: https://lore.kernel.org/r/009b01d60804$ae25c2d0$0a714870$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index b19ecaf0febf..17556a47f727 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -362,7 +362,7 @@ static int soc_tplg_add_kcontrol(struct soc_tplg *tplg,
 	struct snd_soc_component *comp = tplg->comp;
 
 	return soc_tplg_add_dcontrol(comp->card->snd_card,
-				comp->dev, k, NULL, comp, kcontrol);
+				comp->dev, k, comp->name_prefix, comp, kcontrol);
 }
 
 /* remove a mixer kcontrol */
-- 
2.21.0



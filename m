Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A961A70A6
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgDNBtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:49:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49690 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDNBtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:49:45 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200414014939epoutp03b79d2e62876180811e09df958cc162dd~FjIzIFOwV0252702527epoutp03Z
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 01:49:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200414014939epoutp03b79d2e62876180811e09df958cc162dd~FjIzIFOwV0252702527epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586828980;
        bh=q+0JxxlqeXL1LJhYQIOYZ4/6oRjGLlg0Kil276s8dEU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=U1/cTtho3Tte9PGMEtPvZbRR2EYviH6oUqLUmNl2W4SIXbS7REG4eh6WLN6WlG6f/
         IVJRWOvijxR3zLmloMiXcc1Bg3jwnzKPzhK/QUYOq6ZM/QsyohbGAYcIoYPJZVS5oH
         aCeAJFBK/UVH4tOtRedGcl3KD2Bq1CPXa3SCz0Jo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200414014939epcas2p2c47538cba1e38cf8d481047821e0ee47~FjIyyjMDD2781127811epcas2p2K;
        Tue, 14 Apr 2020 01:49:39 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 491T1t1Y8zzMqYls; Tue, 14 Apr
        2020 01:49:38 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        25.E2.04704.0B6159E5; Tue, 14 Apr 2020 10:49:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200414014935epcas2p1a66f4fb5966e7cb5f416c2c29ac2d41f~FjIvMTGac1486014860epcas2p1W;
        Tue, 14 Apr 2020 01:49:35 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200414014935epsmtrp1ccb27d77008f72b24d729d228891a7ed~FjIvKyOna1329113291epsmtrp1B;
        Tue, 14 Apr 2020 01:49:35 +0000 (GMT)
X-AuditID: b6c32a46-811ff70000001260-7e-5e9516b03c85
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.19.04158.FA6159E5; Tue, 14 Apr 2020 10:49:35 +0900 (KST)
Received: from KORDO025540 (unknown [12.36.182.130]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200414014935epsmtip1def94eed6f8715b79e603275218c701c~FjIvEBWJZ2729027290epsmtip1I;
        Tue, 14 Apr 2020 01:49:35 +0000 (GMT)
From:   "Gyeongtaek Lee" <gt82.lee@samsung.com>
To:     <stable@vger.kernel.org>
Cc:     <broonie@kernel.org>, <tiwai@suse.com>, <tkjung@samsung.com>,
        <hmseo@samsung.com>, <tkjung@samsung.com>, <kimty@samsung.com>
Subject: [PATCH 1/4] ASoC: fix regwmask
Date:   Tue, 14 Apr 2020 10:49:35 +0900
Message-ID: <000501d611fe$f35f6910$da1e3b30$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdYR/utaRna4bAGEQGKqiONXE7DI1A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmqe4GsalxBr3LWS2mPnzCZjFjWzeL
        xeqrW5gsFmx8xGix4ftaRosjjVOYHNg8Nq3qZPPo27KK0WP9lqssHp83yQWwROXYZKQmpqQW
        KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
        K+nb2RTll5akKmTkF5fYKqUWpOQUGBoW6BUn5haX5qXrJefnWhkaGBiZAlUm5GTMnnudueAh
        d8XNnRPYGhjfcnYxcnJICJhI9C74wt7FyMUhJLCDUWLynlOsEM4nRolLb56yQTjfGCV+3j3A
        AtOyZuIBqJa9QIk7k9hBEkICLxklJq1UAbHZBHQlvty7wwxiiwjISExv3csEYjMLNDFKNHf4
        gNjCAuoSE9deYgSxWQRUJS7saWADsXkFLCXmdpxmhbAFJU7OfMIC0Ssvsf3tHGaIIxQkfj5d
        xgoxX0/izZKPrBA1IhKzO9ugao6wSbxYAvWni0TfilVMELawxKvjW9ghbCmJl/1tYM9ICDQz
        Srw7+wcqMYVRorNbCMI2ltgy9xRQMwfQAk2J9bv0QUwJAWWJI7egTuOT6Dj8lx0izCvR0QbV
        qCSx8dQ/JoiwhMS8DVCzPSRmNJ5knsCoOAvJj7OQ/DgLyS+zENYuYGRZxSiWWlCcm55abFRg
        hBzVmxjByVLLbQfjknM+hxgFOBiVeHgn+E+JE2JNLCuuzD3EKMHBrCTC+6R8YpwQb0piZVVq
        UX58UWlOavEhRlNgFExklhJNzgcm8rySeENTIzMzA0tTC1MzIwslcd5N3DdjhATSE0tSs1NT
        C1KLYPqYODilGhgrj9UZ2lze9WWOzdrAt+lWm2ycriif/X/lTZC3x7J3avt8+PK3LFHR28Ks
        tEv88vNdu2rXrXxTc6Vx1nfut+zWPXnu79b93TTTinNNwvO5p8QiLv53sa/cMKEu7DG7o/6j
        HNfXB/gO55/X+r4/8MGBzDiZqxzxBjkv7p5R7n9dc963f+Pd5+6+SizFGYmGWsxFxYkAmSL2
        qawDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnO56salxBvO+aFtMffiEzWLGtm4W
        i9VXtzBZLNj4iNFiw/e1jBZHGqcwObB5bFrVyebRt2UVo8f6LVdZPD5vkgtgieKySUnNySxL
        LdK3S+DKmD33OnPBQ+6KmzsnsDUwvuXsYuTkkBAwkVgz8QA7iC0ksJtR4u6zIIi4hMSH+WfY
        IWxhifstR1i7GLmAap4zSrS+XMsMkmAT0JX4cu8OmC0iICMxvXUvE4jNLNDFKLH+lBqILSyg
        LjFx7SVGEJtFQFXiwp4GNhCbV8BSYm7HaVYIW1Di5MwnLF2MHEC9ehJtGxkhxshLbH87hxni
        BgWJn0+XsUKs0pN4s+QjK0SNiMTszjbmCYyCs5BMmoUwaRaSSbOQdCxgZFnFKJlaUJybnlts
        WGCUl1quV5yYW1yal66XnJ+7iREcBVpaOxhPnIg/xCjAwajEwzvBf0qcEGtiWXFl7iFGCQ5m
        JRHeJ+UT44R4UxIrq1KL8uOLSnNSiw8xSnOwKInzyucfixQSSE8sSc1OTS1ILYLJMnFwSjUw
        Cl0vz7G2bbha4+m9g3FylbirWmaSd5eekvuCC/l8dR7XWJa13zz+6/vL++IL/p77wLH6ke3X
        yB3Kn67MStJM7jcpU/Mt6326w2WTwdflJhxXgjPyH+W8bnLq7Jmf/aFv7y9uvVk918Lr12wR
        Epz55VzZmzS/7tk3d7xSEyv0m/F8Z/iHixKSSizFGYmGWsxFxYkAn8dVoX4CAAA=
X-CMS-MailID: 20200414014935epcas2p1a66f4fb5966e7cb5f416c2c29ac2d41f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200414014935epcas2p1a66f4fb5966e7cb5f416c2c29ac2d41f
References: <CGME20200414014935epcas2p1a66f4fb5966e7cb5f416c2c29ac2d41f@epcas2p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If regwshift is 32 and the selected architecture compiles '<<' operator
for signed int literal into rotating shift, '1<<regwshift' became 1 and
it makes regwmask to 0x0.
The literal is set to unsigned long to get intended regwmask.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Link: https://lore.kernel.org/r/001001d60665$db7af3e0$9270dba0$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index f4dc3d445aae..95fc24580f85 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -832,7 +832,7 @@ int snd_soc_get_xr_sx(struct snd_kcontrol *kcontrol,
 	unsigned int regbase = mc->regbase;
 	unsigned int regcount = mc->regcount;
 	unsigned int regwshift = component->val_bytes * BITS_PER_BYTE;
-	unsigned int regwmask = (1<<regwshift)-1;
+	unsigned int regwmask = (1UL<<regwshift)-1;
 	unsigned int invert = mc->invert;
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long min = mc->min;
@@ -881,7 +881,7 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	unsigned int regbase = mc->regbase;
 	unsigned int regcount = mc->regcount;
 	unsigned int regwshift = component->val_bytes * BITS_PER_BYTE;
-	unsigned int regwmask = (1<<regwshift)-1;
+	unsigned int regwmask = (1UL<<regwshift)-1;
 	unsigned int invert = mc->invert;
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long max = mc->max;
-- 
2.21.0



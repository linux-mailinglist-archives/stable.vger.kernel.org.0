Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8252122E407
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 04:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG0Cdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 22:33:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33194 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgG0Cdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 22:33:54 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200727023350epoutp03a8646f0f80ca0205174465cc119d4a3d~le1EEhYkc0873508735epoutp03L
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 02:33:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200727023350epoutp03a8646f0f80ca0205174465cc119d4a3d~le1EEhYkc0873508735epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595817230;
        bh=nyorqQFc3R2/eKKFva9vj1FIOhdGfDZzIo30VBX79mQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=OOinQJ+kAOxUy5LeELg8p1HqXPdx+/rfb+vPDsjAjzoSMKPZO3mQUw/jRj+lO2z5+
         5Yi8bhoItu70OL+on3OJsqqaCM5lePbXk0wl9c+T6QKt1lelgXkCPp1PIZ/IH03Ogs
         TABb23EkGCgcj4iJKzJ8GDb52CA6X4aHSOMfGyC4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200727023350epcas1p27d58be94218ef8bc849209971d22faa9~le1DuGReY2987029870epcas1p2S;
        Mon, 27 Jul 2020 02:33:50 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.158]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BFP4r24PszMqYkY; Mon, 27 Jul
        2020 02:33:48 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.13.28578.60D3E1F5; Mon, 27 Jul 2020 11:33:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200727023342epcas1p3ec7e442440ead0762a67d244f20cf2fb~le08BIz681376213762epcas1p3M;
        Mon, 27 Jul 2020 02:33:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200727023342epsmtrp174ada468c5624a2dd72067f77aca882c~le08Afr9V3044430444epsmtrp1V;
        Mon, 27 Jul 2020 02:33:42 +0000 (GMT)
X-AuditID: b6c32a39-8c9ff70000006fa2-05-5f1e3d06b6cd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.2B.08303.60D3E1F5; Mon, 27 Jul 2020 11:33:42 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200727023341epsmtip119e8b6fc7db150ce587062ccdaaa31cc~le07ypIK72422024220epsmtip1X;
        Mon, 27 Jul 2020 02:33:41 +0000 (GMT)
From:   Chanwoo Choi <cw00.choi@samsung.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     cw00.choi@samsung.com, chanwoo@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH] PM / devfreq: Fix the wrong end with semicolon
Date:   Mon, 27 Jul 2020 11:45:24 +0900
Message-Id: <20200727024524.24203-1-cw00.choi@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmgS6brVy8wa3XchYTb1xhsbj+5Tmr
        xdmmN+wWl3fNYbP43HuE0eJ24wo2iwUbHzE6sHtsWtXJ5tG3ZRWjx+dNcgHMUdk2GamJKalF
        Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
        Svp2NkX5pSWpChn5xSW2SqkFKTkFlgV6xYm5xaV56XrJ+blWhgYGRqZAhQnZGbd+nmYv2MpR
        sfNxVgNjG3sXIyeHhICJxJZpW5m7GLk4hAR2MEp82XqJBcL5xCjxbf5RdgjnM6NEz8d7LDAt
        e94+YoRI7GKUWLTiHlT/F0aJI0f3MIJUsQloSex/cYMNxBYRsJI4/b+DGcRmFqiRmNC4iBXE
        Fhawl1i3fBfYVBYBVYlL894ygdi8QPU9LzuZIbbJS6zecABsgYTAMnaJ32/uskIkXCRaV2xi
        hLCFJV4d3wL1kZTEy36Y76olVp48wgbR3MEosWX/BahmY4n9SycDbeMAukhTYv0ufYiwosTO
        33MZIQ7lk3j3tYcVpERCgFeio00IokRZ4vKDu0wQtqTE4vZONogSD4kpd1xATCGBWInDb/wm
        MMrOQhi/gJFxFaNYakFxbnpqsWGBKXIcbWIEJyctyx2M099+0DvEyMTBeIhRgoNZSYSXW1Qm
        Xog3JbGyKrUoP76oNCe1+BCjKTC4JjJLiSbnA9NjXkm8oamRsbGxhYmhmamhoZI477+z7PFC
        AumJJanZqakFqUUwfUwcnFINTDNjT6/75fVSTNMn4naGoN4na42Cy9MCtup77Hj140Ry663P
        hsvXRnb2lXD3/Nbff+e+kpFSzgmt/ld9l1tXvbl4KX/3teJsPZXwsBoOcWMHTuY2m59X3LYe
        /rzFu8Df+ebF+AatG7LXQmf4GVUVfOy+eiKv4/G2jK+czZEz95zsVDYy2NssG2DQe+my4NHM
        xPyC7i9K3JOlO5N883+Jb+6em3Ugc3OlP+MRMTsHGaX+2xOvb13fniR1TtCV87zYttsp65b0
        SG34FxboVl5sHNnjJZ06f+bHB3P6r6/vqN/etV6UbaXGoyTJBdd2T1FcO7XJ4oVxXkyaXxmL
        Ro9qlIm5qeuB9bW1d50fJTxRYinOSDTUYi4qTgQAk9HuL9cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsWy7bCSnC6brVy8wfpHHBYTb1xhsbj+5Tmr
        xdmmN+wWl3fNYbP43HuE0eJ24wo2iwUbHzE6sHtsWtXJ5tG3ZRWjx+dNcgHMUVw2Kak5mWWp
        Rfp2CVwZt36eZi/YylGx83FWA2MbexcjJ4eEgInEnrePGLsYuTiEBHYwSqz+PJ8FIiEpMe3i
        UeYuRg4gW1ji8OFiiJpPjBJNrZvAmtkEtCT2v7jBBmKLCNhI3F18jQWkiFmgiVFi4ryDjCAJ
        YQF7iXXLd4ENZRFQlbg07y0TiM0rYCXR87KTGWKZvMTqDQeYJzDyLGBkWMUomVpQnJueW2xY
        YJSXWq5XnJhbXJqXrpecn7uJERwwWlo7GPes+qB3iJGJg/EQowQHs5IIL7eoTLwQb0piZVVq
        UX58UWlOavEhRmkOFiVx3q+zFsYJCaQnlqRmp6YWpBbBZJk4OKUamKKadRpMV3d55Anr8F1+
        vytLuNpRYhfzPmO93dd+xZ/2069/VrEkPFqWeTkrd+O1dfPqTt7fmjfbfKLyviWSDsIdx2p1
        5Zb9dpUXWxOYrjI37qrvKYaMI8nrPmxa8mCKhMrP79vMFnAl7zBafuXhW+5gTeH8FS8y/oVu
        aTMKOv7qxr/2ZdkfPC4Ia/TnBjStSFH3jvfWfr55QnXjaQ2Gq33XteY+WtS3mWW+44rG7Tn2
        TAVPQg8tc3Qw+vj+k9iX2VxnrM8sly9QvFMkm2oRsbE0YuXbvNadU18Yzq2Se1lhUnl72r79
        NRMzXm7+eHPKFjld57pjt0tKTe1vBrDdODt/0kT72oK9+U8c/y8s3KnEUpyRaKjFXFScCABG
        ZjGvhwIAAA==
X-CMS-MailID: 20200727023342epcas1p3ec7e442440ead0762a67d244f20cf2fb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200727023342epcas1p3ec7e442440ead0762a67d244f20cf2fb
References: <CGME20200727023342epcas1p3ec7e442440ead0762a67d244f20cf2fb@epcas1p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the wrong grammar at the end of code line by using semicolon.

Cc: stable@vger.kernel.org
Fixes: 490a421bc575 ("PM / devfreq: Add debugfs support with devfreq_summary file")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
It was my mistake using comma instead of semicolon. But, I don't know
why the build error was not caught. Anyway, I fix the wrong basic grammar.

 drivers/devfreq/devfreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 9d324ff87ee6..561d91b2d3bf 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1800,9 +1800,9 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 #endif
 
 		mutex_lock(&devfreq->lock);
-		cur_freq = devfreq->previous_freq,
+		cur_freq = devfreq->previous_freq;
 		get_freq_range(devfreq, &min_freq, &max_freq);
-		polling_ms = devfreq->profile->polling_ms,
+		polling_ms = devfreq->profile->polling_ms;
 		mutex_unlock(&devfreq->lock);
 
 		seq_printf(s,
-- 
2.17.1


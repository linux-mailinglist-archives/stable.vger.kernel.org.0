Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAAD1A70AA
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgDNBuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:50:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36096 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDNBuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:50:13 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200414015009epoutp045551b91049c003705da8fdc4661e0cb4~FjJOzcWY-2282722827epoutp04d
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 01:50:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200414015009epoutp045551b91049c003705da8fdc4661e0cb4~FjJOzcWY-2282722827epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586829009;
        bh=CAFLOcPGGtoQ4KJIjkWaDA0/oum8SrBeR7ABecM4Nm8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=lfoYz3ledcjpZpPbkQmC+D2VCaclI3Vtv37oI1WLxJUrXVFp43/0MKfv2oQW2T2pu
         IhxBAvhWU/xJZ0oeFCyxBkUk5GB4Aj2jFxBiHZ2c3BT7L+WqVdnaGQRvs7Qq/SG9wD
         2M4JQdERXWmjEvJUNOp709kvFW4lo/1J7rEfHwgo=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200414015008epcas2p1560002f6befc58e92fa3a9679c865d09~FjJOA1rV02236122361epcas2p1O;
        Tue, 14 Apr 2020 01:50:08 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 491T2R3jxbzMqYkg; Tue, 14 Apr
        2020 01:50:07 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.31.04598.EC6159E5; Tue, 14 Apr 2020 10:50:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200414015005epcas2p36cd86ae99991dae7022ebd6c052c9786~FjJLNuAcR0889808898epcas2p3D;
        Tue, 14 Apr 2020 01:50:05 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200414015005epsmtrp15ed07c17e55d63b5b84512037a8a95f9~FjJLKn5_G1416714167epsmtrp1W;
        Tue, 14 Apr 2020 01:50:05 +0000 (GMT)
X-AuditID: b6c32a45-eb9ff700000011f6-8e-5e9516ce7423
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.29.04158.DC6159E5; Tue, 14 Apr 2020 10:50:05 +0900 (KST)
Received: from KORDO025540 (unknown [12.36.182.130]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200414015005epsmtip2ecb15bc4261c34f33f0ca0d056022531~FjJLD1C3D2472424724epsmtip2K;
        Tue, 14 Apr 2020 01:50:05 +0000 (GMT)
From:   "Gyeongtaek Lee" <gt82.lee@samsung.com>
To:     <stable@vger.kernel.org>
Cc:     <broonie@kernel.org>, <tiwai@suse.com>, <tkjung@samsung.com>,
        <hmseo@samsung.com>, <tkjung@samsung.com>, <kimty@samsung.com>
Subject: [PATCH 2/4] ASoC: dapm: connect virtual mux with default value
Date:   Tue, 14 Apr 2020 10:50:05 +0900
Message-ID: <000601d611ff$054b1e30$0fe15a90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdYR/wDNYuNLkYZPRducSBxGGQBogg==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmqe45salxBpPfalhMffiEzWLGtm4W
        i9VXtzBZLNj4iNFiw/e1jBZHGqcwObB5bFrVyebRt2UVo8f6LVdZPD5vkgtgicqxyUhNTEkt
        UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
        VtK3synKLy1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMl49egGS8Ee
        roprJ2axNzDu4Ohi5OSQEDCRWN+9mbmLkYtDSGAHo8T+5fcZIZxPjBJv5/1jgnC+MUqsenaP
        GaZlz7EPTCC2kMBeRontc3kgil4ySuz60ApWxCagK/Hl3h0wW0RARmJ6616wBmaBJkaJ5g4f
        EFtYwF3iwu517CA2i4CqxKqWvywgNq+ApcTd/xNYIWxBiZMzn7BA9MpLbH87B+oIBYmfT5ex
        QszXk7jyt5EVokZEYnZnG9g/EgIH2CS6161nh2hwkXjVtoYFwhaWeHV8C1RcSuJlfxs7REMz
        o8S7s3+gElMYJTq7hSBsY4ktc08BfcABtEFTYv0ufRBTQkBZ4sgtqNv4JDoO/2WHCPNKdLRB
        NSpJbDz1jwkiLCExbwPUbA+JZad/M01gVJyF5MlZSJ6cheSZWQhrFzCyrGIUSy0ozk1PLTYq
        MESO602M4HSp5bqDccY5n0OMAhyMSjy8LwKnxAmxJpYVV+YeYpTgYFYS4X1SPjFOiDclsbIq
        tSg/vqg0J7X4EKMpMA4mMkuJJucDU3leSbyhqZGZmYGlqYWpmZGFkjjvZu6bMUIC6Yklqdmp
        qQWpRTB9TBycUg2Mt1myH2fpvZ5+ZFqQ2dU6pocOUtk/tWRbeYPX3RHqnDHdvnb3wgqJ9lvT
        X4jP0d7/KtiVe6Jw8xqxw5tOuFfuc+7gKFmeuLEzzjTBzUY3XVZdvVHQ7MpFkYgHp6Zvc/Co
        cFmqezxzTgRjnxfn8xme/FbZwZHfvv/1uBh05/OkF/LvCt76tW9UYinOSDTUYi4qTgQAxDNk
        f60DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSvO5ZsalxBmemGFhMffiEzWLGtm4W
        i9VXtzBZLNj4iNFiw/e1jBZHGqcwObB5bFrVyebRt2UVo8f6LVdZPD5vkgtgieKySUnNySxL
        LdK3S+DKePXoBkvBHq6KaydmsTcw7uDoYuTkkBAwkdhz7ANTFyMXh5DAbkaJOb/uMUMkJCQ+
        zD/DDmELS9xvOcIKUfScUWL+vodgRWwCuhJf7t0Bs0UEZCSmt+5lArGZBboYJdafUgOxhQXc
        JS7sXgc2iEVAVWJVy18WEJtXwFLi7v8JrBC2oMTJmU+A4hxAvXoSbRsZIcbIS2x/OwfqHgWJ
        n0+XsUKs0pO48reRFaJGRGJ2ZxvzBEbBWUgmzUKYNAvJpFlIOhYwsqxilEwtKM5Nzy02LDDK
        Sy3XK07MLS7NS9dLzs/dxAiOAy2tHYwnTsQfYhTgYFTi4Z3gPyVOiDWxrLgy9xCjBAezkgjv
        k/KJcUK8KYmVValF+fFFpTmpxYcYpTlYlMR55fOPRQoJpCeWpGanphakFsFkmTg4pRoY561k
        cvssyD//cN/TXx08wZdXLpzsa8rKWJjycfaf7/NmnmCInfVn1a69IuKcpltEFwtPMs1rCvBw
        1gnexmHu9E7UzX6DIuf8W54mL86bbxB94+CkH1m3nfPBG4WfVuLztOZJ/bmfy8b35MXMl7d0
        qio+Nx5nCN3fzTW7umKWSe3pic/ymcruKbEUZyQaajEXFScCAP0goPx/AgAA
X-CMS-MailID: 20200414015005epcas2p36cd86ae99991dae7022ebd6c052c9786
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200414015005epcas2p36cd86ae99991dae7022ebd6c052c9786
References: <CGME20200414015005epcas2p36cd86ae99991dae7022ebd6c052c9786@epcas2p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since a virtual mixer has no backing registers
to decide which path to connect,
it will try to match with initial state.
This is to ensure that the default mixer choice will be
correctly powered up during initialization.
Invert flag is used to select initial state of the virtual switch.
Since actual hardware can't be disconnected by virtual switch,
connected is better choice as initial state in many cases.

Signed-off-by: Gyeongtaek Lee <gt82.lee@samsung.com>
Link: https://lore.kernel.org/r/01a301d60731$b724ea10$256ebe30$@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-dapm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index ebd785f9aa46..e0ff40b10d85 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -802,7 +802,13 @@ static void dapm_set_mixer_path_status(struct snd_soc_dapm_path *p, int i,
 			val = max - val;
 		p->connect = !!val;
 	} else {
-		p->connect = 0;
+		/* since a virtual mixer has no backing registers to
+		 * decide which path to connect, it will try to match
+		 * with initial state.  This is to ensure
+		 * that the default mixer choice will be
+		 * correctly powered up during initialization.
+		 */
+		p->connect = invert;
 	}
 }
 
-- 
2.21.0



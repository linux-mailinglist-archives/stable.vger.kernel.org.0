Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11621D056
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 09:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgGMHTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 03:19:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23771 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgGMHTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 03:19:51 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200713071946epoutp02dcc1765e31f2475683f8f5ff599cb552~hPsuIVRby3030630306epoutp02W
        for <stable@vger.kernel.org>; Mon, 13 Jul 2020 07:19:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200713071946epoutp02dcc1765e31f2475683f8f5ff599cb552~hPsuIVRby3030630306epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594624786;
        bh=T2NFV6aDiWcdlpfPV04JlC6pzkdoFqVotNneudFkf5E=;
        h=From:To:Cc:Subject:Date:References:From;
        b=JvH/KqBGdDENB0dCeIb12NvkI9manvTB+0f0zGVCbM/yFMQH3i+lJvRHgLSn1QFjn
         BIGKc577z8h9AYx9M+4hX+txxhIY0tSkWib1SJ0Wc/x8NUKqU0Voo4Cw88y31BiTnn
         Nfz8V8h3ydOsosKUZ5I/WU3GgrdVT6tq9FfSByYs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200713071946epcas1p1fa28a4f4ed866798785fc37805b1aa21~hPstgrUb90770907709epcas1p1b;
        Mon, 13 Jul 2020 07:19:46 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.153]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B4w5C2w7czMqYkq; Mon, 13 Jul
        2020 07:19:43 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.E8.18978.F0B0C0F5; Mon, 13 Jul 2020 16:19:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200713071942epcas1p14a9a1d2017e2e5005f7146f5bed09c82~hPsqOyail0774007740epcas1p1R;
        Mon, 13 Jul 2020 07:19:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200713071942epsmtrp2fac249b59d75accf1d54cddeb267490c~hPsqOKOM32359023590epsmtrp2O;
        Mon, 13 Jul 2020 07:19:42 +0000 (GMT)
X-AuditID: b6c32a35-5edff70000004a22-d7-5f0c0b0fd948
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.ED.08303.E0B0C0F5; Mon, 13 Jul 2020 16:19:42 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200713071942epsmtip1cf2dd598ec869b849267405ada4f543a~hPsp9sadM2443624436epsmtip1I;
        Mon, 13 Jul 2020 07:19:42 +0000 (GMT)
From:   Chanwoo Choi <cw00.choi@samsung.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     cw00.choi@samsung.com, chanwoo@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH] PM / devfrq: Fix indentaion of devfreq_summary debugfs node
Date:   Mon, 13 Jul 2020 16:31:12 +0900
Message-Id: <20200713073112.6297-1-cw00.choi@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmvi4/N0+8wdu/QhYTb1xhsbj+5Tmr
        xdmmN+wWl3fNYbP43HuE0eJ24wo2iwUbHzE6sHtsWtXJ5tG3ZRWjx+dNcgHMUdk2GamJKalF
        Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
        Svp2NkX5pSWpChn5xSW2SqkFKTkFlgV6xYm5xaV56XrJ+blWhgYGRqZAhQnZGQfbNzIX3Fau
        +N3WzdLAeE+si5GTQ0LAROJ19xXGLkYuDiGBHYwS7Z9vQTmfGCV6frQwQTifGSUWz/zACtNy
        ZP5xdojELkaJT3/nMUM4XxglFrxbyQhSxSagJbH/xQ02EFtEwEri9P8OZhCbWaBGYkLjIrBJ
        wgI+EiteTQCrZxFQlXhx9TALiM0rYCmx6f1cFoht8hKrNxwAWyAhsIhd4tb0dUwQCReJY5vf
        QBUJS7w6voUdwpaS+PxuLxuEXS2x8uQRNojmDkaJLfsvQP1gLLF/6WSgQRxAF2lKrN+lDxFW
        lNj5ey4jxKF8Eu++9rCClEgI8Ep0tAlBlChLXH5wF+oESYnF7Z1sECUeEn8XyYGEhQRiJWZv
        3cA0gVF2FsL8BYyMqxjFUguKc9NTiw0LDJFjaRMjOEFpme5gnPj2g94hRiYOxkOMEhzMSiK8
        0aKc8UK8KYmVValF+fFFpTmpxYcYTYHhNZFZSjQ5H5gi80riDU2NjI2NLUwMzUwNDZXEef+d
        ZY8XEkhPLEnNTk0tSC2C6WPi4JRqYOrY9WERY1dZ8Oldrk4Kx6Q+5ynN+WP6pHT5hJpZKu16
        C1dyW+/TNFGafex+xN78JMPEhen2F1Rljc7/1w/x0ph94dnF78/OfGPWdJHmV2Bone00ZSPb
        YYcXnev+TAyccmjr3l9esy9tSVxqcS3lyFqFOn2nk6KySxPXapRMNAhv+3t9wTm9SEW9Y++v
        Mif2/XpqLlH5wGSZhEHPCY6naXyS5/7cq+/LUn52W0+LN/HL4aZWkxtbO0zOaqYq7LpbMe/f
        dzUBHptnGar+FbxZL62eR69a4JHuFffpy/FEo6y0j2vzPiQeNU6cdiSnhcPQMzj8cUTfsZfK
        3Q1FvkHzz4n7P7x41XjtJAuFmt2nLiqxFGckGmoxFxUnAgBArucw2QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsWy7bCSnC4fN0+8wZZPKhYTb1xhsbj+5Tmr
        xdmmN+wWl3fNYbP43HuE0eJ24wo2iwUbHzE6sHtsWtXJ5tG3ZRWjx+dNcgHMUVw2Kak5mWWp
        Rfp2CVwZB9s3MhfcVq743dbN0sB4T6yLkZNDQsBE4sj84+xdjFwcQgI7GCX6n3axQyQkJaZd
        PMrcxcgBZAtLHD5cDFHziVHi+PKPYDVsAloS+1/cYAOxRQRsJO4uvsYCUsQs0MQoMXHeQUaQ
        hLCAj8SKVxPAbBYBVYkXVw+zgNi8ApYSm97PZYFYJi+xesMB5gmMPAsYGVYxSqYWFOem5xYb
        FhjlpZbrFSfmFpfmpesl5+duYgSHjJbWDsY9qz7oHWJk4mA8xCjBwawkwhstyhkvxJuSWFmV
        WpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalFMFkmDk6pBiYrX9/pB6bJbp4h9irb
        bdYro56DLAesDdlV30av6ZVw8T7DXVvTm5mToyqwr7FdWX7F/huVdoHx37d4zOGxaL7LutIp
        0fjUg/uX7ZIj3qUZbm+VjpaMCM09s/W2VE3elh3hJ4I+iouf2fb6zbbnYo07eCv+9Px/Ovv9
        /qxdHAv8z4kozLkvq2Td+2Z1nfQrHc2GB6H+5tvVjmqosbEuuliywHFD6dZdzHdEn+0/ciBT
        oanhMd/2uw6SYRVrNAvsl6xKZk43iJFSCdkX92g/a3VRZ2sl97f/H30Vsu/FObNVlFhV/FRe
        9XnKp7/s5y5f5DdIFrt/2frFNDPbwJIlhvf8Nm8427Ml+EWxW307oxJLcUaioRZzUXEiAGd+
        yhWIAgAA
X-CMS-MailID: 20200713071942epcas1p14a9a1d2017e2e5005f7146f5bed09c82
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200713071942epcas1p14a9a1d2017e2e5005f7146f5bed09c82
References: <CGME20200713071942epcas1p14a9a1d2017e2e5005f7146f5bed09c82@epcas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name
as devfreq(X) for sysfs"") roll back the device name from 'devfreqX'
to device name explained in DT. After applied commit 66d0e797bf09,
the indentation of devfreq_summary debugfs node was broken.

So, fix indentaion of devfreq_summary debugfs node as following:

For example on Exynos5422-based Odroid-XU3 board,
$ cat /sys/kernel/debug/devfreq/devfreq_summary
dev                            parent_dev                     governor        polling_ms  cur_freq_Hz  min_freq_Hz  max_freq_Hz
------------------------------ ------------------------------ --------------- ---------- ------------ ------------ ------------
10c20000.memory-controller     null                           simple_ondemand          0    413000000    165000000    825000000
soc:bus_wcore                  null                           simple_ondemand         50     88700000     88700000    532000000
soc:bus_noc                    soc:bus_wcore                  passive                  0     66600000     66600000    111000000
soc:bus_fsys_apb               soc:bus_wcore                  passive                  0    111000000    111000000    222000000
soc:bus_fsys                   soc:bus_wcore                  passive                  0     75000000     75000000    200000000
soc:bus_fsys2                  soc:bus_wcore                  passive                  0     75000000     75000000    200000000
soc:bus_mfc                    soc:bus_wcore                  passive                  0     83250000     83250000    333000000
soc:bus_gen                    soc:bus_wcore                  passive                  0     88700000     88700000    266000000
soc:bus_peri                   soc:bus_wcore                  passive                  0     66600000     66600000     66600000
soc:bus_g2d                    soc:bus_wcore                  passive                  0     83250000     83250000    333000000
soc:bus_g2d_acp                soc:bus_wcore                  passive                  0            0     66500000    266000000
soc:bus_jpeg                   soc:bus_wcore                  passive                  0            0     75000000    300000000
soc:bus_jpeg_apb               soc:bus_wcore                  passive                  0            0     83250000    166500000
soc:bus_disp1_fimd             soc:bus_wcore                  passive                  0            0    120000000    200000000
soc:bus_disp1                  soc:bus_wcore                  passive                  0            0    120000000    300000000
soc:bus_gscl_scaler            soc:bus_wcore                  passive                  0            0    150000000    300000000
soc:bus_mscl                   soc:bus_wcore                  passive                  0            0     84000000    666000000

Cc: stable@vger.kernel.org
Fixes: commit 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index ce82bdb5fa5c..2ff35ec1b53b 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1839,8 +1839,7 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 	unsigned long cur_freq, min_freq, max_freq;
 	unsigned int polling_ms;
 
-	seq_printf(s, "%-30s %-10s %-10s %-15s %10s %12s %12s %12s\n",
-			"dev_name",
+	seq_printf(s, "%-30s %-30s %-15s %10s %12s %12s %12s\n",
 			"dev",
 			"parent_dev",
 			"governor",
@@ -1848,10 +1847,9 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 			"cur_freq_Hz",
 			"min_freq_Hz",
 			"max_freq_Hz");
-	seq_printf(s, "%30s %10s %10s %15s %10s %12s %12s %12s\n",
+	seq_printf(s, "%30s %30s %15s %10s %12s %12s %12s\n",
+			"------------------------------",
 			"------------------------------",
-			"----------",
-			"----------",
 			"---------------",
 			"----------",
 			"------------",
@@ -1880,8 +1878,7 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
 		mutex_unlock(&devfreq->lock);
 
 		seq_printf(s,
-			"%-30s %-10s %-10s %-15s %10d %12ld %12ld %12ld\n",
-			dev_name(devfreq->dev.parent),
+			"%-30s %-30s %-15s %10d %12ld %12ld %12ld\n",
 			dev_name(&devfreq->dev),
 			p_devfreq ? dev_name(&p_devfreq->dev) : "null",
 			devfreq->governor_name,
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8767F108603
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 01:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKYAll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 19:41:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41657 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfKYAli (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 19:41:38 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191125004135epoutp014be7f02e53fb6374f06b53675e7fea8a~aQQG4WuWJ0435304353epoutp011
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 00:41:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191125004135epoutp014be7f02e53fb6374f06b53675e7fea8a~aQQG4WuWJ0435304353epoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574642495;
        bh=5Ht5K2A6R+wV0tu8tWTA30lFNcsiTm3/tEOPL8Pvps8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=OVlSdCyLNEjhIuFL2iwUL07cUKO8JBeZVaycz+uXJlEhxpY2w7lv37NxH2bQbAdy+
         LjryCBL1ssXcG986SU2n82/IPTOxUQq9UAEVi05j3S19dUzRZ6RxkcvqUWezfiNcmW
         oFxPac2ZVhWbxfay9X1+qyGY70AJYz51ea2JhMvM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20191125004134epcas1p10926a06d8eb9b192d3a9a293f4df0e9f~aQQGUcugf0950409504epcas1p1F;
        Mon, 25 Nov 2019 00:41:34 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.158]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 47LpBN1mVmzMqYkY; Mon, 25 Nov
        2019 00:41:32 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.AA.48019.C332BDD5; Mon, 25 Nov 2019 09:41:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20191125004131epcas1p403cab8b34662b44a704d6f91aa4c4a0f~aQQDb18Y90678506785epcas1p4a;
        Mon, 25 Nov 2019 00:41:31 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191125004131epsmtrp12c60372583e66436fdf35de64a04b356~aQQDbINHE1367713677epsmtrp1q;
        Mon, 25 Nov 2019 00:41:31 +0000 (GMT)
X-AuditID: b6c32a38-23fff7000001bb93-78-5ddb233c4e0b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C7.63.06569.B332BDD5; Mon, 25 Nov 2019 09:41:31 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191125004131epsmtip259b4c20014eb53e09129ec8a38ec16fb~aQQDRQAzs0970409704epsmtip2W;
        Mon, 25 Nov 2019 00:41:31 +0000 (GMT)
From:   Chanwoo Choi <cw00.choi@samsung.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, chanwoo@kernel.org, stable@vger.kernel.org
Subject: [v2 PATCH] PM / devfreq: Add new name attribute for sysfs
Date:   Mon, 25 Nov 2019 09:47:23 +0900
Message-Id: <20191125004723.17926-1-cw00.choi@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7bCmga6N8u1Yg3kLOC0m3rjCYnH9y3NW
        i+bF69kszja9Ybe4vGsOm8Xn3iOMFrcbV7BZPF7xlt1iwcZHjA6cHov3vGTy2LSqk81j/9w1
        7B59W1YxenzeJBfAGpVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwLJArzgxt7g0L10v
        OT/XytDAwMgUqDAhO+N79yLWgh7Bio7WNewNjDv4uhg5OSQETCSufb3I2sXIxSEksINR4s2T
        vcwQzidGiW3LZzGCVAkJfGOUWN1YD9Mx++NtqI69jBIb5jQyQThfGCWWnN/ADFLFJqAlsf/F
        DTYQW0TASuL0/w6wscwC24DG7roGNlZYwEniz9oWVhCbRUBVYs6x92DNvEANr05sY4VYJy+x
        esMBsGYJgRlsEi8ufmKHSLhILOyeBFUkLPHq+BaouJTEy/42KLtaYuXJI2wQzR2MElv2X4Bq
        MJbYv3Qy0N0cQCdpSqzfpQ8RVpTY+Xsu2HHMAnwS7772sIKUSAjwSnS0CUGUKEtcfnCXCcKW
        lFjc3skGYXtI3NqxkwUSXLESc7ZdY57AKDsLYcECRsZVjGKpBcW56anFhgUmyNG0iRGcyrQs
        djDuOedziFGAg1GJh3fD2luxQqyJZcWVuYcYJTiYlUR43c7eiBXiTUmsrEotyo8vKs1JLT7E
        aAoMvYnMUqLJ+cA0m1cSb2hqZGxsbGFiaGZqaKgkzsvx42KskEB6YklqdmpqQWoRTB8TB6dU
        A6PfCVV+fXbRNTOa9gZI6ExSkjibavIwYYv3txnTpY2503+eeHRs/5HipVGKsk+mbI3f+Gd1
        cvOehy++6gi+9HJ2O/xu2dUNsov+ev7eoODzzcj0OXuEuJlxUMuWXUGtt1mPH5+3SujfgbcG
        x0s2m7s6zorwn6BsIZJ5oSOI0XEyQ9ZCNnf9SUJKLMUZiYZazEXFiQBP5aJOewMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsWy7bCSvK618u1YgyX3VS0m3rjCYnH9y3NW
        i+bF69kszja9Ybe4vGsOm8Xn3iOMFrcbV7BZPF7xlt1iwcZHjA6cHov3vGTy2LSqk81j/9w1
        7B59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CV8b17EWtBj2BFR+sa9gbGHXxdjJwcEgImErM/
        3mbtYuTiEBLYzSgx98MpRoiEpMS0i0eZuxg5gGxhicOHiyFqPjFK7LnzDqyGTUBLYv+LG2wg
        toiAjcTdxddYQGxmgX2MEm1n7UBsYQEniT9rW1hBbBYBVYk5x94zg9i8AlYSr05sY4XYJS+x
        esMB5gmMPAsYGVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgQHlpbWDsYTJ+IPMQpw
        MCrx8HJsuBUrxJpYVlyZe4hRgoNZSYTX7eyNWCHelMTKqtSi/Pii0pzU4kOM0hwsSuK88vnH
        IoUE0hNLUrNTUwtSi2CyTBycUg2MIq//WtrGMWasqjpSEel4Wz7/EEPB1q8h1/P4nrErypxI
        FwpQc5VQ3jcj7Mm+h1rl7mfbd94K3DNZJL6yac2vCbmtXJqb10ufSOeoFPqQcTNuUo11ZJPc
        jQ5fpa+GRzgyuViC2bz+LZjPENXhnWFkeqyCRfn/1btWTjP3LnlwqY0z9v+TU0pKLMUZiYZa
        zEXFiQBtuAyxKAIAAA==
X-CMS-MailID: 20191125004131epcas1p403cab8b34662b44a704d6f91aa4c4a0f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20191125004131epcas1p403cab8b34662b44a704d6f91aa4c4a0f
References: <CGME20191125004131epcas1p403cab8b34662b44a704d6f91aa4c4a0f@epcas1p4.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for
sysfs") changed the node name to devfreq(x). After this commit, it is not
possible to get the device name through /sys/class/devfreq/devfreq(X)/*.

Add new name attribute in order to get device name.

Cc: stable@vger.kernel.org
Fixes: 4585fbcb5331 ("PM / devfreq: Modify the device name as devfreq(X) for sysfs")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes from v1:
- Update sysfs-class-devfreq documentation
- Show device name directly from 'devfreq->dev.parent'

 Documentation/ABI/testing/sysfs-class-devfreq | 7 +++++++
 drivers/devfreq/devfreq.c                     | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index 01196e19afca..75897e2fde43 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -7,6 +7,13 @@ Description:
 		The name of devfreq object denoted as ... is same as the
 		name of device using devfreq.
 
+What:		/sys/class/devfreq/.../name
+Date:		November 2019
+Contact:	Chanwoo Choi <cw00.choi@samsung.com>
+Description:
+		The /sys/class/devfreq/.../name shows the name of device
+		of the corresponding devfreq object.
+
 What:		/sys/class/devfreq/.../governor
 Date:		September 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 61c3e2d08969..2e5f64ee1969 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1476,7 +1476,16 @@ static ssize_t trans_stat_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(trans_stat);
 
+static ssize_t name_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
+}
+static DEVICE_ATTR_RO(name);
+
 static struct attribute *devfreq_attrs[] = {
+	&dev_attr_name.attr,
 	&dev_attr_governor.attr,
 	&dev_attr_available_governors.attr,
 	&dev_attr_cur_freq.attr,
-- 
2.17.1


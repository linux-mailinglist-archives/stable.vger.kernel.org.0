Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969B010862B
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 01:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKYA6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Nov 2019 19:58:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18798 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfKYA6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Nov 2019 19:58:04 -0500
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20191125005800epoutp0294776f39e1578dde32ac856f6217a197~aQecxs_qa2453124531epoutp02i
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 00:58:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20191125005800epoutp0294776f39e1578dde32ac856f6217a197~aQecxs_qa2453124531epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574643480;
        bh=tSa4S79qDEaWYHC+mpXYSPLWN5N1BoYyfUbew9s5uls=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Ig8Vezo53qH873wRNLbknUAzyU1FD3tU5o1irin+Vrizgzf6sxSnjsmDzE/XIMCHE
         tAvYQn58GJTbELkcmbUlrFORpueQKUq4YvsOobnxDZ7J+Xvhd7bRX45amMTl/JAkCF
         VnkWWWmgt4lX4JWrFuLZkjQSgX+O5uNZv7aG/1Fo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191125005800epcas1p20f99f289ef54158e135c9d832ac1c8c9~aQecD7m240106901069epcas1p2T;
        Mon, 25 Nov 2019 00:58:00 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.152]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 47LpYK6HBdzMqYkq; Mon, 25 Nov
        2019 00:57:57 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.0F.48019.3172BDD5; Mon, 25 Nov 2019 09:57:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8~aQeXntyqH0106901069epcas1p2L;
        Mon, 25 Nov 2019 00:57:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191125005755epsmtrp2da26d5dafb2823476d724d346b934432~aQeXms3fZ1846218462epsmtrp2V;
        Mon, 25 Nov 2019 00:57:55 +0000 (GMT)
X-AuditID: b6c32a38-257ff7000001bb93-14-5ddb27139fed
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.C3.10238.3172BDD5; Mon, 25 Nov 2019 09:57:55 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.102]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191125005755epsmtip2853975521ca2c524193e297b46a66fe0~aQeXY9sU41971219712epsmtip2H;
        Mon, 25 Nov 2019 00:57:55 +0000 (GMT)
From:   Chanwoo Choi <cw00.choi@samsung.com>
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, chanwoo@kernel.org, stable@vger.kernel.org
Subject: [PATCH v3] PM / devfreq: Add new name attribute for sysfs
Date:   Mon, 25 Nov 2019 10:03:57 +0900
Message-Id: <20191125010357.27153-1-cw00.choi@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsWy7bCmvq6I+u1Yg8UZFhNvXGGxuP7lOatF
        8+L1bBZnm96wW1zeNYfN4nPvEUaL240r2Cwer3jLbrFg4yNGB06PxXteMnlsWtXJ5rF/7hp2
        j74tqxg9Pm+SC2CNyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
        8QnQdcvMAbpHSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgWaBXnJhbXJqXrpec
        n2tlaGBgZApUmJCd8XLePvaCe8IVi1ZfYGlgPC/QxcjJISFgIvF6xhrWLkYuDiGBHYwSfc8P
        sUE4nxglbj7eyQThfGOUOH5oJksXIwdYy97dShDxvYwS7Qc2MkI4Xxglbrd9YQeZyyagJbH/
        xQ02EFtEwEri9P8OZpAiZoFtjBLbdl1jBEkICzhJXDpwlAnEZhFQlTj2YTYziM0L1HC2bz4L
        xIHyEqs3HABrlhCYwiYxf9MOVoiEi8TXRQ/YIWxhiVfHt0DZUhKf3+1lg7CrJVaePMIG0dzB
        KLFl/wWoZmOJ/UsnM4H8wyygKbF+lz5EWFFi5++5YMcxC/BJvPvawwrxMq9ER5sQRImyxOUH
        d5kgbEmJxe2dUKs8JK6v3wUWFxKIlZj59j3bBEbZWQgLFjAyrmIUSy0ozk1PLTYsMEGOpk2M
        4ESmZbGDcc85n0OMAhyMSjy8G9beihViTSwrrsw9xCjBwawkwut29kasEG9KYmVValF+fFFp
        TmrxIUZTYOhNZJYSTc4HJtm8knhDUyNjY2MLE0MzU0NDJXFejh8XY4UE0hNLUrNTUwtSi2D6
        mDg4pRoYy/5+2RTYvW/hy5uN/zZ/TnlwvUli5hvfwnB2rybWqT9y62YIPEme01opHXx3fyjH
        Tq4nohd8BA427M5aX274n/2yKJdnAYfHrQdOzX2PPJu7Px6Sdzbc7/O8SLdE4PXDj7YRhq7M
        ew5suFFTWM7mON99bpHur6vaM202X5/w+VPbrm999q8LlFiKMxINtZiLihMBvZ6hwnoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsWy7bCSvK6w+u1Yg94/ghYTb1xhsbj+5Tmr
        RfPi9WwWZ5vesFtc3jWHzeJz7xFGi9uNK9gsHq94y26xYOMjRgdOj8V7XjJ5bFrVyeaxf+4a
        do++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKeDlvH3vBPeGKRasvsDQwnhfoYuTgkBAwkdi7
        W6mLkYtDSGA3o8TqzoMsXYycQHFJiWkXjzJD1AhLHD5cDFHziVFi2/JWsBo2AS2J/S9usIHY
        IgI2EncXXwOLMwvsY5RoO2sHYgsLOElcOnCUCcRmEVCVOPZhNjOIzStgJXG2bz7ULnmJ1RsO
        ME9g5FnAyLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4rLQ0dzBeXhJ/iFGAg1GJ
        h3fD2luxQqyJZcWVuYcYJTiYlUR43c7eiBXiTUmsrEotyo8vKs1JLT7EKM3BoiTO+zTvWKSQ
        QHpiSWp2ampBahFMlomDU6qBUfXk1bzzqz99SFX8wdQnUhycLLq8aoeAsz3H1ZopgRdMLbNW
        F5vmfRXv6+eRO/jvSJHzCoGw6+f/F8iWZhwo8z5Y/fSz1S4ewZoHlu2Sz69+y+ScHHTCIPuq
        qK9URvpr5qyM01zm4leTS/T4g06f6BCL/qb95OiT53f7Zl37JXL5xFrGlqfdSizFGYmGWsxF
        xYkAqv4URicCAAA=
X-CMS-MailID: 20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8
References: <CGME20191125005755epcas1p2404d0f095e6ce543d36e55e2427282f8@epcas1p2.samsung.com>
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
 Changes from v2:
- Change the order of name_show() according to the sequence in devfreq_attrs[]

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
index 65a4b6cf3fa5..6f4d93d2a651 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1169,6 +1169,14 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
 }
 EXPORT_SYMBOL(devfreq_remove_governor);
 
+static ssize_t name_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	return sprintf(buf, "%s\n", dev_name(devfreq->dev.parent));
+}
+static DEVICE_ATTR_RO(name);
+
 static ssize_t governor_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
@@ -1477,6 +1485,7 @@ static ssize_t trans_stat_show(struct device *dev,
 static DEVICE_ATTR_RO(trans_stat);
 
 static struct attribute *devfreq_attrs[] = {
+	&dev_attr_name.attr,
 	&dev_attr_governor.attr,
 	&dev_attr_available_governors.attr,
 	&dev_attr_cur_freq.attr,
-- 
2.17.1


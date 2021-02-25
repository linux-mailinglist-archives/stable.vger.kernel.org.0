Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83391325894
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 22:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBYVYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 16:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbhBYVY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 16:24:28 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687A9C06174A
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 13:23:48 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id e10so6410509wro.12
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 13:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uxVQ1dg2nqhX8SNUvSx/CFwCMMBlF2nfp3347F+VDtY=;
        b=PAAxWsfRQaqHyQHVBsZcTfsHYcam3D/lZHov192trhSuyuWHOeTHssyDHro6GZ1m41
         +mFE0/jr5ucIxRTGCDmwunY1W8iaG9fuzEefRedUsYYuaPrTLEI/X3eWfpsK5/RDUPGl
         bp9CJuDtTl/UGLYsNHOZ3+vffNr/sHgqxTY/igHpqQySJlkauOjkWwZvVCdvtvSYK8Wb
         D7RopBFC/jUAbbN0h+F4tcvb1LsvYNuM5O9SrOfPClwaY0AqdO1xWYJrok9bL4NCqSSC
         DklWYigl3CEN2MFsqscOCRCg5Q6dsdiBEm8DGC2rOOAVWwP3pvsR3ugKKt9sopmhTSB0
         hLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uxVQ1dg2nqhX8SNUvSx/CFwCMMBlF2nfp3347F+VDtY=;
        b=srB1XGw5m6tLlcneYMW+OstP/ylp5+S97ISM/xGGcfEPQeXqd5Z2MuC43TJnMXNPpc
         s7jwFG/YXHkyL3VewVQSPnvI8FWTPZRODTCrTRQMvvNNl5l7a8ASEvpIOUyzmFCIPgeU
         Tl1CXpaedZD80MbGOTkyk2I9DfGh+SMIii4TOX5aBNpuOauu8JNVnpOGGF01TKyjKMw7
         A3HZuYGKg6pEt+jkOnd1KdfrdKiG/72eQ4nyfUp5QksIJlMCVXPfysT92boWe18Cnj07
         CM9tKlZmD3g1o+/uI6MNgk5TxD0iEVqFG5uCrLf285dNZ470M1XhpX4p2z6fjyaWS3sP
         lRYg==
X-Gm-Message-State: AOAM5304hH6n8MKwkgy4v7vf6d1698VXQDN5+Kyzq1Qgxm5YswGZZwmq
        GY6NYxKoH9kduqtru8ACIxM=
X-Google-Smtp-Source: ABdhPJzQ5YlLo33xI6bURCHVBnHZRYD+YCCLimQibZKvpvL7oBafeaEZweIqce9eJPt5giT5vq/Vcg==
X-Received: by 2002:adf:f841:: with SMTP id d1mr5322608wrq.36.1614288227234;
        Thu, 25 Feb 2021 13:23:47 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id n186sm8854440wmn.22.2021.02.25.13.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 13:23:46 -0800 (PST)
Date:   Thu, 25 Feb 2021 21:23:44 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     dan.j.williams@intel.com, colyli@suse.com, dave.jiang@intel.com,
        ira.weiny@intel.com, rpalethorpe@suse.com, stable@vger.kernel.org,
        vishal.l.verma@intel.com
Subject: Re: FAILED: patch "[PATCH] libnvdimm/dimm: Avoid race between probe
 and" failed to apply to 4.19-stable tree
Message-ID: <YDgVYCKzK8zNt3Jy@debian>
References: <1612779897191109@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KFEKECFtOqNiUDDD"
Content-Disposition: inline
In-Reply-To: <1612779897191109@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KFEKECFtOqNiUDDD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 08, 2021 at 11:24:57AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will apply to all branches till 4.4-stable.

--
Regards
Sudip

--KFEKECFtOqNiUDDD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-libnvdimm-dimm-Avoid-race-between-probe-and-availabl.patch"

From 49a07391dd8bef6e40bb44ca5636dd429f86e81a Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Feb 2021 16:20:40 -0800
Subject: [PATCH] libnvdimm/dimm: Avoid race between probe and
 available_slots_show()

commit 7018c897c2f243d4b5f1b94bc6b4831a7eab80fb upstream

Richard reports that the following test:

(while true; do
     cat /sys/bus/nd/devices/nmem*/available_slots 2>&1 > /dev/null
 done) &

while true; do
     for i in $(seq 0 4); do
         echo nmem$i > /sys/bus/nd/drivers/nvdimm/bind
     done
     for i in $(seq 0 4); do
         echo nmem$i > /sys/bus/nd/drivers/nvdimm/unbind
     done
 done

...fails with a crash signature like:

    divide error: 0000 [#1] SMP KASAN PTI
    RIP: 0010:nd_label_nfree+0x134/0x1a0 [libnvdimm]
    [..]
    Call Trace:
     available_slots_show+0x4e/0x120 [libnvdimm]
     dev_attr_show+0x42/0x80
     ? memset+0x20/0x40
     sysfs_kf_seq_show+0x218/0x410

The root cause is that available_slots_show() consults driver-data, but
fails to synchronize against device-unbind setting up a TOCTOU race to
access uninitialized memory.

Validate driver-data under the device-lock.

Fixes: 4d88a97aa9e8 ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Coly Li <colyli@suse.com>
Reported-by: Richard Palethorpe <rpalethorpe@suse.com>
Acked-by: Richard Palethorpe <rpalethorpe@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[sudip: use device_lock()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/nvdimm/dimm_devs.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 863cabc35215..f0e0e3b42c91 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -359,16 +359,16 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(state);
 
-static ssize_t available_slots_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t __available_slots_show(struct nvdimm_drvdata *ndd, char *buf)
 {
-	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
+	struct device *dev;
 	ssize_t rc;
 	u32 nfree;
 
 	if (!ndd)
 		return -ENXIO;
 
+	dev = ndd->dev;
 	nvdimm_bus_lock(dev);
 	nfree = nd_label_nfree(ndd);
 	if (nfree - 1 > nfree) {
@@ -380,6 +380,18 @@ static ssize_t available_slots_show(struct device *dev,
 	nvdimm_bus_unlock(dev);
 	return rc;
 }
+
+static ssize_t available_slots_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	ssize_t rc;
+
+	device_lock(dev);
+	rc = __available_slots_show(dev_get_drvdata(dev), buf);
+	device_unlock(dev);
+
+	return rc;
+}
 static DEVICE_ATTR_RO(available_slots);
 
 static struct attribute *nvdimm_attributes[] = {
-- 
2.30.0


--KFEKECFtOqNiUDDD--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA59315A17
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhBIXdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 18:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbhBIWkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 17:40:53 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D7DC061574
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 14:39:55 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 190so189559wmz.0
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 14:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wuCKQ4FhGi56HfGUJszEpRdJJcLEz955sReXVOUg2rs=;
        b=M6zoU90t+oKRxrDF5ONnDvpOqroCyeTOfArVg+0UrjTO6S9yH1RLTPpzpljx1cDZKr
         bVueasX7BmrlbgsY1TzSMZsCUF+/pTtheD0bdbgEKhsm4TIKDPG/Zba1ajB1m92UjNYR
         JY3KLS4YxI8uXc4mc2C4GdESoJE2E62EbONFUyTSk6jg9AuhrwZYvFBMhuicMf0vUeop
         fY93952Ib0W90BDc9ylBbdw1LMWkT7Jof5cBeqamAixPvA0QkVjidkKow5w9CcpV/xsu
         2HN0qY2f+sWJWqN59WoTsPP/AJx+mjWAVJaTP+ZzuGcquIyGHKaubTf/GfEQOlBevZJ5
         4LYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wuCKQ4FhGi56HfGUJszEpRdJJcLEz955sReXVOUg2rs=;
        b=Jz9L/QS1n+75rjtRNb0tB2ZphSkCpwZsTyFo48GDjKcug5TLQ1mlMaoIee3UJlK9ch
         tp6YJxCm5X84YTCGHgrT+WBY/yiACBqWY3BpndHVVyq427MOPIYiHpDNRkX1umi1H6yb
         pEGr5Ky+9vHaJRd2S7bxHKlVPaft1OCBlJ6EbPNOpJdnYt2iRvauB5rA5jIHguqjbGqM
         SfIL8oMgqR6M6vt14UxZ+nzTn+STBeGaEBTLqm2LWDNbaPSJeGxRGf35Pc0cVhHBxdd+
         Tz7KY4Ch3SFmwmKaP01pxzU9vFxsopovXkV+Vk0oUt3td+lT7ZJBXigkL70N01AqIQSt
         ATXw==
X-Gm-Message-State: AOAM532fRliLol0X/yam7QZkOab7E0KNrh0d8zw26W///6Z9J9ZC998w
        HqKvlrmB10nznzH0KeIBrTM=
X-Google-Smtp-Source: ABdhPJw+mBw7SLHMZWmPQagB8BZOCPQOToXDYgpsj/773QQi6o3M2CNvV+pLMprk4XJw4TmEzaovng==
X-Received: by 2002:a1c:e309:: with SMTP id a9mr235681wmh.99.1612910388945;
        Tue, 09 Feb 2021 14:39:48 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id z4sm28000wrw.38.2021.02.09.14.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 14:39:48 -0800 (PST)
Date:   Tue, 9 Feb 2021 22:39:46 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     sibis@codeaurora.org, bjorn.andersson@linaro.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate MBA
 firmware size before" failed to apply to 4.19-stable tree
Message-ID: <YCMPMtk5djNwhXn5@debian>
References: <1597843356243112@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4F5OXSaY0H/o6hmE"
Content-Disposition: inline
In-Reply-To: <1597843356243112@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4F5OXSaY0H/o6hmE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 03:22:36PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.14-stable and 4.9-stable.

--
Regards
Sudip

--4F5OXSaY0H/o6hmE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-remoteproc-qcom_q6v5_mss-Validate-MBA-firmware-size-.patch"

From 7d37a8a02ba946cc76d519611d7f664c9dc73be5 Mon Sep 17 00:00:00 2001
From: Sibi Sankar <sibis@codeaurora.org>
Date: Thu, 23 Jul 2020 01:40:45 +0530
Subject: [PATCH] remoteproc: qcom_q6v5_mss: Validate MBA firmware size before
 load

commit e013f455d95add874f310dc47c608e8c70692ae5 upstream

The following mem abort is observed when the mba firmware size exceeds
the allocated mba region. MBA firmware size is restricted to a maximum
size of 1M and remaining memory region is used by modem debug policy
firmware when available. Hence verify whether the MBA firmware size lies
within the allocated memory region and is not greater than 1M before
loading.

Err Logs:
Unable to handle kernel paging request at virtual address
Mem abort info:
...
Call trace:
  __memcpy+0x110/0x180
  rproc_start+0x40/0x218
  rproc_boot+0x5b4/0x608
  state_store+0x54/0xf8
  dev_attr_store+0x44/0x60
  sysfs_kf_write+0x58/0x80
  kernfs_fop_write+0x140/0x230
  vfs_write+0xc4/0x208
  ksys_write+0x74/0xf8
  __arm64_sys_write+0x24/0x30
...

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200722201047.12975-2-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[sudip: manual backport to old file path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/remoteproc/qcom_q6v5_pil.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pil.c b/drivers/remoteproc/qcom_q6v5_pil.c
index cc475dcbf27f..28ea17894bad 100644
--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -340,6 +340,12 @@ static int q6v5_load(struct rproc *rproc, const struct firmware *fw)
 {
 	struct q6v5 *qproc = rproc->priv;
 
+	/* MBA is restricted to a maximum size of 1M */
+	if (fw->size > qproc->mba_size || fw->size > SZ_1M) {
+		dev_err(qproc->dev, "MBA firmware load failed\n");
+		return -EINVAL;
+	}
+
 	memcpy(qproc->mba_region, fw->data, fw->size);
 
 	return 0;
-- 
2.30.0


--4F5OXSaY0H/o6hmE--

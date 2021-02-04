Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952B030F882
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 17:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhBDQu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 11:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbhBDQuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 11:50:35 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FB7C0613D6
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 08:49:55 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c4so4285476wru.9
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 08:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=19AJMKszImxESo3RQ6pat0tNPa9/UwGG5RZlLeu6jsc=;
        b=hE9WgxQySzRdzFHTn3xWtAHlx3FtJXWdDveKQTHQjVRWKpG7g5pIm0snPNgjrMPgRw
         q7BYFO1XdHyZKjsAu6RCy1acKAkQCEZRlu5Q6fe5dMABogpt06ZPy7uFYpCbmK8l9qym
         iavJ0tuRHgetImk8cTOBh7i0+6XeFNB8QzP7iFI7uNmDrp9MSFOOcgmoxcVAAkoXlKQe
         w3qhSQSDW3IQKomZsPGEWNDt6IL/+yiyICRcISiVcb/2qw5DP1auIuPSt0lLxN7Vp060
         U+Vo44N+vWCTMX66FgZXDKHq1pKb5bOOWF7HGRrPzxJpadOBfFqTU9gWBVEeqOdbTgzx
         hksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=19AJMKszImxESo3RQ6pat0tNPa9/UwGG5RZlLeu6jsc=;
        b=JIP9PP95hGI5F5X5P7x1ANL2atoEkdqQ+QFkQUdjJheJs9+lC/XuOwWpDtXoqog7qR
         uxRBT7xRo5Zj9OkQK5+akHBKeoPAxIFADIvtXyS/4bdB/SPEEzIQbu8OxfNGO2EEUx7t
         A6wFVCKOti1nTF1Br4HEyoy1ZRNnNzL+oD45T8Id+S/WnWXVvEt2NFmmwJAbucNnSz3C
         96NASjSQsV7aW6H14Z91tfVvscaoWJ0rYFbeD/msMFK+UAiatBFTypNFMCekqYm6ExVp
         K/QeGfk1ND2OCmW6Zki+wXcla7ZJ0+li4QhowL/A6XUS3UbQiRHecU2+v/GLyQYCYUN2
         Afxw==
X-Gm-Message-State: AOAM5300BVg4N8xto+DYugqqNgWh2xd/NLkc6l7hLQyZcKaEFTGpatyu
        zQCoABP1NMXAm+qR/PLp6qyaCgPpnAJJ/g==
X-Google-Smtp-Source: ABdhPJwdPpinzsv8Khp9LM5TsAZcnIUuKSKjve05+3yQiu5cvUayS0VTvJlnQaASKXlWwKpdACkWQw==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr271274wrz.86.1612457394282;
        Thu, 04 Feb 2021 08:49:54 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id k4sm9570869wrm.53.2021.02.04.08.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 08:49:53 -0800 (PST)
Date:   Thu, 4 Feb 2021 16:49:52 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Thinh.Nguyen@synopsys.com, balbi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: udc: core: Use lock when write to
 soft_connect" failed to apply to 4.4-stable tree
Message-ID: <YBwlsCtNI9Nyuwq6@debian>
References: <1611584391127172@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aLeQ47nG7p8wRn2V"
Content-Disposition: inline
In-Reply-To: <1611584391127172@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aLeQ47nG7p8wRn2V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 25, 2021 at 03:19:51PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--aLeQ47nG7p8wRn2V
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-udc-core-Use-lock-when-write-to-soft_connect.patch"

From a2a1a8f2013e91b11f3db55d65b6c1ce3d51bf98 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 14 Jan 2021 00:09:51 -0800
Subject: [PATCH] usb: udc: core: Use lock when write to soft_connect

commit c28095bc99073ddda65e4f31f6ae0d908d4d5cd8 upstream

Use lock to guard against concurrent access for soft-connect/disconnect
operations when writing to soft_connect sysfs.

Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
Cc: stable@vger.kernel.org
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/338ea01fbd69b1985ef58f0f59af02c805ddf189.1610611437.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: manual backporting to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/gadget/udc/udc-core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
index a6a1678cb927..c6859fdd74bc 100644
--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -612,10 +612,13 @@ static ssize_t usb_udc_softconn_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t n)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
+	ssize_t			ret;
 
+	mutex_lock(&udc_lock);
 	if (!udc->driver) {
 		dev_err(dev, "soft-connect without a gadget driver\n");
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	if (sysfs_streq(buf, "connect")) {
@@ -627,10 +630,14 @@ static ssize_t usb_udc_softconn_store(struct device *dev,
 		usb_gadget_udc_stop(udc);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
-	return n;
+	ret = n;
+out:
+	mutex_unlock(&udc_lock);
+	return ret;
 }
 static DEVICE_ATTR(soft_connect, S_IWUSR, NULL, usb_udc_softconn_store);
 
-- 
2.29.2


--aLeQ47nG7p8wRn2V--

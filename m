Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0362FDB0D
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 21:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388502AbhATUmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 15:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387942AbhATUjf (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 20 Jan 2021 15:39:35 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F0AC061757
        for <Stable@vger.kernel.org>; Wed, 20 Jan 2021 12:38:54 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m187so3928730wme.2
        for <Stable@vger.kernel.org>; Wed, 20 Jan 2021 12:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Phgm/n8+2BhEOckGQCa9I2FHE1qD57M7lRcExOoYzpI=;
        b=QA9KT3Nu4kwo5lWDuOi2sNVS/xcaQDEvr3BvKaUF92ObZIAnFUpgHtOL3IIO0UFbVx
         /C1HGsLdrcIVwl5+PozqJ76Cn3YzitpNmHnBo7LI28DrB3a2BW6Rgk0r3ngXuH1nBKo7
         1YVfkE9Z9oPVx/KezMIPmROVuFAtiGdEbWSUM9IHHdvyfMtbCqSX7ch3Q3JGD6xBkXay
         slIEMYFMbnrxo2I7gMH7ad7I0r4QAth/+VpcI3fJGDkzCE3RVEVIvnJJ5eB803GMxqQc
         egXXhJs7zmI7F1tZvaNxV4KsHz9iEYVlMeSR9t3gXa4xiL4tMzquWxd9xyXQDDJcUEue
         tVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Phgm/n8+2BhEOckGQCa9I2FHE1qD57M7lRcExOoYzpI=;
        b=rH8LrgeidGsj+/sKjWa1MfvRvy5IQRtTw25VccLBwIyFeqSBlFM0L5nCqZb0qFNeXJ
         B7DmTaZRumfMwtNKyA7dXLXmTxeZsW0O3eU2z77poNY+vvC53LdebztffNW/rbUnilHk
         BxAPc0l5XFzi4ZK3XbT4GOus23yaQ+qYtAFOhT/hbEwxo1+Z3UTTGcP9gkr1VbzmXOQJ
         u1VV/yWSjec5PY71AfYTlvxh3WYe5zuULRh5O8yQGxHCXBFIhyJa4es9ZAtvUJucv0MA
         D/NHBtUCIJIOuyIoREZgbZiQquRrqk5epC/JqPL2VuZLv6GytlnD4VKu7hPwcM/xq6tN
         1R2g==
X-Gm-Message-State: AOAM533n8B7Xaovk+8i0vA7+O2B5FbFUtkiH6I5lX0sVEqaKasgRnKjw
        JIwn6dly0QoJg+QW8YIy2Bs=
X-Google-Smtp-Source: ABdhPJwrHp38dlny1TlHnfw1VecRJWEy5xfC5WfVp3I0F0ba3G4WzAMF0pwDasEzw8Nmw70LpJx/wQ==
X-Received: by 2002:a7b:c41a:: with SMTP id k26mr5963816wmi.1.1611175133711;
        Wed, 20 Jan 2021 12:38:53 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id h16sm5553631wmb.41.2021.01.20.12.38.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Jan 2021 12:38:53 -0800 (PST)
Date:   Wed, 20 Jan 2021 20:38:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: buffer: Fix demux update" failed to
 apply to 4.4-stable tree
Message-ID: <20210120203851.mqmhizwrfonznily@debian>
References: <1609153940167171@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jucywlxn3onuqc42"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1609153940167171@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jucywlxn3onuqc42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 12:12:20PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--jucywlxn3onuqc42
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-iio-buffer-Fix-demux-update.patch"
Content-Transfer-Encoding: 8bit

From 441947967026f382aa78bc51955024995f546543 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Thu, 12 Nov 2020 15:43:22 +0100
Subject: [PATCH] iio: buffer: Fix demux update
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 19ef7b70ca9487773c29b449adf0c70f540a0aab upstream

When updating the buffer demux, we will skip a scan element from the
device in the case `in_ind != out_ind` and we enter the while loop.
in_ind should only be refreshed with `find_next_bit()` in the end of the
loop.

Note, to cause problems we need a situation where we are skippig over
an element (channel not enabled) that happens to not have the same size
as the next element.   Whilst this is a possible situation we haven't
actually identified any cases in mainline where it happens as most drivers
have consistent channel storage sizes with the exception of the timestamp
which is the last element and hence never skipped over.

Fixes: 5ada4ea9be16 ("staging:iio: add demux optionally to path from device to buffer")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20201112144323.28887-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/iio/industrialio-buffer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 864a61b05665..d3cdd742972f 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1281,9 +1281,6 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 				       indio_dev->masklength,
 				       in_ind + 1);
 		while (in_ind != out_ind) {
-			in_ind = find_next_bit(indio_dev->active_scan_mask,
-					       indio_dev->masklength,
-					       in_ind + 1);
 			ch = iio_find_channel_from_si(indio_dev, in_ind);
 			if (ch->scan_type.repeat > 1)
 				length = ch->scan_type.storagebits / 8 *
@@ -1292,6 +1289,9 @@ static int iio_buffer_update_demux(struct iio_dev *indio_dev,
 				length = ch->scan_type.storagebits / 8;
 			/* Make sure we are aligned */
 			in_loc = roundup(in_loc, length) + length;
+			in_ind = find_next_bit(indio_dev->active_scan_mask,
+					       indio_dev->masklength,
+					       in_ind + 1);
 		}
 		ch = iio_find_channel_from_si(indio_dev, in_ind);
 		if (ch->scan_type.repeat > 1)
-- 
2.11.0


--jucywlxn3onuqc42--

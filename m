Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBC315A1A
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhBIXdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 18:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhBIXAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 18:00:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BD2C0617AA
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 15:00:06 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m13so96015wro.12
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 15:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fseR+MEqsN3MXq2NIHnju8yX86RQKbEsx/6DrQcDDHY=;
        b=nBOYRou2cOK79Qc9uD1o/lDjCw9kbFlHTIVk2EZgl1j9+c5U0bpvSisxKH1zLuPAQP
         TIFtJbwLIyuacX4aaaU6SAKlGVmmw/E4om/9MIgtE5EYJbf6jKfdj3uHuzLpV53X3WeW
         x1qf1p4u01QMfnkiTm7SdVcujNILKMdgs1oZphuuKpxyUgDGjh8FZAcW7hq7Jp5CYTAv
         Pt9oM65MICj+/PTZonQdSYRi9dkIn6yFAhljF8l5mf973Xfd2ah6rgbdOExXFnkkAjoY
         p11RifkszDttrv7BCxj7EwhnCHwvNnCAv8RVLazukH/bHju1fWcHW4Z7GNm7Z1T+NsgI
         kHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fseR+MEqsN3MXq2NIHnju8yX86RQKbEsx/6DrQcDDHY=;
        b=URxovsF0llfFjtCGpKp4eRT7MNMjP+jceNJ6PXUoyDraPmnjpeH4OeSPCcEGE3qd/D
         0XLjnlSj9NWUHD4LmWg0n8j7Q8qUZrzLU8RE3Tmm8CJ8/TNuY/WvGM4ZnnAT3HB01L9L
         0yit11ynG2uak+W0bX5jkQqt4BDVUgB6rWPbX6JtyiGVgXDmQ7LUIelucnlb2198JX27
         /4rXIffaS7RGwaD3TEERsW0ruJ058jFHPmw4097hM6bRFXgVvA2Ir2XA3GwkkxqV9IKU
         2cAwqIU6S4cuj7gPxxHNvSCiDrS4jaA0TrEDTuiraW8UUGGgAzx1F9YldUh7n9gojiyr
         0O9Q==
X-Gm-Message-State: AOAM5320vODA0ZF+2tVoKlBYf4piyOgAgS9tJmIo+yALI9famR0zJHuI
        Nuy1/QyXeOiyciraraV5+KzRbY5JwkoMYA==
X-Google-Smtp-Source: ABdhPJyStUZEd4AttCTSUZ+nxOn6SkynpPn5wJV5bLHnNEG337jj2RxthsET1/LVwy3cYNhsaWeAGw==
X-Received: by 2002:a5d:684b:: with SMTP id o11mr372676wrw.52.1612911605144;
        Tue, 09 Feb 2021 15:00:05 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id l1sm106801wrp.40.2021.02.09.15.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 15:00:04 -0800 (PST)
Date:   Tue, 9 Feb 2021 23:00:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     sibis@codeaurora.org, bjorn.andersson@linaro.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] remoteproc: qcom_q6v5_mss: Validate modem
 blob firmware size" failed to apply to 4.19-stable tree
Message-ID: <YCMT88Uh0OjGyPU2@debian>
References: <15978433765775@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wcg84lGSkBqjJj7K"
Content-Disposition: inline
In-Reply-To: <15978433765775@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wcg84lGSkBqjJj7K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 03:22:56PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.14-stable.

--
Regards
Sudip

--wcg84lGSkBqjJj7K
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-remoteproc-qcom_q6v5_mss-Validate-modem-blob-firmwar.patch"

From 1811e33f6cb0b3dde721c82ff14a15149ea319eb Mon Sep 17 00:00:00 2001
From: Sibi Sankar <sibis@codeaurora.org>
Date: Thu, 23 Jul 2020 01:40:46 +0530
Subject: [PATCH] remoteproc: qcom_q6v5_mss: Validate modem blob firmware size
 before load

commit 135b9e8d1cd8ba5ac9ad9bcf24b464b7b052e5b8 upstream

The following mem abort is observed when one of the modem blob firmware
size exceeds the allocated mpss region. Fix this by restricting the copy
size to segment size using request_firmware_into_buf before load.

Err Logs:
Unable to handle kernel paging request at virtual address
Mem abort info:
...
Call trace:
  __memcpy+0x110/0x180
  rproc_start+0xd0/0x190
  rproc_boot+0x404/0x550
  state_store+0x54/0xf8
  dev_attr_store+0x44/0x60
  sysfs_kf_write+0x58/0x80
  kernfs_fop_write+0x140/0x230
  vfs_write+0xc4/0x208
  ksys_write+0x74/0xf8
...

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 051fb70fd4ea4 ("remoteproc: qcom: Driver for the self-authenticating Hexagon v5")
Cc: stable@vger.kernel.org
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200722201047.12975-3-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[sudip: manual backport to old file path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/remoteproc/qcom_q6v5_pil.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_pil.c b/drivers/remoteproc/qcom_q6v5_pil.c
index 28ea17894bad..604828c04ddf 100644
--- a/drivers/remoteproc/qcom_q6v5_pil.c
+++ b/drivers/remoteproc/qcom_q6v5_pil.c
@@ -745,14 +745,13 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 
 		if (phdr->p_filesz) {
 			snprintf(seg_name, sizeof(seg_name), "modem.b%02d", i);
-			ret = request_firmware(&seg_fw, seg_name, qproc->dev);
+			ret = request_firmware_into_buf(&seg_fw, seg_name, qproc->dev,
+							ptr, phdr->p_filesz);
 			if (ret) {
 				dev_err(qproc->dev, "failed to load %s\n", seg_name);
 				goto release_firmware;
 			}
 
-			memcpy(ptr, seg_fw->data, seg_fw->size);
-
 			release_firmware(seg_fw);
 		}
 
-- 
2.30.0


--wcg84lGSkBqjJj7K--

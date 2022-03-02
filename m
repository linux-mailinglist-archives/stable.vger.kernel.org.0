Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C784CB218
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 23:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242803AbiCBWPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 17:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242425AbiCBWPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 17:15:37 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE33D204C
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 14:14:53 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u10so3313386wra.9
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 14:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vi08Vn7RoN5d7B5dTGvckrZHByqOK2akqldvx3IGLB4=;
        b=nocAjoFigpwj4ENXKZZdqooggpPmgNWX37Z9eLuG5t+FWUOeh6/PwnIX9PeSScth/J
         V4ax7CQcMrHRGm3v5hpdY6fqW3/K2vSf5iGRoS5Qy1d1O5nnVn36N9fXHdr114Rc8TdQ
         T+0fJlije1IGE2UsnnjPx0r4cun2TO02p/RtYPYhKQ/N9iVlz5tDOpVwIX9QBoRDPfBL
         Fl1tZNrUczuCtm4oaVyYyKNzdJe8MECb6xZ+FG33jNV3pQaJN2RIwTCr8XPc88vkeao4
         KN74Ep+KpqDMBJYQHp1zwwLrcdQ9d5qie+byJcFlTqV3rRuaeqQZAcKDKYI8j844r259
         0MaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vi08Vn7RoN5d7B5dTGvckrZHByqOK2akqldvx3IGLB4=;
        b=zwkoHppt4eN5RwAxfqNDmYIptAxoayXIJnpOHLALQK4Vizkltg8Crc3MP1hArzDGto
         c3qXU6ESNqgIwtOiljn0P70oPqSFzLNRgOUQTQe01b3AEuYQBlF9j3G7P7capZDwqogd
         mHkSyMEQcqRVCj/FWnyocss/D7F/ut+K6eoupVJhtkedskM35PJkeorpgAUxor3b3okO
         /7qFAW4xlPJ5T+2/1ahySLsGnwNpmWgJpxzZaHCLUMZUVsWQ8Y26v4NPP4y4JOtxu4BN
         Ob6hgZSU1DHF/gDOBSWw02d/lSAHV6ig3QLyb0qG0E/6k0TSjrxrPCXjJlnXJt5GR5JG
         XF2A==
X-Gm-Message-State: AOAM531FYXQo8HUltm6HjugzDTpfwMhw/SmlH+J/TReI8AD9wccCm9TH
        2rIUpiL6LjRzM9K5XwD7BphmFAo6qVsFJhcT
X-Google-Smtp-Source: ABdhPJxMr6YSUubPCLKijU21CFIywh1v2o6D90F/O817g1TlGGubOHagoA5vpc+EBzwAOd+sqgHVFg==
X-Received: by 2002:adf:fcd0:0:b0:1ef:31fe:d08e with SMTP id f16-20020adffcd0000000b001ef31fed08emr22498692wrs.667.1646259291681;
        Wed, 02 Mar 2022 14:14:51 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p2-20020a1c7402000000b0038159076d30sm6997722wmc.22.2022.03.02.14.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 14:14:51 -0800 (PST)
Date:   Wed, 2 Mar 2022 22:14:49 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     johan@kernel.org, somlo@cmu.edu, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] firmware: qemu_fw_cfg: fix kobject leak
 in probe error path" failed to apply to 4.14-stable tree
Message-ID: <Yh/sWZImSWjBAhwB@debian>
References: <164249590460244@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VK4Wzp6QWi04K23y"
Content-Disposition: inline
In-Reply-To: <164249590460244@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VK4Wzp6QWi04K23y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Tue, Jan 18, 2022 at 09:51:44AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with the backport of:
fe3c60684377 ("firmware: Fix a reference count leak.") which was needed to
make the backport easier. Both will also apply to 4.9-stable.

--
Regards
Sudip

--VK4Wzp6QWi04K23y
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-firmware-Fix-a-reference-count-leak.patch"

From cee693694f56f4819bc92e406eeb4f44151b3851 Mon Sep 17 00:00:00 2001
From: Qiushi Wu <wu000273@umn.edu>
Date: Sat, 13 Jun 2020 14:05:33 -0500
Subject: [PATCH 1/2] firmware: Fix a reference count leak.

commit fe3c60684377d5ad9b0569b87ed3e26e12c8173b upstream.

kobject_init_and_add() takes reference even when it fails.
If this function returns an error, kobject_put() must be called to
properly clean up the memory associated with the object.
Callback function fw_cfg_sysfs_release_entry() in kobject_put()
can handle the pointer "entry" properly.

Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200613190533.15712-1-wu000273@umn.edu
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/firmware/qemu_fw_cfg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index 586dedadb2f0..59ecbed32042 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -461,8 +461,10 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
 				   fw_cfg_sel_ko, "%d", entry->f.select);
-	if (err)
-		goto err_register;
+	if (err) {
+		kobject_put(&entry->kobj);
+		return err;
+	}
 
 	/* add raw binary content access */
 	err = sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);
@@ -478,7 +480,6 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 
 err_add_raw:
 	kobject_del(&entry->kobj);
-err_register:
 	kfree(entry);
 	return err;
 }
-- 
2.30.2


--VK4Wzp6QWi04K23y
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-firmware-qemu_fw_cfg-fix-kobject-leak-in-probe-error.patch"

From a0efe2fb6149f222be297da49d80fd05ec22c915 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 1 Dec 2021 14:25:26 +0100
Subject: [PATCH 2/2] firmware: qemu_fw_cfg: fix kobject leak in probe error
 path

commit 47a1db8e797da01a1309bf42e0c0d771d4e4d4f3 upstream.

An initialised kobject must be freed using kobject_put() to avoid
leaking associated resources (e.g. the object name).

Commit fe3c60684377 ("firmware: Fix a reference count leak.") "fixed"
the leak in the first error path of the file registration helper but
left the second one unchanged. This "fix" would however result in a NULL
pointer dereference due to the release function also removing the never
added entry from the fw_cfg_entry_cache list. This has now been
addressed.

Fix the remaining kobject leak by restoring the common error path and
adding the missing kobject_put().

Fixes: 75f3e8e47f38 ("firmware: introduce sysfs driver for QEMU's fw_cfg device")
Cc: stable@vger.kernel.org      # 4.6
Cc: Gabriel Somlo <somlo@cmu.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211201132528.30025-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/firmware/qemu_fw_cfg.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index 59ecbed32042..047d3fd08474 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -461,15 +461,13 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
 				   fw_cfg_sel_ko, "%d", entry->f.select);
-	if (err) {
-		kobject_put(&entry->kobj);
-		return err;
-	}
+	if (err)
+		goto err_put_entry;
 
 	/* add raw binary content access */
 	err = sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);
 	if (err)
-		goto err_add_raw;
+		goto err_del_entry;
 
 	/* try adding "/sys/firmware/qemu_fw_cfg/by_name/" symlink */
 	fw_cfg_build_symlink(fw_cfg_fname_kset, &entry->kobj, entry->f.name);
@@ -478,9 +476,10 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	fw_cfg_sysfs_cache_enlist(entry);
 	return 0;
 
-err_add_raw:
+err_del_entry:
 	kobject_del(&entry->kobj);
-	kfree(entry);
+err_put_entry:
+	kobject_put(&entry->kobj);
 	return err;
 }
 
-- 
2.30.2


--VK4Wzp6QWi04K23y--

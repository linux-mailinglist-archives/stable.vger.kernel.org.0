Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D002253B4E6
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 10:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiFBIXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 04:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiFBIXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 04:23:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB5317E3E;
        Thu,  2 Jun 2022 01:23:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c14so4122154pgu.13;
        Thu, 02 Jun 2022 01:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cbmNOareeTE5Db8Piv7hDPn78IPOWasDWjVRSeszEak=;
        b=F2LlSXp3PxiU4nJ+UEfZulTenT901DxKJZUBhWrOIghbAJO7H41vsGxbtH7E6owQWK
         zQNb3UDVLjgTRyR3z0DwxC517totfjnOMzlmsup9oVLRJ7WIcIHmVTAS06wIa0d3jzBn
         pGeP0Hnz64qgoYJ2AGAah3DGsQXD+uEy0SyEZlkn9IU2qLQiwtVQsW+yvaR8P/V7kamU
         PSl9zdxBEmC6RnXKuSxR823fwizfddWXsJUYVeIciFVC6gcr6ZiEvi6BrVD861SpdSCl
         rVYObcA9UB3exWvMCpScTGJFvKdKHge8UpqidsV4EqPSuxyGlR/kwSWy/e7x5HT03n9x
         a/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cbmNOareeTE5Db8Piv7hDPn78IPOWasDWjVRSeszEak=;
        b=CiM9cgp5HC14Bbbvn85oRL23reUx+LNK9EKItSmyY8EDhpexh7NRI/Wwe4/RW/FbMV
         4ZZxT9OrX0fX/puwOWK/7quVlaZFjcfyB3DTUR2w71hUGPDl28t+c5j5Wigz5a7xwOgE
         qEi5uB5ucrf8icDPWjhFmEadMQcto8B0SphGfVIfCzz5NbeDF4BtJdu3VXqDrsL+Nbsc
         Nfg+KrwxkMbFE4WWG9few/Z1F1WTDbZsDfMyqktKsV89pzQky9xYLgGv1c4pqb6t90FQ
         V4t6RZJVkk+Z2/8XE8g7j0BD9DcEUYW9fNs8jg5L6W83rCqa8yuxtO80Vh40v+L6xs9z
         C9SA==
X-Gm-Message-State: AOAM532GpZ96spuGwrLaIiK431dHU9xBWe4IiEAuOYoK786xWo/gO7tX
        POAueHJ+aIl4+3wjLQcZElXK+La3ZqUDAg==
X-Google-Smtp-Source: ABdhPJxFm4ypSV8CsNf46zwnitNOtF7T1Y2Qz7WihywdMlvPbxJxJgebJkp9t7XcCiJigUBLFeMVdA==
X-Received: by 2002:a05:6a00:16cd:b0:51b:5f55:9bd with SMTP id l13-20020a056a0016cd00b0051b5f5509bdmr15451936pfc.6.1654158212946;
        Thu, 02 Jun 2022 01:23:32 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-21.three.co.id. [180.214.233.21])
        by smtp.gmail.com with ESMTPSA id z14-20020a170903018e00b0016368840c41sm2972334plg.14.2022.06.02.01.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 01:23:32 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Nikolai Kondrashov <spbnick@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        llvm@lists.linux.dev, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] HID: uclogic: properly format kernel-doc comment for hid_dbg() wrappers
Date:   Thu,  2 Jun 2022 15:23:21 +0700
Message-Id: <20220602082321.313143-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Running kernel-doc script on drivers/hid/hid-uclogic-params.c, it found
6 warnings for hid_dbg() wrapper functions below:

drivers/hid/hid-uclogic-params.c:48: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
drivers/hid/hid-uclogic-params.c:48: warning: missing initial short description on line:
 * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
drivers/hid/hid-uclogic-params.c:48: info: Scanning doc for function Dump
drivers/hid/hid-uclogic-params.c:80: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Dump tablet interface frame parameters with hid_dbg(), indented with two
drivers/hid/hid-uclogic-params.c:80: warning: missing initial short description on line:
 * Dump tablet interface frame parameters with hid_dbg(), indented with two
drivers/hid/hid-uclogic-params.c:80: info: Scanning doc for function Dump
drivers/hid/hid-uclogic-params.c:105: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Dump tablet interface parameters with hid_dbg().
drivers/hid/hid-uclogic-params.c:105: warning: missing initial short description on line:
 * Dump tablet interface parameters with hid_dbg().

One of them is reported by kernel test robot.

Fix these warnings by properly format kernel-doc comment for these
functions.

Link: https://lore.kernel.org/linux-doc/202205272033.XFYlYj8k-lkp@intel.com/
Fixes: a228809fa6f39c ("HID: uclogic: Move param printing to a function")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: José Expósito <jose.exposito89@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: llvm@lists.linux.dev
Cc: stable@vger.kernel.org # v5.18
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Changes since v2 [1]:
   - Format NULL as kernel-doc constant (suggested by Randy Dunlap)
   - Collect review tags:
     - Tested-by and Acked-by from Randy Dunlap
     - Tested-by from José Expósito

 [1]: https://lore.kernel.org/linux-doc/20220531092817.13894-1-bagasdotme@gmail.com/
 drivers/hid/hid-uclogic-params.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index db838f16282d64..e5e65d849faa97 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -23,11 +23,11 @@
 /**
  * uclogic_params_pen_inrange_to_str() - Convert a pen in-range reporting type
  *                                       to a string.
- *
  * @inrange:	The in-range reporting type to convert.
  *
- * Returns:
- *	The string representing the type, or NULL if the type is unknown.
+ * Return:
+ * * The string representing the type, or
+ * * %NULL if the type is unknown.
  */
 static const char *uclogic_params_pen_inrange_to_str(
 				enum uclogic_params_pen_inrange inrange)
@@ -45,10 +45,12 @@ static const char *uclogic_params_pen_inrange_to_str(
 }
 
 /**
- * Dump tablet interface pen parameters with hid_dbg(), indented with one tab.
- *
+ * uclogic_params_pen_hid_dbg() - Dump tablet interface pen parameters
  * @hdev:	The HID device the pen parameters describe.
  * @pen:	The pen parameters to dump.
+ *
+ * Dump tablet interface pen parameters with hid_dbg(). The dump is indented
+ * with a tab.
  */
 static void uclogic_params_pen_hid_dbg(const struct hid_device *hdev,
 					const struct uclogic_params_pen *pen)
@@ -77,11 +79,12 @@ static void uclogic_params_pen_hid_dbg(const struct hid_device *hdev,
 }
 
 /**
- * Dump tablet interface frame parameters with hid_dbg(), indented with two
- * tabs.
- *
+ * uclogic_params_frame_hid_dbg() - Dump tablet interface frame parameters
  * @hdev:	The HID device the pen parameters describe.
  * @frame:	The frame parameters to dump.
+ *
+ * Dump tablet interface frame parameters with hid_dbg(). The dump is
+ * indented with two tabs.
  */
 static void uclogic_params_frame_hid_dbg(
 				const struct hid_device *hdev,
@@ -102,10 +105,11 @@ static void uclogic_params_frame_hid_dbg(
 }
 
 /**
- * Dump tablet interface parameters with hid_dbg().
- *
+ * uclogic_params_hid_dbg() - Dump tablet interface parameters
  * @hdev:	The HID device the parameters describe.
  * @params:	The parameters to dump.
+ *
+ * Dump tablet interface parameters with hid_dbg().
  */
 void uclogic_params_hid_dbg(const struct hid_device *hdev,
 				const struct uclogic_params *params)

base-commit: d1dc87763f406d4e67caf16dbe438a5647692395
-- 
An old man doll... just what I always wanted! - Clara


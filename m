Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35821DDB6B
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgEUX6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:09 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5805AC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id r9so9663316qtn.20
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=kDFl6yGm4aHUMU9L0i8tjs7DIH/mLKt3c+c4Oc1QHYc=;
        b=aFZftlbIbl4V86IKewAc+CrhC0avTBnDPJyqHUf0cFxZMFksqzjuMNCsa2plhPxQBM
         E3bKMJUdQ2xPk8gFJGdrWRjdTbs37+nFcb+Y8j1GYaALttSeJ/jO6XlHSssefW6xpz4i
         n/7U1RfCW7i9PXfdtKZnsG+9jy8+WrmhsU5V8f02cOPqQDjMN20sZI+fz970ueUVb2kN
         jkb2o8FsIhYTc3KKd19ndfkogCY1/q0ty58DX65KOEQlWTc3OT79Iw8VwaFoL48e78tV
         siFE9eVX14kNevf7X5svoMAWJifJqaGIfwX25FFcy1NQm730OJhS1d9BjJr3cOoZbCN5
         LrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=kDFl6yGm4aHUMU9L0i8tjs7DIH/mLKt3c+c4Oc1QHYc=;
        b=V+oT8IoYoKssyyg6bdykG9Le8CQXNipgiPS8TvlKk3aMdJSGpgluI5ZUkTvEFGu0kJ
         m/QYo3ySIgtbY6STvQmvwkJLI6KD5tIIkuI45YW38ecm3jI0V83ztAzc/lPSn+0V//2x
         D7xApOP1Ke4STzQjmzZhccu56pT7aLjybAjSYVc4SFUNrWYksYcgywrXF/4pvFr73YCr
         n/t1uVjwohfLBQ5E5+aE0cSLNS9aEKtVovKxojkmcmrPAB5/Ppujc0G10TCD+0+noF1a
         GVH0SW3Ncn3I1ovF6QmFI4x0tfg52yJkDIgj9NY+LL1Mi9SC6iRY8vLPdhEyIDQqVlaZ
         Nyvg==
X-Gm-Message-State: AOAM531tmuGIoWShtE2+Nsy/e4YHG96SU+VzfM3HYBh1rhyOL4ZWUGOk
        tBpwmgviEGnV9hNL4KRd3LDJpXCg6G0gmA==
X-Google-Smtp-Source: ABdhPJw2cQio34eun+a8qKBQAa4oYnmZ7LmSHgDEa0A8qF4D4womKvzNH5f6ati64aZKq/OrHq+IU57gIrsDtA==
X-Received: by 2002:a0c:8e84:: with SMTP id x4mr1254714qvb.175.1590105487453;
 Thu, 21 May 2020 16:58:07 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:20 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-8-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 07/27] net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org,
        "=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=" 
        <asbjorn@asbjorn.st>, "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asbj=C3=B8rn Sloth T=C3=B8nnesen <asbjorn@asbjorn.st>

commit 47c3e7783be4e142b861d34b5c2e223330b05d8a upstream.

PPPOL2TP_MSG_* and L2TP_MSG_* are duplicates, and are being used
interchangeably in the kernel, so let's standardize on L2TP_MSG_*
internally, and keep PPPOL2TP_MSG_* defined in UAPI for compatibility.

Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.st>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 Documentation/networking/l2tp.txt |  8 ++++----
 include/uapi/linux/if_pppol2tp.h  | 13 ++++++-------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/l2tp.txt b/Documentation/networking/l=
2tp.txt
index 4650a00ed012..9bc271cdc9a8 100644
--- a/Documentation/networking/l2tp.txt
+++ b/Documentation/networking/l2tp.txt
@@ -177,10 +177,10 @@ setsockopt on the PPPoX socket to set a debug mask.
=20
 The following debug mask bits are available:
=20
-PPPOL2TP_MSG_DEBUG    verbose debug (if compiled in)
-PPPOL2TP_MSG_CONTROL  userspace - kernel interface
-PPPOL2TP_MSG_SEQ      sequence numbers handling
-PPPOL2TP_MSG_DATA     data packets
+L2TP_MSG_DEBUG    verbose debug (if compiled in)
+L2TP_MSG_CONTROL  userspace - kernel interface
+L2TP_MSG_SEQ      sequence numbers handling
+L2TP_MSG_DATA     data packets
=20
 If enabled, files under a l2tp debugfs directory can be used to dump
 kernel state about L2TP tunnels and sessions. To access it, the
diff --git a/include/uapi/linux/if_pppol2tp.h b/include/uapi/linux/if_pppol=
2tp.h
index 163e8adac2d6..de246e9f4974 100644
--- a/include/uapi/linux/if_pppol2tp.h
+++ b/include/uapi/linux/if_pppol2tp.h
@@ -17,6 +17,7 @@
=20
 #include <linux/types.h>
=20
+#include <linux/l2tp.h>
=20
 /* Structure used to connect() the socket to a particular tunnel UDP
  * socket over IPv4.
@@ -89,14 +90,12 @@ enum {
 	PPPOL2TP_SO_REORDERTO	=3D 5,
 };
=20
-/* Debug message categories for the DEBUG socket option */
+/* Debug message categories for the DEBUG socket option (deprecated) */
 enum {
-	PPPOL2TP_MSG_DEBUG	=3D (1 << 0),	/* verbose debug (if
-						 * compiled in) */
-	PPPOL2TP_MSG_CONTROL	=3D (1 << 1),	/* userspace - kernel
-						 * interface */
-	PPPOL2TP_MSG_SEQ	=3D (1 << 2),	/* sequence numbers */
-	PPPOL2TP_MSG_DATA	=3D (1 << 3),	/* data packets */
+	PPPOL2TP_MSG_DEBUG	=3D L2TP_MSG_DEBUG,
+	PPPOL2TP_MSG_CONTROL	=3D L2TP_MSG_CONTROL,
+	PPPOL2TP_MSG_SEQ	=3D L2TP_MSG_SEQ,
+	PPPOL2TP_MSG_DATA	=3D L2TP_MSG_DATA,
 };
=20
=20
--=20
2.27.0.rc0.183.gde8f92d652-goog


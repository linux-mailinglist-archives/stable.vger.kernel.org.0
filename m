Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C81DD03E
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgEUOlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgEUOlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:15 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF02AC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:14 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 19so7926712qtp.8
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=kuSsRzX86p5UC5JoZMb8+4VBJbFMjIVeNfyoV7vR8wE=;
        b=U1k5ynRwLoisWU3h6m5k83Yj/MbJwLCZoqwbAZ1thEjqatydnzsUm+GH0adMQ614nz
         4KYYiBBru2iT+4BJgZqIpa7Tr4OtNz9sV29xkZit2eQBdqsRk97EABATUdvBiFDqMqDU
         xpfKlOI1PagIfeE2mDJtHhq07xfOqBIyknZ+kvLoIlrFXzgji8v/fazGG1+1Ce9L88eJ
         b6xG+VcM0DEPVBrQTIkNso9oR90SC1W+A1vCN9Z8AeqRuHSE/LlKfAGXSnW+7lYqiuum
         MtBlHVXe5GRtGeUNxS7fBopp4BMn7WWldzelWDA6W7V8N68cWQLQwXl3LczkKqaWNAsw
         bBSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=kuSsRzX86p5UC5JoZMb8+4VBJbFMjIVeNfyoV7vR8wE=;
        b=E3R86tmg/qo19IopcoW2HWHRvm4vdNOCGFWPQXmT6wKlhhM9yVxPx1jWABiGKPchsr
         N6Oy5swYKpWZ7vkiu9YJropv5CJQb1oQX0uIbbh0XJJ4+HD8yEDU10JbHWtwMNdO7Q9u
         T8iKv4ra+ouGcHkKhzmBGKgd8OiKTg/hZ4jJ5H2umfnhK/xW6G6tWQc602YVo9xIvjQJ
         o9knOhvVKico0OgQH8QCAxIkefojAvCey9hV5DQTEFpxtsXuFVmuO5GKxDSJyjINEMUV
         YDbhi4CA9ZXj18sb1heEkHtZ1cHlT1xJgO1bc2vHqvzU4KLVUed8kOAM9YmOdfFNEQiu
         1C2g==
X-Gm-Message-State: AOAM533fchlGv7tiQw/7FiQbSjVeBFhglRIGeRYzu3Usy3dxK6EWQk/f
        Z/xMaSDLH2hllPuVu65ne5CZDwnmiGiGpQ==
X-Google-Smtp-Source: ABdhPJylJeaKaj5vW8WOg+ZeTC8I6v5VQyAN4hw1U4uTH9YJ4N1+rei6OG85K02GLVqZC3CorUAlcd3kAdmtGg==
X-Received: by 2002:a0c:ba27:: with SMTP id w39mr4375455qvf.46.1590072074001;
 Thu, 21 May 2020 07:41:14 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:40 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-3-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 02/22] net: l2tp: deprecate PPPOL2TP_MSG_* in favour of L2TP_MSG_*
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
index 4bd1f55d6377..6418c4d10241 100644
--- a/include/uapi/linux/if_pppol2tp.h
+++ b/include/uapi/linux/if_pppol2tp.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/l2tp.h>
=20
 /* Structure used to connect() the socket to a particular tunnel UDP
  * socket over IPv4.
@@ -90,14 +91,12 @@ enum {
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
2.26.2.761.g0e0b3e54be-goog


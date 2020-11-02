Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C732B2A330B
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 19:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgKBSdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 13:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgKBSdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 13:33:22 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350C6C0617A6;
        Mon,  2 Nov 2020 10:33:22 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id x13so11856857pfa.9;
        Mon, 02 Nov 2020 10:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K2gP+OrgFPL2KLEFKam9Uauc1FNV+0UTOYtpfcBPmJ0=;
        b=KV8aBRenNHEBI+YaEktdR+EPbZdcifZbgo51mzdPFrPl7mj4nJL+2KSOHXRu6APkyQ
         /AcYouZANygDHeifj58J7bd4i9xPf8pn5rlaBECN4WBl74bAP0znNI+euPTM0Xx8anZF
         eC5vQ7i17DXp6Nj1PzV919IsFdL3afMO5tyOq/rmLb0u6Z8WkvXJOQEgzWa0FrayAuUv
         j8mdYb2OwNHkrNLCbLZXmJecYc9BZGVIypDaXfdG0HtueUbc+B/tLuFfFEPlvQO4X+4G
         k8OtoZ8+A7kWmShB6v6WBVvNKnjT5kyiYLWiwJwaQ3SDo4YOJ36UWmRbYQ4euLZ9NrV7
         yoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2gP+OrgFPL2KLEFKam9Uauc1FNV+0UTOYtpfcBPmJ0=;
        b=ZoGJqPmnldhLCDQ8abMVYsI17WWJLPwPeAarqAoCdPKhxVMu2NN0rZbjm30aUJaEol
         yCg1WYc6xawGPqP+GbN6+mDPeXEQjqU9kXKqOOXJmeEC9uy4S8aS02KuTUUSIOpTN7yu
         0Q3q7Vq5n1+WNcciHSC9IiUyvrQDjm87EVAkZtf2TroY7vEYUUfipNOSx7HOovVo2f6b
         KMFbnnnHWUMgXFXZLzDSDDB3ObjY7VdyleghhBY33KhJjTv06d6GiKxXJi+P/eUZAJT4
         UxgM7gki6pv9AK+KJMhckKF82mvOmI6V3jE3dkjUmrGP+Pgbldlruy5a64zN+S6Xcfho
         0BjA==
X-Gm-Message-State: AOAM531lJsPsKN0d6MpmcxS4wSPg9tDeUsclDWZu02tn4/xsfzP48VxZ
        BrCtOAaQYhgWcOBB2G6Xsw==
X-Google-Smtp-Source: ABdhPJxrj7Y+iRxUOxNpoqBGoH+8ihA5+0nKh5ooQAnRficsSFHXmlJ5aeG+/kgQykQUx47K9UIWKQ==
X-Received: by 2002:a17:90a:648:: with SMTP id q8mr4929640pje.176.1604342001667;
        Mon, 02 Nov 2020 10:33:21 -0800 (PST)
Received: from localhost.localdomain (59-125-13-244.HINET-IP.hinet.net. [59.125.13.244])
        by smtp.gmail.com with ESMTPSA id 21sm5706169pfw.105.2020.11.02.10.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 10:33:21 -0800 (PST)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     lee.jones@linaro.org, daniel.vetter@ffwll.ch,
        gregkh@linuxfoundation.org
Cc:     linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v2 1/1] Fonts: Replace discarded const qualifier
Date:   Mon,  2 Nov 2020 13:32:42 -0500
Message-Id: <20201102183242.2031659-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030181822.570402-1-lee.jones@linaro.org>
References: <20201030181822.570402-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

Commit 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in
fonts") introduced the following error when building rpc_defconfig (only
this build appears to be affected):

 `acorndata_8x8' referenced in section `.text' of arch/arm/boot/compressed/ll_char_wr.o:
    defined in discarded section `.data' of arch/arm/boot/compressed/font.o
 `acorndata_8x8' referenced in section `.data.rel.ro' of arch/arm/boot/compressed/font.o:
    defined in discarded section `.data' of arch/arm/boot/compressed/font.o
 make[3]: *** [/scratch/linux/arch/arm/boot/compressed/Makefile:191: arch/arm/boot/compressed/vmlinux] Error 1
 make[2]: *** [/scratch/linux/arch/arm/boot/Makefile:61: arch/arm/boot/compressed/vmlinux] Error 2
 make[1]: *** [/scratch/linux/arch/arm/Makefile:317: zImage] Error 2

The .data section is discarded at link time.  Reinstating acorndata_8x8 as
const ensures it is still available after linking.  Do the same for the
other 12 built-in fonts as well, for consistency purposes.

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Fixes: 6735b4632def ("Fonts: Support FONT_EXTRA_WORDS macros for built-in fonts")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Co-developed-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Changes in v2:
  - Fix commit ID to 6735b4632def in commit message (Russell King
    <linux@armlinux.org.uk>)
  - Add `const` back for all 13 built-in fonts (Daniel Vetter
    <daniel.vetter@ffwll.ch>)
  - Add a Fixes: tag

 lib/fonts/font_10x18.c     | 2 +-
 lib/fonts/font_6x10.c      | 2 +-
 lib/fonts/font_6x11.c      | 2 +-
 lib/fonts/font_6x8.c       | 2 +-
 lib/fonts/font_7x14.c      | 2 +-
 lib/fonts/font_8x16.c      | 2 +-
 lib/fonts/font_8x8.c       | 2 +-
 lib/fonts/font_acorn_8x8.c | 2 +-
 lib/fonts/font_mini_4x6.c  | 2 +-
 lib/fonts/font_pearl_8x8.c | 2 +-
 lib/fonts/font_sun12x22.c  | 2 +-
 lib/fonts/font_sun8x16.c   | 2 +-
 lib/fonts/font_ter16x32.c  | 2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/lib/fonts/font_10x18.c b/lib/fonts/font_10x18.c
index 0e2deac97da0..e02f9df24d1e 100644
--- a/lib/fonts/font_10x18.c
+++ b/lib/fonts/font_10x18.c
@@ -8,7 +8,7 @@
 
 #define FONTDATAMAX 9216
 
-static struct font_data fontdata_10x18 = {
+static const struct font_data fontdata_10x18 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, 0x00, /* 0000000000 */
diff --git a/lib/fonts/font_6x10.c b/lib/fonts/font_6x10.c
index 87da8acd07db..6e3c4b7691c8 100644
--- a/lib/fonts/font_6x10.c
+++ b/lib/fonts/font_6x10.c
@@ -3,7 +3,7 @@
 
 #define FONTDATAMAX 2560
 
-static struct font_data fontdata_6x10 = {
+static const struct font_data fontdata_6x10 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
diff --git a/lib/fonts/font_6x11.c b/lib/fonts/font_6x11.c
index 5e975dfa10a5..2d22a24e816f 100644
--- a/lib/fonts/font_6x11.c
+++ b/lib/fonts/font_6x11.c
@@ -9,7 +9,7 @@
 
 #define FONTDATAMAX (11*256)
 
-static struct font_data fontdata_6x11 = {
+static const struct font_data fontdata_6x11 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
diff --git a/lib/fonts/font_6x8.c b/lib/fonts/font_6x8.c
index 700039a9ceae..e7442a0d183d 100644
--- a/lib/fonts/font_6x8.c
+++ b/lib/fonts/font_6x8.c
@@ -3,7 +3,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data fontdata_6x8 = {
+static const struct font_data fontdata_6x8 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 000000 */
diff --git a/lib/fonts/font_7x14.c b/lib/fonts/font_7x14.c
index 86d298f38505..9cc7ae2e03f7 100644
--- a/lib/fonts/font_7x14.c
+++ b/lib/fonts/font_7x14.c
@@ -8,7 +8,7 @@
 
 #define FONTDATAMAX 3584
 
-static struct font_data fontdata_7x14 = {
+static const struct font_data fontdata_7x14 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 0000000 */
diff --git a/lib/fonts/font_8x16.c b/lib/fonts/font_8x16.c
index 37cedd36ca5e..bab25dc59e8d 100644
--- a/lib/fonts/font_8x16.c
+++ b/lib/fonts/font_8x16.c
@@ -10,7 +10,7 @@
 
 #define FONTDATAMAX 4096
 
-static struct font_data fontdata_8x16 = {
+static const struct font_data fontdata_8x16 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
diff --git a/lib/fonts/font_8x8.c b/lib/fonts/font_8x8.c
index 8ab695538395..109d0572368f 100644
--- a/lib/fonts/font_8x8.c
+++ b/lib/fonts/font_8x8.c
@@ -9,7 +9,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data fontdata_8x8 = {
+static const struct font_data fontdata_8x8 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, /* 00000000 */
diff --git a/lib/fonts/font_acorn_8x8.c b/lib/fonts/font_acorn_8x8.c
index 069b3e80c434..fb395f0d4031 100644
--- a/lib/fonts/font_acorn_8x8.c
+++ b/lib/fonts/font_acorn_8x8.c
@@ -5,7 +5,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data acorndata_8x8 = {
+static const struct font_data acorndata_8x8 = {
 { 0, 0, FONTDATAMAX, 0 }, {
 /* 00 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* ^@ */
 /* 01 */  0x7e, 0x81, 0xa5, 0x81, 0xbd, 0x99, 0x81, 0x7e, /* ^A */
diff --git a/lib/fonts/font_mini_4x6.c b/lib/fonts/font_mini_4x6.c
index 1449876c6a27..592774a90917 100644
--- a/lib/fonts/font_mini_4x6.c
+++ b/lib/fonts/font_mini_4x6.c
@@ -43,7 +43,7 @@ __END__;
 
 #define FONTDATAMAX 1536
 
-static struct font_data fontdata_mini_4x6 = {
+static const struct font_data fontdata_mini_4x6 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/*{*/
 	  	/*   Char 0: ' '  */
diff --git a/lib/fonts/font_pearl_8x8.c b/lib/fonts/font_pearl_8x8.c
index 32d65551e7ed..a6f95ebce950 100644
--- a/lib/fonts/font_pearl_8x8.c
+++ b/lib/fonts/font_pearl_8x8.c
@@ -14,7 +14,7 @@
 
 #define FONTDATAMAX 2048
 
-static struct font_data fontdata_pearl8x8 = {
+static const struct font_data fontdata_pearl8x8 = {
    { 0, 0, FONTDATAMAX, 0 }, {
    /* 0 0x00 '^@' */
    0x00, /* 00000000 */
diff --git a/lib/fonts/font_sun12x22.c b/lib/fonts/font_sun12x22.c
index 641a6b4dca42..a5b65bd49604 100644
--- a/lib/fonts/font_sun12x22.c
+++ b/lib/fonts/font_sun12x22.c
@@ -3,7 +3,7 @@
 
 #define FONTDATAMAX 11264
 
-static struct font_data fontdata_sun12x22 = {
+static const struct font_data fontdata_sun12x22 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	/* 0 0x00 '^@' */
 	0x00, 0x00, /* 000000000000 */
diff --git a/lib/fonts/font_sun8x16.c b/lib/fonts/font_sun8x16.c
index 193fe6d988e0..e577e76a6a7c 100644
--- a/lib/fonts/font_sun8x16.c
+++ b/lib/fonts/font_sun8x16.c
@@ -3,7 +3,7 @@
 
 #define FONTDATAMAX 4096
 
-static struct font_data fontdata_sun8x16 = {
+static const struct font_data fontdata_sun8x16 = {
 { 0, 0, FONTDATAMAX, 0 }, {
 /* */ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 /* */ 0x00,0x00,0x7e,0x81,0xa5,0x81,0x81,0xbd,0x99,0x81,0x81,0x7e,0x00,0x00,0x00,0x00,
diff --git a/lib/fonts/font_ter16x32.c b/lib/fonts/font_ter16x32.c
index 91b9c283bd9c..f7c3abb6b99e 100644
--- a/lib/fonts/font_ter16x32.c
+++ b/lib/fonts/font_ter16x32.c
@@ -4,7 +4,7 @@
 
 #define FONTDATAMAX 16384
 
-static struct font_data fontdata_ter16x32 = {
+static const struct font_data fontdata_ter16x32 = {
 	{ 0, 0, FONTDATAMAX, 0 }, {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x7f, 0xfc, 0x7f, 0xfc,
-- 
2.25.1


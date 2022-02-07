Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0226E4AC23F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245436AbiBGO7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349198AbiBGOlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:41:05 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3917AC0401C8
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:41:05 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 824165C00B9;
        Mon,  7 Feb 2022 09:41:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 09:41:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=6Sg0QBfdCWc/qnMFh06Cg7DrCm33Wh
        KR7jB1stOJ6zo=; b=2CjIyVgVdu0UF7dd1qSXQZSIj0p2E/lKQANGdWh1ZLYLo6
        a/BAsfdSBDunfqJLVxp9C0UtJVYlIPjCZ2dfxmsiRUdt17Hj/V8+Ek9n0VXhBeR6
        N5GSHQEBKj22B6eskeZ3qmx7Yc2+ebN4hMD8XNdvFyM6x2iVZWRO/1izGxjO7SpP
        gfLXMBykHI526L8qGzkP7ClUWpTZmA55VGBbXfLMJnp3mOtPhks4fV2w0aNz/BV7
        Jc6MZhFGBYVkuiLT3ZGuHotiMMcqJ6S2msswLiL7s+7+6JazD2rguB56KU08IYq3
        mVb0PHw4/BcdZjp4c3Vrn9JKyxf4pe5L8vuxwuWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6Sg0QB
        fdCWc/qnMFh06Cg7DrCm33WhKR7jB1stOJ6zo=; b=ma5KsMpNnw/JSf9WpI8y97
        73U2guYlJLaiisqZBZZeBcQ5jbUfTA1CRNqIhDiJOlUOfDT2hAN7BfOV58FizUk/
        kyBu8zGV6si3kZdCQA2f7wtvU1nhv7iC9zqVBtoBqaPNsemVOYdE5ohzd0FkrZzS
        5lhBTEbaDM3LZOEWdwE9qGkmBLdcEBx/mwOIaij3MIUFp0qDutQ9iEl1hr0pST4J
        z5L+woQWx3DVOYj9S4Mix4tY29aWebrKx430SY2FVWmT2E4vdDJHn1aL4XXaks8Q
        EAXq3wC+xspDapsor48e4DCNej9yKgoI8SnNLzYCHe8Yr4JpQFr9U9XUzKI3ExxA
        ==
X-ME-Sender: <xms:gC8BYg5f-YsNjZztw6W-4XQoB-9WqUd2D7WXrvleZztkSMIEX1PMBA>
    <xme:gC8BYh4pcrFdESvrXDmTVUFX2CHRLHzKSK6F7Yd5VdMS86YmuwImkPhDwOSuXT942
    wiZ5QLu7603Ub0Pi7Y>
X-ME-Received: <xmr:gC8BYvfNlAHlNfQ-MBc9KkONTWc7K-Z8vceo1e9DFdSrqIZe50kxcwU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:gC8BYlII_7N4yXrGF7S4JmMkLyYOoarbEE_Uihy7rI3yWPMNhr9TnQ>
    <xmx:gC8BYkL768hnG-FSqWCTKFjNa8aT6TgetL-XkOFs1qRT7OFFscQbSA>
    <xmx:gC8BYmzj9e3x9v2kzSFSBAu-rQxf6-3LrHFINyrpCxmTr77g3g-6tw>
    <xmx:gC8BYo3KNj1-TjxytUXf9Ps0--nC6rQZKHNjJd9RWuFe1EqK0l4s1w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:41:03 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.9 2/2] kbuild: simplify access to the kernel's version
Date:   Mon,  7 Feb 2022 14:40:52 +0000
Message-Id: <20220207144052.235533-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207144052.235533-1-jiaxun.yang@flygoat.com>
References: <20220207144052.235533-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org>

commit 88a686728b3739d3598851e729c0e81f194e5c53 upstream.

Instead of storing the version in a single integer and having various
kernel (and userspace) code how it's constructed, export individual
(major, patchlevel, sublevel) components and simplify kernel code that
uses it.

This should also make it easier on userspace.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[jiaxun.yang@flygoat.com: Stable backport, remove mlx5 part,
fix geth as well.]
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 Makefile                      | 5 ++++-
 drivers/scsi/gdth.c           | 6 +++---
 drivers/usb/core/hcd.c        | 4 ++--
 include/linux/usb/composite.h | 4 ++--
 kernel/sys.c                  | 2 +-
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index c86dfa5b27bb..1b83b7011c7a 100644
--- a/Makefile
+++ b/Makefile
@@ -1148,7 +1148,10 @@ define filechk_version.h
 		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
 	fi;                                                              \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
-	((c) > 255 ? 255 : (c)))'
+	((c) > 255 ? 255 : (c)))';                                       \
+	echo \#define LINUX_VERSION_MAJOR $(VERSION);                    \
+	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL);            \
+	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
 endef
 
 $(version_h): $(srctree)/Makefile FORCE
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 0a767740bf02..3cf78d28ad1d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4497,9 +4497,9 @@ static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
       { 
         gdth_ioctl_osvers osv; 
 
-        osv.version = (u8)(LINUX_VERSION_CODE >> 16);
-        osv.subversion = (u8)(LINUX_VERSION_CODE >> 8);
-        osv.revision = (u16)(LINUX_VERSION_CODE & 0xff);
+        osv.version = LINUX_VERSION_MAJOR;
+        osv.subversion = LINUX_VERSION_PATCHLEVEL;
+        osv.revision = LINUX_VERSION_SUBLEVEL;
         if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
                 return -EFAULT;
         break;
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 2246731d96b0..25825d6cab3c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -125,8 +125,8 @@ static inline int is_root_hub(struct usb_device *udev)
  */
 
 /*-------------------------------------------------------------------------*/
-#define KERNEL_REL	bin2bcd(((LINUX_VERSION_CODE >> 16) & 0x0ff))
-#define KERNEL_VER	bin2bcd(((LINUX_VERSION_CODE >> 8) & 0x0ff))
+#define KERNEL_REL	bin2bcd(LINUX_VERSION_MAJOR)
+#define KERNEL_VER	bin2bcd(LINUX_VERSION_PATCHLEVEL)
 
 /* usb 3.1 root hub device descriptor */
 static const u8 usb31_rh_dev_descriptor[18] = {
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 0ec7185e5ddf..a020f3cbc9f8 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -570,8 +570,8 @@ static inline u16 get_default_bcdDevice(void)
 {
 	u16 bcdDevice;
 
-	bcdDevice = bin2bcd((LINUX_VERSION_CODE >> 16 & 0xff)) << 8;
-	bcdDevice |= bin2bcd((LINUX_VERSION_CODE >> 8 & 0xff));
+	bcdDevice = bin2bcd(LINUX_VERSION_MAJOR) << 8;
+	bcdDevice |= bin2bcd(LINUX_VERSION_PATCHLEVEL);
 	return bcdDevice;
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 2e1def48ed73..1e4f88b12008 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1132,7 +1132,7 @@ static int override_release(char __user *release, size_t len)
 				break;
 			rest++;
 		}
-		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 60;
+		v = LINUX_VERSION_PATCHLEVEL + 60;
 		copy = clamp_t(size_t, len, 1, sizeof(buf));
 		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
 		ret = copy_to_user(release, buf, copy + 1);
-- 
2.35.1


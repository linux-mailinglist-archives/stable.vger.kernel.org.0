Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872B14AC236
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbiBGO7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345796AbiBGOkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:40:11 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF84C0401C3
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:40:10 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F82B5C01A2;
        Mon,  7 Feb 2022 09:40:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 09:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=/ys5YnXg0iHskvgQtTq9BHJ9ds8/CB
        FhUFvRotOP3qA=; b=mpaGVEzQhEi2/i1QA1xNIbazEP4Bd4p4LhpGv/L0e4rUzJ
        PcENwu26OXlPB1Zo3LrjV733sm0D3RR1ULn/PlAm/7DYStXlj0iJjZCRZyTg8vQ3
        MaTKttrjs64OFKHSrQ1DK8OkEDxPaCrZd8tD8cn7pBj9+xwzrlf4P1YngAmjxAiN
        Tgz58cM5v3xLjjzXAU7Xnsb4oySIl3mor7U9DnjkuJzTIJzA/bqtofxWQcx0sw+D
        6tSVS+oY3XoK8gRQb4Zvw78jDrt/lvv12iD3kylXiPpJNhMpwyHkb77Xna9jkHWO
        7e5f9SodV4kOwnEq03IjrPETrXOF4YW09ghFgyzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/ys5Yn
        Xg0iHskvgQtTq9BHJ9ds8/CBFhUFvRotOP3qA=; b=oM/GgFK0/GfWwSljQGDz45
        70+5twT2Bn1zLl2ysT/zzeA06N8lQPiI6kG5mQR4yq+1tEZYQL628vIXfYIlFk4p
        4ILw4AN/qe7KzmfQTUuB6cGW+hlziobIVfqeggNi/45Q8d95ovFWv/Vl+bARkjEu
        0jWajQafjnJqOwZTrp6TGeuIkW0W1NOenNGtVARnId6MLEDkm14ItUjOt20DXXLh
        FPzEGzjgwnPrYTz3h4JYVs/oQBrqQ05PhQvCXnQSjekjYlYotJIxau5L0snJNfAS
        mrpuTm8zADKE7kvWudtrnAlDiGzTTHvJJqqtlZVwpR5SPVYTuSB+ybqX3M8se9RQ
        ==
X-ME-Sender: <xms:Si8BYq2TrXRWnDj-mfQ14ZSneJrTGC6izu0M49yW9JXpAAz8phC6fA>
    <xme:Si8BYtFqBxJ8hxbNq-gIGga1JsJbkZUcrfLDDSduIbncDUDqeKmUZdBYOTEPmVR4z
    SPeFcaKChH2O47lR0I>
X-ME-Received: <xmr:Si8BYi6ZLAWbHD_L29I3lxmrRJAaPQu-OqNRrbGGucMfE_3_9MnLYxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:Si8BYr3456TZp7D8NlIvSVAkQnlAe_rA-pEJlYPbuJbpiqUjAEaD-g>
    <xmx:Si8BYtF6vhCz_-fnaJiUb_N97qExXaiezcYBxA0reSBsfbGeX7xvEQ>
    <xmx:Si8BYk-tBDukPw7LJGnrAKnUF4yDyp0H3R-CYm7yGTQOogk0y79Aiw>
    <xmx:Si8BYtDNUYZecOGLKxlSBI9ZGgeMaT3nfhzc812Q0DTxy2m9660KiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:40:09 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.14 2/2] kbuild: simplify access to the kernel's version
Date:   Mon,  7 Feb 2022 14:39:57 +0000
Message-Id: <20220207143957.235063-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207143957.235063-1-jiaxun.yang@flygoat.com>
References: <20220207143957.235063-1-jiaxun.yang@flygoat.com>
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
[jiaxun.yang@flygoat.com: Stable backport, fix geth as well.]
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 Makefile                                       | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ++--
 drivers/scsi/gdth.c                            | 6 +++---
 drivers/usb/core/hcd.c                         | 4 ++--
 include/linux/usb/composite.h                  | 4 ++--
 kernel/sys.c                                   | 2 +-
 6 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index addf1d22bf83..ebcc9a06ab5d 100644
--- a/Makefile
+++ b/Makefile
@@ -1169,7 +1169,10 @@ define filechk_version.h
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 049d9d19c66d..0622ae358df6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -207,8 +207,8 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
 
 	snprintf(string + strlen(string), remaining_size, "%u.%u.%u",
-		 (u8)((LINUX_VERSION_CODE >> 16) & 0xff), (u8)((LINUX_VERSION_CODE >> 8) & 0xff),
-		 (u16)(LINUX_VERSION_CODE & 0xffff));
+		LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL,
+		LINUX_VERSION_SUBLEVEL);
 
 	/*Send the command*/
 	MLX5_SET(set_driver_version_in, in, opcode,
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index a4473356a9dc..bfd888e72f0f 100644
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
index d634db802fbd..9f8c1bef7c2b 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -126,8 +126,8 @@ static inline int is_root_hub(struct usb_device *udev)
  */
 
 /*-------------------------------------------------------------------------*/
-#define KERNEL_REL	bin2bcd(((LINUX_VERSION_CODE >> 16) & 0x0ff))
-#define KERNEL_VER	bin2bcd(((LINUX_VERSION_CODE >> 8) & 0x0ff))
+#define KERNEL_REL	bin2bcd(LINUX_VERSION_MAJOR)
+#define KERNEL_VER	bin2bcd(LINUX_VERSION_PATCHLEVEL)
 
 /* usb 3.1 root hub device descriptor */
 static const u8 usb31_rh_dev_descriptor[18] = {
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index a865698361c1..21a751e7f142 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -572,8 +572,8 @@ static inline u16 get_default_bcdDevice(void)
 {
 	u16 bcdDevice;
 
-	bcdDevice = bin2bcd((LINUX_VERSION_CODE >> 16 & 0xff)) << 8;
-	bcdDevice |= bin2bcd((LINUX_VERSION_CODE >> 8 & 0xff));
+	bcdDevice = bin2bcd(LINUX_VERSION_MAJOR) << 8;
+	bcdDevice |= bin2bcd(LINUX_VERSION_PATCHLEVEL);
 	return bcdDevice;
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 65701dd2707e..1ba3378bc0e5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1166,7 +1166,7 @@ static int override_release(char __user *release, size_t len)
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


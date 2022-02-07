Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687F74AC230
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 15:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbiBGO7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiBGOib (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:38:31 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F1EC0401C7
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:38:27 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E83AA5C013F;
        Mon,  7 Feb 2022 09:38:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Feb 2022 09:38:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=QZCQguud0P0/CW9U9S7KnK6Iw6ned7
        /r+uOWc/ATU4s=; b=WwUChjnxiDHjSsReNR70UJHCcyygYmE3lQRVcTLPkScHKj
        BdTIuw3+GKTaUaNuJqowV74B6FEdwk2wzr17SUiVqpw++D0kj96Eg606it5yE0cb
        qD2LlQjCilR9YFoJpR/iD8eyzzY+mGVsLW5bMQP7c/8owaley54e1XuvY31+pylW
        66KkSJ65/p5+lTdf64iWxWMeHpN0blQhcGfBz7eqB+bHSdNhhZ1ANgcvI+xhdmdb
        Eu2Y7dJLUXXjTgCBQNjGPgYFQtx+2obtFJm2TwrZKa8kgDwaGiFkJQFvLkTMxAr/
        8DrVuZjX76YHiQYQC/ajIugNGZ9cHbn29SjDj7Ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QZCQgu
        ud0P0/CW9U9S7KnK6Iw6ned7/r+uOWc/ATU4s=; b=ns0ibQ2HEKKabFmCNj4XON
        DecXgplazVQbjXcRVXslB1KTsuB8YXfQGfKtifjsAkqCCHueBOHQ3Aum0r2z4rkm
        EHonwCR1y59GIrPPjjj0jRmcJIGD8C71qdkTKSZ8VvBjfgU55VNNvBWXzg7lLl2l
        rxyItNFAPvfU0WS4vYIZrDEUNwAjRHuNEqVJMpB1MFHlPP5xqTAFgec8WM/dtGsA
        sMKi6MTKE1RMcj8asyY9ycndlEN067f3vHOiMNS7jqId5Jt76uH60L8cTeG/uVhk
        yAE7zFDw7MjbwbcHBrASYB6t4Mk0GEpfiR2Oo5ilC2kwi6wXl+e0aFXAqEMoL4wA
        ==
X-ME-Sender: <xms:4i4BYholwDD_1E6WKW_nU7KYbBd8scHH8K5FOaiCI6WzyuxkYWj-uA>
    <xme:4i4BYjpEE2tYOF0FTXMR-hX_uXDm9fZlgIyfsYmaifXRxI7ujCJBTwsdPTmbW28Fm
    5Ba6aCtIa4X67D6rTY>
X-ME-Received: <xmr:4i4BYuOAWA8V6lp6WEcJ58wuX20Z4hNy5x7snrSqECZYWCbMBtaAiJs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejiefhgfetleekleffudektdehvedujedvgeekkeejfefhhffhtedu
    tefgtdffueenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:4i4BYs4-ovwrE7j93K_FOVurUyPuGivx09gTraX3Fr3WCDk4cS1Wpw>
    <xmx:4i4BYg6WrRs-czkoqQCKub_Yqamv9k_96A7FsxITq5jWkFPXkpN4rQ>
    <xmx:4i4BYkgUiLe7DJ8JLJWxH0NuLCNQzMJ78EDzyq0qaqSqzqL3YeVMNw>
    <xmx:4i4BYum6M7kq2XS63R587hYC44zpFIq3Z1Efnt9m-T_AlaPxqMGzWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:38:25 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.19 2/2] kbuild: simplify access to the kernel's version
Date:   Mon,  7 Feb 2022 14:38:14 +0000
Message-Id: <20220207143814.234615-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207143814.234615-1-jiaxun.yang@flygoat.com>
References: <20220207143814.234615-1-jiaxun.yang@flygoat.com>
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
index ab70e3305a1b..744b89418a28 100644
--- a/Makefile
+++ b/Makefile
@@ -1165,7 +1165,10 @@ define filechk_version.h
 		expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
 	fi;                                                              \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
-	((c) > 255 ? 255 : (c)))'
+	((c) > 255 ? 255 : (c)))';                                       \
+	echo \#define LINUX_VERSION_MAJOR $(VERSION);                    \
+	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL);            \
+	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
 endef
 
 $(version_h): FORCE
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a2b25afa2472..4f0b4af93366 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -214,8 +214,8 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
 
 	snprintf(string + strlen(string), remaining_size, "%u.%u.%u",
-		 (u8)((LINUX_VERSION_CODE >> 16) & 0xff), (u8)((LINUX_VERSION_CODE >> 8) & 0xff),
-		 (u16)(LINUX_VERSION_CODE & 0xffff));
+		LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL,
+		LINUX_VERSION_SUBLEVEL);
 
 	/*Send the command*/
 	MLX5_SET(set_driver_version_in, in, opcode,
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 16709735b546..57e33d8d8b6b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4498,9 +4498,9 @@ static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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
index 11cc189bf105..42b551e6603f 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -113,8 +113,8 @@ static inline int is_root_hub(struct usb_device *udev)
  */
 
 /*-------------------------------------------------------------------------*/
-#define KERNEL_REL	bin2bcd(((LINUX_VERSION_CODE >> 16) & 0x0ff))
-#define KERNEL_VER	bin2bcd(((LINUX_VERSION_CODE >> 8) & 0x0ff))
+#define KERNEL_REL	bin2bcd(LINUX_VERSION_MAJOR)
+#define KERNEL_VER	bin2bcd(LINUX_VERSION_PATCHLEVEL)
 
 /* usb 3.1 root hub device descriptor */
 static const u8 usb31_rh_dev_descriptor[18] = {
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 2040696d75b6..764f58b74f26 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -573,8 +573,8 @@ static inline u16 get_default_bcdDevice(void)
 {
 	u16 bcdDevice;
 
-	bcdDevice = bin2bcd((LINUX_VERSION_CODE >> 16 & 0xff)) << 8;
-	bcdDevice |= bin2bcd((LINUX_VERSION_CODE >> 8 & 0xff));
+	bcdDevice = bin2bcd(LINUX_VERSION_MAJOR) << 8;
+	bcdDevice |= bin2bcd(LINUX_VERSION_PATCHLEVEL);
 	return bcdDevice;
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index d0663f8e6fb8..8677854e2690 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1224,7 +1224,7 @@ static int override_release(char __user *release, size_t len)
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


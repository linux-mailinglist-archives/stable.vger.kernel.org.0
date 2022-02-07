Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208E74AC242
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354509AbiBGO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382611AbiBGOhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:37:01 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0981C0401C1
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:36:59 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A6EDB5C0126;
        Mon,  7 Feb 2022 09:36:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Feb 2022 09:36:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=+EH8ky//euJiWV5c07rjXp/+TBblU5mjwnoLedBz2D8=; b=MoVAp
        FZmWKWkd6Dj9EDL/5jEJU+0fjbBU0YaT5nP3rByj5l3DF2HxjM+sYs0645lWft7O
        Oe3IjrKos+CZlh1iUow2i85qishSOMIJEcvvv1d8t78dj9WrSvGXSEgu7VRNf6Bn
        OnawgwI8GUWyVtIfH2ICDo46lEc8XmnBjWwON0a5kL3RoNJ5OWvNtSNYJdOVHlf4
        d5xWEFEaG03DvAMSUMEFXb29SJbNZe6obE+TljkEDuWJZnLNZD+fE98JiznnPt1z
        MODwNXEbw3r7yGTKHnXZpkD1GWKxewgI91o4M6apsKh7FQLgyRDjLwWCHQN5FWqY
        crl5nGbXD0lUmU6PQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=+EH8ky//euJiWV5c07rjXp/+TBblU
        5mjwnoLedBz2D8=; b=jlQr63+Di4Q0Lmg997f8X8h0Evg5PpbBBOaf6Ie0RXyv6
        Q7rOs/lwf0oXkS/OBvCmRk6T0V5tTMEBPl8xBsErwBuDLKoWgFbCzkTZDH/Kid7w
        5sCpvXpSvJ9fb7p0cC0Lszl3SjKXRGVyWfC2u/9qNRmLxDDmJZAdsAgXaO9VJGUN
        vGCHZWRdVL3LWeIAibFJM5+EG6vbC/odlK2wPYisUQaC/7KoBiPpEL0RxzzhHSdk
        zz7+GieNhOVL1XhRhr3cEMCUKjM99tGRbdPGs83GU2qFgnvA93JWer3NoEe1pp1p
        eFb3nFoaNNEBx0FLMYx9AOV0s7ciiQ7UDPwvMA4OQ==
X-ME-Sender: <xms:iS4BYgAxJuh8lKSWwkNKGTT-B7YLIEp3yryAm5yXjpbbugtC98lStg>
    <xme:iS4BYij5PpxBFo5xYJ3GyQqxJwf2z33nMCI2hSTByj8eoDuiKHqh4SbP6l27rZY_N
    zLBXZ_tYqS9zkvbqio>
X-ME-Received: <xmr:iS4BYjle6nL8iN29oBMFZdmQkyCsmvuqsNHBIJO8JYqomOqPW43pcK4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomheplfhirgiguhhnucgj
    rghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtffrrg
    htthgvrhhnpefhjedtkedtueehtdeifeetkeevffetjeetfeegkeevgefftedvudfgleei
    hfdtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:iS4BYmzA4A1aCDXwX6UOK-wZgiAxbykfmOTV5423BAgPbDUjjYXvxA>
    <xmx:iS4BYlS6Zh0I_2JM7NG8f9SRdCf9QhePS0oxw3p85wfDYJNcn7mL-A>
    <xmx:iS4BYhZqe-63RTf3O5UC0T7-OVXEI3tXVC4L3kiNkh1kDLSzcoMJqA>
    <xmx:iS4BYne8okkd_A6pDLAEpKdzd8HGFNFMz2dcY7zr02cSe_ZVNlf1Ug>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:36:56 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-5.4,5.10] kbuild: simplify access to the kernel's version
Date:   Mon,  7 Feb 2022 14:36:43 +0000
Message-Id: <20220207143643.234233-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
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
index 324939b64d7b..92dd066edd44 100644
--- a/Makefile
+++ b/Makefile
@@ -1183,7 +1183,10 @@ define filechk_version.h
 		expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + $(SUBLEVEL)); \
 	fi;                                                              \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) +  \
-	((c) > 255 ? 255 : (c)))'
+	((c) > 255 ? 255 : (c)))';                                       \
+	echo \#define LINUX_VERSION_MAJOR $(VERSION);                    \
+	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL);            \
+	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL)
 endef
 
 $(version_h): PATCHLEVEL := $(if $(PATCHLEVEL), $(PATCHLEVEL), 0)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f2657cd3ffa4..d57d0bc8d933 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -230,8 +230,8 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
 	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
 
 	snprintf(string + strlen(string), remaining_size, "%u.%u.%u",
-		 (u8)((LINUX_VERSION_CODE >> 16) & 0xff), (u8)((LINUX_VERSION_CODE >> 8) & 0xff),
-		 (u16)(LINUX_VERSION_CODE & 0xffff));
+		LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL,
+		LINUX_VERSION_SUBLEVEL);
 
 	/*Send the command*/
 	MLX5_SET(set_driver_version_in, in, opcode,
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index fe03410268e6..3ff0326f22fd 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3907,9 +3907,9 @@ static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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
index 39203f2ce6a1..323f210090bf 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -110,8 +110,8 @@ DECLARE_WAIT_QUEUE_HEAD(usb_kill_urb_queue);
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
index b075fe84eb5a..0278461760b0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1228,7 +1228,7 @@ static int override_release(char __user *release, size_t len)
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


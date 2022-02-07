Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291814ABF36
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 14:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349306AbiBGNEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442694AbiBGMV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 07:21:29 -0500
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 04:11:00 PST
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763C3C03FEEF
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 04:11:00 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B875B32023EF;
        Mon,  7 Feb 2022 06:52:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 07 Feb 2022 06:52:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=KG+wo0OK3gsN135WwnZ265e0wRbTaDjWBHKrYM2Gl38=; b=vAokf
        8DlHBPOaqdljZVqelGm607Bxyx93JfPivu+WG7kAO36ZTo+iZWIF1Y04wy6mEPxi
        BmQH1zjgnVFv8s0jSnoJONYEpwZJmoC25vjG4OB13g72BqCnbSpq62gApznZSYc6
        o3okCre83rrLFGzoypY+yQHa74vyUi2zI1I5HLPLHUlyvZbrLCynaoZurtSuIylx
        kdDr62b9m20wMDstnbHW2J0AGKA4tuFsqYvdjBY+fK8RmOwKq0kfyW+CHu3mZ7zX
        R8T55RFhYlUArjkRodLjQqbvsej1MnQkak07IO6sfaSIPEMZGwwod73xy/eTnxxX
        xtI/xON9PJ02dqdVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=KG+wo0OK3gsN135WwnZ265e0wRbTa
        DjWBHKrYM2Gl38=; b=Fyg9ZKvPmJc6gnLfknb0ycxPWgWsd3dnd57mW1WYWWLBw
        zQsA+0/cEu+U3tCQ6cv+Pcme6UuDagzJk267OiFqWmxvhDqGsi9k9rs3eJCUZibD
        FibqNEUlfRQj9Cw/dYJumDi/y4eyZsfvqONm+GpXr6MdYZYwaCbv0J6eOFAjQo0s
        Ez+tPVwCVHUQ2g5ZUmUM/AtzoaALlAx/7tXj2SYgKcCVvMbFvq6e1cV2oZsh0OYV
        q9eRWbl5bStLm3IO2sxMU5qO6us/9ltM6w9JY3G22xUwX5YXDwP5Ev0YwIKEzOWP
        KlgsADRiyvNjcnkaAUjD2XuHlBkg/iQ/038k8ApdA==
X-ME-Sender: <xms:-wcBYgMx1QXkh0a0pQknPMJIWDIhL2ru553-5C56vx4jhO_hl7aegw>
    <xme:-wcBYm-siBbkTrSEP6hTpSFdQ052QicrBGIzufMhNIppOe2kYtlvohmqRE5n-2-ZY
    ScHEK4oNlgIoNBvvNM>
X-ME-Received: <xmr:-wcBYnR90ZKxrYqN2Kov-UbCBFhIX63tmPd9pyDDdj5FbXUG2nO5JlY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhl
    hihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepkeduffeikeejleduudfhffeije
    fhhfejhedtfeefjeejgfefjeevfffgueeguddvnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:-wcBYosOvD3DfhnstGWvuGlwIjDZSYGtakOhbF5ZPYg3cUqXS02aiw>
    <xmx:-wcBYofXimzto-3eedJAQFf7zzSrUf58nYr0YAP_7NC6IeFxusWohQ>
    <xmx:-wcBYs2qGzilhlrqSqzyJn2jxht3tQwlDaISraD78JvmImUqHj6l5w>
    <xmx:-wcBYpquEPb0VOiu3kRBlPitvLYIITpzAUj-ABPD6NUDgwtuMXC-0w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 06:52:26 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [RFC PATCH for-stable] kbuild: Define LINUX_VERSION_{MAJOR,PATCHLEVEL,SUBLEVEL}
Date:   Mon,  7 Feb 2022 11:52:12 +0000
Message-Id: <20220207115212.217744-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the SUBLEVEL overflowed LINUX_VERSION, we have no reliable
way to tell the current SUBLEVEL in source code.

This brings significant difficulties for backport works to deal
with changes in stable releases.

Define those macros so we can continue to get proper SUBLEVEL
in source without breaking stable ABI by refining KERNEL_VERSION
bit fields.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
For some context: https://lore.kernel.org/backports/bb0ae37aa770e016463706d557fec1c5205bc6a9.camel@sipsolutions.net/T/#t
---
 Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 99d37c23495e..8132f81d94d8 100644
--- a/Makefile
+++ b/Makefile
@@ -1142,7 +1142,10 @@ endef
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
 	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
-	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
+	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'; \
+	echo \#define LINUX_VERSION_MAJOR $(VERSION); \
+	echo \#define LINUX_VERSION_PATCHLEVEL $(PATCHLEVEL); \
+	echo \#define LINUX_VERSION_SUBLEVEL $(SUBLEVEL);)
 endef
 
 $(version_h): $(srctree)/Makefile FORCE
-- 
2.35.1


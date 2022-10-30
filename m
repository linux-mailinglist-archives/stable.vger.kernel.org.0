Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED6612899
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 08:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiJ3HNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 03:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJ3HNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 03:13:22 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBC3EA8;
        Sun, 30 Oct 2022 00:13:18 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 55F655C00A5;
        Sun, 30 Oct 2022 03:13:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 30 Oct 2022 03:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1667113998; x=1667200398; bh=LGUTbFYKx/IAmswm/E+Mt+qNJPB4ZgOwy8T
        Xo7c4Lqc=; b=dLdYbx3R3u+KO33HPmxYo+LStlRoMXxR3d1Q4x8Ljspm2tu90M7
        ujUaqSfOX0Py8Yb1W4jQK0Aj41sZKEF9NsFuJsU00AiIjvg3Q7EloGVNrbXJykEk
        IWAh7wGjoUqPbOO6egHuVVW9GRq6Y+p2c6gZjndP/rzTgiNMeI4Uokhe9yq2juyn
        trQbNOZwzz4HK4j+UiW6e0DWjyeTJVeOPkdQbRps2zzVBKByEBZsUAm4wbfGCcR1
        367j5uvwlR0fl2ryrhEx3Me26uuSJ1ePbMoi2eSwxe1N1z6X8ymzoxNE+PoT8iKN
        pP3QwOLJiJJmNkDoK/wBD2c1+i/p0Oo3/cQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667113998; x=1667200398; bh=LGUTbFYKx/IAm
        swm/E+Mt+qNJPB4ZgOwy8TXo7c4Lqc=; b=oj7ZEzf8U2UZUzhqThJzZdNGbAik7
        PXGDGrFlDC48ZZGP+ZqeofDn4fim4WJKsmRzqLey5ORU4e+DaYDZZu8/72NLUpR6
        ZAbliWxkm2ZUFxhq/du6FaeX9Xjx9dtzxxTupb/CCt1uSGG4mVs4+Bd7SoNSw+vk
        nPuH1Qx2ezkBWiNhlOodfVnRhPn8N7jbjGBYznCnze4xrSXog8qbwwIYrLccuAz5
        K3STQ9NZuFeHT+2gPL3zHIM8Q09710WPR5rtlfthjp1CTLktT8h061dmJaLr80i/
        XjKDIaB7L1J9a2nmosH36MTFtBylSSz5hI3sIdPPmshHIYLzkBdMjH45g==
X-ME-Sender: <xms:DSReYxsNi6xDc9WWA8xVra5LkwJCzb1pXUOl4Xjldk1zAZTJfL8Ejw>
    <xme:DSReY6fy1CsJ723k4T63JEO6Iv1l8vI1oXWvBBfL7qH_Chpr5YmONTsspWdkCm87Z
    aZyaxfEmljnCXo>
X-ME-Received: <xmr:DSReY0yzAXdZy-LmwtNVF1WRTZKwzhPTHL5S6YedlutuhIOQjKP31o55x_oP4KM6hdGZGd_xDBjD>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdelgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnheptedtgeduleekleevjeehhfdvkefh
    veeuvdevtdduhffhvdeltdegtdfgkeduudegnecuffhomhgrihhnpehgihhthhhusgdrtg
    homhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtg
    homh
X-ME-Proxy: <xmx:DSReY4MLw6kdj0O68nzgpG_nUnozF3trz9zdnK22tnniuRFaKXI_tA>
    <xmx:DSReYx9da_e9cj06ZisW_gQi7Vy8N1TpMzRhM0X9hpC8UG0H45DJpA>
    <xmx:DSReY4Uc2wnjKcxrQBB4Yd338wcPAbp4-JNaJQc75pu1DYSItwdoZQ>
    <xmx:DiReY9QG9DBkWaxf9hf4EExrvEP58XZKD9zZ3w4V7o3SHh0jE_HCyA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Oct 2022 03:13:16 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Subject: [PATCH 2/3] xen/gntdev: Prevent leaking grants
Date:   Sun, 30 Oct 2022 03:12:42 -0400
Message-Id: <20221030071243.1580-3-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221030071243.1580-1-demi@invisiblethingslab.com>
References: <20221030071243.1580-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "M. Vefa Bicakci" <m.v.b@runbox.com>

commit 0991028cd49567d7016d1b224fe0117c35059f86 upstream.

Prior to this commit, if a grant mapping operation failed partially,
some of the entries in the map_ops array would be invalid, whereas all
of the entries in the kmap_ops array would be valid. This in turn would
cause the following logic in gntdev_map_grant_pages to become invalid:

  for (i = 0; i < map->count; i++) {
    if (map->map_ops[i].status == GNTST_okay) {
      map->unmap_ops[i].handle = map->map_ops[i].handle;
      if (!use_ptemod)
        alloced++;
    }
    if (use_ptemod) {
      if (map->kmap_ops[i].status == GNTST_okay) {
        if (map->map_ops[i].status == GNTST_okay)
          alloced++;
        map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
      }
    }
  }
  ...
  atomic_add(alloced, &map->live_grants);

Assume that use_ptemod is true (i.e., the domain mapping the granted
pages is a paravirtualized domain). In the code excerpt above, note that
the "alloced" variable is only incremented when both kmap_ops[i].status
and map_ops[i].status are set to GNTST_okay (i.e., both mapping
operations are successful).  However, as also noted above, there are
cases where a grant mapping operation fails partially, breaking the
assumption of the code excerpt above.

The aforementioned causes map->live_grants to be incorrectly set. In
some cases, all of the map_ops mappings fail, but all of the kmap_ops
mappings succeed, meaning that live_grants may remain zero. This in turn
makes it impossible to unmap the successfully grant-mapped pages pointed
to by kmap_ops, because unmap_grant_pages has the following snippet of
code at its beginning:

  if (atomic_read(&map->live_grants) == 0)
    return; /* Nothing to do */

In other cases where only some of the map_ops mappings fail but all
kmap_ops mappings succeed, live_grants is made positive, but when the
user requests unmapping the grant-mapped pages, __unmap_grant_pages_done
will then make map->live_grants negative, because the latter function
does not check if all of the pages that were requested to be unmapped
were actually unmapped, and the same function unconditionally subtracts
"data->count" (i.e., a value that can be greater than map->live_grants)
from map->live_grants. The side effects of a negative live_grants value
have not been studied.

The net effect of all of this is that grant references are leaked in one
of the above conditions. In Qubes OS v4.1 (which uses Xen's grant
mechanism extensively for X11 GUI isolation), this issue manifests
itself with warning messages like the following to be printed out by the
Linux kernel in the VM that had granted pages (that contain X11 GUI
window data) to dom0: "g.e. 0x1234 still pending", especially after the
user rapidly resizes GUI VM windows (causing some grant-mapping
operations to partially or completely fail, due to the fact that the VM
unshares some of the pages as part of the window resizing, making the
pages impossible to grant-map from dom0).

The fix for this issue involves counting all successful map_ops and
kmap_ops mappings separately, and then adding the sum to live_grants.
During unmapping, only the number of successfully unmapped grants is
subtracted from live_grants. The code is also modified to check for
negative live_grants values after the subtraction and warn the user.

Link: https://github.com/QubesOS/qubes-issues/issues/7631
Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Acked-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221002222006.2077-2-m.v.b@runbox.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/xen/gntdev.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 8cf9f2074c5d57bff81364d7d6a70b0007a85e44..62a65122c73fbfe673405ce90a53c5f364b75082 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -372,8 +372,7 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 	for (i = 0; i < map->count; i++) {
 		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-			if (!use_ptemod)
-				alloced++;
+			alloced++;
 		} else if (!err)
 			err = -EINVAL;
 
@@ -382,8 +381,7 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 
 		if (use_ptemod) {
 			if (map->kmap_ops[i].status == GNTST_okay) {
-				if (map->map_ops[i].status == GNTST_okay)
-					alloced++;
+				alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
 			} else if (!err)
 				err = -EINVAL;
@@ -399,8 +397,14 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int i;
 	struct gntdev_grant_map *map = data->data;
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
+	int successful_unmaps = 0;
+	int live_grants;
 
 	for (i = 0; i < data->count; i++) {
+		if (map->unmap_ops[offset + i].status == GNTST_okay &&
+		    map->unmap_ops[offset + i].handle != -1)
+			successful_unmaps++;
+
 		WARN_ON(map->unmap_ops[offset+i].status &&
 			map->unmap_ops[offset+i].handle != -1);
 		pr_debug("unmap handle=%d st=%d\n",
@@ -408,6 +412,10 @@ static void __unmap_grant_pages_done(int result,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = -1;
 		if (use_ptemod) {
+			if (map->kunmap_ops[offset + i].status == GNTST_okay &&
+			    map->kunmap_ops[offset + i].handle != -1)
+				successful_unmaps++;
+
 			WARN_ON(map->kunmap_ops[offset+i].status &&
 				map->kunmap_ops[offset+i].handle != -1);
 			pr_debug("kunmap handle=%u st=%d\n",
@@ -416,11 +424,15 @@ static void __unmap_grant_pages_done(int result,
 			map->kunmap_ops[offset+i].handle = -1;
 		}
 	}
+
 	/*
 	 * Decrease the live-grant counter.  This must happen after the loop to
 	 * prevent premature reuse of the grants by gnttab_mmap().
 	 */
-	atomic_sub(data->count, &map->live_grants);
+	live_grants = atomic_sub_return(successful_unmaps, &map->live_grants);
+	if (WARN_ON(live_grants < 0))
+		pr_err("%s: live_grants became negative (%d) after unmapping %d pages!\n",
+		       __func__, live_grants, successful_unmaps);
 
 	/* Release reference taken by __unmap_grant_pages */
 	gntdev_put_map(NULL, map);
-- 
2.38.1

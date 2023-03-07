Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C406AEC7C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjCGRzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjCGRzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:01 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC09DA6BF7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:49:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 23-20020a250b17000000b00a1f7de39bf5so14919402ybl.19
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 09:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678211395;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XuSnV7OCpkIAM2G9k6sd6gSSsUR3Bk9DEqfZVzHtRo=;
        b=ePwD+igYzYQ4J080ctGnJwGVDE+FojvFUYvVAdlQOEJZhsjk8nxoA/e7j+XYn5QgHS
         A/AXIYdVXHTpxErZ1ODdT+4+p68qLAfJ1t3wnF1+l2p4qNVgMhjZtCzq0ndqYq74UHD0
         4DSmVivtQqURbq8C56k1X/UUy0T+t8arlwAVtVIY/BknlQ5qQydKxOJWidT7cXeXsgTr
         Me9QGAoTWTbJ1us6RucLR4r2UMVSWZ/PKsivoVvJd0d13iDlqhqYuz+sqTK0nseAmnDL
         CTkCkpyvKw0e5xYSgpum9bmF2LIU7Zp8iC6cBVacjdmiGPnJKwXuZxGQvFb3vrBkHwzw
         p7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211395;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1XuSnV7OCpkIAM2G9k6sd6gSSsUR3Bk9DEqfZVzHtRo=;
        b=qI9ENDhp0VDtADEgGTnMbFw2um6PQ1ZqiR6xaldO11MN38pekxqGkObkpDNvg/D+/k
         72A1XSXTITzLmdX56DDP4le8SDs/hgwswUXysmMZNCg+XE/8/AX7eSbkDqCJMWagHHdt
         lr6yFnXyC61x8mL6JmZv4Mcq7qP5fsMY2mTdF45NPS3pc35Q3SOFNdq+eGDAlJaGarhe
         J6lwLWcn8hMgYVLrqrFLRx0WiNmsRp0lMK5Zqmx50ACOF9UA97tSFjMNEujuahNW8ogT
         yuaY1kSNofiAUCcvX6ZR+24IPs6m8a4lPrrqR6uRteUUg593soIvOqUHD4bR5Fbr7IOq
         k6lg==
X-Gm-Message-State: AO0yUKWl0RE6+raUYEwuUWDb10W7EGsZj5iXJRk7TVFleFcMUDVxH5/G
        QdORjgLWqk0w59jfUeKZPZaDH+Xfal3fLLoI8bBVEUw07ZUToUaEDMAGaZZgXPTuzsdF8j57Af3
        S7iN2M8PIxhvDPOav5sa4vH0aAOEy9qwm3svc2iNvyXKT3E113jhDqg==
X-Google-Smtp-Source: AK7set86NDPpd8KUjZ/3NMAfVxN/169u4yHBV8Hoz3oBmbiPqg+JYJf7ksn1n17FAFnhgiYFBVCyEFE=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:2f35:422b:c5cb:f70d])
 (user=pcc job=sendgmr) by 2002:a0d:d247:0:b0:538:77bb:86c5 with SMTP id
 u68-20020a0dd247000000b0053877bb86c5mr4ywd.127.1678211394627; Tue, 07 Mar
 2023 09:49:54 -0800 (PST)
Date:   Tue,  7 Mar 2023 09:49:25 -0800
In-Reply-To: <20230307174925.3613182-1-pcc@google.com>
Message-Id: <20230307174925.3613182-2-pcc@google.com>
Mime-Version: 1.0
References: <1678182267252151@kroah.com> <20230307174925.3613182-1-pcc@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Subject: [PATCH 6.1.y 2/2] arm64: Reset KASAN tag in copy_highpage with HW
 tags only
From:   Peter Collingbourne <pcc@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Collingbourne <pcc@google.com>,
        "=?UTF-8?q?Kuan-Ying=20Lee=20=28=E6=9D=8E=E5=86=A0=E7=A9=8E=29?=" 
        <Kuan-Ying.Lee@mediatek.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During page migration, the copy_highpage function is used to copy the
page data to the target page. If the source page is a userspace page
with MTE tags, the KASAN tag of the target page must have the match-all
tag in order to avoid tag check faults during subsequent accesses to the
page by the kernel. However, the target page may have been allocated in
a number of ways, some of which will use the KASAN allocator and will
therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
update the target page's KASAN tag to match the source page.

We ended up unintentionally fixing this issue as a result of a bad
merge conflict resolution between commit e059853d14ca ("arm64: mte:
Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
preserved a tag reset for PG_mte_tagged pages which was considered to be
unnecessary at the time. Because SW tags KASAN uses separate tag storage,
update the code to only reset the tags when HW tags KASAN is enabled.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/If303d8a709438d3ff5af5fd8570=
6505830f52e0c
Reported-by: "Kuan-Ying Lee (=E6=9D=8E=E5=86=A0=E7=A9=8E)" <Kuan-Ying.Lee@m=
ediatek.com>
Cc: <stable@vger.kernel.org> # 6.1
Fixes: 20794545c146 ("arm64: kasan: Revert "arm64: mte: reset the page tag =
in page->flags"")
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20230215050911.1433132-1-pcc@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
(cherry picked from commit e74a68468062d7ebd8ce17069e12ccc64cc6a58c)
---
 arch/arm64/mm/copypage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 731d8a35701e..6dbc822332f2 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -22,7 +22,8 @@ void copy_highpage(struct page *to, struct page *from)
 	copy_page(kto, kfrom);
=20
 	if (system_supports_mte() && page_mte_tagged(from)) {
-		page_kasan_tag_reset(to);
+		if (kasan_hw_tags_enabled())
+			page_kasan_tag_reset(to);
 		mte_copy_page_tags(kto, kfrom);
 		set_page_mte_tagged(to);
 	}
--=20
2.40.0.rc0.216.gc4246ad0f0-goog


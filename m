Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907644D4DAD
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbiCJPy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 10:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiCJPy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 10:54:57 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747E21162BE;
        Thu, 10 Mar 2022 07:53:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so6535974pjd.1;
        Thu, 10 Mar 2022 07:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgabLxCCybdI64zTvKRw4q5XUush958IsLoo2XJRLSs=;
        b=qgplTiH04GPgsGK9xoHOnHMvLwZWSluIHSFvu/yGr9aDgmPT54QMxkJw/tT+J57Fpc
         VoLNxWy3k8tpCxMHml+Z7oZQ2ANhM/r/+6wVCeo37FG/nBl4daOD5JzDgHttiPV/huDf
         cijPSpXS6A19XoS3QjhktavZmxuFKKNvhR5IPtaG/+3apheTe3R1+2AGjW78At3E0NlP
         8xLoQNLWz6DqPq9GPVAjBJmupvaRZitXV9o05pc3Qr+vkVUCJIcgMfSPm5AaA83vIMnY
         w7VdOwbYslBqm6/m1QYApL8hLyJYLy/mgfzIzgdfBtGtoQwWmGljYnIET6O7BTdiTILh
         dE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgabLxCCybdI64zTvKRw4q5XUush958IsLoo2XJRLSs=;
        b=hRwibzVGqkS56DIGvHVG4b4hWLc7z2oDpje4+j7udoT7AHF+rWx2JYo3NsuulBET3Y
         iClcUdHLVitGRcJyPuXRmrhwj5uS0w9jKUW+J8HKg30xZ1uAbCbYvqyzvMbuVQS1YGal
         Vy4St9j4oFop3hVGyiCRRS0TyDd5g5VmbS2mKeXhFm0AfifHudrzq92gB4KnbJK/AsfE
         NZ/HX8NrouyCSCZr1nbyaYqpaEttZwZciG4kPGvQhmJW341pFF9CHS5gkBAnx4tcrMml
         L3jWcVNoMYoEzNmJ2u3ZAsI1XK7Cndkaxn/8vU67q0YQdnKHi0XSHW78DD4MFu5I9Yxi
         v+JA==
X-Gm-Message-State: AOAM532Ans+ZysrIKYpX6XSSm+pO4nyH+qpZHLA4d0KLsa5BtJnpYua/
        XHDZJi4Iv5y5LS1V+aDsxB9uHRmoGwU=
X-Google-Smtp-Source: ABdhPJw9iBQ2BXozpULtXIOnC+gl3sX+BxNz4NL98Nf8SjShflZKc3mi8c2OOVkr25XzTOeaMJz3Ew==
X-Received: by 2002:a17:90a:3e42:b0:1bf:53ce:f1ef with SMTP id t2-20020a17090a3e4200b001bf53cef1efmr16647773pjm.33.1646927634855;
        Thu, 10 Mar 2022 07:53:54 -0800 (PST)
Received: from localhost.localdomain ([119.28.83.143])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0010cb00b004e1b76b09c0sm7441904pfu.74.2022.03.10.07.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:53:54 -0800 (PST)
From:   Hengqi Chen <hengqi.chen@gmail.com>
To:     bpf@vger.kernel.org
Cc:     hengqi.chen@gmail.com, stable@vger.kernel.org
Subject: [PATCH bpf-next] bpf: Fix comment for helper bpf_current_task_under_cgroup()
Date:   Thu, 10 Mar 2022 23:53:35 +0800
Message-Id: <20220310155335.1278783-1-hengqi.chen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the descriptions of the return values of helper
bpf_current_task_under_cgroup().

Fixes: c6b5fb8690fa ("bpf: add documentation for eBPF helpers (42-50)")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
---
 include/uapi/linux/bpf.h       | 4 ++--
 tools/include/uapi/linux/bpf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bc23020b638d..374db485f063 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2302,8 +2302,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- *		* 0, if current task belongs to the cgroup2.
- *		* 1, if current task does not belong to the cgroup2.
+ *		* 1, if current task belongs to the cgroup2.
+ *		* 0, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bc23020b638d..374db485f063 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2302,8 +2302,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- *		* 0, if current task belongs to the cgroup2.
- *		* 1, if current task does not belong to the cgroup2.
+ *		* 1, if current task belongs to the cgroup2.
+ *		* 0, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
--
2.30.2

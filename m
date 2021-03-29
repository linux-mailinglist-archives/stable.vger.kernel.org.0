Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481F734C082
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 02:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhC2AN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 20:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhC2ANc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 20:13:32 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206DAC061756
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 17:13:32 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so10680831otk.5
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 17:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=bC4DZg6A7Apvgfjj8/7c1Q7KWSOL04oIv544oOvDzxs=;
        b=mvH9G9j3xBjpfwPLvah4sYZKNNvia3W4A8hu9ZrmsB7XXDghA/StvTzyWaAjALefE7
         wfUSOVJXeXMnbWD9bMLk/lO1NMAev8R99A7BP5rKZs6Q/Q8v0sVXy0+lwrnSfHEQWrZA
         auJOA69yDBp4rdct2kD1wQ3fdsstBr32B0PqoLl2126q6VB0/p6OE74P30b6qvr8KHIc
         nuu+OweAPsMKBT22T9a+CBSSOv0Xb0tl3E65O8xHd1Gl2IUn2sXIOPoVbf/IFzUwqfH1
         Mme4xeHzotZO7OQvAdgjnKIGpJUm1C0Xqv37eN7mpd1/Vt+/doT2Xy6zRhwXmVSEG5WL
         yTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:user-agent
         :mime-version;
        bh=bC4DZg6A7Apvgfjj8/7c1Q7KWSOL04oIv544oOvDzxs=;
        b=K6dMqfrcxMiVAUmAUuMsTX8SzudYveY9rtkxcaBl+udJweXPKBURC/imtc18KezHJt
         IPgrPjZYuXUYFdzOVuGwNd24AqGnbQBDT2UffiFGYKDjyMHVlKFyjbh5gLVqaqkZ4b82
         55yat39U/M9W8Hh52w1L+asyYbNaqk2hkYO2ORVb1p4lYuaaRHdb1KUbqw9AeedsA7Pj
         Tf+Xdidp/qSuHEWJ7xgLpZXffP1oE00D/qW/PC35DNvLk8EGhbF6YJKerzqAIJ3OsvDU
         FGu9SFA07JYMWHp1tDyuCY24agXrM75/FWwTvxzE3gwOQaUtUDWvcCXvpS9vOEMEHNs9
         QuAQ==
X-Gm-Message-State: AOAM5310Cb887Lg/b+uCSx5DL1IkYqPjsyKkRC9YqXf56Ovp/MN+aVfE
        kloPG50vwzPQeytuYPHTmRB+4Q==
X-Google-Smtp-Source: ABdhPJw6QDxJ6PjnaWp/NFcgtlc0jk1/JWoYJ1/d+zipVDMbgBlfMLqCBWa7/saRM1BeV/L8j3CCQA==
X-Received: by 2002:a9d:71de:: with SMTP id z30mr20608230otj.266.1616976811352;
        Sun, 28 Mar 2021 17:13:31 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d206sm3242357oib.56.2021.03.28.17.13.29
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 28 Mar 2021 17:13:30 -0700 (PDT)
Date:   Sun, 28 Mar 2021 17:13:13 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     gregkh@linuxfoundation.org
cc:     akpm@linux-foundation.org, chenweilong@huawei.com,
        dingtianhong@huawei.com, guohanjun@huawei.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mhocko@suse.com,
        npiggin@gmail.com, rui.xiang@huawei.com, shakeelb@google.com,
        torvalds@linux-foundation.org, wangkefeng.wang@huawei.com,
        willy@infradead.org, zhouguanghui1@huawei.com, ziy@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH] mm/memcg: fix 5.10 backport of splitting page memcg
Message-ID: <alpine.LSU.2.11.2103281706200.4623@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The straight backport of 5.12's e1baddf8475b ("mm/memcg: set memcg when
splitting page") works fine in 5.11, but turned out to be wrong for 5.10:
because that relies on a separate flag, which must also be set for the
memcg to be recognized and uncharged and cleared when freeing. Fix that.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3274,13 +3274,17 @@ void obj_cgroup_uncharge(struct obj_cgro
 void split_page_memcg(struct page *head, unsigned int nr)
 {
 	struct mem_cgroup *memcg = head->mem_cgroup;
+	int kmemcg = PageKmemcg(head);
 	int i;
 
 	if (mem_cgroup_disabled() || !memcg)
 		return;
 
-	for (i = 1; i < nr; i++)
+	for (i = 1; i < nr; i++) {
 		head[i].mem_cgroup = memcg;
+		if (kmemcg)
+			__SetPageKmemcg(head + i);
+	}
 	css_get_many(&memcg->css, nr - 1);
 }
 

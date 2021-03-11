Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40719336970
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 02:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCKBJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 20:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhCKBJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 20:09:43 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B57C061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 17:09:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v15so25421185wrx.4
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 17:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=XiHrRV2/MBsmwC8yOcE2jl9MVMfB2FhFSIXVXevJIgw=;
        b=h4DfeSJ17GTyzh2RMnhEuqFkLLDe94w+NYQ59k3jaM+qtegmDWmIRLb21pfkK1BLDe
         rGGEIraBp/sFl3p2UxpHayZmIo475sLZhhCjkMSBANTKoiK1hQGE2R6Ki2UoChyUTEuK
         rjULgH9IW3xx3iCAOl2eJCMpipySB8GE5BlnYGKKAmPOJrOcPM/zfkKwUMF2tchfZsqV
         zsm8/R8qbDD3C33rHp9lkqF6JYknm6+jGV3CtvNqLh2a40ZyBO9Bm8nYpfpsxFn7c3uB
         UtYnQTcj8erIxfrz351oZpQkq3DduZX9SML2PmtG4Xx4B8q/cJIJosvsv2s67WrAVCWS
         sbBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=XiHrRV2/MBsmwC8yOcE2jl9MVMfB2FhFSIXVXevJIgw=;
        b=Z/HDFjF/RV4wFhpz4P58TbEWO7kUW2ZHcGNLiw/kG6PrMTU/zpDuSsRDSyuu5cHaxy
         LzdqwvzpG+0V2nueejLrNtH8BVIqHWaPJak5wJE4n40E5XO1ASdsfa2dE/yioHQfBn1z
         S4KGcO1FvQFNSQOFwXaYwl5ogdv6zB/t8F9q/tgz+sXKl+ilcnRqGMzrLJF5Fw0pFJBq
         xFPG2e2wKrQfpv3sDq1HmE2ziXrB/B80WSlyrp8CaO9I8CQUaE5SrwXMlXgg0rxvhdYl
         Z3FRD2p9st9dAR47gI3YiYzM8ghvn0H3NJJXy07vBNLpyvBjX6g9MEGSKKhjWPxkHLpm
         GRqw==
X-Gm-Message-State: AOAM531xZ7DTQDfKytuJhpfBEUIl++2eDd3bIpCf5+0YEvBfwpETBSue
        Z3jtaYtxlZKCNeyygrgj2GNVhdIVaVAeOOyZREnwWA==
X-Google-Smtp-Source: ABdhPJzJRkVWNM6CWispECJ8+z15E+9Z9B4yuC8z5CgR1OdiDaNxzbFkU4vnp8f9z8y3HT087yQCSAB9XEkTxB+YvNw=
X-Received: by 2002:adf:90c2:: with SMTP id i60mr6000854wri.75.1615424981347;
 Wed, 10 Mar 2021 17:09:41 -0800 (PST)
MIME-Version: 1.0
From:   Manoj Gupta <manojgupta@google.com>
Date:   Wed, 10 Mar 2021 17:09:30 -0800
Message-ID: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
Subject: 9c8e2f6d3d36 for linux-4.{4,9,14,19}-y
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     joe.lawrence@redhat.com, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Luis Lozano <llozano@google.com>,
        Jian Cai <jiancai@google.com>,
        Doug Anderson <dianders@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable kernel maintainers,

Please consider applying the following patch for 4.{4,9,14,19}-y
kernel branches.
9c8e2f6d3d36 scripts/recordmcount.{c,pl}: support -ffunction-sections
.text.* section names

It is needed to fix a kernel boot issue with trunk clang compiler
which now puts functions with  __cold attribute to .text.unlikely
section.  Please feel free to  check
https://bugs.chromium.org/p/chromium/issues/detail?id=1184483 for
details.

9c8e2f6d3d36 applies cleanly for 4.14 and 4.19.
For 4.4 and 4.9, a slight changed diff for scripts/recordmcount.c is
needed to apply the patch cleanly. The final changed lines are still
the same.

scripts/recordmcount.c diff for 4.4 and 4.9 kernel.

--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -362,7 +362,7 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-       return strcmp(".text",           txtname) == 0 ||
+       return strncmp(".text",          txtname, 5) == 0 ||
                strcmp(".ref.text",      txtname) == 0 ||
                strcmp(".sched.text",    txtname) == 0 ||
                strcmp(".spinlock.text", txtname) == 0 ||

Thanks,
Manoj

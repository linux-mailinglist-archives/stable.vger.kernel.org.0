Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42A8526F59
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiENFfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 01:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiENFfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 01:35:00 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7469622F
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:34:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j187-20020a638bc4000000b003c1922b0f1bso5169666pge.3
        for <stable@vger.kernel.org>; Fri, 13 May 2022 22:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eTDEYyOKJF/dcu34f0ARXiMlOyx/6AQzmobINCAqI0g=;
        b=FWI5US6RXbHhoKT/1UOI6+SCMHcTzbgQ/9WaCoiZAxSOEfhA6qy+/9MePKI9LA2oqU
         RFB+yNh1Mevpq2hM+r0FmCMaJClNxnomsx1YuUYHvp3nJJinECwbBW2SsRxkwy6OWGy/
         vhOLYnv2+ZlA90bRSwPZuMEiqyQKlUieXlt9haFZYKvFrsmGRVb8SXmyWlpjHE5Yb5cV
         wVayyydxKD/fVgICCFxh4kl66E4lBpRnMlao3OEhYMvqvm03DhZffObuAjW4htGq3jMv
         kk041L3i3Wi+TRNpNrrt62FLNgr2Hkpa3/Ww5ilW1sJSx+e2HwepNIbnrjrhVUG1XOf4
         aimg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eTDEYyOKJF/dcu34f0ARXiMlOyx/6AQzmobINCAqI0g=;
        b=FhA+F7ewA3QhLyzZAuu+6tsqZN45CQWQXT9IGYgx2IbEH+mU+N5mIJWulavRid61qV
         sPPKPOQywlzElHDQjIf11ar00jD0azqYTiL03vhTlntXu3QFsygFNFUtl/LW39OQP/ut
         axxJF2IqghO8J0Zh56BMAAW6Uapy4gIozKrkE/YNnSyYPAx8SvoFuARBfrSeR/B/95ve
         YOHQLFe3ZmdmbO8RGi2LGJBmThLWuHPGQ/L8itBk0VDdbuGmyHMyz6u2QkFUdUmQUfsC
         Yrm49QnHUqA9igI3QcznPKUKBxSOotEq5wyy9tYRj4RFW3zUCId+Nsiw9yBvV6ZyVqCA
         KrKg==
X-Gm-Message-State: AOAM530F/DMdqmsMZQiKb84pSdUD1lMCb/wy8FToYLBlcE4y6GmnFB1t
        l5ocsoWSfn2Tsd4OxqbRTvDQykh6VjXmuJ8YiSceHw==
X-Google-Smtp-Source: ABdhPJwM0RC0ZsRCmzKOA5UGnDZT7etkEHq45W+ElfbohS5v3XLOyq0W9tkOxMMHnFimxMVCapCNGXoZ8+THq9SpqfO5ug==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a17:903:32c9:b0:15e:a1b8:c1ef with
 SMTP id i9-20020a17090332c900b0015ea1b8c1efmr7662389plr.173.1652506498823;
 Fri, 13 May 2022 22:34:58 -0700 (PDT)
Date:   Sat, 14 May 2022 05:34:49 +0000
In-Reply-To: <Yn82ZO/Ysxq0v/0/@kroah.com>
Message-Id: <20220514053453.3277330-1-meenashanmugam@google.com>
Mime-Version: 1.0
References: <Yn82ZO/Ysxq0v/0/@kroah.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 0/4] Request to cherry-pick f00432063db1 to 5.10
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     gregkh@linuxfoundation.org
Cc:     enrico.scholz@sigma-chemnitz.de, meenashanmugam@google.com,
        stable@vger.kernel.org, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
Ensure we flush any closed sockets before xs_xprt_free()) fixes
CVE-2022-28893, hence good candidate for stable trees.
The above commit depends on 3be232f(SUNRPC: Prevent immediate
close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
once on a TCP socket). Commit 3be232f depends on commit
e26d9972720e(SUNRPC: Clean up scheduling of autoclose).

Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
kernel. commit 89f4249 didn't apply cleanly. This patch series includes
all the commits required for back porting f00432063db1.

Trond Myklebust (4):
  SUNRPC: Clean up scheduling of autoclose
  SUNRPC: Prevent immediate close+reconnect
  SUNRPC: Don't call connect() more than once on a TCP socket
  SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

 fs/file_table.c                 |  1 +
 include/linux/sunrpc/xprtsock.h |  1 +
 include/trace/events/sunrpc.h   |  1 -
 net/sunrpc/xprt.c               | 36 ++++++++++++++++-----------------
 net/sunrpc/xprtsock.c           | 35 +++++++++++++++++++++-----------
 5 files changed, 43 insertions(+), 31 deletions(-)

-- 
2.36.0.550.gb090851708-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD3C4D6D65
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiCLICZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiCLICR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:02:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932771C74C5;
        Sat, 12 Mar 2022 00:01:09 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id bx5so10117918pjb.3;
        Sat, 12 Mar 2022 00:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qRmt4XcC/REi1EbkBQWw92xliWthfO4Gtbh8q/qhhmg=;
        b=A+OR99rOtQ5XxhfAza0jK49hmaEizDUwr6mYBZmnUTNLNxTjIpNsjgFUo4fxhF+y2G
         mUyG/Gg6e6hUM6rFDTWtLK53OgcNFzeuQRA0K8OwMJYwDeaEkM3ZlA8YdqJwuH7zUEQ/
         Z/gzzwJPpZluh406LhWdnX0QbfjDKizIv8xfw4tK9efIJ3C6Ykcm5Lthy3mp1nN/olzQ
         gPo22g3EONL4mcpHMe75zAca3hW86xzVBTfgSJ3ppX26+Lwotam1r+unXOlju9GyWd4b
         Igi6fFqlsY17AJDL0NsywofUH0aS2KYvaYJw3wJCyz3rmbis44ji3xzhxyv0xsC9TuR0
         F5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qRmt4XcC/REi1EbkBQWw92xliWthfO4Gtbh8q/qhhmg=;
        b=cuq8IJ5IyWvJCe9DxMXqwSzdrKQEZcZpR//Qdbax8gvHwshyMkrzEvgVCWzDbueqGs
         rU0NyBbi6EOYSB3Kk0Bs+D61zxCe6hgo3as015WJ298+3FgQmRRd64Yw19AfkRoNn93e
         DzPvKTb2D4Zpj/Fd9lVEGtkG7uYjeSwRfH8idTgJtNWfBa0XgcgzZDDJfgrls6AHY1mX
         CE0SrYNtPEx3k/OTXyJeJOUUyGpZBC7D74y/WNgcwf13IaazR2UPMdxCJx1LV2rm55Uf
         FP3pYt4EjtfItTwq9bXdGukDoVijJaKrgRs06DrE2h3c+obtIA8Mi/UyKv0GRVTHCnak
         w7eA==
X-Gm-Message-State: AOAM5322R9Se7fJqSvTzgDzDdwNTCwr23nYlS76NIvUyzyJchWau2gh1
        GHaPawcYQfQOxZEkt+eeg6WeUOJ/FBp1qA==
X-Google-Smtp-Source: ABdhPJzuFhW6auYb8of7SogWrWPXQeu0sOjvKGj5pOVqsL6OOkR49WF269FDLnoKmchvayQsQiZkTA==
X-Received: by 2002:a17:90a:8686:b0:1bf:3e06:7368 with SMTP id p6-20020a17090a868600b001bf3e067368mr14761358pjn.49.1647072068522;
        Sat, 12 Mar 2022 00:01:08 -0800 (PST)
Received: from ubuntu.mate (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id x33-20020a056a0018a100b004f71b6a8698sm13025141pfh.169.2022.03.12.00.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 00:01:08 -0800 (PST)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Documentation: add link to stable release candidate tree
Date:   Sat, 12 Mar 2022 15:00:42 +0700
Message-Id: <20220312080043.37581-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220312080043.37581-1-bagasdotme@gmail.com>
References: <20220312080043.37581-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is also stable release candidate tree. Mention it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/process/stable-kernel-rules.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index c0c87d87f7d..523d2d35127 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -183,6 +183,10 @@ Trees
 
 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
 
+ - The release candidate of all stable kernel versions can be found at:
+
+        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/
+
 
 Review committee
 ----------------
-- 
An old man doll... just what I always wanted! - Clara


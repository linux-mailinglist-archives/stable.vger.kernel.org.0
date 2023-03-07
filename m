Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7178D6AF476
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjCGTRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjCGTQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:13 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC37B78BA;
        Tue,  7 Mar 2023 10:59:41 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id ky4so15207753plb.3;
        Tue, 07 Mar 2023 10:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8x2FXGYE/xrIk8aP1rcoSXqv4tUZYWMw4sXU9s9C90=;
        b=E1RFox8JP6OKs9zpVTGXxL3tiWtm2PY8twAu2cALQ422bOGhaPFHpwF8NEiC+V1uIt
         x2zdLeCCTYbMvQuRo0IhC+rTR18PFvN+oSqpN6qucTptIhY+9oEpbHchs5do36FUOiVL
         hJmB/dCeI29645g67AcozNJLQk84pXY+xubCTO0du+dRLJ8VENRrrTeGofj1qzxPDUn/
         ZNOnliXAkglHv15FVP7KZzEusOvwv3OXD7zBgv1CaxOHMYNDVkPhPCpiGTZeWTlV6JRy
         QfPIDbYkA3LauGNPAVsfjRybhWtRdtvnMXRKijjdm2U68qUOsNjXGE42ehDUGMHGmJGi
         5o1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G8x2FXGYE/xrIk8aP1rcoSXqv4tUZYWMw4sXU9s9C90=;
        b=WzdeRW8izpmSLcFZ78Nd4j1VvQUKPaywueo+gb62TPtsS4Ffi/XcXcFeR4aL83Qmv1
         aenm02HOpJ3r/ILXHsBZ9lb8jwYRDCLGQ8UXcpa6JAWRyQl0OZr5PIDhXY4NBTJY/uvR
         eNnmmLEsiwFG93mitUGMb2LdCKkY33cECtXL2RksszIYfzRhhwYNrApUgndbrtgX28up
         qmydzRJ3o5JOx1obfEDQykadWC/Anaz2BmPf+IQEJ/o6oIjUKeTFztVVMI5oI5mJBjd5
         bgI+hm2B3fy8bIsZBflNzM23/p2cOvmmkv1N9tc9YxzK7Cv+bwic5yOCAWKrn9v+z56r
         KzIw==
X-Gm-Message-State: AO0yUKW2fFOu8Crq70vyhuDODl8TlFP2QsMMB5Fyx6dKVkk172Xu4LhX
        8YbB5VPirxI2oCUUb8MFle0eH4dfbXMNog==
X-Google-Smtp-Source: AK7set+0dqZYAUfPChKubbuIJLQ6Vp7a6Tc+U337t07ehuqv4y95Lgu/Q+vc67b6CZ9mO4R9YSSSeA==
X-Received: by 2002:a17:902:ab4f:b0:19a:9897:461 with SMTP id ij15-20020a170902ab4f00b0019a98970461mr12980331plb.52.1678215580045;
        Tue, 07 Mar 2023 10:59:40 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:39 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 11/11] fs: use consistent setgid checks in is_sxid()
Date:   Tue,  7 Mar 2023 10:59:22 -0800
Message-Id: <20230307185922.125907-12-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230307185922.125907-1-leah.rumancik@gmail.com>
References: <20230307185922.125907-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9601c2d774c8..23ecfecdc450 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3571,7 +3571,7 @@ int __init list_bdev_fs_names(char *buf, size_t size);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct user_namespace *mnt_userns,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog


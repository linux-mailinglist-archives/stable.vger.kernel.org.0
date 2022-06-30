Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04AD56249B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiF3Uwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 16:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiF3Uwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 16:52:50 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461C53CFC3;
        Thu, 30 Jun 2022 13:52:50 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 23so452804pgc.8;
        Thu, 30 Jun 2022 13:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KGYYu2Fo1hyZ3+gMldB9Eal3HX5d6cH/DMCkl9TGf8Q=;
        b=OJ7i7BpDpeZ7LDKU3ise/G9+Tqfv/1ZhaDbu9jirECTdlGhCGlnvPnBfBTjCgsAb/2
         hG4K9kwFNtICzFFVc8oMwM3203zsfXUcq1JJE3kDvXMSRzaTkz7TgSH1dCDXbSwSBL0y
         meMQ7rb5F7wL6SikTZKfGhKquu7vamg4CiM4ByofFs2CQPUhULAkaRbWLGkpa2UATbsJ
         WURtqMq2wLFirLO2OrhfHFvbrbISanmgTkaBwf1oyjpzmG4yEguE+5drcUO3IVsv/TvB
         p3bVi0LtmXDEboOEbSdxgfciEib8SzkjZOSFdHchP6pqq4mMUTIMJmjha5Vus8xo9Q/l
         zo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KGYYu2Fo1hyZ3+gMldB9Eal3HX5d6cH/DMCkl9TGf8Q=;
        b=HdUJJlOu2iR+BqncdpIc7RKaMgKVYAzkD9M9TCgqDEosC5ITzxXHcRVmySvXT44Fjs
         Ww60l6avAfrLjh+HpomU85l0yej9BYbIAuPgLUM2LSlarGa+ja2hWChjA51QWau+bqww
         Rft6ircVaFVakQNtx3mBD4vlLn+AWYVCgsWP7cVju+LiRqQ9DXHiRBDtsf82wAzpPfZk
         fR9Xi5vF8cmGA/W2qDMZ4mP2ECObzmr4xlrr4s6H6y+8LCyWmtCBEFRnzmRf9X3XhNRy
         1E27imzIrsZUUtvY9bRomZ9WtiJrGAY9//5w/ynB3MjT8whAiMWkbN4hLp3T4yd6geZk
         wUzA==
X-Gm-Message-State: AJIora/AKDzCvQTm0SXx6D5C9NKB2bMvw90pkMBpz6GBJqyaftZ5gZau
        64zm0l+1MzvNNGIGjbTgl8Dp70GlAB5IcQ==
X-Google-Smtp-Source: AGRyM1vD5x4U+bfzDPjMiVFfQhAMyTEw8Z4kBpmZhZpkNMeWYmI74RmPgKBDWjaH8ErMK3rE+utv2Q==
X-Received: by 2002:a63:6c42:0:b0:3fe:465:7a71 with SMTP id h63-20020a636c42000000b003fe04657a71mr8983770pgc.101.1656622369554;
        Thu, 30 Jun 2022 13:52:49 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:d96:61ed:44ac:2a28])
        by smtp.gmail.com with ESMTPSA id i8-20020a17090332c800b0016a71196150sm12955980plr.135.2022.06.30.13.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 13:52:49 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [5.15] MAINTAINERS: add Leah as xfs maintainer for 5.15.y
Date:   Thu, 30 Jun 2022 13:52:28 -0700
Message-Id: <20220630205228.4021891-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
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

Update MAINTAINERS for xfs in an effort to help direct bots/questions
about xfs in 5.15.y.

Note: 5.10.y and 5.4.y will have different updates to their
respective MAINTAINERS files for this effort.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 393706e85ba2..a60d7e0466af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20579,6 +20579,7 @@ F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
 C:	irc://irc.oftc.net/xfs
+M:	Leah Rumancik <leah.rumancik@gmail.com>
 M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
-- 
2.37.0.rc0.161.g10f37bed90-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6644564537
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiGCFFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiGCFFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:05:08 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF4DAE60;
        Sat,  2 Jul 2022 22:05:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v9so8746021wrp.7;
        Sat, 02 Jul 2022 22:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3P7csWRRsUqQ4jppd8Z6Oxx3zMviRgUdqAGaQRqzKM4=;
        b=SsaQu/novIa0xtJi8LTpizEgmlw1PA6BJtOE+VnrunyCizQaNcUT+xZdpFRWJScrHs
         MJUTrq6SJN/WgER+8aSlmIqvy+uZa/GETWQY5a2Bs+3ajm8RORMORLGjRKXLJnLzT38D
         dTwKFYLdFM2jESPNNb9QdDF14VLwvO3sgUpxYGbXoBynFUjydhXwDLSL3yAfLW/XXep/
         cGoERR9zf2VIifjjIZ2iupepBltHzhMH8iAni5DyxY7tTtzyldzcRfLb3oT97BHwjcfz
         T3y7ktIfRPTFOMKbV2XvtsgVX4Fj+1KjdJDd076qXy/7h+TxI4s6HxNe6OLieZXRTW8D
         ztog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3P7csWRRsUqQ4jppd8Z6Oxx3zMviRgUdqAGaQRqzKM4=;
        b=0eIkFQhfxib0Q//vR6JqBXAL2yUTJrTv8SjP9GMpsyS0fWhkZcc0HV1VxYugzAaSHm
         w10S6j9uvESnOvupp0m68wz60h63gAltFbocywlg2fHhelDj3Gi3/uBPAdmRfl9NRYs0
         mqVHJ7ugkxxFl/MW5xuXPNgHrj9pn071sxuIC/D7UrAjdrdxxG3yr+Pr8DTW6R6sqNdK
         wXRpUKNY1LRfgrXohEpFS2mJsOOkpu3Oz3Eb95cBk0+cvTCWb9/ow1M+ONGSNsE492nZ
         JjVG4+mVKabhCxEzu5xdY6zdqqYs1iIly8qBu+Dpjm2uif/9p35omgyd2KcCJZpHd7Vu
         d7pg==
X-Gm-Message-State: AJIora/92Be3AhGrWhRrwMHKPnC4EKf0NY9Lvmz/DYjxBQNrXctl0pjE
        rv5czYOqhgCM/bPVD2c9uMg=
X-Google-Smtp-Source: AGRyM1vwU2ti1hbK2pPT6KHKCzlQE/VMdH976SUH91e001MkBih7RCJ/LQClIMpWJvWcRgzNGEr0fA==
X-Received: by 2002:a5d:4647:0:b0:21b:bde9:f267 with SMTP id j7-20020a5d4647000000b0021bbde9f267mr20419470wrs.526.1656824706570;
        Sat, 02 Jul 2022 22:05:06 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id e2-20020adfdbc2000000b0021b9f126fd3sm27028952wrj.14.2022.07.02.22.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:05:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5.10 v3 3/7] xfs: Skip repetitive warnings about mount options
Date:   Sun,  3 Jul 2022 08:04:52 +0300
Message-Id: <20220703050456.3222610-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220703050456.3222610-1-amir73il@gmail.com>
References: <20220703050456.3222610-1-amir73il@gmail.com>
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

From: Pavel Reichl <preichl@redhat.com>

commit 92cf7d36384b99d5a57bf4422904a3c16dc4527a upstream.

Skip the warnings about mount option being deprecated if we are
remounting and deprecated option state is not changing.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Pavel Reichl <preichl@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index cba47adbbfdc..04af5d17abc7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1155,6 +1155,22 @@ suffix_kstrtoint(
 	return ret;
 }
 
+static inline void
+xfs_fs_warn_deprecated(
+	struct fs_context	*fc,
+	struct fs_parameter	*param,
+	uint64_t		flag,
+	bool			value)
+{
+	/* Don't print the warning if reconfiguring and current mount point
+	 * already had the flag set
+	 */
+	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
+			!!(XFS_M(fc->root->d_sb)->m_flags & flag) == value)
+		return;
+	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
+}
+
 /*
  * Set mount state from a mount option.
  *
@@ -1294,19 +1310,19 @@ xfs_fc_parse_param(
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
 		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_noikeep:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, false);
 		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
 		return 0;
 	case Opt_attr2:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_ATTR2, true);
 		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
 		return 0;
 	case Opt_noattr2:
-		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
+		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
 		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
 		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
 		return 0;
-- 
2.25.1


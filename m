Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74854D6D66
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiCLICY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiCLICN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:02:13 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4887E1C60F4;
        Sat, 12 Mar 2022 00:01:06 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so2360365pjb.1;
        Sat, 12 Mar 2022 00:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i1vvPwlpfuQTivIygVJ0iEU+hr/Vo/mRbffopkdNd3M=;
        b=b4GOHk3KU5ITlaxZK//kEcv5lR2uVvCeC7UVGUgeQDeaUSLcngDarBfdwsyRV/KK+L
         CWtyUCjjfh00toPB1p4qdpcgukw4AaEaaZKkwKrZPeqTner6kIIJZVCcRpuI4vzMqiw+
         vNgmAA1DXjYxiNPli+vlSkvnafIuhyu29/NXmYfOhgVh1uyDxNEy/aX6rZy8OxsxbR1w
         9yr9jLuc4/owObnvKOJjsEP6sMx/gAISG8ZZQ1H0SXUG7U2+j0BqvISOwAAXnu5gs51L
         /F1fllaDdAgna73VanGgiWQuUAB35JvRntWQG+qrUyVo+4x/IFLL9pCaMuHX2LNeFzWs
         YdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i1vvPwlpfuQTivIygVJ0iEU+hr/Vo/mRbffopkdNd3M=;
        b=aiEYnRs1jCeTZaDY+HwyyaYP9Q1lbPq7UKryngBSJ6ojE5tt4rKJY2s60Fiui3kDLg
         ucBBKtVDU6mRleiNtJ+SUWJieCHSlR0BPjjowjTh25n1kKfswIExuoHrtLNxFaTvxLff
         dQmL6lX33MfqL2rI78tVfJ9Bfs8BA+dJQxz6wi2apB6kX2cdNAwydBlCNrjdEOK42I8c
         +db+U5Kjc7IYC7M3xUpusbFzyXFv8j/6vKu/PcOgLpd5gWOZm6PD7c3c8VBTj0rSFOe6
         aZlln64yx0BfW/SB9hX9NVm1fAknx1vfmDTrrFR6ommkNRSoWIbPgxABoFguUYgNZMSl
         f4jg==
X-Gm-Message-State: AOAM533W1GhyYwElgMC+Y11RX0rvG+C37wrXeEeR3LsOj9ZO9fMQN5K1
        sIHWvnBSFTBF3q9ZLa8DADYD8vMwH5Y4IQ==
X-Google-Smtp-Source: ABdhPJy8RhZ5FEu0HXcHH4ppavZ15gdvvKVvGwlfgb3RDMzCeW3xxHAWswIlWB/+4DPlirg+BxscmA==
X-Received: by 2002:a17:90b:3ec8:b0:1c5:68d3:1883 with SMTP id rm8-20020a17090b3ec800b001c568d31883mr4642895pjb.201.1647072065449;
        Sat, 12 Mar 2022 00:01:05 -0800 (PST)
Received: from ubuntu.mate (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id x33-20020a056a0018a100b004f71b6a8698sm13025141pfh.169.2022.03.12.00.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 00:01:04 -0800 (PST)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Documentation: update stable review cycle documentation
Date:   Sat, 12 Mar 2022 15:00:41 +0700
Message-Id: <20220312080043.37581-3-bagasdotme@gmail.com>
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

In recent times, the review cycle for stable releases have been changed.
In particular, there is release candidate phase between ACKing patches
and new stable release. Also, in case of failed submissions (fail to
apply to stable tree), manual backport (Option 3) have to be submitted
instead.

Update the release cycle documentation on stable-kernel-rules.rst to
reflect the above.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/process/stable-kernel-rules.rst | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index d8ce4c0c775..c0c87d87f7d 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -139,6 +139,9 @@ Following the submission:
    days, according to the developer's schedules.
  - If accepted, the patch will be added to the -stable queue, for review by
    other developers and by the relevant subsystem maintainer.
+ - Some submitted patches may fail to apply to -stable tree. When this is the
+   case, the maintainer will reply to the sender requesting the backport.
+   If no backport is made, the submission will be ignored.
 
 
 Review cycle
@@ -147,13 +150,22 @@ Review cycle
  - When the -stable maintainers decide for a review cycle, the patches will be
    sent to the review committee, and the maintainer of the affected area of
    the patch (unless the submitter is the maintainer of the area) and CC: to
-   the linux-kernel mailing list.
+   the linux-kernel mailing list. Patches are prefixed with either ``[PATCH
+   AUTOSEL]`` (for automatically selected patches) or ``[PATCH MANUALSEL]``
+   for manually backported patches.
  - The review committee has 48 hours in which to ACK or NAK the patch.
  - If the patch is rejected by a member of the committee, or linux-kernel
    members object to the patch, bringing up issues that the maintainers and
    members did not realize, the patch will be dropped from the queue.
- - At the end of the review cycle, the ACKed patches will be added to the
-   latest -stable release, and a new -stable release will happen.
+ - The ACKed patches will be posted again as part of release candidate (-rc)
+   to be tested by developers and users willing to test (testers). When
+   testing all went OK, they can give Tested-by: tag for the -rc. Usually
+   only one -rc release is made, however if there are any outstanding
+   issues, some patches may be modified or dropped or additional patches may
+   be queued. Additional -rc releases are then released and tested until no
+   issues are found.
+ - At the end of the review cycle, the new -stable release will be released
+   containing all the queued and tested patches.
  - Security patches will be accepted into the -stable tree directly from the
    security kernel team, and not go through the normal review cycle.
    Contact the kernel security team for more details on this procedure.
-- 
An old man doll... just what I always wanted! - Clara


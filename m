Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D244D80C9
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbiCNLe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiCNLez (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:34:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725A23EB98;
        Mon, 14 Mar 2022 04:33:46 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so14203363pju.2;
        Mon, 14 Mar 2022 04:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ff/1Jr/2hs4fOFFV9jM9HFojNDiwGL05jxZYLw9e1x8=;
        b=eNo6uJh4s0EgJRyUlmbMs9Yarg38XY/jBkrXSMMevgW/GLt3ioCGQHsUkL9zVtIrer
         GB4vkFue2FZductmaYkNtX/rR+R6H7byn3ufB61I3XrEq7rAIk8XWcyInuIX1kXOYPKq
         RRCQgMCPAzjJj6GOiccgrxaO1Z8fd4oyAw2s7EA3/VuRbnc12FcXQZPbpjZa3Hy/qMWl
         0cwT7YbdKNihfEEQGpITGUULood7JZRRPjhzNtLQTR8YImt8GPwqsI1Y20jJ9KDc6ixs
         4l8Wfdq12w7ZmD8Knx8/bGPQYtoGrkcDnZvI45MNlMMhHB/R8PKnRWuaHcykzsQzQOFS
         USXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ff/1Jr/2hs4fOFFV9jM9HFojNDiwGL05jxZYLw9e1x8=;
        b=OMnwYxqrvxGfzUUwXJ9sQUybodlIMa3VqQnw1UIqNz1SEnaZNorxP41z4mzEVHuIIO
         lyLj+epjJRky43aMAQ6Mn9+NWwPby/MMjdJuAHFufXvoYjgMl6BlzMPu7N27CYEYqPZR
         VN9XrLCXwdDTgVAu6t/Du7fgka8IxEtLy5m34cnuib6dZwDNkerFe39oKQ2nmbPSVrVp
         fKMrLV3i/2/4Fbl63HH3PI4pnhE7rnjBT4BttKBRi+aYjXh9j8L9EcMGZOEQf4Dq7sRn
         ftnKAm+SO9PxB9qLuo6j8klgNIy+vvrOaZIWZRdhOZ43fH6/DrbxADDJHXaI5JQfS4Zb
         i0bQ==
X-Gm-Message-State: AOAM532WlFjS6Bh7X7OBbJnW5DdPv2J0nSw/VK4zgvP41hCtHFTgTbL6
        1vESnwKSGS4oSYXCcPj41LYLEIFgNwotjQ==
X-Google-Smtp-Source: ABdhPJxIWQezka+89nyDFZiesddgbPwDahIZP3KuxMlCOv4ErqxIdrLAiGxXQBgSgW//SnW0UWeHkQ==
X-Received: by 2002:a17:90b:38c2:b0:1bf:ad37:c320 with SMTP id nn2-20020a17090b38c200b001bfad37c320mr28325264pjb.148.1647257625575;
        Mon, 14 Mar 2022 04:33:45 -0700 (PDT)
Received: from ubuntu.mate (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a030300b001c17851b6a1sm13608117pje.28.2022.03.14.04.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:33:45 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] Documentation: update stable review cycle documentation
Date:   Mon, 14 Mar 2022 18:33:27 +0700
Message-Id: <20220314113329.485372-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314113329.485372-1-bagasdotme@gmail.com>
References: <20220314113329.485372-1-bagasdotme@gmail.com>
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
 Documentation/process/stable-kernel-rules.rst | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index d8ce4c0c775..c207e476c11 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -82,8 +82,8 @@ it to be applied to.
 :ref:`option_2` and :ref:`option_3` are more useful if the patch isn't deemed
 worthy at the time it is applied to a public git tree (for instance, because
 it deserves more regression testing first).  :ref:`option_3` is especially
-useful if the patch needs some special handling to apply to an older kernel
-(e.g., if API's have changed in the meantime).
+useful if the original upstream patch needs to be backported (for example
+the backport needs some special handling due to e.g. API changes).
 
 Note that for :ref:`option_3`, if the patch deviates from the original
 upstream patch (for example because it had to be backported) this must be very
@@ -152,8 +152,17 @@ Review cycle
  - If the patch is rejected by a member of the committee, or linux-kernel
    members object to the patch, bringing up issues that the maintainers and
    members did not realize, the patch will be dropped from the queue.
- - At the end of the review cycle, the ACKed patches will be added to the
-   latest -stable release, and a new -stable release will happen.
+ - The ACKed patches will be posted again as part of release candidate (-rc)
+   to be tested by developers and testers.
+ - Usually only one -rc release is made, however if there are any outstanding
+   issues, some patches may be modified or dropped or additional patches may
+   be queued. Additional -rc releases are then released and tested until no
+   issues are found.
+ - Responding to the -rc releases can be done on the mailing list by sending
+   a "Tested-by:" email with any testing information desired. The "Tested-by:"
+   tags will be collected and added to the release commit.
+ - At the end of the review cycle, the new -stable release will be released
+   containing all the queued and tested patches.
  - Security patches will be accepted into the -stable tree directly from the
    security kernel team, and not go through the normal review cycle.
    Contact the kernel security team for more details on this procedure.
-- 
An old man doll... just what I always wanted! - Clara


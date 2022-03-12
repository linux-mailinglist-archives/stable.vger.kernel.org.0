Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABD64D6D5E
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiCLICI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiCLICI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:02:08 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02AF1C60F7;
        Sat, 12 Mar 2022 00:01:02 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id n15so9534916plh.2;
        Sat, 12 Mar 2022 00:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aJ14arsAul3SlLt5mlCzJmi9KKQVjgoCLUM8tJyemVY=;
        b=Rx0qKg3baqW/uNf8ysd4E/DRmNDFNzF6LEYtmukVJ3oV8H0UEDJjdnqPZeLu836L+s
         Scu+YSLf1W26bk6SiFNLTMyUSynsX/14rAvQ8aeL5cafvxulb7iTABFmkJiskSKAfEx7
         JJ/yPkI+dj8bP9twRnIUoz6kw7XosrRWZD6GUzNUlGyBtqH3ROy5FgPLmMZv8orHqjr9
         zZBqAN2gQxmyPFo9yCutkvjuKM2eUx0nf7p5pC67VTFNvGCKDzYbDgusVNU43U11R+v8
         ieh+ak9dD03iySRInaPpPc6dL6PtSDFTw2TLY7ynr91m4FJbcS4ohHaTGHdDG6sqQlE9
         wDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aJ14arsAul3SlLt5mlCzJmi9KKQVjgoCLUM8tJyemVY=;
        b=Y70p1i0B+Cqp3i9mkXLMGC1DUv6N1INf2Jp0ei9OJJtLpjqtdqViz1dk3nE1hwhcS+
         QlCKCnbdKGxpOvCH54SrhmYsJqPymA8CxvO8H2Ls3zK5hYhYWUdKfqJJNIjvPFHKWcF5
         cjCXVqoSe/p5hSwUHIWoPBE4WrwFF/PtxMtR8BJiiAs1uYoyU/QJbq6HMBWDeDwgLf/u
         ZSRn6a6vAcY6XUz9+XyzQMUQgeRsja+o/HAuQl1ymBOu6+qihj2ojk/t/ikS0RLg75Al
         KUkyxXfqQlmFNSWKeAA0dMw1cgxP/EmR/s0wqw4aECGUWzgrWApFWNRkcoojHUCBNoFD
         Cdqw==
X-Gm-Message-State: AOAM5315azHNII175/e4D2D5emRErKtjYjgDvkcCGkrXg7IlnpAyY01I
        I9QwvQIy57IS76ew1B7aGF+o4vNTi9wzEw==
X-Google-Smtp-Source: ABdhPJyp2t3Ou5Q9cha/XqAUvJCGqRao8Ahz2XT5Cr7Sfta/1FzGxYP6hFEQ7Ze/GExzTvr62RIBHw==
X-Received: by 2002:a17:903:41c8:b0:151:bf44:ba9d with SMTP id u8-20020a17090341c800b00151bf44ba9dmr14022641ple.160.1647072061976;
        Sat, 12 Mar 2022 00:01:01 -0800 (PST)
Received: from ubuntu.mate (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id x33-20020a056a0018a100b004f71b6a8698sm13025141pfh.169.2022.03.12.00.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 00:01:01 -0800 (PST)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Documentation: make option lists subsection of "Procedure for submitting patches to the -stable tree" in stable-kernel-rules.rst
Date:   Sat, 12 Mar 2022 15:00:40 +0700
Message-Id: <20220312080043.37581-2-bagasdotme@gmail.com>
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

The table of contents generated for stable-kernel-rules.rst contains
"For all other submissions..." section, that includes options
subsections. These options subsections should have been subsections of
"Procedure for submitting patches..." section. Remove the redundant
section.

Also, convert note about security patches to use `.. note::` block.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/process/stable-kernel-rules.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 003c865e9c2..d8ce4c0c775 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -35,12 +35,13 @@ Rules on what kind of patches are accepted, and which ones are not, into the
 Procedure for submitting patches to the -stable tree
 ----------------------------------------------------
 
- - Security patches should not be handled (solely) by the -stable review
+.. note::
+
+   Security patches should not be handled (solely) by the -stable review
    process but should follow the procedures in
    :ref:`Documentation/admin-guide/security-bugs.rst <securitybugs>`.
 
-For all other submissions, choose one of the following procedures
------------------------------------------------------------------
+There are three options:
 
 .. _option_1:
 
-- 
An old man doll... just what I always wanted! - Clara


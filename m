Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9094E4D80D1
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbiCNLe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbiCNLe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:34:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A0B41F8C;
        Mon, 14 Mar 2022 04:33:49 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so14194776pjb.3;
        Mon, 14 Mar 2022 04:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=djz1hmUxaDckM2SKIB33i3cq/ClgZGc+PJ0IT1vh7Z0=;
        b=iWDHzKQCkHBy3RelL9USeEaP7OSN7yxKytao1//P+lCFE/selLHxN6DxzNcMhb1PK8
         uWvzStb1nCMZbENcqUOTxuZIfbiyMDVV7sVVgJMwig75ePs1xG6yKUptpzbV5ipO8MU4
         uuF0f2fs0NM+EIVcFKpwzoU0KV8sWMsoGv409GvEJDtsbTLBgtgVUOA2tD952Xmxcxlo
         fXUAaJjqdQKJuIujDDnW3jO9edFFL0gb50wkjKQmGGoNVNvs31T4VKrryrA7P6wvNF+c
         rQRFIY1iw2PeKYWsDtxqRegLY7/xO+MWjc/clWUKBO2j3QC4coGPb7kI86Hr8kW5d3Ri
         Tc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=djz1hmUxaDckM2SKIB33i3cq/ClgZGc+PJ0IT1vh7Z0=;
        b=zNrSRELcnCor3nLZiB4dAPT2r7cWkP5IEuQjNtnQIkhcRiOBmy3nBNr7YsvYmcnfbq
         tmAHFr05kXvRCpjSYAgqMzwmjIm/nTadFrlbUSAfcUzjHN9ayKFqU+FzKLIGyUX67PMO
         9VKc7eFtzAM9MwsxSixD2Wfx7JRFVMVqSmQqOHQdnzLdYTE1c6S4cW5bXPMYg4KfzVhn
         Bws/3xgmFImjQkJFYsm0kqRTc+0oX36lA/FVc7vMCw+xtIZhZdqug8UKsPDIEgsiG8Z1
         c/hjvbg7C6S7hTlrp73TeXB73E1dKdlYKiYRtTRpVUXBw8JfwjwmBSeznp6kNTuzgvuN
         go1g==
X-Gm-Message-State: AOAM5313y0SfvLKB6RRnm3AwtlUgBcUopJNK/dRdLeDZSOQoure21W/d
        FEwwLdv9UteC9HMv2561OFREqXyaZVDuSg==
X-Google-Smtp-Source: ABdhPJyd0sDXjRGy8K4jHlzi2XwjNF8oFTXUzgbPu4b+eRWLDkOpbshH73Lep0MLoH5WYl0jn/fyew==
X-Received: by 2002:a17:90b:2243:b0:1c3:40b:547 with SMTP id hk3-20020a17090b224300b001c3040b0547mr19157142pjb.69.1647257628571;
        Mon, 14 Mar 2022 04:33:48 -0700 (PDT)
Received: from ubuntu.mate (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a030300b001c17851b6a1sm13608117pje.28.2022.03.14.04.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:33:48 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] Documentation: add link to stable release candidate tree
Date:   Mon, 14 Mar 2022 18:33:28 +0700
Message-Id: <20220314113329.485372-5-bagasdotme@gmail.com>
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

There is also stable release candidate tree. Mention it, however with a
warning that the tree is for testing purposes.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/process/stable-kernel-rules.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index c207e476c11..c494914622e 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -180,6 +180,15 @@ Trees
 
 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
 
+ - The release candidate of all stable kernel versions can be found at:
+
+        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/
+
+   .. warning::
+      The -stable-rc tree is a snapshot in time of the stable-queue tree and
+      will change frequently, hence will be rebased often. It should only be
+      used for testing purposes (e.g. to be consumed by CI systems).
+
 
 Review committee
 ----------------
-- 
An old man doll... just what I always wanted! - Clara


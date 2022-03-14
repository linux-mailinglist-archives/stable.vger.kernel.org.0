Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815934D80D4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239049AbiCNLfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239035AbiCNLfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:35:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F05342486;
        Mon, 14 Mar 2022 04:33:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q13so13237064plk.12;
        Mon, 14 Mar 2022 04:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xJJVf4XEMS36RF5BbkvFmc1p0vno0lmSqAoaojk+slA=;
        b=PHPEp2SKy9JooD3Aftbg0qeiKDQRQUX/ARYN1xjsX0tgRSiBwubEkLn3uB4OT5ahh9
         cGf+l5rHd7iSPGDzTuK3Bm7z3cmy2mWruG3B+a3K8BucByQbZSH/7wJyt8nZ5tNVgxLo
         6TS5xdTpb9nx2JaL0gbb0/ikCmgNNQnBFpeLAy1Dp6XPgkTWkQnvR1jh4cLl4mYUFpga
         VHCBh3idXBfkvmEVA17siKwqAZPY1Ga0GdZJSp1Q4FoWadHV9hDkjh8n5an+AlqdeOqn
         X6h8bnwWz6TLNdsPw7NcX4hr13TOhxx5F953CufuBCAzz+LSXLutS9AMxcnt3T9KpKpK
         woSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xJJVf4XEMS36RF5BbkvFmc1p0vno0lmSqAoaojk+slA=;
        b=0TktoOJNyeGQMNQSu0zeIPkxHrYjwzqwivR0lVvTUlPYEqkC28oRMviy3yo1h7YXFS
         aXyjQAqwN/j2v1lMoW2h8gi3fm9T3hFGydonabkgfsKrMgcDjOuwSUIdVE9fxIYSwNq6
         +ZbRiTYo/RBppGGGWcxjSvaQmNny4bvZIZaSpee1et9iVYy39Gc4wbW4n3yzyIdETJcC
         H025IB62avjF9xOec4qtX+/Ui75y7BTpCTRGvN8E2LDRX6xNEr83/3EvV6f581SPHEHa
         5wNtPNnApxnHaP7r6aDasY0gjhmkWlJXzKNOLr5ltRxZqC6ybyhYgrE8qo2BNjIlkU5p
         NuoQ==
X-Gm-Message-State: AOAM533wEpNhBDuQrZYYaPF4/zIcWbZ9bX23v/2zcnftcK6hkKjvKtTU
        saFVN1Zy7eLVOs2UQnR+ACgl23VCraQ63A==
X-Google-Smtp-Source: ABdhPJzJP9uVr7dX011F6jFGipnvelTk+3P07bcB2Cn2YFKJ4ur9c+h3c15aMRP1gV9Kn0yvEESgWA==
X-Received: by 2002:a17:902:7805:b0:151:b8ec:202b with SMTP id p5-20020a170902780500b00151b8ec202bmr23074862pll.111.1647257631606;
        Mon, 14 Mar 2022 04:33:51 -0700 (PDT)
Received: from ubuntu.mate (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a030300b001c17851b6a1sm13608117pje.28.2022.03.14.04.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:33:51 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] Documentation: update stable tree link
Date:   Mon, 14 Mar 2022 18:33:29 +0700
Message-Id: <20220314113329.485372-6-bagasdotme@gmail.com>
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

The link to stable tree is redirected to
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git. Update
accordingly.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/process/stable-kernel-rules.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index c494914622e..a9a479fba90 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -178,7 +178,7 @@ Trees
  - The finalized and tagged releases of all stable kernels can be found
    in separate branches per version at:
 
-	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
+	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
 
  - The release candidate of all stable kernel versions can be found at:
 
-- 
An old man doll... just what I always wanted! - Clara


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020BE4D6D69
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 09:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiCLIC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 03:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiCLICY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 03:02:24 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A1E1C7E88;
        Sat, 12 Mar 2022 00:01:12 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id g1so9846548pfv.1;
        Sat, 12 Mar 2022 00:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rPJ6jpnft/qeiJ9pThscP2X0mTBWCChO9A5lcCNp75o=;
        b=DdyzYB8Kf80TQqvamWUY24GVeMKCK2OS+1AKcJI0Bj4KZbCqlWx83wya5zIyfWQoCW
         /0xKlBjHtl22WiLKd2NxkzYZGt3exkALDFYkYXOuoyog7wM/fc8yLszytcWrIEgHEGSF
         wsedfEgHCEWxC/oFbhftZYvXAjWe/Hw+ezVZ03BV9O8PypHCzaOsUEwWU9jtn5ceiFnC
         K37qcciOrCR0Ezyt7CZY6QjUmKGvw7JzcqskL2+/2LXpN2oiGt7IZ45hCXrdoRIzwJWK
         krQ2VBGF84AeC0/lEZ2Wldv5owSrZxhy0wr6lHJQe8fedIouAZrpPzGuvx/6soopJD0m
         CVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rPJ6jpnft/qeiJ9pThscP2X0mTBWCChO9A5lcCNp75o=;
        b=hK4snB3mBpPdc9cxjTEfYD5b1mA+xXtEaqesqA096DqmpK2mv44Ohbb/IzSkhqcROu
         qWnc/sHfHoexQ06V0w8oFgNJF1T3khuY8C3aDHbKuW8rYo9FBNB7wcgrJ4sxyZrtaGl4
         1aKZ/LteVcUN0dyMhjpDkkPvULuaLaXiRam7+LKmLMssIl7ouTLofNYdNM/urpV5OqKS
         reK7ZTcHAgcwrse/FmGlubZTmtHTYEot8KUcoZrpEPSvKd5eOtXLkCl1bG+QAbxYAOz3
         /hIQTKsw2TFf4xevAzbL8sfaGgBsXiHoZiYHNwsfIg2mDKixyxfr0ZegsWtFcKqrCG6N
         MamQ==
X-Gm-Message-State: AOAM533DLKXUUY4N01cROjwesf4Yu5nGm/dyLXw8QQBmZWl13R8jjkAX
        pNbup7jcuUQP06SEQF+0UxE7hGd8OBi/AQ==
X-Google-Smtp-Source: ABdhPJwSQVo+grdjIxNJ21cFe/2gUEeq6e5bpr7XGJmZ5dFnRMLY6KLzfAK5AFmU4U2qCBHNSuTEDQ==
X-Received: by 2002:a63:cf0c:0:b0:380:fb66:fa2a with SMTP id j12-20020a63cf0c000000b00380fb66fa2amr8236399pgg.273.1647072071673;
        Sat, 12 Mar 2022 00:01:11 -0800 (PST)
Received: from ubuntu.mate (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id x33-20020a056a0018a100b004f71b6a8698sm13025141pfh.169.2022.03.12.00.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 00:01:11 -0800 (PST)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Documentation: update stable tree link
Date:   Sat, 12 Mar 2022 15:00:43 +0700
Message-Id: <20220312080043.37581-5-bagasdotme@gmail.com>
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
index 523d2d35127..c242fe1788c 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -181,7 +181,7 @@ Trees
  - The finalized and tagged releases of all stable kernels can be found
    in separate branches per version at:
 
-	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
+	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
 
  - The release candidate of all stable kernel versions can be found at:
 
-- 
An old man doll... just what I always wanted! - Clara


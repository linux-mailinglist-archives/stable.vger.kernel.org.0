Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3440E563E72
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 06:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiGBE0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 00:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiGBE0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 00:26:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC16935DE0;
        Fri,  1 Jul 2022 21:26:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 136so4155676pfy.10;
        Fri, 01 Jul 2022 21:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnI/7Ov6YbpdQeEP05xUeEXN9eI+0MLVjCVd9MAZtjk=;
        b=bXIdLub1Pnvocp7RpggOw6BKJDRQUE3gnyDEdbsb79iJLKs9rvOxArzqx2oqoV1f7d
         3zla2Zq2cxAtvTl1/HA4ufwc63+/fP1qBC7La7DU+ie5r6dG6MvC4VzW94jpwS5fr28b
         4DA6csaBBCcwyxhHeXe/76ShCGTyvudTV9zigYs+EuEwNrpM8N/98HVg24rTZoy2wP/k
         A3/YE3fAxdT1zAniMUtr4bUaGo3rXg3iY9a0MpOYOkQQoZuO+E+vBeJGfWgSnNJkb/8e
         qkpqOftxhAjGjiZmmC1el9Gsyri9IELVeMGR6DuAFTyEr5iUU7Ym+01l3n5q1/aWXCrg
         AXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnI/7Ov6YbpdQeEP05xUeEXN9eI+0MLVjCVd9MAZtjk=;
        b=raiDFDiesGnkwYOSqJCVdORew4ZunmsC/I57tNmw21WC5CaNkC+ggRr3lQgm+Xe4wT
         awRFmWeiCDyzQNyP2KowtIZ2HyRtd9diTlmH0XsC0EovEuioxoAuAMUle6oauR7dHw3T
         JzDewp1LVozeAJ+4J55baIdC4ZiRxwrWTHbiSSoqjxdA4m8LjTHmGpzjuRIUOb0FZWYa
         LuLOtKy0HF91Y0w8mEKg4Sky/gEzRTlNO0qjGd2x4m2Ix4ZNGMPd6X7fEikyi7cHQBFB
         5Qf2P9Wst3xdgD7fLjtaOJQDjLgmjGahEBuEPFI9Hkx7FDb1fNg5Mns4BeZiswxm3+J5
         Wu9g==
X-Gm-Message-State: AJIora87iwj8dLNPl5aqqFZ3/Pw4M2QY3AhDGCuuq3jz7eMa11k7+YaA
        0Bjt1hw9Ch2qLopVBUAdTFM=
X-Google-Smtp-Source: AGRyM1sXOzvQDqtyzNo8A329BwQufwl42WeRYAYt/7k+ikN5zVMCZpb+DhGacMMhTAHQ8qQXOwVzUg==
X-Received: by 2002:a63:2ccd:0:b0:411:54ac:5c7e with SMTP id s196-20020a632ccd000000b0041154ac5c7emr15067038pgs.561.1656735978328;
        Fri, 01 Jul 2022 21:26:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id j17-20020a056a00175100b00522c0600de9sm16380010pfc.198.2022.07.01.21.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 21:26:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 98456103921; Sat,  2 Jul 2022 11:23:53 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Ross Zwisler <zwisler@kernel.org>,
        Colin Ian King <colin.king@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        dm-devel@redhat.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Documentation: dm writecache: Add missing blank line before optional parameters
Date:   Sat,  2 Jul 2022 11:23:49 +0700
Message-Id: <20220702042350.23187-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220702042350.23187-1-bagasdotme@gmail.com>
References: <20220702042350.23187-1-bagasdotme@gmail.com>
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

kernel test robot reported htmldocs warning which first happened 1 year ago:

Documentation/admin-guide/device-mapper/writecache.rst:23: WARNING: Unexpected indentation.

The warning above is due to missing blank line between numbered list (at
n. 5) and optional parameters list (as definition list).

Add the blank line to suppress the warning.

Link: https://lore.kernel.org/linux-doc/202207020824.oMJMSB8R-lkp@intel.com/
Fixes: d284f8248c72d0 ("dm writecache: support optional offset for start of device")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Colin Ian King <colin.king@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: dm-devel@redhat.com
Cc: stable@vger.kernel.org # v4.19+
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/device-mapper/writecache.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/writecache.rst b/Documentation/admin-guide/device-mapper/writecache.rst
index 10429779a91abc..6bf78b0446acba 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -20,6 +20,7 @@ Constructor parameters:
    size)
 5. the number of optional parameters (the parameters with an argument
    count as two)
+
 	start_sector n		(default: 0)
 		offset from the start of cache device in 512-byte sectors
 	high_watermark n	(default: 50)
-- 
An old man doll... just what I always wanted! - Clara


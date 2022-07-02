Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A670563E6D
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 06:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiGBE0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 00:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiGBE0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 00:26:20 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC3536303;
        Fri,  1 Jul 2022 21:26:19 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m14so4086308plg.5;
        Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8dpcDlwR6UgAXLxdxQBFPJ8Kqg1ETqhfqVNIp7mcNZk=;
        b=Vthj9m3tngYYIROVhJEkaL7JWxZ0s7vz0dot+0c6BrWKRuA7Ki0rhwDVIcasNvSXpc
         OsmqWrfn+0XNigUv1ItcNrUyirZTo2Cjc2tk1kR33FfYSK4bcU1bKrbtCSw15iAai/xr
         tFOCZKlKi9fiRvMrNBo84Ti5AiJGfXnk6uIdkpPadzuYnSZcrHQlL6Tj2bccqaaQTeh3
         HC/Okd+26UL7jg9n+jQrDxDeQcHsZFXZQCRouRep3rAOqZR4N0/jLPN3bHY5hMWe6NCk
         qXdhsWlJ5geFuPw8jVON5lJ+wFMbfGeb2e8quXP0hysEwGGFCO9x5qC0qkLz3fr2Phl1
         9pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8dpcDlwR6UgAXLxdxQBFPJ8Kqg1ETqhfqVNIp7mcNZk=;
        b=UyWgatFAlK5yXneKXwpWcPo+7Xm33/pRUCz/CDzqOtWNC3pQAinylgGwlwsLEIm2Os
         P1QDRw8WRYQlo6K/CPfgUdkoPcAKEvx5Ri38rA2iYM7AgxNdp87g+dubLTxOA1TwFbLM
         jlrY70uWLkNw5EMalO+Uzv5rjTjunnzDliGc3KP002K/nGQ23oqjP7mjwpTBTDJBgxvz
         aFDmxfrYBditDuhuiVFfvFk8hW83cd0zy/BKcsTjfaDHiU1nhQ9qGRN7aUm48We9EsEh
         J2OrOMaL9Juo10zrQTcNzaWcH3VWTzGGSvHRzgyx+GVbq/ZJddoSQINXmhKInxWUxK8D
         qKZg==
X-Gm-Message-State: AJIora/AecUBOzemo6Nfb9RPJPVSA8yZO7ezQUOOhWWsgnrOSz4ftc7w
        iCsHl+V+lC/YI59g/1ZiHD8=
X-Google-Smtp-Source: AGRyM1vsbc5MSeVulXe3sQnjanmzmFEPLLYT6pcFzsHsCiy0YajshHAxqtqNJ9FHkhsvi2+1XZXLww==
X-Received: by 2002:a17:90a:6fc5:b0:1ec:87db:b9f6 with SMTP id e63-20020a17090a6fc500b001ec87dbb9f6mr20617032pjk.104.1656735979173;
        Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id u9-20020a1709026e0900b0015e8d4eb2cdsm12305552plk.279.2022.07.01.21.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 21:26:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7A5F01038DE; Sat,  2 Jul 2022 11:23:53 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
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
Subject: [PATCH 2/2] Documentation: dm writecache: Render status list as list
Date:   Sat,  2 Jul 2022 11:23:50 +0700
Message-Id: <20220702042350.23187-3-bagasdotme@gmail.com>
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

The status list isn't rendered as list, but rather as normal paragraph,
because there is missing blank line between "Status:" line and the list.

Fix the issue by adding the blank line separator.

Fixes: 48debafe4f2fea ("dm: add writecache target")
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
index 6bf78b0446acba..2104812f028129 100644
--- a/Documentation/admin-guide/device-mapper/writecache.rst
+++ b/Documentation/admin-guide/device-mapper/writecache.rst
@@ -75,6 +75,7 @@ Constructor parameters:
 		the origin volume in the last n milliseconds
 
 Status:
+
 1. error indicator - 0 if there was no error, otherwise error number
 2. the number of blocks
 3. the number of free blocks
-- 
An old man doll... just what I always wanted! - Clara


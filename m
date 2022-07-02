Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C3D563E6C
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 06:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiGBE0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 00:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiGBE0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 00:26:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140C036172;
        Fri,  1 Jul 2022 21:26:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so8249834pjl.5;
        Fri, 01 Jul 2022 21:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CrnMX/y17RbreUUoQH2OPYzTSPe+shNvumhDkSBxTNs=;
        b=LInhJ5lXc+MaW6MvH/aptxzQFWfdvB2UO8DR8Wjh7getx8C6dvqj7fq9wB0AmB7/dx
         mF+WUddZfsr/Ganc9ugv2i4XUKCAkM1T58qtVDAlEl/zEPy6LyzXaeYZIzh/xBhLhtah
         2p78/GKWWcbM82objPtgj9QK09v5PEHmyALrQWdRpD/yaqpQQ78KYShaG3+W5h5AANlq
         Nuq+ycJkjmURk6R/Vnhqf315nazra3T/O4dMJ6TCwv1+U/XPDU/wyyJiKKjeXET/Qqjd
         D4cVEnCibyOb1rwiVMogDwes71Jw3wyvgf0MLnyiWHVGt2RrsauJbF5VYvus4M/PP11S
         rZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CrnMX/y17RbreUUoQH2OPYzTSPe+shNvumhDkSBxTNs=;
        b=uAgdgmOSi2s8KWgAg/v1hmpYGSUvRGYoR3drmj9i84/Qgn8z0c+SV9nQDFQlhJuTw6
         Y04yFuroh0nJOKncZrAv1OMKPXZhSfZm13so7rm+l0lr8FolkQgggkzstJlO2dermBi4
         6qW9u/Vd8Mf9QTwdWau53GC7t1seXggKB+VBtWb7mTFhKMQdOG+1SF/u9mDf/LvvQKhN
         GQM2cVPU1c3aUFUOgIz/Dzth3WXmmPWITdG8zDsPSU/Jo6cGH35OHotnTcmbziQKnSlc
         4Vr+GBaP8U3NZuN0qBuHSoS35cPzvPRxl6UR0uX0p6OnLl/788bNyAUPjiYs6b+F4ZWS
         l/kQ==
X-Gm-Message-State: AJIora/TFkhg2gtNXyHzhYEWfzHoeQUKX+D4TFvsEPkwFhD+9D5NWpav
        c7jFQYvlU0GZ+C0in2xpiyo=
X-Google-Smtp-Source: AGRyM1uZafyoF1S6AVLn7IBZsh2efEOnKLTPX84jcOmtzDIgrEzXdlwftEixQdfH+iRTZ0auN4LeFg==
X-Received: by 2002:a17:902:d491:b0:16a:76c5:c1fa with SMTP id c17-20020a170902d49100b0016a76c5c1famr24976368plg.103.1656735978654;
        Fri, 01 Jul 2022 21:26:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id q6-20020a63cc46000000b0040d287f1378sm16246039pgi.7.2022.07.01.21.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 21:26:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 21DDF1038FC; Sat,  2 Jul 2022 11:23:53 +0700 (WIB)
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
Subject: [PATCH 0/2] Documentation: dm writecache: documentation fixes
Date:   Sat,  2 Jul 2022 11:23:48 +0700
Message-Id: <20220702042350.23187-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.36.0
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

Two small documentation fixes for writecache functionality of device
mapper. The shortlog below should be self-explanatory.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Colin Ian King <colin.king@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: dm-devel@redhat.com
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Bagas Sanjaya (2):
  Documentation: dm writecache: Add missing blank line before optional
    parameters
  Documentation: dm writecache: Render status list as list

 Documentation/admin-guide/device-mapper/writecache.rst | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 089866061428ec9bf67221247c936792078c41a4
-- 
An old man doll... just what I always wanted! - Clara


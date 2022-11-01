Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115F8614B81
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 14:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiKANSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 09:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiKANSA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 09:18:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC581B9CE;
        Tue,  1 Nov 2022 06:17:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso12890095pjc.5;
        Tue, 01 Nov 2022 06:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SZStpR1lAywA4/7qBURPNQ4IOtsjBZHRYMQymFdTRYs=;
        b=ICimq5g3SQr0EIGp9dAm1iBnXGYoBdXWX7Gv9ZnxCtsXsO5J1XxqrXMmE/0r0ZjW51
         g7nKkmM10LXh9wUziD26lQkT+wheww9qrcNOgTxlPO/YYHuTBewnSu88T2SW7WYw1UlR
         cZt59i2idpItyoXU0tBDjhddgsZX5ug1jEQkqqlET0xkiayImhhdY8Jdy4/cICNGnDlm
         +47+l2yt2GELSHMuevXIyJJbFu5dLvr/EOaDzDIUfwASahd14yoWyniaRfT2q9z39lHW
         IYmuR5vmNAQLelfzfv9V7rIDRb/566d3s68VN0wWDhDdUiSGngmxdV0/XPCISwVa0weL
         fVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SZStpR1lAywA4/7qBURPNQ4IOtsjBZHRYMQymFdTRYs=;
        b=KOaTwh8hiEOK4D57IvlmhdKtiG1V2q0RZ0FmWP4C7XEDGYBCZKW1DBo2bOQF8hpFqa
         tjRl3jYAk7aOSy47FuJoMU45NC4m2/QiZo0BYIJeAYnVRH67DoseOq+77vteKeMnWPyp
         iAGw3HwJc9nSYjBNfIHA7ZoZQ4ey7eGAAnb4gfBrfT+Vcb3GrFPqJRtXzhDiQy6bt0Of
         WPSOzwGwJGoLOY9xgDm8LSvLtXHnAIK2PzIN27u38P5zX0uihQ3eB5r1ZYLF8AJbOE7q
         2zui714BEtvOFRUCzr8EY5tVts3TRRXd+Wsqs7PTXZQzxEh1zTLkEkdpRPph0EV0W7+R
         3Pww==
X-Gm-Message-State: ACrzQf2g8DnyRldZZBL+Olqdvuc0FmpOHFzq6VB+wr+SJ/NOGId92xLC
        jixia/eIxVzK57+RUcL3U+UtS7IF0bJFYg==
X-Google-Smtp-Source: AMsMyM5bwLtd76eUNGRWg9awECg+BMt4aF9pSYS0/6T/xy0NTPQ4TtVy0KFj2FKBug6dggT/UllhIA==
X-Received: by 2002:a17:902:d4ce:b0:186:c8b9:c301 with SMTP id o14-20020a170902d4ce00b00186c8b9c301mr19581091plg.27.1667308678756;
        Tue, 01 Nov 2022 06:17:58 -0700 (PDT)
Received: from debian.. (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902cece00b0017f64ab80e5sm6357767plg.179.2022.11.01.06.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 06:17:58 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     stable@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@denx.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] Documentation: process: Describe kernel version prefix for third option
Date:   Tue,  1 Nov 2022 20:17:43 +0700
Message-Id: <20221101131743.371340-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1745; i=bagasdotme@gmail.com; h=from:subject; bh=P8qNp9CcuZ7RseMNAYFQaX1Xu9cmLi6P2n4KkPfzHok=; b=owGbwMvMwCH2bWenZ2ig32LG02pJDMmJMuWiEy+adRatenJsZ3bKxLsMd2VT/UwOMGU1HJlgITPl +fu7HaUsDGIcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIoXRGhisPt4u2pAvHrxBWiPgWOi /9Iuc7n/ANj78Lm7U2Kr30N2Bk+BiY7tSWXSpbYz/DPEV/edUMAVHvJ+In22cGfD55WXcdDwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The current wording on third option of stable kernel submission doesn't
mention how to specify desired kernel version. Submitters reading the
documentation could simply send multiple backported patches of the same
upstream commit without any kernel version information, leaving stable
maintainers and reviewers hard time to figure out the correct kernel
version to be applied.

Describe the subject prefix for specifying kernel version for the case
above.

Cc: stable@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 This patch is sent as response to [1].

 [1]: https://lore.kernel.org/stable/20221101074351.GA8310@amd/

 Documentation/process/stable-kernel-rules.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 2fd8aa593a2851..409ae73c1ffcd1 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -77,7 +77,9 @@ Option 3
 Send the patch, after verifying that it follows the above rules, to
 stable@vger.kernel.org.  You must note the upstream commit ID in the
 changelog of your submission, as well as the kernel version you wish
-it to be applied to.
+it to be applied to by adding desired kernel version number to the
+patch subject prefix. For example, patches targeting 5.15 kernel should
+have ``[PATCH 5.15]`` prefix.
 
 :ref:`option_1` is **strongly** preferred, is the easiest and most common.
 :ref:`option_2` and :ref:`option_3` are more useful if the patch isn't deemed

base-commit: 30a0b95b1335e12efef89dd78518ed3e4a71a763
-- 
An old man doll... just what I always wanted! - Clara


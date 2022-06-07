Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B53D541961
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359385AbiFGVVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378158AbiFGVS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:18:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F25224120;
        Tue,  7 Jun 2022 11:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EBD1617D6;
        Tue,  7 Jun 2022 18:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56771C385A2;
        Tue,  7 Jun 2022 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628360;
        bh=GO2/dJXxU3jn4w3PPMjapgOqxAc5x+7aKg2QIYd8dO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MH31hcxO8Pk75agGzpy/6LET49xyVPmmBY1tgyt0TKuxQ0WPaXAknllJ6egI4SsgJ
         +yP8/va0JTPvAI8Q9XOyX2sYuMyTYan02j78fBa+J3H0sWjGhkHUv0CK2gWS0FpbNS
         xD49BhMvX2b0UHZ9jQfzu1la4Pbks7RE+C96kttI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Akira Yokosawa <akiyks@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 284/879] docs: driver-api/thermal/intel_dptf: Use copyright symbol
Date:   Tue,  7 Jun 2022 18:56:42 +0200
Message-Id: <20220607165011.091005074@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akira Yokosawa <akiyks@gmail.com>

[ Upstream commit 2c2de6f2e2bc444eed65eaa949b4fdadab93f6b3 ]

Using a substitution pattern of "|copy|" without including
isonum.txt causes a doc build warning.

Using the symbol "©" itself is a better choice for those
who read .rst sources.

Reported by: Randy Dunlap <rdunlap@infradead.org>

Fixes: 16c02447f3e1 ("Documentation: thermal: DPTF Documentation")
Suggested-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/thermal/intel_dptf.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/thermal/intel_dptf.rst b/Documentation/driver-api/thermal/intel_dptf.rst
index 96668dca753a..372bdb4d04c6 100644
--- a/Documentation/driver-api/thermal/intel_dptf.rst
+++ b/Documentation/driver-api/thermal/intel_dptf.rst
@@ -4,7 +4,7 @@
 Intel(R) Dynamic Platform and Thermal Framework Sysfs Interface
 ===============================================================
 
-:Copyright: |copy| 2022 Intel Corporation
+:Copyright: © 2022 Intel Corporation
 
 :Author: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
 
-- 
2.35.1




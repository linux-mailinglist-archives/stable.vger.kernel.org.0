Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD2159456D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350582AbiHOWTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346812AbiHOWP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E953B786DD;
        Mon, 15 Aug 2022 12:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E044611E0;
        Mon, 15 Aug 2022 19:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D361C433D6;
        Mon, 15 Aug 2022 19:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592363;
        bh=36kaqV//Q65MyMm68X4c+Dpwi17dNDifBxO1QrGo2o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqgBYFQcJzDA1Knqj7CT1QvYlUuXAcdw0V36CIXjyzlJaRLrthU9lPEW2BVr/IMXk
         +ZBItzJ5uR/MqOXiz8gKFIBdQWJEsmSQuPgmFscgGeNfS2ADzikRDyXK9rU4NrbacM
         CLLMRJ+vC42FxWcvm2WSRfitJUw478B9k+BUbxFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.19 0099/1157] um: Remove straying parenthesis
Date:   Mon, 15 Aug 2022 19:50:55 +0200
Message-Id: <20220815180443.587681164@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

commit c6496e0a4a90d8149203c16323cff3fa46e422e7 upstream.

Commit e3a33af812c6 ("um: fix and optimize xor select template for CONFIG64 and timetravel mode")
caused a build regression when CONFIG_XOR_BLOCKS and CONFIG_UML_TIME_TRAVEL_SUPPORT
are selected.
Fix it by removing the straying parenthesis.

Cc: stable@vger.kernel.org
Fixes: e3a33af812c6 ("um: fix and optimize xor select template for CONFIG64 and timetravel mode")
Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
[rw: Added commit message]
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/asm/xor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/include/asm/xor.h
+++ b/arch/um/include/asm/xor.h
@@ -18,7 +18,7 @@
 #undef XOR_SELECT_TEMPLATE
 /* pick an arbitrary one - measuring isn't possible with inf-cpu */
 #define XOR_SELECT_TEMPLATE(x)	\
-	(time_travel_mode == TT_MODE_INFCPU ? TT_CPU_INF_XOR_DEFAULT : x))
+	(time_travel_mode == TT_MODE_INFCPU ? TT_CPU_INF_XOR_DEFAULT : x)
 #endif
 
 #endif



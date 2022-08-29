Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42065A4642
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 11:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiH2Jkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 05:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiH2Jkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 05:40:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DE64505D;
        Mon, 29 Aug 2022 02:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1FBFB80CAB;
        Mon, 29 Aug 2022 09:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABD3C433D6;
        Mon, 29 Aug 2022 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661766034;
        bh=8w3m2pFW1bFCkH+w8JrXhF/YTRrc7mp0Up5rFqLYqNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBeYRDTfZPDBErsjkcs4dzEom8roBvY0BvgU5ul17FLGQRs3kR1phWrl06/tIsKfR
         CcHn4Raav4DZDFo13ELO6xmCwbiPKgdoKk6OfImRQANCeGTE+mymmAwUP+8SiEiuqE
         Yc218SPGtRDeJC6tYWnnp9rYehncHLz9I8f8hxvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.139
Date:   Mon, 29 Aug 2022 11:40:31 +0200
Message-Id: <166176603020038@kroah.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <166176603093188@kroah.com>
References: <166176603093188@kroah.com>
MIME-Version: 1.0
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

diff --git a/Makefile b/Makefile
index 234c8032c2b4..48140575f960 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 138
+SUBLEVEL = 139
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h b/scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h
new file mode 100644
index 000000000000..e69de29bb2d1

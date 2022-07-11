Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F047556FD94
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiGKJ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiGKJ5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:57:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EF9B4BE5;
        Mon, 11 Jul 2022 02:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C50EB80E8F;
        Mon, 11 Jul 2022 09:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C4BC341C8;
        Mon, 11 Jul 2022 09:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531606;
        bh=7glkkp0LLer/1vOu19Ra/fd2zYttlhPNl2QaoAA/NUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRJoLC+swP99YiWqrFNCE/D/y8b2XNi25A0YHYGUzBxEhytBy1JMy+EN/kKo9rruj
         Fn8IlTO0wSkCQCVw+ykwICMceMfKkmg6qvg8moBsvPN5chEh2Ag0qm4T9+U9jGEEQ9
         DpQuB1TJva5fAMRXdqx+bBebUILqy3hPN4y6qsaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 165/230] video: of_display_timing.h: include errno.h
Date:   Mon, 11 Jul 2022 11:07:01 +0200
Message-Id: <20220711090608.742508474@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsin-Yi Wang <hsinyi@chromium.org>

commit 3663a2fb325b8782524f3edb0ae32d6faa615109 upstream.

If CONFIG_OF is not enabled, default of_get_display_timing() returns an
errno, so include the header.

Fixes: 422b67e0b31a ("videomode: provide dummy inline functions for !CONFIG_OF")
Suggested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/video/of_display_timing.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/video/of_display_timing.h
+++ b/include/video/of_display_timing.h
@@ -8,6 +8,8 @@
 #ifndef __LINUX_OF_DISPLAY_TIMING_H
 #define __LINUX_OF_DISPLAY_TIMING_H
 
+#include <linux/errno.h>
+
 struct device_node;
 struct display_timing;
 struct display_timings;



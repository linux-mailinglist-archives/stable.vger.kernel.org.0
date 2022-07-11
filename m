Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D238E56F9AA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiGKJHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiGKJHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B7522BD6;
        Mon, 11 Jul 2022 02:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1AF06115B;
        Mon, 11 Jul 2022 09:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4A1C34115;
        Mon, 11 Jul 2022 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530426;
        bh=3Rmk8qZWpW2yMzZ5SsMzHiMd/7zR1ly06CyIaurBVtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9LlgR20keYs0zimBSBBjgZ/Zn9LbHAx8ptUTcfGmUCcn+ky8hGMjP3Dvnoc4D29v
         pNcV7PqnUNc6Fj93TTDWuMzIg9Z32jHbkT3dway5dSqd6WxSXZcZetNa7jmuSNPKcz
         UuKh4gLfL8wbxOD+QWEJBtJqgc3uegZN650uo5Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 07/14] video: of_display_timing.h: include errno.h
Date:   Mon, 11 Jul 2022 11:06:26 +0200
Message-Id: <20220711090535.736124488@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
References: <20220711090535.517697227@linuxfoundation.org>
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
@@ -9,6 +9,8 @@
 #ifndef __LINUX_OF_DISPLAY_TIMING_H
 #define __LINUX_OF_DISPLAY_TIMING_H
 
+#include <linux/errno.h>
+
 struct device_node;
 struct display_timing;
 struct display_timings;



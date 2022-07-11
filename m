Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5756F9E2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiGKJK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiGKJJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:09:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B99248FF;
        Mon, 11 Jul 2022 02:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14FA1B80E49;
        Mon, 11 Jul 2022 09:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D986C34115;
        Mon, 11 Jul 2022 09:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530495;
        bh=3Rmk8qZWpW2yMzZ5SsMzHiMd/7zR1ly06CyIaurBVtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcjOS2bRZXj6sKhmckvfvkR/31413NxKrQ3OhOXoHTDUEqbRi1pX5My600YILWOq4
         eDU+35/i2Iy8mXIzvpYQDXtJRfkGuwbSPP3lHYxq2gz7aNrnUVvF+0+jWe3wKsR+Tz
         VmIEuN2LDHxlcyfTdVRWaVSHOlwVOmj5D5Fd/kB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 09/17] video: of_display_timing.h: include errno.h
Date:   Mon, 11 Jul 2022 11:06:34 +0200
Message-Id: <20220711090536.537267956@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
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



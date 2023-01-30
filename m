Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084DB681237
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbjA3OTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbjA3OS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:18:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BC27681;
        Mon, 30 Jan 2023 06:17:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A58FB811E1;
        Mon, 30 Jan 2023 14:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBD8C4339E;
        Mon, 30 Jan 2023 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088268;
        bh=A3tC2FbFK0ui4EdTlSAS2z7JqfxGBW7AJ2cXa2P2ug8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2W6P0d1x6DC152GmSGuDCxeHAKKcm199g/bVolVYgyNxIghw0Sxt0+FisGHTsa0nW
         cywHwRqr6Q8r99eTEDu9LtTV8BRFtMVGyfeHf0zZQcLCnd2VltS/DScPU4SZ3i4gc7
         K9xofpndN4CeL9+OFWfWe9CN0NN1OHHEFAucSIkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/204] docs: Fix path paste-o for /sys/kernel/warn_count
Date:   Mon, 30 Jan 2023 14:51:46 +0100
Message-Id: <20230130134322.737944287@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 00dd027f721e0458418f7750d8a5a664ed3e5994 upstream.

Running "make htmldocs" shows that "/sys/kernel/oops_count" was
duplicated. This should have been "warn_count":

  Warning: /sys/kernel/oops_count is defined 2 times:
  ./Documentation/ABI/testing/sysfs-kernel-warn_count:0
  ./Documentation/ABI/testing/sysfs-kernel-oops_count:0

Fix the typo.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-doc/202212110529.A3Qav8aR-lkp@intel.com
Fixes: 8b05aa263361 ("panic: Expose "warn_count" to sysfs")
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-warn_count | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-warn_count b/Documentation/ABI/testing/sysfs-kernel-warn_count
index 08f083d2fd51..90a029813717 100644
--- a/Documentation/ABI/testing/sysfs-kernel-warn_count
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -1,4 +1,4 @@
-What:		/sys/kernel/oops_count
+What:		/sys/kernel/warn_count
 Date:		November 2022
 KernelVersion:	6.2.0
 Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
-- 
2.39.0




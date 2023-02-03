Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4644568959A
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbjBCKXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbjBCKX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D21C19694;
        Fri,  3 Feb 2023 02:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D59B82A68;
        Fri,  3 Feb 2023 10:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8D2C433EF;
        Fri,  3 Feb 2023 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419776;
        bh=zQYHj2KM02S7NwV8wPHwHGe2qHKXTCHAN6ATf9utus8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNP3a22+Ohd1n0QVErt9ueJifs8fLtRNrxXJT1hRoAcBE7RFItIipXVo8HwRcraVg
         yONpeSRn+a2uBqF3rIRdNmafKbm3MH+Q9ySrOfw5zXZlZz+X5IPjUwPyE1eiHcdbXL
         VEKh3WKTEOOsqBJ25ja25lMH8ZXotjlVMMBroX4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 77/80] docs: Fix path paste-o for /sys/kernel/warn_count
Date:   Fri,  3 Feb 2023 11:13:11 +0100
Message-Id: <20230203101018.546022139@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-kernel-warn_count |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-warn_count
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -1,4 +1,4 @@
-What:		/sys/kernel/oops_count
+What:		/sys/kernel/warn_count
 Date:		November 2022
 KernelVersion:	6.2.0
 Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>



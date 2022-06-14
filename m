Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F7E54B914
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357117AbiFNSpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiFNSod (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB254DF62;
        Tue, 14 Jun 2022 11:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A711617C2;
        Tue, 14 Jun 2022 18:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B43C3411D;
        Tue, 14 Jun 2022 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232197;
        bh=P5FmmPv7W8nZXq1bkPUvHhCzKWwpZrJWrZn48QxwLmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ziShOMiZmlli9nzLUbw1V/nYJ1cv+aPopqYG6lpDF6iFBaGGR4oaMQBpTL4ieNSvU
         AN9W1hy0CvFbYd5E7p2DK4Rb85iUIUKVKPRTp1jtRjM80kg/IzrB/zvkZHt/MjjNAH
         xXug8KZkhLZ+a3nZ0g78GZOSNwhMiTE84tffj8Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 03/16] x86/cpu: Add Jasper Lake to Intel family
Date:   Tue, 14 Jun 2022 20:40:04 +0200
Message-Id: <20220614183721.722449954@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
References: <20220614183720.928818645@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

commit b2d32af0bff402b4c1fce28311759dd1f6af058a upstream.

Japser Lake is an Atom family processor.
It uses Tremont cores and is targeted at mobile platforms.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -86,6 +86,7 @@
 
 #define INTEL_FAM6_ATOM_TREMONT_X	0x86 /* Jacobsville */
 #define INTEL_FAM6_ATOM_TREMONT		0x96 /* Elkhart Lake */
+#define INTEL_FAM6_ATOM_TREMONT_L	0x9C /* Jasper Lake */
 
 /* Xeon Phi */
 



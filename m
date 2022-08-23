Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E016F59D3E7
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbiHWIMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbiHWILB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:11:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4D46438;
        Tue, 23 Aug 2022 01:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52A2FB81BF8;
        Tue, 23 Aug 2022 08:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E06BC433D7;
        Tue, 23 Aug 2022 08:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242096;
        bh=gFXQRxtXqz+RRD14GNlAxmJ1RuaEsq6DD8fkF1qEdK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqT/Jwlydi89EKlKfhRunNOQjqTq0nT0bjcweT01S2/GveqdhWM5QsI3jYRsudbrc
         14IwfIHtgX4ftyApbecVDKlnxBvXZUFOyNyJOnjckhtY9p8FPSHmR1oEP0AgYEXH7c
         WHv7G0kq8lkmje/fzLc/PeG7+STNv2RKcwGl1ZT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH 4.9 018/101] init/main: properly align the multi-line comment
Date:   Tue, 23 Aug 2022 10:02:51 +0200
Message-Id: <20220823080035.269099048@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 1b3b3b49b9961401331a1b496db5bec5c7b41ae6 upstream.

Add a tab before it to follow standard practices. Also add the missing
full stop '.'.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -498,10 +498,10 @@ asmlinkage __visible void __init start_k
 	local_irq_disable();
 	early_boot_irqs_disabled = true;
 
-/*
- * Interrupts are still disabled. Do necessary setups, then
- * enable them
- */
+	/*
+	 * Interrupts are still disabled. Do necessary setups, then
+	 * enable them.
+	 */
 	boot_cpu_init();
 	page_address_init();
 	pr_notice("%s", linux_banner);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94605A48FD
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiH2LTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiH2LS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:18:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893611177;
        Mon, 29 Aug 2022 04:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C83D611B3;
        Mon, 29 Aug 2022 11:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5390C433C1;
        Mon, 29 Aug 2022 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771038;
        bh=CskFODK24XP61S8XHnOcBXRzfeS7HOnzRz69tyNccf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYxqUugzBuXLOYj3etsZw2ngRiIIqIweZulrRXdXN49fYIAg2v/6DtbGfZ9sl26SN
         eIZroEsjscrexESbb/ScWksKkUQ0vjbgN1zBRHl1E+c3u4d0GzVwIZcxFFSG3RpLuX
         8Ote4JhkRNdzRF6f34er1gAD2lXT3zy2XKZq32tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Su <suhui_kernel@163.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [PATCH 5.10 11/86] kernel/sched: Remove dl_boosted flag comment
Date:   Mon, 29 Aug 2022 12:58:37 +0200
Message-Id: <20220829105756.992352518@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Hui Su <suhui_kernel@163.com>

commit 0e3872499de1a1230cef5221607d71aa09264bd5 upstream.

since commit 2279f540ea7d ("sched/deadline: Fix priority
inheritance with multiple scheduling classes"), we should not
keep it here.

Signed-off-by: Hui Su <suhui_kernel@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Link: https://lore.kernel.org/r/20220107095254.GA49258@localhost.localdomain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -542,10 +542,6 @@ struct sched_dl_entity {
 	 * task has to wait for a replenishment to be performed at the
 	 * next firing of dl_timer.
 	 *
-	 * @dl_boosted tells if we are boosted due to DI. If so we are
-	 * outside bandwidth enforcement mechanism (but only until we
-	 * exit the critical section);
-	 *
 	 * @dl_yielded tells if task gave up the CPU before consuming
 	 * all its available runtime during the last job.
 	 *



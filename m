Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD7F5AB0D0
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbiIBM7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238647AbiIBM7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1682BD5DCB;
        Fri,  2 Sep 2022 05:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9C2B82A95;
        Fri,  2 Sep 2022 12:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A052AC433C1;
        Fri,  2 Sep 2022 12:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121511;
        bh=JPy/xrZXxNcdbj1iowz4GQ8lByASYODcJqylTdob+MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWECyqW/I9wHgw0tHd3/qTmX8LhA0Xj+40TQbDNyVT9KjBgDlIoqBgteuCMC26YXC
         FBcVmng1B9EKU/2mhCpYNy3x3qIwXQEa/QD1GDYp+XE6FdRnRxE6gqmqffllmwcq82
         oZGXuwS/LdIHcvuIb83jcz+Xcr2TLAdlmYKNpPQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "srivatsab@vmware.com, srivatsa@csail.mit.edu, akaher@vmware.com,
        amakhalov@vmware.com, vsirnapalli@vmware.com, sturlapati@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, Ankit Jain" 
        <ankitja@vmware.com>, Hui Su <suhui_kernel@163.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Ankit Jain <ankitja@vmware.com>
Subject: [PATCH 4.19 08/56] kernel/sched: Remove dl_boosted flag comment
Date:   Fri,  2 Sep 2022 14:18:28 +0200
Message-Id: <20220902121400.478281825@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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
[Ankit: Regenerated the patch for v4.19.y]
Signed-off-by: Ankit Jain <ankitja@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -528,10 +528,6 @@ struct sched_dl_entity {
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



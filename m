Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD965663F
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 01:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiL0AZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Dec 2022 19:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiL0AZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Dec 2022 19:25:51 -0500
Received: from out20-110.mail.aliyun.com (out20-110.mail.aliyun.com [115.124.20.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E26E9C
        for <stable@vger.kernel.org>; Mon, 26 Dec 2022 16:25:47 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3584884|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.134137-0.0107909-0.855072;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.QeaxVb7_1672100744;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.QeaxVb7_1672100744)
          by smtp.aliyun-inc.com;
          Tue, 27 Dec 2022 08:25:44 +0800
Date:   Tue, 27 Dec 2022 08:25:45 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     stable@vger.kernel.org
Subject: queue-6.1 drop perf-stat-display-event-stats-using-aggr-counts.patch please
Message-Id: <20221227082544.AC63.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

drop perf-stat-display-event-stats-using-aggr-counts.patch
from queue-6.1 please.

It failed to compile on 6.1.y now.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/12/27



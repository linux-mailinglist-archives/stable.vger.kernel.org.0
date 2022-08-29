Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C09E5A40DC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 04:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiH2CAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 22:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2CA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 22:00:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C35713D57;
        Sun, 28 Aug 2022 19:00:27 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGD9P3fgmznTlQ;
        Mon, 29 Aug 2022 09:58:01 +0800 (CST)
Received: from huawei.com (10.67.174.191) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 29 Aug
 2022 10:00:25 +0800
From:   Li Hua <hucool.lihua@huawei.com>
To:     <peterz@infradead.org>, <hucool.lihua@huawei.com>
CC:     <bristot@redhat.com>, <bsegall@google.com>,
        <dietmar.eggemann@arm.com>, <juri.lelli@redhat.com>,
        <linux-kernel@vger.kernel.org>, <mgorman@suse.de>,
        <mingo@redhat.com>, <rostedt@goodmis.org>,
        <stable@vger.kernel.org>, <vincent.guittot@linaro.org>,
        <vschneid@redhat.com>
Subject: Re: [PATCH -next] sched/cputime: Fix the bug of reading time backward from /proc/stat
Date:   Mon, 29 Aug 2022 23:57:24 +0800
Message-ID: <20220829155724.53581-1-hucool.lihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817004445.43216-1-hucool.lihua@huawei.com>
References: <20220817004445.43216-1-hucool.lihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping...

Thank you for your reply.

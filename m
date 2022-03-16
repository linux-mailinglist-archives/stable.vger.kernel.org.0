Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADEE4DAA2D
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 07:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbiCPGCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 02:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiCPGCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 02:02:30 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEA060064
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 23:01:16 -0700 (PDT)
X-UUID: 478691174e064559b27fe260b8858b2a-20220316
X-UUID: 478691174e064559b27fe260b8858b2a-20220316
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <cheng-jui.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1481693341; Wed, 16 Mar 2022 14:01:13 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 16 Mar 2022 14:01:12 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 16 Mar 2022 14:01:11 +0800
Message-ID: <6eb2052f463d323b0a82e795d765afb9d5925f6e.camel@mediatek.com>
Subject: apply commit 61cc4534b655 ("locking/lockdep: Avoid potential access
 of invalid memory in lock_class") to linux-5.4-stable
From:   Cheng Jui Wang <cheng-jui.wang@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Bart Van Assche" <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        Eason-YH Lin <eason-yh.lin@mediatek.com>
Date:   Wed, 16 Mar 2022 14:01:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Reviewers,

This patch fixes a use-after-free error when /proc/lockdep is read by
user after a lockdep splat.

I checked and I think this patch can be applied to stable-5.4 and
later. 

commit: 61cc4534b6550997c97a03759ab46b29d44c0017
Subject: locking/lockdep: Avoid potential access of invalid memory in
lock_class

Thanks.
Cheng-Jui Wang



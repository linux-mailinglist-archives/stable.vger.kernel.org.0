Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6969504E5B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237496AbiDRJaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbiDRJaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:30:09 -0400
X-Greylist: delayed 1385 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Apr 2022 02:27:30 PDT
Received: from mail1.wrs.com (unknown-3-146.windriver.com [147.11.3.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F0C15FF0
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:27:30 -0700 (PDT)
Received: from mail.windriver.com (mail.wrs.com [147.11.1.11])
        by mail1.wrs.com (8.15.2/8.15.2) with ESMTPS id 23I9RTCi005708
        (version=TLSv1.1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:27:29 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.corp.ad.wrs.com [147.11.82.252])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 23I9RTLJ001333
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:27:29 -0700 (PDT)
Received: from otp-dpanait-l2.corp.ad.wrs.com (128.224.125.182) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 18 Apr 2022 02:27:28 -0700
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     <stable@vger.kernel.org>
CC:     <dragos.panait@windriver.com>
Subject: [PATCH 4.19 0/1] can: usb_8dev: backport fix for CVE-2022-28388
Date:   Mon, 18 Apr 2022 12:26:41 +0300
Message-ID: <20220418092642.2351883-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [128.224.125.182]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit is needed to fix CVE-2022-28388:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d3925ff6433f98992685a9679613a2cc97f3ce2

Hangyu Hua (1):
  can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in
    error path

 drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)


base-commit: aaad8e56ca1e56fe34b5a33f30fb6f9279969020
-- 
2.25.1


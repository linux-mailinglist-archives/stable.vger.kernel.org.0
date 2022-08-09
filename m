Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB80F58DB89
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244883AbiHIQCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 12:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiHIQCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 12:02:51 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF33215711
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 09:02:49 -0700 (PDT)
Received: from lvc-arm12.ispras.local (unknown [83.149.199.125])
        by mail.ispras.ru (Postfix) with ESMTPS id CE02340D4004;
        Tue,  9 Aug 2022 16:02:46 +0000 (UTC)
From:   Viacheslav Sablin <sablin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Viacheslav Sablin <sablin@ispras.ru>,
        Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] mac80211: fix a memory leak where sta_info is not freed
Date:   Tue,  9 Aug 2022 19:02:44 +0300
Message-Id: <20220809160245.29232-1-sablin@ispras.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzkaller reports memory leak issue at ieee80211_ibss_rx_no_sta() 
in 5.10 stable releases. The problem has been fixed by the following patch 
which can be cleanly applied to the 5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

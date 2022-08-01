Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C742B586E2F
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 17:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiHAP7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 11:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHAP7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 11:59:54 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A1D3343D
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:59:51 -0700 (PDT)
Received: from localhost.localdomain (unknown [95.31.173.239])
        by mail.ispras.ru (Postfix) with ESMTPSA id 35B0740D403D;
        Mon,  1 Aug 2022 15:59:46 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 0/2] ath9k_htc: fix NULL pointer dereferences at ath9k_htc_rxep() and ath9k_htc_tx_get_packet()
Date:   Mon,  1 Aug 2022 18:59:06 +0300
Message-Id: <20220801155908.1539833-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzkaller reports NULL pointer dereference issues at ath9k_htc_rxep()
and ath9k_htc_tx_get_packet() in 5.10 stable releases. The problems have
been fixed by the following patch series which can be cleanly applied to
the 5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9115859C031
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbiHVNIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiHVNIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:08:41 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05AC616B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:08:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [95.31.169.23])
        by mail.ispras.ru (Postfix) with ESMTPSA id EABA040737B6;
        Mon, 22 Aug 2022 13:08:17 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
Date:   Mon, 22 Aug 2022 16:08:04 +0300
Message-Id: <20220822130805.261446-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
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

WARN_ON_ONCE macro should not be triggered in that place so better to
replace it with more appropriate netdev_warn_once() in 5.10 stable branch.

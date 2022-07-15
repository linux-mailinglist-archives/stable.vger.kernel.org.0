Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BFA576535
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiGOQ1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiGOQ1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:04 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D2A564CA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id F1E5E40755C7;
        Fri, 15 Jul 2022 16:27:01 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.10 0/7] net: fix use-after-free of net_device's in __rtnl_newlink()
Date:   Fri, 15 Jul 2022 19:26:25 +0300
Message-Id: <20220715162632.332718-1-pchelkin@ispras.ru>
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

Syzkaller reports use-after-free for net_device's in 5.10 stable releases.
The problem has been fixed by the following patch series and
it can be cleanly applied to the 5.10 branch.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.


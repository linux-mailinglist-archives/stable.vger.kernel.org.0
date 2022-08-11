Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8998C590899
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 00:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiHKWIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 18:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiHKWIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 18:08:19 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80656A0262
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 15:08:16 -0700 (PDT)
Received: from hednb3.intra.ispras.ru (unknown [109.252.119.247])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8BE2F40737A5;
        Thu, 11 Aug 2022 22:08:14 +0000 (UTC)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        ldv-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] Backport support for tracing capacity constants
Date:   Fri, 12 Aug 2022 01:08:02 +0300
Message-Id: <1660255683-1889-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzkaller reports a number of "BUG: MAX_LOCKDEP_CHAINS too low!" warnings
on 5.10 branch and it means that the fuzz testing is terminated prematurely.
Since upstream patch that allows to increase limits is applied cleanly
and our testing demonstrated that it works well, we suggest to backport
it to the 5.10 branch.

--
Alexey

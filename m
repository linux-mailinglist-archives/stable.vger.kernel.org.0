Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82495292AD
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 23:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiEPVNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 17:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349398AbiEPVM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 17:12:26 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF30540E46
        for <stable@vger.kernel.org>; Mon, 16 May 2022 14:04:21 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4L2BMr2HXhz9sS6
        for <stable@vger.kernel.org>; Mon, 16 May 2022 22:55:04 +0200 (CEST)
From:   Markus Boehme <markubo@amazon.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 0/2] x86/xen: Make the idle task stacks reliable
Date:   Mon, 16 May 2022 22:54:37 +0200
Message-Id: <20220516205439.255114-1-markubo@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: nry8i5mrkqwj19bbisashsrexm6n87gg
X-MBO-RS-ID: cfc89b47120c6217942
X-Rspamd-Queue-Id: 4L2BMr2HXhz9sS6
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux v5.7 introduced a couple patches to make walking the stack of the
idle tasks reliable when Linux runs as a Xen PV guest. Attached are the
backports for the 5.4 LTS, which are of special interest when using the
livepatch subsystem.

Markus



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC076B63C7
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 09:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCLIEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 04:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCLIEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 04:04:05 -0400
Received: from w4.tutanota.de (w4.tutanota.de [81.3.6.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80817303FB;
        Sun, 12 Mar 2023 00:04:03 -0800 (PST)
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
        by w4.tutanota.de (Postfix) with ESMTP id DA644106015F;
        Sun, 12 Mar 2023 08:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678608241;
        s=s1; d=tuta.io;
        h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
        bh=9cV4gJAAyf09YrEjy9VeU7LRiU4Jxu9VTZ0+rWXShHQ=;
        b=ra6JmJf+pixEfoP9ckGByygDU8Fcl2UXTUzNHrdUzbUeuK0YviS1usHXsRFknSij
        Trg7yQ43nHVdUhYyvEZOPCDrOUpHvNAwxCJYGFjhOZKzfq9IE3Yh4KE+PTGO3memxIo
        kluv66Kimwgsb+MuwwD0XmGJdufQ+dIVjEmdqNKHPkI3XGv8BKlG+VOAzP4wWhEcL5J
        YqTAAVYVMFR+YVnQcPnw4uMUjyNk9l2zydbxNlthylaDFYRZTQiedCUKc3+vqrhWDcF
        ybhYXkVb9W0AGP3VI6Hpu6cKByoMfMgXnHSeNT/XXUVBsnCo2shYwGXRjeNvusuUEJ1
        U6UlwVVBGQ==
Date:   Sun, 12 Mar 2023 09:04:01 +0100 (CET)
From:   "A.P. Jo." <apjo@tuta.io>
To:     Stable <stable@vger.kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <NQJqG8n--3-9@tuta.io>
Subject: Bricked LTS Kernel: Questionable i915 Commit
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Linux dev community,

5.15.99 LTS and higher can't boot on many laptops using Intel graphics.

Originally spotted using Alpine Linux, see: https://gitlab.alpinelinux.org/alpine/aports/-/issues/14704.
Seems to have been traced to commit 4eb6789f9177a5fdb90e1b7cdd4b069d1fb9ce45, see i915 git issue: https://gitlab.freedesktop.org/drm/intel/-/issues/8284.

Suggest releasing with patch undone or fixed.

Thanks,
Anant Prem Joshi.

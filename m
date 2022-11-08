Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5568F62141D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbiKHN5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiKHN5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:57:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F21CCCF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A59ECE1B96
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326FCC433B5;
        Tue,  8 Nov 2022 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915826;
        bh=D0jJIemx6fqoLQzv6MyEpZjQy3nqd7ClP1DdBqbamak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWj2nsOi3ylBWXoeQVOEb88VrvrJgrUrioF+PjwjsLfYmVXVjghhJxSkJfwLx5LSD
         Zh0Oj0/gzucZ+/bnhg5qFenqYwp1GoxdfqZYC4JLO3zoyHcoGo9tRF5mMjgrKRhCXh
         vR4Y8mLk1reuhBvdI47VDz3R3M2PLpwSX8ApbmSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 102/118] parisc: Export iosapic_serial_irq() symbol for serial port driver
Date:   Tue,  8 Nov 2022 14:39:40 +0100
Message-Id: <20221108133345.152513700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit a0c9f1f2e53b8eb2ae43987a30e547ba56b4fa18 upstream.

The parisc serial port driver needs this symbol when it's compiled
as module.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: kernel test robot <lkp@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/iosapic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -875,6 +875,7 @@ int iosapic_serial_irq(struct parisc_dev
 
 	return vi->txn_irq;
 }
+EXPORT_SYMBOL(iosapic_serial_irq);
 #endif
 
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B9062131B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiKHNqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiKHNqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:46:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C9459859
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:46:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C320B81AEE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF48C433D6;
        Tue,  8 Nov 2022 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915200;
        bh=epfwt4R+Vqb2uPFXpJPcuM80qjAyy3Lx/TZgZKiqD3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUkyaMN5/AO8fY7nkg9a6joalRtq4YkttM7AJ48n9ixCG9/eRXSBWDbXsw7HxAHXZ
         FDs32V/7lYv4habhkz1g0O4NBmfDCYh2E/n6U1moNb6dm18or9G8Iq2w2zOB7RC5VB
         5zoGUgqILoOCP+gKbmf++1VAvT+ypW3YviaLm6pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 4.19 40/48] parisc: Export iosapic_serial_irq() symbol for serial port driver
Date:   Tue,  8 Nov 2022 14:39:25 +0100
Message-Id: <20221108133330.978772900@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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
@@ -889,6 +889,7 @@ int iosapic_serial_irq(struct parisc_dev
 
 	return vi->txn_irq;
 }
+EXPORT_SYMBOL(iosapic_serial_irq);
 #endif
 
 



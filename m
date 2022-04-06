Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531C84F6A32
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiDFTpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiDFTp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B020A1E110D;
        Wed,  6 Apr 2022 11:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C19361C57;
        Wed,  6 Apr 2022 18:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C7CC385A3;
        Wed,  6 Apr 2022 18:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269645;
        bh=1f90r0PPcWyC00HpJvDQcFTIRgfNox54/raYZWqCdlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hj8AgYaJdghULcuPho5HQJyN4Ms0g54iIOWvjNR6FCmUrexSjegxlgv1o8D1bWuh
         V2pOAEHBnFSECA1mkbhfnnivOvON2P3vYk/EOogUAvprbWlPWe+0MA53xg8UTr9BYL
         qIPZJxgfXh2rsSyuR0Jyjmlj6LtU9WvNi4r95pRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 18/43] arm64: Add silicon-errata.txt entry for ARM erratum 1188873
Date:   Wed,  6 Apr 2022 20:26:27 +0200
Message-Id: <20220406182437.212978702@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit e03a4e5bb7430f9294c12f02c69eb045d010e942 upstream.

Document that we actually work around ARM erratum 1188873

Fixes: 95b861a4a6d9 ("arm64: arch_timer: Add workaround for ARM erratum 1188873")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -55,6 +55,7 @@ stable kernels.
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
+| ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
 | ARM            | MMU-500         | #841119,#826419 | N/A                         |
 |                |                 |                 |                             |
 | Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375        |



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD6158690A
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiHAL4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiHAL4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:56:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A39447BA7;
        Mon,  1 Aug 2022 04:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E004EB8117B;
        Mon,  1 Aug 2022 11:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD1FC433C1;
        Mon,  1 Aug 2022 11:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354693;
        bh=5QFadlSXgXSglT340fPMpSI4euDZVQDvEDAnpaAMXg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yyIoUIC2h4cHymeDBAwl26Zqzreahc9/ylm6t88FgHy3eF5TlJFeOuYi+6WpHSBPS
         2LHEhLMkiksYHoQ3Fym8Xf7FfSNpJaYwjAe5sip4PBG4VTw0wS/YtyzhCkU6A14v+x
         QTA+7X1LOy70uEOCRKlyJDZkcuyhJWqHcX3Z0RiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Borislav Petkov <bp@suse.de>, corbet@lwn.net
Subject: [PATCH 5.10 52/65] docs/kernel-parameters: Update descriptions for "mitigations=" param with retbleed
Date:   Mon,  1 Aug 2022 13:47:09 +0200
Message-Id: <20220801114135.857998247@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114133.641770326@linuxfoundation.org>
References: <20220801114133.641770326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

commit ea304a8b89fd0d6cf94ee30cb139dc23d9f1a62f upstream.

Updates descriptions for "mitigations=off" and "mitigations=auto,nosmt"
with the respective retbleed= settings.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: corbet@lwn.net
Link: https://lore.kernel.org/r/20220728043907.165688-1-eiichi.tsukata@nutanix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2873,6 +2873,7 @@
 					       no_entry_flush [PPC]
 					       no_uaccess_flush [PPC]
 					       mmio_stale_data=off [X86]
+					       retbleed=off [X86]
 
 				Exceptions:
 					       This does not have any effect on
@@ -2895,6 +2896,7 @@
 					       mds=full,nosmt [X86]
 					       tsx_async_abort=full,nosmt [X86]
 					       mmio_stale_data=full,nosmt [X86]
+					       retbleed=auto,nosmt [X86]
 
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this



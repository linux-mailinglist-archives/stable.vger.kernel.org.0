Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57F45869D1
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiHAMHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiHAMHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:07:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C259C4D14A;
        Mon,  1 Aug 2022 04:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 498CBB80EAC;
        Mon,  1 Aug 2022 11:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9E0C433C1;
        Mon,  1 Aug 2022 11:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354919;
        bh=KvfUaIHcTB0p6wpwGMyOq7nomADf+22xhnDmP9/yU04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDPNI95bnoQWzG498pd6vC1DKvwFS245zYjbXxFIiy2Ru8pomXLdnxLsZBt6gostk
         m4xdp/hQVRtY7vh6Nq1/vrG47RM2C4Uvlw4fDXmr5Qc+h05tX1xm0vf5hTl0R6ln/d
         yeSOuiaAyKsDd+pcrba4DR14hWPgMVCpoFcbb2xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Borislav Petkov <bp@suse.de>, corbet@lwn.net
Subject: [PATCH 5.15 67/69] docs/kernel-parameters: Update descriptions for "mitigations=" param with retbleed
Date:   Mon,  1 Aug 2022 13:47:31 +0200
Message-Id: <20220801114137.165241886@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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
@@ -3020,6 +3020,7 @@
 					       no_entry_flush [PPC]
 					       no_uaccess_flush [PPC]
 					       mmio_stale_data=off [X86]
+					       retbleed=off [X86]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3042,6 +3043,7 @@
 					       mds=full,nosmt [X86]
 					       tsx_async_abort=full,nosmt [X86]
 					       mmio_stale_data=full,nosmt [X86]
+					       retbleed=auto,nosmt [X86]
 
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30961586A9B
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiHAMTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiHAMSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:18:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491CC80F49;
        Mon,  1 Aug 2022 04:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04378601CD;
        Mon,  1 Aug 2022 11:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E96C433C1;
        Mon,  1 Aug 2022 11:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355165;
        bh=s6/Q8Al62DMo2y50v8o5Znuj8DH9PcBFebnUBPhX7EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taIk3IZk4U63SyPDoxROuRIJzY1QKIcIjty8Fl8yeeuS64YZwzXghr7U0e1AOtTJW
         GkXLzaPbdgnUchnjwN18f9LuSjI7LKT8y6Uu6kpgS8/GbmrWWOMvrobfN6Rf6p3ptS
         JUM0fOsjQKfLLSaNARXPHgsrKHK3xHl3GZGDlVK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        Borislav Petkov <bp@suse.de>, corbet@lwn.net
Subject: [PATCH 5.18 86/88] docs/kernel-parameters: Update descriptions for "mitigations=" param with retbleed
Date:   Mon,  1 Aug 2022 13:47:40 +0200
Message-Id: <20220801114141.904693588@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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
@@ -3106,6 +3106,7 @@
 					       no_entry_flush [PPC]
 					       no_uaccess_flush [PPC]
 					       mmio_stale_data=off [X86]
+					       retbleed=off [X86]
 
 				Exceptions:
 					       This does not have any effect on
@@ -3128,6 +3129,7 @@
 					       mds=full,nosmt [X86]
 					       tsx_async_abort=full,nosmt [X86]
 					       mmio_stale_data=full,nosmt [X86]
+					       retbleed=auto,nosmt [X86]
 
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this



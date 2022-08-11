Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9582E58FD62
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiHKNaZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiHKNaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C11114B
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F001C614FC
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07022C433D7;
        Thu, 11 Aug 2022 13:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660224623;
        bh=rt1yobvJXUQnRvA/4s2GLU5opIzeCjkHvpBbVbKg7Qs=;
        h=Subject:To:Cc:From:Date:From;
        b=WNkSpvvUoPpgmFgcHPPwyIfzi6dGGRBdhseJomFr8Kj8CE/a/gDq2rCVOxMIQMKxJ
         A+QsiJdgbZ2kf0PmWu+iprAeIIEYpctE+s0eT7TX0JDoqO+ribyfiICCeuBLpdoXNF
         P0bxrz266Q2pEv7PBdX7kPcq89HlSLp0k14KS7Xg=
Subject: FAILED: patch "[PATCH] NFSD: Clean up the show_nf_flags() macro" failed to apply to 5.10-stable tree
To:     chuck.lever@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Aug 2022 15:30:20 +0200
Message-ID: <1660224620154165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bb283ca18d1e67c82d22a329c96c9d6036a74790 Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Sun, 27 Mar 2022 16:43:03 -0400
Subject: [PATCH] NFSD: Clean up the show_nf_flags() macro

The flags are defined using C macros, so TRACE_DEFINE_ENUM is
unnecessary.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index feb6e6f834b6..a60ead3b227a 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -692,12 +692,6 @@ DEFINE_CLID_EVENT(confirmed_r);
 /*
  * from fs/nfsd/filecache.h
  */
-TRACE_DEFINE_ENUM(NFSD_FILE_HASHED);
-TRACE_DEFINE_ENUM(NFSD_FILE_PENDING);
-TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_READ);
-TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_WRITE);
-TRACE_DEFINE_ENUM(NFSD_FILE_REFERENCED);
-
 #define show_nf_flags(val)						\
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\


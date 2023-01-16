Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE17066C821
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbjAPQgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbjAPQgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331631E27
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:24:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DD46B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C04C433EF;
        Mon, 16 Jan 2023 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886280;
        bh=LTXeYNjfoeH0hkMRfd1kIlFfsqUDRKZjxUkLpDuRLww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qt7Cj44j3DfS3yrAKS0DR47dbqi/aWw8Zx/bAu9mnbVXbnfPnC5ncZgCFDtJkF+zd
         ma3HxlgDzte+xfd5RJlu564bdcbJzU9FyEqXtRLOq5ulst4d/+klkTnF2LwK8Vkr+r
         TzOAjSCo5Ir5OOs0KxZn7jCT0vLIGQrvtwz3kUn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 370/658] nfsd: Define the file access mode enum for tracing
Date:   Mon, 16 Jan 2023 16:47:38 +0100
Message-Id: <20230116154926.499053436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit c19285596de699e4602f9c89785e6b8c29422286 ]

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Stable-dep-of: 3bc8edc98bd4 ("nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 127db5351d01..dc6aae4ef41d 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -166,6 +166,12 @@ DEFINE_STATEID_EVENT(layout_recall_done);
 DEFINE_STATEID_EVENT(layout_recall_fail);
 DEFINE_STATEID_EVENT(layout_recall_release);
 
+TRACE_DEFINE_ENUM(NFSD_FILE_HASHED);
+TRACE_DEFINE_ENUM(NFSD_FILE_PENDING);
+TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_READ);
+TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_WRITE);
+TRACE_DEFINE_ENUM(NFSD_FILE_REFERENCED);
+
 #define show_nf_flags(val)						\
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\
-- 
2.35.1




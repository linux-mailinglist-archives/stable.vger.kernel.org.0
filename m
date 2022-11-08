Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE8B6214E1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiKHOGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiKHOGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2989B7054C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5751615B4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D6BC433D6;
        Tue,  8 Nov 2022 14:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916360;
        bh=ruYVwcD0pygA3xGuMQL2vNu76g0uIown+H+aSRRP5ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7f7guIeasNMm1cv1+VmJX/h9/leurpS1v+9kX3D5v5XpT9xTb344ChGQehMY6Uo2
         VWok2oo0uJm3t+80bnu5LdPnK0gri02DWyO0uSEEbMooFPZGHvXbZ/hO8II5Jmt6Xd
         m+hzRN/4a97n3odW8Uj0wSOfP2zCHrJH9K2gnEq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 111/144] tracing/histogram: Update document for KEYS_MAX size
Date:   Tue,  8 Nov 2022 14:39:48 +0100
Message-Id: <20221108133350.003231404@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

commit a635beeacc6d56d2b71c39e6c0103f85b53d108e upstream.

After commit 4f36c2d85ced ("tracing: Increase tracing map KEYS_MAX size"),
'keys' supports up to three fields.

Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20221017103806.2479139-1-zhengyejian1@huawei.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/trace/histogram.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -39,7 +39,7 @@ Documentation written by Tom Zanussi
   will use the event's kernel stacktrace as the key.  The keywords
   'keys' or 'key' can be used to specify keys, and the keywords
   'values', 'vals', or 'val' can be used to specify values.  Compound
-  keys consisting of up to two fields can be specified by the 'keys'
+  keys consisting of up to three fields can be specified by the 'keys'
   keyword.  Hashing a compound key produces a unique entry in the
   table for each unique combination of component keys, and can be
   useful for providing more fine-grained summaries of event data.



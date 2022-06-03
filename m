Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E2A53D051
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346204AbiFCSCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346133AbiFCR7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D93443C6;
        Fri,  3 Jun 2022 10:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73086B82189;
        Fri,  3 Jun 2022 17:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0272C341CB;
        Fri,  3 Jun 2022 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278941;
        bh=AcfFm/yHcxVrDDYCPrsFv0Wa5KiA0w+LkOopDm5lkzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj3ysM0lUaORig/MBFm5iTY29/z3zZm3XwT60DYGqNmrQtVGvBfrjUdPch8yiqyDO
         7kBa772j52lSNvQ/ZP13FHSFx43t9vepukGROG4BqsN4QacY0kepmo4mMn0KvwtPml
         jHaXni8CiH8YjrVoIh2OM9uxkvRVrqTFX9erGGw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akira Yokosawa <akiyks@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 66/75] docs: submitting-patches: Fix crossref to The canonical patch format
Date:   Fri,  3 Jun 2022 19:43:50 +0200
Message-Id: <20220603173823.603641865@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Akira Yokosawa <akiyks@gmail.com>

commit 6d5aa418b3bd42cdccc36e94ee199af423ef7c84 upstream.

The reference to `explicit_in_reply_to` is pointless as when the
reference was added in the form of "#15" [1], Section 15) was "The
canonical patch format".
The reference of "#15" had not been properly updated in a couple of
reorganizations during the plain-text SubmittingPatches era.

Fix it by using `the_canonical_patch_format`.

[1]: 2ae19acaa50a ("Documentation: Add "how to write a good patch summary" to SubmittingPatches")

Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Fixes: 5903019b2a5e ("Documentation/SubmittingPatches: convert it to ReST markup")
Fixes: 9b2c76777acc ("Documentation/SubmittingPatches: enrich the Sphinx output")
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: stable@vger.kernel.org # v4.9+
Link: https://lore.kernel.org/r/64e105a5-50be-23f2-6cae-903a2ea98e18@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/submitting-patches.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -77,7 +77,7 @@ as you intend it to.
 
 The maintainer will thank you if you write your patch description in a
 form which can be easily pulled into Linux's source code management
-system, ``git``, as a "commit log".  See :ref:`explicit_in_reply_to`.
+system, ``git``, as a "commit log".  See :ref:`the_canonical_patch_format`.
 
 Solve only one problem per patch.  If your description starts to get
 long, that's a sign that you probably need to split up your patch.



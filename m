Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD544561DA6
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbiF3OGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiF3OFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 10:05:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEE54D15D;
        Thu, 30 Jun 2022 06:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7D261FDB;
        Thu, 30 Jun 2022 13:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AA6C34115;
        Thu, 30 Jun 2022 13:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597232;
        bh=Iu1OfCnEgYMCTBqhY7LS0FaFYOCSYNxznq0CJFpxzPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWZUE/fyIn8pGGtB0D0bnQV5Xemu/UaSyHvOgZfSHeW5ZFQwbI/5HZkUvHyk0LiXX
         cSpmDEGpS1TwFuYK21RJxvahzRFIH7edbjX2xqPQ93B2JQQm4+g2ZVWsKfyPbzJb2y
         vuUmy/9Ub6yT45kSND1Fsmth/m9JcKcrjZtBxkSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 01/12] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
Date:   Thu, 30 Jun 2022 15:47:06 +0200
Message-Id: <20220630133230.722432211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133230.676254336@linuxfoundation.org>
References: <20220630133230.676254336@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

This is an attempt to direct the bots and human that are testing
LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.

This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
have their own LTS xfs maintainer entries.

Update Darrick's email address from upstream and add Amir as xfs
maintaier for the 5.10.y tree.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19246,7 +19246,8 @@ F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
-M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Amir Goldstein <amir73il@gmail.com>
+M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 S:	Supported



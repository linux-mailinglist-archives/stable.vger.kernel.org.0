Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8E5BAAC6
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiIPKMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiIPKLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:11:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CD11AD;
        Fri, 16 Sep 2022 03:09:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B54B62A0A;
        Fri, 16 Sep 2022 10:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D42C433D6;
        Fri, 16 Sep 2022 10:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322964;
        bh=5W1NvthT7Gk6j/4+GOkbynLdXPLwKUVSKJmdvZ0KROw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nbr4feJQAX7eGO4Wq8bvmNKhq1T7IE8gssNKsYxMZTzCDcOZj9jrhxIhPc68tO3kP
         5m7HHup9Sgc4cEPeRFZ5TRF32258ucyaE0shCX/V1cnvdDYrVXSyfMqJYwQNPVHHGA
         Ej+Lub+GPJb6DxmDruzqGD0p55aFyf9FLE7yzpcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/14] HID: ishtp-hid-clientHID: ishtp-hid-client: Fix comment typo
Date:   Fri, 16 Sep 2022 12:08:09 +0200
Message-Id: <20220916100443.252923503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
References: <20220916100443.123226979@linuxfoundation.org>
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

From: Jason Wang <wangborong@cdjrlc.com>

[ Upstream commit 94553f8a218540d676efbf3f7827ed493d1057cf ]

The double `like' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
index 5ffd0da3cf1fa..65af0ebef79f6 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.h
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.h
@@ -110,7 +110,7 @@ struct report_list {
  * @multi_packet_cnt:	Count of fragmented packet count
  *
  * This structure is used to store completion flags and per client data like
- * like report description, number of HID devices etc.
+ * report description, number of HID devices etc.
  */
 struct ishtp_cl_data {
 	/* completion flags */
-- 
2.35.1




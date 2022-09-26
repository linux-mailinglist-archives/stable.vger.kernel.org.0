Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801245EA3B7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiIZLbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiIZLbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43426CD2C;
        Mon, 26 Sep 2022 03:42:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6FB5B80943;
        Mon, 26 Sep 2022 10:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F48C433D6;
        Mon, 26 Sep 2022 10:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188921;
        bh=jG+YnRP0qQaGWIPk0TfDfTFYX/DRbm19JxWm/sIXadg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ht64jzD8yJyBK8l/fX97FMGADab+1iS8ciu6A/PWy7Y8G1v0NTd8aOcZ6LD+0DgLc
         8hcW74J/Yd/Xj8sAtReStcu+lfsW1Qmmo35hgYrE7Y1uJSwRWEo7j6xTTzRpiQ89st
         GYi26EL6XMvSHcyGQ7EdVeMPXXaOiH79tAW6Gi4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 016/207] xfrm: fix XFRMA_LASTUSED comment
Date:   Mon, 26 Sep 2022 12:10:05 +0200
Message-Id: <20220926100807.204896124@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 36d763509be326bb383b1b1852a129ff58d74e3b ]

It is a __u64, internally time64_t.

Fixes: bf825f81b454 ("xfrm: introduce basic mark infrastructure")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/xfrm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 65e13a099b1a..a9f5d884560a 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -296,7 +296,7 @@ enum xfrm_attr_type_t {
 	XFRMA_ETIMER_THRESH,
 	XFRMA_SRCADDR,		/* xfrm_address_t */
 	XFRMA_COADDR,		/* xfrm_address_t */
-	XFRMA_LASTUSED,		/* unsigned long  */
+	XFRMA_LASTUSED,		/* __u64 */
 	XFRMA_POLICY_TYPE,	/* struct xfrm_userpolicy_type */
 	XFRMA_MIGRATE,
 	XFRMA_ALG_AEAD,		/* struct xfrm_algo_aead */
-- 
2.35.1




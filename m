Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE9603E32
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiJSJLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiJSJIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:08:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B87168CC5;
        Wed, 19 Oct 2022 02:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A498617E1;
        Wed, 19 Oct 2022 08:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB84C433D6;
        Wed, 19 Oct 2022 08:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169961;
        bh=SyZIbY4zZI5FHErIT/jl+UCVX6Sy/rZJBz9+xeMBpEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkwk/nfYxsOQpXjIqDWtX4aNwQMO3FhF0Pgh+xIKU5BCEw8z313MHsZempQFdZISl
         FcWDdTHjrlQ4CzW44zz9+PrU5b3AHGxQBR3gyk1uOo0CvwrZE3hPQu85t71A0HirXj
         fnL+uyiX9Dpt5qD+ugoNZYA1bjwv50QcjHZjdHZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        James Clark <james.clark@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 474/862] coresight: docs: Fix a broken reference
Date:   Wed, 19 Oct 2022 10:29:21 +0200
Message-Id: <20221019083310.894678603@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b99ee26a1a98a8ac0d8241224c40e6c047091d4d ]

Since the commit in Fixes: tag, "coresight-cpu-debug.txt" has been turned
into "arm,coresight-cpu-debug.yaml".

Update the doc accordingly to avoid a 'make htmldocs' warning

Fixes: 66d052047ca8 ("dt-bindings: arm: Convert CoreSight CPU debug to DT schema")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: James Clark <james.clark@arm.com>
Link: https://lore.kernel.org/r/c7f864854e9e03916017712017ff59132c51c338.1659251193.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/coresight/coresight-cpu-debug.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/coresight/coresight-cpu-debug.rst b/Documentation/trace/coresight/coresight-cpu-debug.rst
index 993dd294b81b..836b35532667 100644
--- a/Documentation/trace/coresight/coresight-cpu-debug.rst
+++ b/Documentation/trace/coresight/coresight-cpu-debug.rst
@@ -117,7 +117,8 @@ divide into below cases:
 Device Tree Bindings
 --------------------
 
-See Documentation/devicetree/bindings/arm/coresight-cpu-debug.txt for details.
+See Documentation/devicetree/bindings/arm/arm,coresight-cpu-debug.yaml for
+details.
 
 
 How to use the module
-- 
2.35.1




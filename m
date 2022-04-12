Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3244FD609
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356517AbiDLHiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353469AbiDLHZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FC9434A5;
        Tue, 12 Apr 2022 00:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BA79B81B4E;
        Tue, 12 Apr 2022 07:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E42C385A1;
        Tue, 12 Apr 2022 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746833;
        bh=33wyTYRMCt/vjpaH5MwKGMEAkzb4U7cqLtDy9m2wrOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCcnfB5nQCZMdoR4nID66NIraJbWZFyIYI1aTxDgH5CbbK/wUSvSfOpsiDn3pJ5TV
         ReEYc8KAi7zcCpYPbFDnG65WOKKGdYUjFkyol8cRl2s6/48X9OdpU7asy7Q6NthyrK
         yx3ucev0HgR2LqYtQTYoLOCUVjwxjbsE8sNjedR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 145/285] selftests: net: Add tls config dependency for tls selftests
Date:   Tue, 12 Apr 2022 08:30:02 +0200
Message-Id: <20220412062947.853545144@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kamboju <naresh.kamboju@linaro.org>

[ Upstream commit d9142e1cf3bbdaf21337767114ecab26fe702d47 ]

selftest net tls test cases need TLS=m without this the test hangs.
Enabling config TLS solves this problem and runs to complete.
  - CONFIG_TLS=m

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index ead7963b9bf0..cecb921a0dbf 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,5 +43,6 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
+CONFIG_TLS=m
 CONFIG_CRYPTO_SM4=y
 CONFIG_AMT=m
-- 
2.35.1




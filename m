Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613E76582E7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiL1QnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiL1Qmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:42:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8B01F9F5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC93BB8188A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C68C433D2;
        Wed, 28 Dec 2022 16:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245393;
        bh=Lw4hn/Jernb32hTCgisRANQ4N/Uaj2mNKeJosIodLEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kn6E+RBLRL1vxEwsVuSLquStW+CLlj+5UKlCei/N8XSqfDEA/kuOFsU/6TVa8ZM9O
         crtSHgnIvfii8ecVOzH6jQpKaoXkw06oHxc/cNuOnzAm9GFMHrzRPcQwYPhg8NTvsf
         azSRxhDWFUxdB6rU3JQoD58NGg1tGevaqj9yYMi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nayna Jain <nayna@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0851/1146] powerpc/pseries: fix the object owners enum value in plpks driver
Date:   Wed, 28 Dec 2022 15:39:50 +0100
Message-Id: <20221228144353.269919928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Nayna Jain <nayna@linux.ibm.com>

[ Upstream commit 2330757e0be0acad88852e211dcd6106390a729b ]

OS_VAR_LINUX enum in PLPKS driver should be 0x02 instead of 0x01.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221106205839.600442-2-nayna@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.h b/arch/powerpc/platforms/pseries/plpks.h
index c6a291367bb1..275ccd86bfb5 100644
--- a/arch/powerpc/platforms/pseries/plpks.h
+++ b/arch/powerpc/platforms/pseries/plpks.h
@@ -17,7 +17,7 @@
 #define WORLDREADABLE 0x08000000
 #define SIGNEDUPDATE 0x01000000
 
-#define PLPKS_VAR_LINUX	0x01
+#define PLPKS_VAR_LINUX	0x02
 #define PLPKS_VAR_COMMON	0x04
 
 struct plpks_var {
-- 
2.35.1




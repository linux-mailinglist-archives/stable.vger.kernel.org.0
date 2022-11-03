Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AB66180C0
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiKCPME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 11:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiKCPLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 11:11:49 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC20DAD;
        Thu,  3 Nov 2022 08:11:12 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A20465C0054;
        Thu,  3 Nov 2022 11:11:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 03 Nov 2022 11:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667488269; x=1667574669; bh=gPsPIUpuWi
        0AzhW+1UQvBnM1pKalxNt18gpNydGWEuE=; b=ivzSOPo0VRRByEJs7gehHrnsoU
        O/1Qpib6eRC6wPu+27XOD2lT1+Zhm+B8ta6XI8FTsKtqyUb34m53Tfr0dPrnen88
        odeMSfTzAhFhYqITHJDfQAW+slcfL0rqsuhgqZM+oBRZHnCUVrYNzBOU/5r3YtZG
        rqgosgjr+pbqZ0bwJOpGwyvSyXlW81k62Ii84OtbkHaHT3VE7CvxvOWl62nsO6I2
        nKvcnV86NYi/+/TN4GeyYMtnaaM1ZeSwotANnQmN81vo7pzy2rKsYtr1U29zKG/O
        LeEQrR7pNK2r8SIBxAW3bhzY+A5sxf/AlU/uqHgvhsjfNhVnXDsbbvWqVUnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667488269; x=1667574669; bh=gPsPIUpuWi0Az
        hW+1UQvBnM1pKalxNt18gpNydGWEuE=; b=NzKAZ3bmOvJNQs5Z+lG5fPp5xIXVn
        a9GQYaHnmclp14YKW5ttwKfdqBJpfc6CcwhNwh2MYpCuAEx2Le/51xua9AiYET14
        5ssO4mvecnw4EWCzq7ZWlPHrK/pZ5dBxatmeA2MoU/SoRE5WbLChPdItHhZQzzYw
        3/nr+XkAc4KLIRL5iuk/XjzMFDzw2I5vyp99iOw05mD6Z9u8SPX9Q/H8W+0Om3lq
        mupvqIQtoG7PQDeUGLSvIfRno2mTuaUW2JheiKdRMLZETp2h+x/1Z8FPPJJ54eKQ
        AzxtZz2+tBWPytfrSmb2sTVU7Cr8vX6grEZYso6xmWXn2rkXQkNONthqg==
X-ME-Sender: <xms:DNpjYy4KvSk6wM7cBHtfHuc9p4qIwtt6tKyJbJ3phUoD_PCkfOTAfQ>
    <xme:DNpjY77FACsayqxCU6jhCg_p6SYHlF_58lQVWtgcBgL4PyS6O6L2xxQvJ26VSNlEx
    1JLWJZcrwbv5SCMJYM>
X-ME-Received: <xmr:DNpjYxc-hQdxWoJl0ar78Bjn4Sk5yqzI-72RDKrMxGEpc5GfUe9KdzVmUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudelgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffogggtgfesthekredtredtjeenucfhrhhomheplfhirgiguhhn
    ucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtf
    frrghtthgvrhhnpedtgfduvedvtdfgkeektdffveeiueeludegheehtdegheduueeuueeg
    tdehjeehheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:DNpjY_KFm12Svr-OBipfMRWk69IlitOc-KUH_w5SOVTbPKBjP0JlBA>
    <xmx:DNpjY2I46yjkQo7q3DYql9m4wo-bTjeJjiUXAbz4E2Id2hIh3sUrfg>
    <xmx:DNpjYwyqDTiO8lD_yvmwwJSk4b4vhev5ks3RKP9liG3dKecLz37Xtg>
    <xmx:DdpjY-9WWZs8L25HFHTlG5Y767sLspjSYdyQ7kXBfhPs13UXhjMvoQ>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Nov 2022 11:11:07 -0400 (EDT)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, tsbogend@alpha.franken.de,
        ardb@kernel.org, rostedt@goodmis.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2] MIPS: jump_label: Fix compat branch range check
Date:   Thu,  3 Nov 2022 15:10:53 +0000
Message-Id: <20221103151053.213583-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cast upper bound of branch range to long to do signed compare,
avoid negative offset trigger this warning.

Fixes: 9b6584e35f40 ("MIPS: jump_label: Use compact branches for >= r6")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
v2: Fix typo, collect review tags.
---
 arch/mips/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 71a882c8c6eb..f7978d50a2ba 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -56,7 +56,7 @@ void arch_jump_label_transform(struct jump_entry *e,
 			 * The branch offset must fit in the instruction's 26
 			 * bit field.
 			 */
-			WARN_ON((offset >= BIT(25)) ||
+			WARN_ON((offset >= (long)BIT(25)) ||
 				(offset < -(long)BIT(25)));
 
 			insn.j_format.opcode = bc6_op;
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD28660948
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 23:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjAFWJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 17:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjAFWIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 17:08:36 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F24384BCB
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 14:08:35 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id B59925C0115;
        Fri,  6 Jan 2023 17:08:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 06 Jan 2023 17:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1673042912; x=1673129312; bh=TJI6CLhMshXv2JlUkkxc9kHMw
        OuqUdP7GM1fLmCfyAM=; b=k744/aaxD9Z7koZoCfpvTCsDWnWIyU7LyaqDjygoI
        mOPTkPS+glbjVFG/cB6ca1iX8LBXpKBcSJo1RMZmoSgz+p86sa2UHt6DwWnYSktq
        PnHHQaMcTrNb3K5TigVxsQT/JRKJ7664KUq8W2ovRGSdC1mZCVGoEeHoZLfPENI9
        wSX9ioOs6CU1DbVN27ZultKVPBpvziEoc2M6WmpxmcZfl7MrOMiKzva2KdEQLhwy
        FjzqPe9YEDNoRXaYI5keplCZybE+8JnWB8wvljfu3oJrzVhXGK8Ua5l5pyD4dyx9
        Nbj9XT2gsya8SZs4wlkLXvFlBGvcp8Ge0QS3XaQI1Jl/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1673042912; x=1673129312; bh=TJI6CLhMshXv2JlUkkxc9kHMwOuqUdP7GM1
        fLmCfyAM=; b=nRESi4nn4ECcIxTZPjbT7xkAAI1pooZGeulZF+LKVcvvTMUiBAK
        4qxWsD0h6keIZ1tV6+aJd8uR/haoQQxwUAAwQ0n37e3AJcDtkylxmID0EdjpTs4p
        aRFCtQlhERGCe2C4u48sgO7+mSiBQIY7UiYYKwWfmswINbnCjyRYrjnrOqsDBAu8
        KkbeIr1n5Jhst603aqr54mKJ6dke2BcwWz2elsiDHhPf2UnUVdNRRJipcvEdgZfl
        NkflFc1c5Bad89mPG6G+PREkM7JMuS+iQjmx7qVNjNyjEdIy5mLd+Mrr1butA80L
        ta5RAOvQqm6pVPepNAzF/ZziSubGlq9scog==
X-ME-Sender: <xms:4Ju4Y2C2TztUFrM3c4RIxWma9cnrNV7fsF06sdUXg0YZi-gzYscXPQ>
    <xme:4Ju4YwgDQYd8SVW4d5_P1NvIXbOIRoVSoHD0iN3EN4MS8ZlTsytg5CnpBqsbbibG_
    2vkIjtYYVrc6RLLug8>
X-ME-Received: <xmr:4Ju4Y5nSJ7LRZYStx0GQwQrgeZjNEsvdEpjsMbL4yTgXeVnLV7BVHwGB9Xk3zH9NGRAZzheUMkJ1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepvfihlhgvrhcu
    jfhitghkshcuoegtohguvgesthihhhhitghkshdrtghomheqnecuggftrfgrthhtvghrnh
    epjeetteejvdefleekuddtgfelgeejudefieegfeekjeehtedvgefgfeffvdegudeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghouggvse
    hthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:4Ju4Y0yNGbpL9I0TMmLrjoB00O-UqBNGcqgO7WO-GDwoGCU7kVb8fQ>
    <xmx:4Ju4Y7Q1J5jaCLTzeVqnsUxCrCl3_z0H16OaMETi3v88_TaO4g2jPQ>
    <xmx:4Ju4Y_YxyB3W-91-v0KrI_ShLtLtIFADhuuYzN6TyyHiqI1JEjS1fA>
    <xmx:4Ju4Y2fFN0MWOLL61Ow325iNIv15rAqr6VdLAlt_wqIHXFhnx-yqfA>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Jan 2023 17:08:32 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        "Tyler Hicks" <code@tyhicks.com>
Subject: [PATCH 5.15 5.10 0/1] Fix kselftest builds when specifying an output dir
Date:   Fri,  6 Jan 2023 16:08:15 -0600
Message-Id: <20230106220816.763835-1-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
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

From: "Tyler Hicks" <code@tyhicks.com>

When attempting to build kselftests with a separate output directory, a
number of the tests fail to build.

For example,

 $ rm -rf build && \
   make INSTALL_HDR_PATH=build/usr headers_install > /dev/null && \
   make O=build FORCE_TARGETS=1 TARGETS=breakpoints -C tools/testing/selftests > /dev/null
 /usr/bin/ld: cannot open output file
 build/kselftest/breakpoints/step_after_suspend_test: No such file or directory
 collect2: error: ld returned 1 exit status
 make[1]: *** [../lib.mk:146: build/kselftest/breakpoints/step_after_suspend_test] Error 1
 make: *** [Makefile:163: all] Error 2

This has already been addressed upstream with v5.18 commit 5ad51ab618de
("selftests: set the BUILD variable to absolute path"). It is a clean
cherry pick to the linux-5.15.y and linux-5.10.y branches.

Tyler

Muhammad Usama Anjum (1):
  selftests: set the BUILD variable to absolute path

 tools/testing/selftests/Makefile | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

-- 
2.34.1


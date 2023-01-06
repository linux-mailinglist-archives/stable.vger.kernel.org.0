Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB67366094A
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 23:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjAFWJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 17:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236846AbjAFWJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 17:09:03 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C19584BEE
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 14:08:59 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E92045C00D8;
        Fri,  6 Jan 2023 17:08:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 06 Jan 2023 17:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm2; t=1673042938; x=1673129338; bh=dozno7prfTcaYWAUVFCcyR2pt
        pV2cJYPN6XphVvRlWA=; b=oD3Eg4RdvjchAF9BWDjGcrp2jZ9jA75XYssizxBzk
        lNTed9GHtpXsN2kiah+1htWQJvh45LBkYwt6NTDboCZkpPRw7boyV+TJatSMdBF7
        8gauuh9UBMUMJmmT7c7FHAOh5h9YGNY1eaigFgsiXVzw2utsIdcXIb5fZ5460vv5
        oL7nkMlAj4yzKNL/32tNZf2aD0+KYojrib/3p0bZc0yCQjDAzMBN4ZMGadfjtYdH
        cO8b0JJnl9qFMqtXOKjjBhcpmo38ln9QiLBp8edi4EvMumASAkSXLAHk8AHLFOfU
        4xSoAB0UQ4eBLLO5Srso6B3y9xWTwHyTEW2ybddUKyPHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1673042938; x=1673129338; bh=dozno7prfTcaYWAUVFCcyR2ptpV2cJYPN6X
        phVvRlWA=; b=ML0uK/N5ieplGzOsXXd0ay6/uVAu/nEgLxXNgqQVJ1YPuKjuGb/
        a5a71A8P+3Ki2hiHpGvESjom1SNIHNHtdoVVqkJeT4/WCK2fVtA5UwgzqIZ+4uCC
        W0oySbkrV1KrIYNcprcTyic9hy5D6TLXTWTxSQHdyimzDM94XRlsc0Gv0purxi1K
        WForK7pWJm+4NkTRieu/uqVZG4IadPw2kHM7Cm1byCsWW+P/hyYgsgwhJ9tZPrMo
        Asn+efPW9lH/fa/30AccAc3HOsBzW/rdREdKaz1n2yfujKnojSsxDGnbhpeuBO93
        qMJ8WLdH84DJk18jGPoFahxmEIWi1TJGXKQ==
X-ME-Sender: <xms:-pu4Y7piCff00qhKUK4UXrfxfAS6PyLepBHSIiaMcfHIB5hzyebAUg>
    <xme:-pu4Y1pBIDWRpTcRQau4LwYcFnopOQ_CDNV6dJDIfQjgimohIyhluYuDQ3r7u8tm7
    tRznze3usinIg8ayxk>
X-ME-Received: <xmr:-pu4Y4MHy9ufhiVnnuA9KyPBTI6Dh1MBjp_UbRhPNQYb79r14IA3iIClPf2bchhCG8LPUvdR9siE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedtgdduheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepvfihlhgvrhcu
    jfhitghkshcuoegtohguvgesthihhhhitghkshdrtghomheqnecuggftrfgrthhtvghrnh
    epjeetteejvdefleekuddtgfelgeejudefieegfeekjeehtedvgefgfeffvdegudeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghouggvse
    hthihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:-pu4Y-5Q2cnZEfdlx6RiG4UVmeRANkfxj0ILNsX53tKyMer2L8EwMA>
    <xmx:-pu4Y64N6WvyT1Clpf-JFWRBmNRCWp-zQU-9iHkTmzoSadAAEgAYKA>
    <xmx:-pu4Y2jD01V6lTV7xH-ZQcc79Rl4yNmnEFzMNmYNMtdNq_4dtiRpHQ>
    <xmx:-pu4Y6HienFkkRWrgoJfIovOMjAvhXl1BBdsx4HnJdQnJ61B6kLNUg>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Jan 2023 17:08:58 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        "Tyler Hicks" <code@tyhicks.com>
Subject: [PATCH 5.4 0/2] Fix kselftest builds when specifying an output dir
Date:   Fri,  6 Jan 2023 16:08:42 -0600
Message-Id: <20230106220844.763870-1-code@tyhicks.com>
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
("selftests: set the BUILD variable to absolute path"). It does not
cleanly cherry pick to the linux-5.4.y branch without v5.7 commit
29e911ef7b70 ("selftests: Fix kselftest O=objdir build from cluttering
top level objdir"). Commit 5ad51ab618de was written in a way that
assumes that the kselftests aren't build in the top level objdir so it
makes sense to bring the pre-req commit back but it does represent a
slight change in behavior since the kselftests will now be built in a
subdir of the specified objdir (O=). 

Tyler

Muhammad Usama Anjum (1):
  selftests: set the BUILD variable to absolute path

Shuah Khan (1):
  selftests: Fix kselftest O=objdir build from cluttering top level
    objdir

 tools/testing/selftests/Makefile | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

-- 
2.34.1


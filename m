Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454F765498E
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 01:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiLWAKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 19:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLWAKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 19:10:09 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68DF20BC7;
        Thu, 22 Dec 2022 16:10:08 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 4F9775C0100;
        Thu, 22 Dec 2022 19:10:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 22 Dec 2022 19:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1671754208; x=1671840608; bh=Bwyalj77/Ba/0vMQnbq0zje7V
        uiWq5z0TaX6kKGRNR0=; b=KCy4dgfyUMeMeQmwfxGbv9cglnPrbxi/JR/SYW63c
        JdhPbBYtDlnEMuriLb335UXGrLgQJxMcZJotbIj44W1FgHs4ciqNN0A+MUUV0JVd
        N6N8V0erzUuBUaHMiC/U1xBfmuxUTGS1Oz+dEPezy5hJ8x9Tz2SL1jBjzVBH9TAE
        a+IqwM1bcb1IHe5egsxvDncLpXa1hjC797jKFMMVUe6N0HsXTUKeU38ZtdhbB8Q0
        ak6yPt16qPuyAYlrY/O/LhJEzOO9QxwIX5UFygvNV4LqrXWOBIKauOCalgkhZeSH
        ixa/oCdY5Ja1AV11H/rHh3RBjL+fBTM3Pd+ADdjUPYzHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1671754208; x=1671840608; bh=Bwyalj77/Ba/0vMQnbq0zje7VuiWq5z0TaX
        6kKGRNR0=; b=at+L0lCZ2y9CRDrytM2QKfJqzz1N8lvcDIAT3gPyvqIrmf+wdHG
        Vj7Vb9RAkAdlODKtBbR6yIOg/7adluhcS17MV6HvWDceRrn0v2ZAyAju9fmvet14
        74On8e6u+KjWKvtXpOrquvlhSe63nqwHrZ2pNFMKsXfN9aJilgjF/bG2Ca6mTV6S
        YM1JUwgXtphPmD74vRP+iOwmi7A9OEKvmSshegJAPhzlmCUubAwQk8VF5dawlUS3
        fzYpAOGV+VNA91jq5ycHgvpoK8d8anoo5hclOqrjeaC8Ve3jxHWlQ4WLoaw24pB7
        sxASflJMwnSU1ia8Ya9F12h2h1ABuUMiR/A==
X-ME-Sender: <xms:4PGkY1cX00W14It12Bg_Q4u42HaABfvahSUl__zY9oDnbf74mnhZ5Q>
    <xme:4PGkYzM2A6CXr2tpraVwE1v6SH-sLFDXBwUC7IW1Vrxn0uw8KVNKOlbNxnCDosSjX
    lq4FIu4qYP4nN3Lrqw>
X-ME-Received: <xmr:4PGkY-g9dCyL-h1CcHMX1xs6tc-zvaKREKzv3YhOVQBYTl_D416wp8pI0QhfoNQ0rYGmMtbBFiOpS8zCUlfk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrhedugddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefvhihlvghrucfj
    ihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtthgvrhhnpe
    ejteetjedvfeelkedutdfgleegjedufeeigeefkeejheetvdeggfefffdvgedukeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegtohguvgesth
    ihhhhitghkshdrtghomh
X-ME-Proxy: <xmx:4PGkY-834OPiAKTpVngdjoE5xvwR1WhdfgAIpi0Krw8L6E7fyLRomw>
    <xmx:4PGkYxtPUIeEoGRG1fsCs5NJH8jB73DaCay0wYmjmuiP41_lUNkGlg>
    <xmx:4PGkY9GMDpxNFXNpbQALnaVvcBs2EiJ6b8wIuarPUlpBKAFtVe9BjQ>
    <xmx:4PGkYynepIQR_AKcj5Y_pcC2Taj-MT7zxkFDlr__k7BXICP173xzKQ>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Dec 2022 19:10:07 -0500 (EST)
From:   Tyler Hicks <code@tyhicks.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Tyler Hicks" <code@tyhicks.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Karolina Drobnik <karolinadrobnik@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: [PATCH 5.15 0/2] Fix kvm selftest build failures in linux-5.15.y
Date:   Thu, 22 Dec 2022 18:09:56 -0600
Message-Id: <20221223000958.729256-1-code@tyhicks.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tyler Hicks" <code@tyhicks.com>

The backport of commit 05c2224d4b04 ("KVM: selftests: Fix number of
pages for memory slot in memslot_modification_stress_test") broke the
build of the KVM selftest memslot_modification_stress_test.c source file
in two ways:

- Incorrectly assumed that max_t() was defined despite commit
  5cf67a6051ea ("tools/include: Add _RET_IP_ and math definitions to
  kernel.h") not being present
- Incorrectly assumed that kvm_vm struct members could be directly
  accessed despite b530eba14c70 ("KVM: selftests: Get rid of
  kvm_util_internal.h") not being present

Backport the first commit, as it is simple enough. Work around the lack
of the second commit by using the accessors to get to the kvm_vm struct
members.

Note that the linux-6.0.y backport of commit 05c2224d4b04 ("KVM:
selftests: Fix number of pages for memory slot in
memslot_modification_stress_test") is fine because the two prerequisite
commits, mentioned above, are both present in v6.0.

Tyler

Karolina Drobnik (1):
  tools/include: Add _RET_IP_ and math definitions to kernel.h

Tyler Hicks (Microsoft) (1):
  KVM: selftests: Fix build regression by using accessor function

 tools/include/linux/kernel.h                                | 6 ++++++
 .../selftests/kvm/memslot_modification_stress_test.c        | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.34.1


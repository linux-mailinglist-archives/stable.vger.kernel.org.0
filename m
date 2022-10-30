Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639A5612895
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 08:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiJ3HNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 03:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3HNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 03:13:15 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB6FEA8;
        Sun, 30 Oct 2022 00:13:11 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D9195C009C;
        Sun, 30 Oct 2022 03:13:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 30 Oct 2022 03:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm3; t=1667113987; x=
        1667200387; bh=ZJibAMbkI97/+xmZRF5cCgBS1DOG88E+xTgG4JMofdw=; b=F
        84YnTjyGRYkELLxxqxkrdOJ3LCm6QlhCm9N9taa7vw3TSdoh9HjV2ySaXDdQjcuG
        g2pPJZhvRplS/auXRnLr2ooRj0mssngLcwmkcr/mh4lzNEvC6590YACw+MBDCfqT
        h2+4ouXApeY1z5gLPhCXNVdrGJ/yjSvc1FNRSnHC8hu7hzHfFyXFEZK334X/WdZ6
        ED1XF2LAY9l4f6BsV6IaP+k6kBf2c3qGSrGu6+5ShayPVdqtuFDuwnwSaFG/SjYj
        /Zn5fThDGRyeoUTBmPZoXYJ+6Gnvlc/YmjyHIWZoQacVb0WVFK/YiQhmeBXrO0BK
        V5YTp3tS52SIbyCPYbC5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1667113987; x=1667200387; bh=ZJibAMbkI97/+xmZRF5cCgBS1DOG88E+xTg
        G4JMofdw=; b=eePFuxfuOizprmG6TJT3XF04VXNFqVbzOzFB726EFiG+NxL0hjj
        I7pBwPS8kT227cnchAIAdKXDO4r/xjX8BLcU9fD2YNZg08WBuqK2eP1HjSKdVjy7
        cEHiD/CnhuVpuVS40UB7rRvnSTOkZi4jnrtPCzXSuGjtuJb6UXy4r4IzdgLP/rF/
        Quw32gfXEBWKAcvXGFetGZy2yY4Ld5+xmCa+d2UclskH6fG0Ro72GNEBBtXC+3Vj
        2yuVTXcq4tXyud78oAwVl6RlWlx1QTp/qb8C4m6zlsa4aVpZ3eSdpnBcsTsYYn88
        VpA2iQlQyq5rjGtWSLj6A6PCuKxiOXHRXgQ==
X-ME-Sender: <xms:AiReY4Cp209zhX2mv9oHxPsCxZL9QGjWvVm9ddcpiLDpc8NFtESJ-A>
    <xme:AiReY6hHxuSOZrHruibhR8D0HyIosg4diaGChBv-4x243sTHFGHgyIWNk075gU1lP
    WRDDurwXCQkmPY>
X-ME-Received: <xmr:AiReY7nKDUOeDhlBOCkWU-ALGoux-Lau1VlpmFH-VUwBZ2B6UiVeAo9_hFYQPw26x1ydN5-kce0F>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdelgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
    rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomheqnecuggftrfgrthhtvghrnhepvdefgeekvdekgfffgeekhfeijedtffek
    hefhleehfeejueetgfelgefgtdevieelnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
    sgdrtghomh
X-ME-Proxy: <xmx:AiReY-zycIagbZnn9asuhUE3rgQb93apAnvKgnwK79ckZAzhhlwSrg>
    <xmx:AiReY9Q6K47KWDlvv1VmXtiShd39iVwp7cl0PX1iaBhAlLzafehMSA>
    <xmx:AiReY5YgmfOJesRNDBivOyiJzY7xLOVTq_FKRa_sVoUpI_TV18slpg>
    <xmx:AyReY-QLcQ3SUJ3rSMw60li0tw3Ru8V6XOC9A5QIK4BqHKKDibiygw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Oct 2022 03:13:05 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 0/3] Stable backports of gntdev fixes
Date:   Sun, 30 Oct 2022 03:12:40 -0400
Message-Id: <20221030071243.1580-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I backported the recent gntdev patches to stable branches before 5.15.
The first patch is a prerequisite for the other backports.  The second
patch should apply cleanly to all stable branches, but the third only
applies to 5.10 as it requires mmu_interval_notifier_insert_locked().

Jan Beulich (1):
  Xen/gntdev: don't ignore kernel unmapping error

M. Vefa Bicakci (2):
  xen/gntdev: Prevent leaking grants
  xen/gntdev: Accommodate VMA splitting

 drivers/xen/gntdev-common.h |  3 +-
 drivers/xen/gntdev.c        | 88 +++++++++++++++++++++----------------
 2 files changed, 52 insertions(+), 39 deletions(-)

-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

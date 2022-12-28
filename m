Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234DA657C09
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiL1P21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbiL1P2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3497914D07
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6973B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337ECC433D2;
        Wed, 28 Dec 2022 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241285;
        bh=4ACBcbDJ6Ctcg/srlEdFd2WrfFh78XgoTZQLLlxPVTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XMM8yE92A78DExSrDTeIFUCaiKS4qUCcYm4+3Yyu1kOeuFKg0dUHAKQZkLUukFfm
         lA6y93W8Ll2Sx1BHTFnlzC6Ff9ibyRENfN8e9Ee56TGvnci72iqfs2LXV79UNwkmLb
         +SzUV/kabkQAWViLkRpKUKIJS5BNu3Tr6VYRvMtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0262/1073] spi: Update reference to struct spi_controller
Date:   Wed, 28 Dec 2022 15:30:50 +0100
Message-Id: <20221228144335.133041079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

[ Upstream commit bf585ccee22faf469d82727cf375868105b362f7 ]

struct spi_master has been renamed to struct spi_controller. Update the
reference in spi.rst to make it clickable again.

Fixes: 8caab75fd2c2 ("spi: Generalize SPI "master" to "controller"")
Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Link: https://lore.kernel.org/r/20221101173252.1069294-1-j.neuschaefer@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/spi.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/spi.rst b/Documentation/driver-api/spi.rst
index f64cb666498a..f28887045049 100644
--- a/Documentation/driver-api/spi.rst
+++ b/Documentation/driver-api/spi.rst
@@ -25,8 +25,8 @@ hardware, which may be as simple as a set of GPIO pins or as complex as
 a pair of FIFOs connected to dual DMA engines on the other side of the
 SPI shift register (maximizing throughput). Such drivers bridge between
 whatever bus they sit on (often the platform bus) and SPI, and expose
-the SPI side of their device as a :c:type:`struct spi_master
-<spi_master>`. SPI devices are children of that master,
+the SPI side of their device as a :c:type:`struct spi_controller
+<spi_controller>`. SPI devices are children of that master,
 represented as a :c:type:`struct spi_device <spi_device>` and
 manufactured from :c:type:`struct spi_board_info
 <spi_board_info>` descriptors which are usually provided by
-- 
2.35.1




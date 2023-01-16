Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213AE66CC80
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbjAPR0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbjAPR0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:26:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331EB28868
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:03:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9542B81014
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E14AC433F2;
        Mon, 16 Jan 2023 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888606;
        bh=4ACBcbDJ6Ctcg/srlEdFd2WrfFh78XgoTZQLLlxPVTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUlmte77S0sDii6Wps6kmDYud1blgrY2a3+JvtCOK8P0zQEBsKxHh5R1XDi6GYfHE
         +Ha7lMfrldBqFn/ea/m10UWUAVTEhadOZOW1Xe0t96zSNfnEk6E7SKmmMRHbSUVlvr
         GydHNp9eQV+WgXhkS76qrsmCMVxtXFwDaZYev/ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/338] spi: Update reference to struct spi_controller
Date:   Mon, 16 Jan 2023 16:49:02 +0100
Message-Id: <20230116154823.874459242@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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




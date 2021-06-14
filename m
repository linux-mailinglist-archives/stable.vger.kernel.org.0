Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC663A62EA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhFNLGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235107AbhFNLEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C91761400;
        Mon, 14 Jun 2021 10:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667492;
        bh=GpfU/dJtA0DE9ufFGk4z6/di0+hAra5dAU9YzJeEG6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXQsJgxqwDpE1BH+HE8DyW2eSpCokDWomniwbScUC54ChzV59SbMts3h13rCx1XoT
         umEoUjiKt4+sq29A5Lcf29iHYxcJ0eAXsGSg8bIx453Zcga9RZjdTeFe7S5l3Q5e9U
         iYnRh6CGp6dp4QS8rPpo99AFKMYXFv16Epwkz0XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 093/131] regulator: fan53880: Fix missing n_voltages setting
Date:   Mon, 14 Jun 2021 12:27:34 +0200
Message-Id: <20210614102656.153768326@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

commit 34991ee96fd8477479dd15adadceb6b28b30d9b0 upstream.

Fixes: e6dea51e2d41 ("regulator: fan53880: Add initial support")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Christoph Fritz <chf.fritz@googlemail.com>
Link: https://lore.kernel.org/r/20210517105325.1227393-1-axel.lin@ingics.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/fan53880.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/regulator/fan53880.c
+++ b/drivers/regulator/fan53880.c
@@ -51,6 +51,7 @@ static const struct regulator_ops fan538
 		      REGULATOR_LINEAR_RANGE(800000, 0xf, 0x73, 25000),	\
 		},							\
 		.n_linear_ranges = 2,					\
+		.n_voltages =	   0x74,				\
 		.vsel_reg =	   FAN53880_LDO ## _num ## VOUT,	\
 		.vsel_mask =	   0x7f,				\
 		.enable_reg =	   FAN53880_ENABLE,			\
@@ -76,6 +77,7 @@ static const struct regulator_desc fan53
 		      REGULATOR_LINEAR_RANGE(600000, 0x1f, 0xf7, 12500),
 		},
 		.n_linear_ranges = 2,
+		.n_voltages =	   0xf8,
 		.vsel_reg =	   FAN53880_BUCKVOUT,
 		.vsel_mask =	   0x7f,
 		.enable_reg =	   FAN53880_ENABLE,
@@ -95,6 +97,7 @@ static const struct regulator_desc fan53
 		      REGULATOR_LINEAR_RANGE(3000000, 0x4, 0x70, 25000),
 		},
 		.n_linear_ranges = 2,
+		.n_voltages =	   0x71,
 		.vsel_reg =	   FAN53880_BOOSTVOUT,
 		.vsel_mask =	   0x7f,
 		.enable_reg =	   FAN53880_ENABLE_BOOST,



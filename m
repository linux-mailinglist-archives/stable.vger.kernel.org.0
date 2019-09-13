Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB6B2024
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389957AbfIMNQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389952AbfIMNQy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:54 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B19B4206BB;
        Fri, 13 Sep 2019 13:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380614;
        bh=iWIUAy8DQM/b3AxXFY8RBNb9Cjp0usuQ9n2TI1b8FBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+EEGfQM2xiJ2bf5z2VG8+997mkjRGbcUX5aRzy43TONAMla5ToJEZF3b9IbR36M3
         G2uTrsCp5s7qoPCuocs/bZlqh8HOcfq4RUz3/BWsOzn/84G/6p9FVlU67VGmbVp9O1
         N1E1fbtv1oxKhzJWc31yGMrhcH3uCflUktYtcd3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Rob Herring <robh@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/190] dt-bindings: mmc: Add supports-cqe property
Date:   Fri, 13 Sep 2019 14:06:17 +0100
Message-Id: <20190913130609.582905678@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c7fddbd5db5cffd10ed4d18efa20e36803d1899f ]

Add supports-cqe optional property for MMC hosts.

This property is used to identify the specific host controller
supporting command queue.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mmc/mmc.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index f5a0923b34ca1..cdbcfd3a4ff21 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -62,6 +62,8 @@ Optional properties:
   be referred to mmc-pwrseq-simple.txt. But now it's reused as a tunable delay
   waiting for I/O signalling and card power supply to be stable, regardless of
   whether pwrseq-simple is used. Default to 10ms if no available.
+- supports-cqe : The presence of this property indicates that the corresponding
+  MMC host controller supports HW command queue feature.
 
 *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
 polarity properties, we have to fix the meaning of the "normal" and "inverted"
-- 
2.20.1




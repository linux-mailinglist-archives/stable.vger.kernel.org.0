Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C25717FA2B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgCJNDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgCJNDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:03:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAED424696;
        Tue, 10 Mar 2020 13:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845392;
        bh=E4+jEyMYuhjupVCxdPlkRRITjFRu6tw0fqfShzaavM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWQnH7Ao0HhAanbj2kk/XrS21QnA+Z8FxWQz6ltPJZAi6pe4mdQ8GrvuDIkHujSn4
         craoVDGkq9L/jZl3qPB2SpkZRl4MdneaA+noLJiLDHOAUXUvMPntbEIbwc92Tbolus
         WJcT05ZSdSLV7xtpOX+U0jZQkWfGL1HqaOkvsdyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 167/189] regulator: qcom_spmi: Fix docs for PM8004
Date:   Tue, 10 Mar 2020 13:40:04 +0100
Message-Id: <20200310123656.833249838@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Vorel <petr.vorel@gmail.com>

commit a5b0cda136f4f420a8e24e50d19dfcef2f81df2e upstream.

Fixes: 2e36e140b8b8 ("regulator: qcom_spmi: Add support for PM8004 regulators")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Link: https://lore.kernel.org/r/20200127231439.3562452-1-petr.vorel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/regulator/qcom,spmi-regulator.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/regulator/qcom,spmi-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/qcom,spmi-regulator.txt
@@ -161,7 +161,7 @@ The regulator node houses sub-nodes for
 sub-node is identified using the node's name, with valid values listed for each
 of the PMICs below.
 
-pm8005:
+pm8004:
 	s2, s5
 
 pm8005:



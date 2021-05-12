Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FD537C45C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhELPao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235076AbhELP0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735536142F;
        Wed, 12 May 2021 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832291;
        bh=jr73FvkythIjY86kfLIk33WJP5X6T+UrY2AtfKEp36E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnBeMzDLNSZOfYeu0k92kNc0R/mZZNG1/lAV86VqF7HwHM9KmfHWILCTadM1Jhc6e
         fmqu1H9NOTtI/kJwVwUsU3lAXROeqerAjuhtYN1I04Zjid5BD5gpSPWH4dUgAyqhjD
         cJEqq46LafR7n9LVdIQ07VDIC/kTaBI7Z25POLBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Valentin Caron <valentin.caron@foss.st.com>,
        dillon min <dillon.minfei@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/530] dt-bindings: serial: stm32: Use type: object instead of false for additionalProperties
Date:   Wed, 12 May 2021 16:44:54 +0200
Message-Id: <20210512144825.888348417@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dillon min <dillon.minfei@gmail.com>

[ Upstream commit 9f299d3264c67a892af87337dbaa0bdd20830c0c ]

To use additional properties 'bluetooth' on serial, need replace false with
'type: object' for 'additionalProperties' to make it as a node, else will
run into dtbs_check warnings.

'arch/arm/boot/dts/stm32h750i-art-pi.dt.yaml: serial@40004800:
'bluetooth' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: af1c2d81695b ("dt-bindings: serial: Convert STM32 UART to json-schema")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Valentin Caron <valentin.caron@foss.st.com>
Signed-off-by: dillon min <dillon.minfei@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/1616757302-7889-8-git-send-email-dillon.minfei@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/serial/st,stm32-uart.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
index 06d5f251ec88..51f390e5c276 100644
--- a/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/st,stm32-uart.yaml
@@ -77,7 +77,8 @@ required:
   - interrupts
   - clocks
 
-additionalProperties: false
+additionalProperties:
+  type: object
 
 examples:
   - |
-- 
2.30.2




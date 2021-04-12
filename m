Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E4C35BF09
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhDLJCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239627AbhDLJA6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:00:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F9FE6136A;
        Mon, 12 Apr 2021 08:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217925;
        bh=UEbnMEt+P4kp+Cgag4XEiNs1RzBV3lHuzyORmmHvXd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhNscnTruCBHmFOx7Le3JLNjYSIljO2bgT1QBrSOrEiFmw7hEBgzlL2XJeqwoiYq1
         7D105lI9oKSWxFS5xdHer0y1Jptc94VY0IOpQIitGwK/NE8csUsBz9wajQ1F22dfSQ
         Enb4Kn7Fd7dtNmcNRg918JZBw4ifeDvxrnei2nuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 172/188] dt-bindings: net: ethernet-controller: fix typo in NVMEM
Date:   Mon, 12 Apr 2021 10:41:26 +0200
Message-Id: <20210412084019.346528059@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

commit af9d316f3dd6d1385fbd1631b5103e620fc4298a upstream.

The correct property name is "nvmem-cell-names". This is what:
1. Was originally documented in the ethernet.txt
2. Is used in DTS files
3. Matches standard syntax for phandles
4. Linux net subsystem checks for

Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -49,7 +49,7 @@ properties:
     description:
       Reference to an nvmem node for the MAC address
 
-  nvmem-cells-names:
+  nvmem-cell-names:
     const: mac-address
 
   phy-connection-type:



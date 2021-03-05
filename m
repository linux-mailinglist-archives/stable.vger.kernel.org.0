Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E20532E9A8
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhCEMeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:34:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231294AbhCEMdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4EF6502E;
        Fri,  5 Mar 2021 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947614;
        bh=cPj837zK88+9mFvcEOyi96omTqjlTMcjh4KWI54Gqzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxBt8kqzmPEt6ijOBzB4phCR0Ftgt5PK3/D94+EFgn6dMTrF7nybhFSr8j174a7GI
         TGdkyxjLDN4r/FQ33FUZ82QF4sqpxmNDt2r2NRpaC3XzZZEvvxMqDMuBd98wdrptuW
         Oi3xDI45itOAxzckOYsiORxLCtw8fDYevU2e0qGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 21/72] dt-bindings: ethernet-controller: fix fixed-link specification
Date:   Fri,  5 Mar 2021 13:21:23 +0100
Message-Id: <20210305120858.379587399@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 322322d15b9b912bc8710c367a95a7de62220a72 upstream.

The original fixed-link.txt allowed a pause property for fixed link.
This has been missed in the conversion to yaml format.

Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/E1l6W2G-0002Ga-0O@rmk-PC.armlinux.org.uk
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -190,6 +190,11 @@ properties:
                 Indicates that full-duplex is used. When absent, half
                 duplex is assumed.
 
+            pause:
+              $ref: /schemas/types.yaml#definitions/flag
+              description:
+                Indicates that pause should be enabled.
+
             asym-pause:
               $ref: /schemas/types.yaml#definitions/flag
               description:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F883837B0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbhEQPqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243470AbhEQPn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7968361D1C;
        Mon, 17 May 2021 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262577;
        bh=B6qVT6Uo7bLg9NTm7gUOg0A/uEvfZb13VC+BllLnX70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffomwu9xmqk6I6zU91tzkW9QahfsY/yXVkr8jhkY/1fZ57twZCMieh0PYBGr4cbL7
         f/kqWJ4WW96ekYTxxnjJ9q+LpU0Krk3zhdUOH7/BLCKFpGrY/H07/zHFE1hecF2775
         rcAg2LEw5Rxtn1nQeZpgmqIFivITen3TkaSeqsI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.11 324/329] dt-bindings: serial: 8250: Remove duplicated compatible strings
Date:   Mon, 17 May 2021 16:03:55 +0200
Message-Id: <20210517140313.038947414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

commit a7277a73984114b38dcb62c8548850800ffe864e upstream.

The compatible strings "mediatek,*" appears two times, remove one of them.

Fixes: e69f5dc623f9 ("dt-bindings: serial: Convert 8250 to json-schema")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210422090857.583-1-thunder.leizhen@huawei.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/8250.yaml |    5 -----
 1 file changed, 5 deletions(-)

--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -94,11 +94,6 @@ properties:
               - mediatek,mt7623-btif
           - const: mediatek,mtk-btif
       - items:
-          - enum:
-              - mediatek,mt7622-btif
-              - mediatek,mt7623-btif
-          - const: mediatek,mtk-btif
-      - items:
           - const: mrvl,mmp-uart
           - const: intel,xscale-uart
       - items:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D48E45BF8D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345468AbhKXM7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345797AbhKXM5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:57:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FD226187C;
        Wed, 24 Nov 2021 12:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757189;
        bh=9s+rSDvOy7U06gwzWgfNajdvN6FhbtNsak6QIH8Ju9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvoJ3KkXTcuPCVB8pQeCA8PexwPCHCz8WllieLPKpuRVFXutyuLX/Pii2IBbOPQwi
         FMHo2S02QP7PaiaVUMoVsPSKAnWvpGKXxg4N+YdirCvYnEi45XtrGPTpPZ3M27NKjp
         EtkNO7N4pGQxeeCriREejgl1gbPMz20vap4G2DA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 044/323] regulator: dt-bindings: samsung,s5m8767: correct s5m8767,pmic-buck-default-dvs-idx property
Date:   Wed, 24 Nov 2021 12:53:54 +0100
Message-Id: <20211124115720.358935507@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit a7fda04bc9b6ad9da8e19c9e6e3b1dab773d068a upstream.

The driver was always parsing "s5m8767,pmic-buck-default-dvs-idx", not
"s5m8767,pmic-buck234-default-dvs-idx".

Cc: <stable@vger.kernel.org>
Fixes: 26aec009f6b6 ("regulator: add device tree support for s5m8767")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Rob Herring <robh@kernel.org>
Message-Id: <20211008113723.134648-3-krzysztof.kozlowski@canonical.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt
+++ b/Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt
@@ -39,7 +39,7 @@ Optional properties of the main device n
 
 Additional properties required if either of the optional properties are used:
 
- - s5m8767,pmic-buck234-default-dvs-idx: Default voltage setting selected from
+ - s5m8767,pmic-buck-default-dvs-idx: Default voltage setting selected from
    the possible 8 options selectable by the dvs gpios. The value of this
    property should be between 0 and 7. If not specified or if out of range, the
    default value of this property is set to 0.



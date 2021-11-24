Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E345BACE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243421AbhKXMOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243390AbhKXMOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB15611C1;
        Wed, 24 Nov 2021 12:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755710;
        bh=9s+rSDvOy7U06gwzWgfNajdvN6FhbtNsak6QIH8Ju9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfyCOHMsSuXnsRUoXCCgEfvm4CwFfdy3XEmtIaWR5Baoo0OKOVDh4USOUr/isojC/
         d7aLVt31zF3lCVLWc7/MpXnbhf1p2ryIvVqI0pD0DjvuXmbuwatiUBXTEet0gBGBpd
         sJ8y9lciho8j7POy5qb+/3ASfqhIQOpaJuLy40PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 030/207] regulator: dt-bindings: samsung,s5m8767: correct s5m8767,pmic-buck-default-dvs-idx property
Date:   Wed, 24 Nov 2021 12:55:01 +0100
Message-Id: <20211124115704.924879843@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDD244F39D
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhKMOUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhKMOUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:20:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6430C611AE;
        Sat, 13 Nov 2021 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636813079;
        bh=akZLeDuhbzZrS15kRh5vRNxa5l36wFKMJZJE2Usr2uA=;
        h=Subject:To:Cc:From:Date:From;
        b=JFeVaLBNp7ubAP0jPRdTF/XlWKvE9RvuyfBzwQ9MmrtIch8izJQthQMagpANn8neT
         Ev8wcGlKHqQ/mio/zLRV4FOfGxI65K+Vfp/9n/3Op6IG4IJNpBndkitDWHMgKkJJI6
         VAhlmnluTtVTgPnPjun6JV1Nbv9rCgs2EgQBr9Kc=
Subject: FAILED: patch "[PATCH] regulator: dt-bindings: samsung,s5m8767: correct" failed to apply to 4.4-stable tree
To:     krzysztof.kozlowski@canonical.com, broonie@kernel.org,
        robh@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:17:57 +0100
Message-ID: <1636813077238175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7fda04bc9b6ad9da8e19c9e6e3b1dab773d068a Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date: Fri, 8 Oct 2021 13:37:14 +0200
Subject: [PATCH] regulator: dt-bindings: samsung,s5m8767: correct
 s5m8767,pmic-buck-default-dvs-idx property

The driver was always parsing "s5m8767,pmic-buck-default-dvs-idx", not
"s5m8767,pmic-buck234-default-dvs-idx".

Cc: <stable@vger.kernel.org>
Fixes: 26aec009f6b6 ("regulator: add device tree support for s5m8767")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Rob Herring <robh@kernel.org>
Message-Id: <20211008113723.134648-3-krzysztof.kozlowski@canonical.com>
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt b/Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt
index d9cff1614f7a..6cd83d920155 100644
--- a/Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt
+++ b/Documentation/devicetree/bindings/regulator/samsung,s5m8767.txt
@@ -39,7 +39,7 @@ Optional properties of the main device node (the parent!):
 
 Additional properties required if either of the optional properties are used:
 
- - s5m8767,pmic-buck234-default-dvs-idx: Default voltage setting selected from
+ - s5m8767,pmic-buck-default-dvs-idx: Default voltage setting selected from
    the possible 8 options selectable by the dvs gpios. The value of this
    property should be between 0 and 7. If not specified or if out of range, the
    default value of this property is set to 0.


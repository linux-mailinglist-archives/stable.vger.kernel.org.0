Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77C317FA67
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgCJNEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730238AbgCJNEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:04:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BB3E24697;
        Tue, 10 Mar 2020 13:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845440;
        bh=HY4LZYMCJVM/+HoxEjo4qU0iWKMaQ33Cw8U8RQ2mBfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWUWbFO6GGcLgcscqxO+Hv1uJb7cg5JlQXWD37zp7uSbagwM7KzcSSOsKUii8iNNR
         UctvZyZrIJ+G0I7uDQi5vETU5Ev0cYkkB7cudr5rtKY1P4ARzr90WJLxVhBNwW7/gI
         Ygeun6UzwrhmfKboJTay2dO3tZsmF5hF+Jae3k9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH 5.5 183/189] dt-bindings: arm: fsl: fix APF6Dev compatible
Date:   Tue, 10 Mar 2020 13:40:20 +0100
Message-Id: <20200310123658.018750911@linuxfoundation.org>
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

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

commit ab4562f4dd92c455f6b313717af5e7d72a55d7b4 upstream.

APF6 Dev compatible is armadeus,imx6dl-apf6dev and not
armadeus,imx6dl-apf6dldev.

Fixes: 3d735471d066 ("dt-bindings: arm: Document Armadeus SoM and Dev boards devicetree binding")
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/arm/fsl.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -139,7 +139,7 @@ properties:
         items:
           - enum:
               - armadeus,imx6dl-apf6      # APF6 (Solo) SoM
-              - armadeus,imx6dl-apf6dldev # APF6 (Solo) SoM on APF6Dev board
+              - armadeus,imx6dl-apf6dev   # APF6 (Solo) SoM on APF6Dev board
               - eckelmann,imx6dl-ci4x10
               - emtrion,emcon-mx6         # emCON-MX6S or emCON-MX6DL SoM
               - emtrion,emcon-mx6-avari   # emCON-MX6S or emCON-MX6DL SoM on Avari Base



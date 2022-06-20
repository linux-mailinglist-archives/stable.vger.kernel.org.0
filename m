Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF3D551A38
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244861AbiFTNF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244054AbiFTNEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4EC18B14;
        Mon, 20 Jun 2022 05:59:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3832061541;
        Mon, 20 Jun 2022 12:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333A7C341C4;
        Mon, 20 Jun 2022 12:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729987;
        bh=qndDqOAs9+3WFGICbDRUpXG2O5z0sRvlr66TBVrcpZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GygTjxk4MuPa9voJGXgNJ3p7jjKc3HLxxePuKalL4tyVSR+QGp2oOHL7z33rLrCsA
         KvhCEmRZF3CnhHLBBiNW7zsain2tKo0fpYAt3+yJowWEC+ihVqfVHlbPF3gdHUVlq+
         fmW3a8H+dJKC7524xzhrsgu/w0Y8AlLK6ioXITjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.18 138/141] dt-bindings: mfd: bd9571mwv: update rohm,bd9571mwv.yaml reference
Date:   Mon, 20 Jun 2022 14:51:16 +0200
Message-Id: <20220620124733.638428436@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@kernel.org>

commit e0b5c5984d4810733b7c24a3d16c904fffc086d2 upstream.

Changeset 983b62975e90 ("dt-bindings: mfd: bd9571mwv: Convert to json-schema")
renamed: Documentation/devicetree/bindings/mfd/bd9571mwv.txt
to: Documentation/devicetree/bindings/mfd/rohm,bd9571mwv.yaml.

Update its cross-reference accordingly.

Fixes: 983b62975e90 ("dt-bindings: mfd: bd9571mwv: Convert to json-schema")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/1906a4d935eab57c10ce09358eae02175ce4abb7.1654529011.git.mchehab@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator b/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
index 42214b4ff14a..90596d8bb51c 100644
--- a/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
+++ b/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
@@ -26,6 +26,6 @@ Description:	Read/write the current state of DDR Backup Mode, which controls
 		     DDR Backup Mode must be explicitly enabled by the user,
 		     to invoke step 1.
 
-		See also Documentation/devicetree/bindings/mfd/bd9571mwv.txt.
+		See also Documentation/devicetree/bindings/mfd/rohm,bd9571mwv.yaml.
 Users:		User space applications for embedded boards equipped with a
 		BD9571MWV PMIC.
-- 
2.36.1




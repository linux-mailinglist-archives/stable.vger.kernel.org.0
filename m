Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D040259D509
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbiHWI1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243559AbiHWIZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5E24D161;
        Tue, 23 Aug 2022 01:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B20E5B81C25;
        Tue, 23 Aug 2022 08:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06128C433C1;
        Tue, 23 Aug 2022 08:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242410;
        bh=JOA4S2elR+67zlKZpWHgnhh6ZM27y/vCwFmhxSo3GtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLXtNOCcbzwGoSQ9LlaltaQ59ukGNiWrouGFFLc37TNtWhF4uu8ajKwBQAN1+IR7Y
         4uzi7BTgHaFSbMuRmC1Yb2KfABtzdm2iwU6N9aZJWhCYFL7VsR5AT4VFpAXHssxa+l
         ONMpOd8Fo6uMqXugiXlkiGopbsL8KRSu4HLXUyXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 111/365] dt-bindings: input: iqs7222: Correct bottom speed step size
Date:   Tue, 23 Aug 2022 10:00:12 +0200
Message-Id: <20220823080122.847534631@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

commit 6cfb357851bd3ef0a48e14bccfb5ca6b8104ea61 upstream.

The bottom speed property is specified in steps of 1, not 4.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-9-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index 6180f7ee2284..c9c3a1e9bcae 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -533,9 +533,8 @@ patternProperties:
 
       azoteq,bottom-speed:
         $ref: /schemas/types.yaml#/definitions/uint32
-        multipleOf: 4
         minimum: 0
-        maximum: 1020
+        maximum: 255
         description:
           Specifies the speed of movement after which coordinate filtering is
           linearly reduced.
-- 
2.37.2




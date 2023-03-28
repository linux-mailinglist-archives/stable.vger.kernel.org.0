Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22AD36CC385
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbjC1Oyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjC1Oyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1600BCC16
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A84026182C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD75CC433EF;
        Tue, 28 Mar 2023 14:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015277;
        bh=ZYWoRqy5TCloj0vmsZMJFllTYRHpUP0O66t2pYMcKeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgY6EUjP27ZUyB4ypOesjdBHvo3uKdXvbFZ1kNcRVnZf9J0umodnOAgreCFB/Td/d
         XHVsPryTlUQOd/gSMR7GpuunTpPTgJMMhnxSlmGZxYL6otVsj0VRjmMGZDG389rWtI
         ihLPtXN8JTZjA6se0BxKXTLh5MKFgqj0lscLTh0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.2 229/240] arm64: dts: qcom: sc8280xp-x13s: mark s11b regulator as always-on
Date:   Tue, 28 Mar 2023 16:43:12 +0200
Message-Id: <20230328142629.259172649@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit b8838e653034425cd26983c7d96535e2742a6212 upstream.

The s11b supply is used by the wlan module (as well as some of the
pmics) which are not yet fully described in the devicetree.

Mark the regulator as always-on for now.

Fixes: 123b30a75623 ("arm64: dts: qcom: sc8280xp-x13s: enable WiFi controller")
Cc: stable@vger.kernel.org	# 6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230322113318.17908-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -186,6 +186,7 @@
 			regulator-min-microvolt = <1272000>;
 			regulator-max-microvolt = <1272000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l3b: ldo3 {



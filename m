Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A6A4ABDBC
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389062AbiBGLp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386757AbiBGLgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:36:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B29C043188;
        Mon,  7 Feb 2022 03:36:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4A9F60A69;
        Mon,  7 Feb 2022 11:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF9CC004E1;
        Mon,  7 Feb 2022 11:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233793;
        bh=q0nvyZV4sYkd7gzOHWgjUx1R62mGh98lgexTYH8IfgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auThh9oh5bknORGhf+fjUVvyhbsvzF+qVnZ09AytsynPao/IdPE42G3JdYvN6nDS8
         hlc2aHSaWJAq5bFCnpIPIVQB6lK2ynH64+h6tQUoE0BbFqrK3ER2HbZGv/Huu6jXiq
         7XQU0GRwXnRjvo6/1Yj/4UPpQPnakkGOCfQNUzKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 120/126] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY
Date:   Mon,  7 Feb 2022 12:07:31 +0100
Message-Id: <20220207103808.201468652@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

commit 4223f86512877b04c932e7203648b37eec931731 upstream.

Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
properly control MT7530 and MT7531 switch PHYs.

A noticeable change is that the behaviour of switchport interfaces going
up-down-up-down is no longer there.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220129062703.595-1-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -36,6 +36,7 @@ config NET_DSA_LANTIQ_GSWIP
 config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	select NET_DSA_TAG_MTK
+	select MEDIATEK_GE_PHY
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
 	  Ethernet switch chips.



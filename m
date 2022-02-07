Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16AC4ABC1C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384872AbiBGLa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383929AbiBGLYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764E0C043189;
        Mon,  7 Feb 2022 03:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36262B81028;
        Mon,  7 Feb 2022 11:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8092AC004E1;
        Mon,  7 Feb 2022 11:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233045;
        bh=aMaqliSo0pUwthaPjUJtqmJ27qP7rBg0/Ef30il+49I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvQYssItOZyTjEkJN7zT87Dvj2PiARN3l1XKJFbK2cx+Kls1ic4LPnYN9q50xFycd
         MUWrfRo0yMdITSyLz1z5QazgbGGi8b6hfwT68Y13VpJprGrL50fZ5RE1XBDwf0IaET
         v904nLYEVkDUKNHtNKN+yVDE6A35qHrF3bNoGGcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 72/74] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY
Date:   Mon,  7 Feb 2022 12:07:10 +0100
Message-Id: <20220207103759.591363633@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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
@@ -36,6 +36,7 @@ config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	depends on NET_DSA
 	select NET_DSA_TAG_MTK
+	select MEDIATEK_GE_PHY
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
 	  Ethernet switch chips.



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A0F648507
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 16:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLIPZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 10:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiLIPZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 10:25:41 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A03F786A0;
        Fri,  9 Dec 2022 07:25:40 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id B5CEF320091F;
        Fri,  9 Dec 2022 10:25:38 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 09 Dec 2022 10:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm1; t=
        1670599538; x=1670685938; bh=El72L61y206EseKUUon70geO5hnaNo4Skdb
        zoWJup0s=; b=ZryyW61SmwUNUdXyXyeQ04j4PF/btO/bIFiVJ29PUhV6gC60luy
        HCSHGECW3YPsUK9C479qv2dQrElPCHFklE0QsHvrS7phHWjGSoA1zJFzV/utK9iC
        GuOmpFBjBs92WvkROGmKkgiQqTCYOUwVAymioMpWryLBAkOTCXFATk7Mxdi9vk5B
        chiG82E0ZuGWHLNLI3UOgNB6k64FdxM1pM2w0ylg1govsSZKrLex0pzFuHEHaOWg
        qy95Y+pkCfF7KGcrxYYwv97yRAqh8mSdj/Wt93HecRDI0FZ3w/Oi3SOaphFtPNEi
        KIo40JnRIV7Hz0U7Ccw7eRUKfsCzHw4tXAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1670599538; x=
        1670685938; bh=El72L61y206EseKUUon70geO5hnaNo4SkdbzoWJup0s=; b=M
        WHAAOylbf+HAsSWpB1jAKZkX+NtsBIJkA9NWLcNLsq3njdBQ4q+Px7TCX/x2AMoC
        PRLKczD/9UVuDpHXUrd4HFEEK1Tus8esKtHAwq+2WNvq1pAlTXuDwhgcOuOPAkDJ
        I7xTrDaGz7BQ6Alk4dc4jWO84MVs/ICkmDEdZZME2/jWN196M1EiK2d8u52Zqr9O
        foQ9ijN7MKjAO7J3dPfyXy/c6dKyaazn9BNwvxAJZ3AZt9KWZESM1b0tDRDpSgl6
        YnFOgR2wuztmHZ1T9Q9EEMlkKXjh6XYjdTWm2HhVSpZev3xUw/I1tyS6PG3Xz66/
        lzN45huAuLtd4RuALJKRg==
X-ME-Sender: <xms:cVOTY6kIgkInYQhS_OQKlTGkmQnhJ6h3e0yL9A-U8nlAUCR3y4_cZA>
    <xme:cVOTYx2i5_bB9EtX8PJV2OF3vR13VOEerSPii0kjEDmkT6inGDGtxt1PO0xsYKxVh
    _EwpN_a_Jk9LDWIWv8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpeeffeeuhfekjeevtddvtdelledttddtjeegvdfhtdduvdfhueekudeihfejtefgieen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:cVOTY4psYswyKqlfJrDg2gF_Aci8hRilCeU-hNwLGFR7zMWGN4ByIA>
    <xmx:cVOTY-meh3OlMcdPaOUbmWMP0VKJIPypP7j11aRaqePKU8p9ocrGwA>
    <xmx:cVOTY43Dk9LFjhq-wf7sZl8-1uuRhpD0WgqBDTM3XUaszHf4eRzPXA>
    <xmx:clOTY-xLVuNhsJ5PG_mck_njKRkFepB_7Ha6PMM-ECko88aQ_chGKw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id D8385B60086; Fri,  9 Dec 2022 10:25:37 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1115-g8b801eadce-fm-20221102.001-g8b801ead
Mime-Version: 1.0
Message-Id: <c2178eba-0c25-4310-8b87-1dc7708d2a34@app.fastmail.com>
Date:   Fri, 09 Dec 2022 16:25:17 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Linus Torvalds" <torvalds@linux-foundation.org>
Cc:     "Francesco Dolcini" <francesco.dolcini@toradex.com>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Marek Vasut" <marex@denx.de>,
        "NXP Linux Team" <linux-imx@nxp.com>, devicetree@vger.kernel.org,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        "Thorsten Leemhuis" <regressions@leemhuis.info>, soc@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 6.1, part 6
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following changes since commit da0cbf9307a227f52a38a0a580a4642ad9d7325c:

  Merge tag 'at91-fixes-6.1-3' of https://git.kernel.org/pub/scm/linux/kernel/git/at91/linux into arm/fixes (2022-11-29 15:45:36 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git tags/soc-fixes-6.1-6

for you to fetch changes up to ef19964da8a668c683f1d38274f6fb756e047945:

  Revert "ARM: dts: imx7: Fix NAND controller size-cells" (2022-12-08 17:47:57 +0100)

----------------------------------------------------------------
ARM: SoC fixes for 6.1, part 6

One more last minute revert for a boot regression that was
found on the popular colibri-imx7.

----------------------------------------------------------------

This came in just after I sent off the "final pull request for 6.1"
yesterday, and it seems important enough for another even more
final round.

Author: Francesco Dolcini <francesco.dolcini@toradex.com>
Date:   Mon Dec 5 16:23:27 2022 +0100

    Revert "ARM: dts: imx7: Fix NAND controller size-cells"
    
    This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
    
    It introduced a boot regression on colibri-imx7, and potentially any
    other i.MX7 boards with MTD partition list generated into the fdt by
    U-Boot.
    
    While the commit we are reverting here is not obviously wrong, it fixes
    only a dt binding checker warning that is non-functional, while it
    introduces a boot regression and there is no obvious fix ready.
    
    Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
    Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
    Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
    Acked-by: Marek Vasut <marex@denx.de>
    Cc: stable@vger.kernel.org
    Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
    Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 03d2e8544a4e..0fc9e6b8b05d 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1270,10 +1270,10 @@ dma_apbh: dma-apbh@33000000 {
                        clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
                };
 
-               gpmi: nand-controller@33002000 {
+               gpmi: nand-controller@33002000{
                        compatible = "fsl,imx7d-gpmi-nand";
                        #address-cells = <1>;
-                       #size-cells = <0>;
+                       #size-cells = <1>;
                        reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
                        reg-names = "gpmi-nand", "bch";
                        interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;

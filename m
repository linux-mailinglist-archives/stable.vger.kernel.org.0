Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE83605B82
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJTJuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 05:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiJTJuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 05:50:02 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50E95600D;
        Thu, 20 Oct 2022 02:49:54 -0700 (PDT)
Received: from p57b7734d.dip0.t-ipconnect.de ([87.183.115.77] helo=phil.fritz.box)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1olSBM-0005RY-FO; Thu, 20 Oct 2022 11:49:44 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Quentin Schulz <foss+kernel@0leil.net>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        devicetree@vger.kernel.org,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency
Date:   Thu, 20 Oct 2022 11:49:42 +0200
Message-Id: <166625937155.645772.13090619800244842653.b4-ty@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com>
References: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Oct 2022 16:27:27 +0200, Quentin Schulz wrote:
> From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> 
> From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
> 
> CRC errors (code -84 EILSEQ) have been observed for some SanDisk
> Ultra A1 cards when running at 50MHz.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency
      commit: 91e8b74fe6381e083f8aa55217bb0562785ab398

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>

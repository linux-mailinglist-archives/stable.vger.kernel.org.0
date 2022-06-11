Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B633154760D
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiFKPUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 11:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiFKPUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 11:20:35 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBF25DD14;
        Sat, 11 Jun 2022 08:20:32 -0700 (PDT)
Received: from p508fd9f0.dip0.t-ipconnect.de ([80.143.217.240] helo=phil.fritz.box)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1o02ua-00050J-Qd; Sat, 11 Jun 2022 17:20:28 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH] arm64: dts: rockchip: Assign RK3399 VDU clock rate
Date:   Sat, 11 Jun 2022 17:20:27 +0200
Message-Id: <165496080836.1951920.11378861622467603485.b4-ty@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid>
References: <20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Jun 2022 14:15:36 -0700, Brian Norris wrote:
> Before commit 9998943f6dfc ("media: rkvdec: Stop overclocking the
> decoder"), the rkvdec driver was forcing the VDU clock rate. After that
> commit, we rely on the default clock rate. That rate works OK on many
> boards, with the default PLL settings (CPLL is 800MHz, VDU dividers
> leave it at 400MHz); but some boards change PLL settings.
> 
> Assign the expected default clock rate explicitly, so that the rate is
> consistent, regardless of PLL configuration.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: rockchip: Assign RK3399 VDU clock rate
      commit: 2d56af33d4df94d2b76446ffc3e3654c42232f4b

      as fix for 5.19

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>

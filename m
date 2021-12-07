Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37C946BECA
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 16:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbhLGPNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 10:13:23 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57330 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbhLGPNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 10:13:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DCFADCE1B74;
        Tue,  7 Dec 2021 15:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6029C341CB;
        Tue,  7 Dec 2021 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638889785;
        bh=JvT5n2TkUUdJIO4FQcbzdIygDF+w/eZYOg/L1l3ghB4=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=L4RfbcTyhuoz0ds+TVKJVVXQfBJJmFeaW40RIMybb3IILPzBLZ4dHuElzAdTxZfKz
         s736ZyhP/eza/CU4SJFNh3e9/MviKasbMURxtdhCmanlyE6Fk9iryB49sYA8Yr8mqU
         gR25WtDQ6r6XLtFfGbhDs1KC7yNUsMZmibD1p57C5382CwPzFEzjyKKag57V46UXg+
         MTwD4yfCqjFD6+m4b2qDJ4bVAqcEN1zjT0t7gz9GLF9WxpODhFuqZ5NFk1M3Ayvf73
         3+vaTOf0q0oA8rWZx61gJxu6zwzPUZTw0cY6mApM+YVrSFrEN7LgKEc6d5/4m55xvU
         0Ikmdq8NnaCcA==
From:   Mark Brown <broonie@kernel.org>
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, stable@vger.kernel.org
In-Reply-To: <20211206124306.14006-1-krzysztof.kozlowski@canonical.com>
References: <20211206124306.14006-1-krzysztof.kozlowski@canonical.com>
Subject: Re: [PATCH] regulator: dt-bindings: samsung,s5m8767: add missing op_mode to bucks
Message-Id: <163888978258.1135169.15249431060250011640.b4-ty@kernel.org>
Date:   Tue, 07 Dec 2021 15:09:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 6 Dec 2021 13:43:06 +0100, Krzysztof Kozlowski wrote:
> While converting bindings to dtschema, the buck regulators lost
> "op_mode" property.  The "op_mode" is a valid property for all
> regulators (both LDOs and bucks), so add it.
> 
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-linus

Thanks!

[1/1] regulator: dt-bindings: samsung,s5m8767: add missing op_mode to bucks
      commit: 85223d609c99eaa07cc598632b426cb33753526f

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3496B09E2
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjCHNw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjCHNws (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:52:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B0ABC79A
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF75A61835
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 13:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E05C433D2;
        Wed,  8 Mar 2023 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678283564;
        bh=6aEGF+WyXs/FSCLM+GEBLQ0KTC+6lu4hT+dtpiUwheQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=HUAmZU5vxtE+owvyebLVqWSoL9J4h/sBi6loCIS5m1W9SAB3ejCU1qlvfnimregsz
         gD7vloW/3+VB27xeSHgAp0Er01v4dzfQH82oXuv2tqPxvdvbuerzeG04rElClqynuf
         SqsND4RBmhHdoI9/49jwJ7Zp+6Sacsm0KgOe52vRjenO7jyb+1t9jyNHO2Dg4/F+iu
         PIGuYQgcKkUtScI/HcsM9o2s2GjBc5Xne7J4iGbITD6+m3wmIxdrdarhlnPTgLQKW0
         Mhsvycu567YpyRlhPt8whSXNDOeb6inDzBKoW7wjTlfLhvSII+QTKQmSmdc9FN2N0p
         gtJcIRrdQHSTg==
From:   Mark Brown <broonie@kernel.org>
To:     lgirdwood@gmail.com,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        yung-chuan.liao@linux.intel.com, stable@vger.kernel.org
In-Reply-To: <20230307100733.15025-1-peter.ujfalusi@linux.intel.com>
References: <20230307100733.15025-1-peter.ujfalusi@linux.intel.com>
Subject: Re: [PATCH] ASoC: Intel: soc-acpi: fix copy-paste issue in
 topology names
Message-Id: <167828356240.31859.4629176125322638062.b4-ty@kernel.org>
Date:   Wed, 08 Mar 2023 13:52:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-bd1bf
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 07 Mar 2023 12:07:33 +0200, Peter Ujfalusi wrote:
> For some reason the convention for topology names was not followed and
> the name inspired by another unrelated hardware configuration. As a
> result, the kernel will request a non-existent topology file.
> 
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: Intel: soc-acpi: fix copy-paste issue in topology names
      commit: 858a438a6cf919e5727d2a0f5f3f0e68b2d5354e

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


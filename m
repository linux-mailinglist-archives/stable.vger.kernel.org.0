Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D286CEFC9
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 18:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjC2Qum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 12:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjC2Quj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 12:50:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF4F5B8F
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 09:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4900E61DC5
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 16:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C5C433D2;
        Wed, 29 Mar 2023 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680108636;
        bh=8PokWA7vbzRuUZwYlu85KkHqJXaMzEsP02sMayeBbW0=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=azMSDg9heTi0pw51OiaaMcXxUKKklFzKZz+Dyv1hWKxuZwvRTsfVEdQd62BvAiWH8
         GRvcIIYs7KPmsTXGtDiod9D7Inyk9VQtJ9JXidoFBKMKMMZAYd9vRNPuMHlHPmnF+H
         9ojSEW6AMJeOhWArapUORE2ngEcacEmaFJSiF7jiliKfmQtZ7cYGKAr3p8TxqnNFPp
         Xp0imGUdRCZG9ZrBJweDXwaB2bw8erWVoQHipwf6WVKGlYsPnMiKbRLMrnwEGwJyQQ
         BmTJQknWEZ5F9DHLYMK2Kqg9Ux+OZI701e2yr7AhR8q7Pk3OiNFt2UiIkT8xHFIxvF
         gdas6E1/fOZiA==
From:   Mark Brown <broonie@kernel.org>
To:     lgirdwood@gmail.com,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com, stable@vger.kernel.org
In-Reply-To: <20230329113828.28562-1-peter.ujfalusi@linux.intel.com>
References: <20230329113828.28562-1-peter.ujfalusi@linux.intel.com>
Subject: Re: [PATCH for v6.3-rc] ASoC: SOF: avoid a NULL dereference with
 unsupported widgets
Message-Id: <168010863363.3244560.3817581008251520478.b4-ty@kernel.org>
Date:   Wed, 29 Mar 2023 17:50:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Mar 2023 14:38:28 +0300, Peter Ujfalusi wrote:
> If an IPC4 topology contains an unsupported widget, its .module_info
> field won't be set, then sof_ipc4_route_setup() will cause a kernel
> Oops trying to dereference it. Add a check for such cases.
> 
> 

Applied to

   broonie/sound.git for-6.3

Thanks!

[1/1] ASoC: SOF: avoid a NULL dereference with unsupported widgets
      commit: e3720f92e0237921da537e47a0b24e27899203f8

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


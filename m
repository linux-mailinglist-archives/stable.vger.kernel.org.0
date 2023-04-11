Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA256DDD90
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjDKOTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjDKOTV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:19:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AB7212F;
        Tue, 11 Apr 2023 07:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7BBA6258A;
        Tue, 11 Apr 2023 14:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77521C4339B;
        Tue, 11 Apr 2023 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681222749;
        bh=YFzILxpIYiv63ImDz5bEYdEX92IZXgELxHml31Egi9w=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=tYOiw23H9xCmwv7lxuKfWTY+u4Mr5SGESCD2nPbHJQCm2POY2NGFGv1XyMgGIjBwN
         RF9vFT9yZeJo8zU+1NLC9D5UiGRuaZ9af5tlexNI0bUYZEicW4ImdNIZIpeM0ZRra8
         TgOExksGs1nvAIlN1e7AFAXnP6vqMpDI0GImVGOnwKf6mbLagutxCgHiXz1151Wu14
         6SE+QQNwzDbqIVlUjZFEd/CB39nw5qYURnH5G0CB6AM87y5jsJkefxLhSDlJJqKhsF
         VK+zn0woJV6CKxrcHQVxILYIvjGTY/+vBj5w88G4w8J9q3rQD8isiPp/w1cpHSXaFW
         489SQA60dewPg==
From:   Mark Brown <broonie@kernel.org>
To:     tiwai@suse.com, perex@perex.cz, Cem Kaya <cemkaya.boun@gmail.com>
Cc:     mario.limonciello@amd.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        stable@vger.kernel.org
In-Reply-To: <20230410183814.260518-1-cemkaya.boun@gmail.com>
References: <20230410183814.260518-1-cemkaya.boun@gmail.com>
Subject: Re: [PATCH v5] ASoC: amd: Add Dell G15 5525 to quirks list
Message-Id: <168122274720.54453.13789305143841583675.b4-ty@kernel.org>
Date:   Tue, 11 Apr 2023 15:19:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 Apr 2023 20:38:15 +0200, Cem Kaya wrote:
> Add Dell G15 5525 Ryzen Edition to quirks list for acp6x so that
> internal mic works.
> 
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: amd: Add Dell G15 5525 to quirks list
      commit: faf15233e59052f4d61cad2da6e56daf33124d96

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


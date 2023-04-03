Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF716D44DD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 14:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjDCMvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 08:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDCMvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 08:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51F861A1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 05:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7010B61A78
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 12:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA71C4339E;
        Mon,  3 Apr 2023 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680526271;
        bh=8aJ44bd4d5edAPiqMTaOF1QxLbXCmKzlPKhW1WxDuCE=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=oXKzBdcxbxgeFTUWlai3aKjiIJShGmjXISgL6d0kQ7DgKNKvFLd74pMIAO1XSVhXt
         7Hn4Aa/4E3UT/sZbggtP0IH/9w+VIPTqzfVrBwRswAkIAUVzwwJJK9y0Y39IPZa1gl
         syvAKBGapk3Y5hm1j5ERlySINC5tO5CFq8rxerVc7F85axKXdeUHrqzNDwdYGGOmSS
         2sk1p81wUNf727vvWmaFC0eKlkqwqmkLvh/J/sRw34xjjhdLW28g8RDk/ammok9o4Y
         IVjPVW6gj0lpivAiJ/b263L6Z1qrXfv2ZjYEmZWyDS90KvEZI7oCXgj1P0qm74/vqz
         mENnD8DF4gzsA==
From:   Mark Brown <broonie@kernel.org>
To:     lgirdwood@gmail.com,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, pierre-louis.bossart@linux.intel.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        guennadi.liakhovetski@linux.intel.com, stable@vger.kernel.org,
        error27@gmail.com
In-Reply-To: <20230403090909.18233-1-peter.ujfalusi@linux.intel.com>
References: <20230403090909.18233-1-peter.ujfalusi@linux.intel.com>
Subject: Re: [PATCH for v6.3-rc] ASoC: SOF: ipc4-topology: Clarify bind
 failure caused by missing fw_module
Message-Id: <168052626818.36561.15470216778715648904.b4-ty@kernel.org>
Date:   Mon, 03 Apr 2023 13:51:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 03 Apr 2023 12:09:09 +0300, Peter Ujfalusi wrote:
> The original patch uses a feature in lib/vsprintf.c to handle the invalid
> address when tring to print *_fw_module->man4_module_entry.name when the
> *rc_fw_module is NULL.
> This case is handled by check_pointer_msg() internally and turns the
> invalid pointer to '(efault)' for printing but it is hiding useful
> information about the circumstances. Change the print to emmit the name
> of the widget and a note on which side's fw_module is missing.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/1] ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module
      commit: de6aa72b265b72bca2b1897d5000c8f0147d3157

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


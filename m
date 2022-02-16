Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7E24B8FCA
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 19:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiBPSCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 13:02:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237394AbiBPSCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 13:02:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE67827CDA
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 10:01:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4A93B81FB4
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 18:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE896C004E1;
        Wed, 16 Feb 2022 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645034515;
        bh=WVgN2U+mLl41uR6SAT7+qakZtHd3vfQQyCqycQFbs00=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=AOUAvu0nuysOfusZ57OwDgdcL4pj2WEUGP8Mk5MboAdMElP1BK7nTF5acWvHBVjQW
         T88lZwg3+wnW57Cv6voWRBiqTFLhVYzLwGBz2PolcBFvilKaNkc64yKood6dbru81U
         eX64dZjXDjY3/rtk53YpsW8LvMkOL+fV38TCCl29pR6bRjuxB/stbPl2qr3cy3442Y
         xazzeIiRg1D8kOegQ97ZZvvy6F47Uqunf5Zjei2xRMIYxMVzsoqIAhNJtChN5BVw9P
         /iUepa1H5ZlZufeLR2w7UOGaAgMsse6q5rmy2zerpkMq1bSyu9HDzEyPJTBMb/aEOM
         za/pVS1LBsZdA==
From:   Mark Brown <broonie@kernel.org>
To:     alsa-devel@alsa-project.org, Marek Vasut <marex@denx.de>
Cc:     stable@vger.kernel.org
In-Reply-To: <20220215130645.164025-1-marex@denx.de>
References: <20220215130645.164025-1-marex@denx.de>
Subject: Re: [PATCH] ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min
Message-Id: <164503451442.3088802.17577982526948199324.b4-ty@kernel.org>
Date:   Wed, 16 Feb 2022 18:01:54 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Feb 2022 14:06:45 +0100, Marek Vasut wrote:
> While the $val/$val2 values passed in from userspace are always >= 0
> integers, the limits of the control can be signed integers and the $min
> can be non-zero and less than zero. To correctly validate $val/$val2
> against platform_max, add the $min offset to val first.
> 
> 

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-linus

Thanks!

[1/1] ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min
      commit: 9bdd10d57a8807dba0003af0325191f3cec0f11c

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

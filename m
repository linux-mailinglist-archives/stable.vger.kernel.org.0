Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799C92AF561
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 16:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgKKPsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 10:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727485AbgKKPr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Nov 2020 10:47:59 -0500
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47A802072C;
        Wed, 11 Nov 2020 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605109678;
        bh=4v5NaBnOx2xXSDdYikOSQfSoefVBXORNdXiU0xorChw=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=CvCx4KhSEjuNWWWzHMNaAgjhqRjXtj/kLDzvTKF3McAtP5mgZ09oCHMTlKp69Bj+J
         iu+F9TU3Z/9ngovZ7WK76ZizJgJxLvKG5Wjws1S+Cg6MZnBQg3c/cwev3jV2pnonsw
         0QFbhxSbYSMcXbI0c4jyJG6aAd2tEG7fhh4zRxbY=
Date:   Wed, 11 Nov 2020 15:47:43 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sean Nyekjaer <sean@geanix.com>, linux-kernel@vger.kernel.org,
        yibin.gong@nxp.com
Cc:     stable@vger.kernel.org
In-Reply-To: <20201105114926.734553-1-sean@geanix.com>
References: <20201105114926.734553-1-sean@geanix.com>
Subject: Re: [PATCH] regualtor: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}
Message-Id: <160510965770.12262.8850331963860803288.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Nov 2020 12:49:26 +0100, Sean Nyekjaer wrote:
> Limit the fsl,pfuze-support-disable-sw to the pfuze100 and pfuze200
> variants.
> When enabling fsl,pfuze-support-disable-sw and using a pfuze3000 or
> pfuze3001, the driver would choose pfuze100_sw_disable_regulator_ops
> instead of the newly introduced and correct pfuze3000_sw_regulator_ops.

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[1/1] regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}
      commit: 365ec8b61689bd64d6a61e129e0319bf71336407

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

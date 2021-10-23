Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9484438377
	for <lists+stable@lfdr.de>; Sat, 23 Oct 2021 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhJWLfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Oct 2021 07:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhJWLfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Oct 2021 07:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A6560F70;
        Sat, 23 Oct 2021 11:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634988765;
        bh=SBP7/+VsPi2zy67Uxc6FSjUy/Hx+Zxd170hX0qozMNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIQhwT7RU1N7YmhKX5F4asZp8XijLsb1vqqupF5Vgc1Ws0k9571QB0D/YkTQYsrfv
         bt7aenUva/+XcSIA5aT/8Zz0nu/BmdLNoHVTS7axDTPtwsiafQtErp1ku7qTPqRGU5
         +QHGnazDkuBkHz1N9GnXg1V6HgY5uTBFqC6aY8qWS+gefx0IYpGPQvYOrSQc6pS7xD
         IfcfZG1mHJ8+XR3lqaZKp/CrxPI2Mh/iSc0Q+BqJY6wWWBRMbiUeGINiXQGN3bOXby
         2jrsPUzyUwYNlJxiALAsUnNEuRz38uAU2G10zLU8ABMeuOqrFK5cipCpK5inJAhMN7
         QryyXma0IXUPA==
From:   Mark Brown <broonie@kernel.org>
To:     Thomas Perrot <thomas.perrot@bootlin.com>,
        linux-spi@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH] spi: spl022: fix Microwire full duplex mode
Date:   Sat, 23 Oct 2021 12:32:42 +0100
Message-Id: <163498875634.38380.8059992136982566473.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211022142104.1386379-1-thomas.perrot@bootlin.com>
References: <20211022142104.1386379-1-thomas.perrot@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Oct 2021 16:21:04 +0200, Thomas Perrot wrote:
> There are missing braces in the function that verify controller parameters,
> then an error is always returned when the parameter to select Microwire
> frames operation is used on devices allowing it.
> 
> 

Applied to

   broonie/spi.git for-next

Thanks!

[1/1] spi: spl022: fix Microwire full duplex mode
      commit: 992ed0c72eb9c459c402205ce274904ea789a780

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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F77F20A154
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 16:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405309AbgFYOx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 10:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405570AbgFYOx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 10:53:59 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5378A2080C;
        Thu, 25 Jun 2020 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593096838;
        bh=G4xNTEa007my02fu3vh5mkxTgo9HbfrCFL5fZTB0L80=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=fJuFGiMloJ2riPHBFo6+GSP4VCaEwThzfnmswUhNFxe9g/rAT6+8MQJqv5ECQhUYl
         ziB+DfJM/5uJQa9b9u0+Ku6/gXElLQ+R51Howfsq76bK9Q/oz2V6++CcMB34MVVXfc
         Vg7sSD89Hwqd0SvZj/KxzCRoDTdQ7+KZU3usB6xk=
Date:   Thu, 25 Jun 2020 14:53:57 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     od@zcrc.me, linux-gpio@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: ingenic: Properly detect GPIO direction when configured for IRQ
In-Reply-To: <20200622214548.265417-2-paul@crapouillou.net>
References: <20200622214548.265417-2-paul@crapouillou.net>
Message-Id: <20200625145358.5378A2080C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ebd6651418b6 ("pinctrl: ingenic: Implement .get_direction for GPIO chips").

The bot has tested the following trees: v5.7.5, v5.4.48.

v5.7.5: Build OK!
v5.4.48: Failed to apply! Possible dependencies:
    1948d5c51dba4 ("pinctrl: Add pinmux & GPIO controller driver for a new SoC")
    3c827873590c3 ("pinctrl: Use new GPIO_LINE_DIRECTION")
    54787d7c14a4a ("pinctrl: rza1: remove unnecessary static inline function")
    5ec008bfac7da ("pinctrl: ingenic: Remove platform ID table")
    7009d046a6011 ("pinctrl: ingenic: Handle PIN_CONFIG_OUTPUT config")
    9e65527ac3bab ("pinctrl: ingenic: Fixup PIN_CONFIG_OUTPUT config")
    baf15647387e8 ("pinctrl: ingenic: Put ingenic_chip_info pointer in match data")
    d5a362149c4db ("pinctrl: Modify Kconfig to fix linker error")
    d7da2a1e4e084 ("pinctrl: Ingenic: Add pinctrl driver for X1830.")
    f742e5ebdd633 ("pinctrl: Ingenic: Introduce reg_offset and use it instead hard code.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

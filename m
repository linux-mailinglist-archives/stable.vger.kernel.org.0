Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC61C0C57
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgEACzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgEACzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:24 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51641207DD;
        Fri,  1 May 2020 02:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301723;
        bh=Qb8/Wobb5l8oQHHCrxRY724vqq/SS6qMPDvfwaXjGOQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Ir2SDGVn6sLy51qbj1gFLTAQAdw6LsjuDplVOVjs1JvDKLf0zI9hRgiMvwycDdXNS
         pxArdrC1BarMjAKboBIsVzufS4YiZ6L7VE68rGmNdYgk+dPe6TwkMEXMfz2PXmFTi1
         3K+cUWkuBlwzuJ0U9g8zNAIt6Z681M6YMMA4lKWg=
Date:   Fri, 01 May 2020 02:55:22 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
To:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mmc: sdio: Fix several potential memory leaks in mmc_sdio_init_card()
In-Reply-To: <20200430091640.455-3-ulf.hansson@linaro.org>
References: <20200430091640.455-3-ulf.hansson@linaro.org>
Message-Id: <20200501025523.51641207DD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Build OK!
v5.4.35: Build OK!
v4.19.118: Failed to apply! Possible dependencies:
    099b64811609 ("mmc: core: Add a debug print when the card may have been replaced")
    3c30e73977e5 ("mmc: sdio: Drop unused in-parameter to mmc_sdio_reinit_card()")
    4aaaf3ab1509 ("mmc: sdio: Drop unused in-parameter from mmc_sdio_init_card()")
    6ebc581c3f9e ("mmc: sdio: Don't re-initialize powered-on removable SDIO cards at resume")
    7fbbe725378d ("mmc: sdio: Drop powered-on re-init at runtime resume and HW reset")

v4.14.177: Failed to apply! Possible dependencies:
    099b64811609 ("mmc: core: Add a debug print when the card may have been replaced")
    247cfe535575 ("mmc: core: Add capability to avoid 3.3V signaling")
    3a3db6030b64 ("mmc: core: Rename ->reset() bus ops to ->hw_reset()")
    3c30e73977e5 ("mmc: sdio: Drop unused in-parameter to mmc_sdio_reinit_card()")
    4aaaf3ab1509 ("mmc: sdio: Drop unused in-parameter from mmc_sdio_init_card()")
    6a11fc47f175 ("mmc: sd: Fix signal voltage when there is no power cycle")
    6ebc581c3f9e ("mmc: sdio: Don't re-initialize powered-on removable SDIO cards at resume")
    7405df4c79cd ("mmc: core: Implement ->sw_reset bus ops for SDIO")
    7fbbe725378d ("mmc: sdio: Drop powered-on re-init at runtime resume and HW reset")
    f690f4409ddd ("mmc: mmc: Enable CQE's")
    fb09f44e290b ("mmc: core: Re-factor some code for SDIO re-initialization")

v4.9.220: Failed to apply! Possible dependencies:
    066185d69063 ("mmc: core: First step in cleaning up private mmc header files")
    099b64811609 ("mmc: core: Add a debug print when the card may have been replaced")
    20348d1981da ("mmc: core: Make mmc_switch_status() available for mmc core")
    247cfe535575 ("mmc: core: Add capability to avoid 3.3V signaling")
    2ed573b603f7 ("mmc: core: Clarify usage of mmc_set_signal_voltage()")
    3a3db6030b64 ("mmc: core: Rename ->reset() bus ops to ->hw_reset()")
    3c30e73977e5 ("mmc: sdio: Drop unused in-parameter to mmc_sdio_reinit_card()")
    437590a123b6 ("mmc: core: Retry instead of ignore at CRC errors when polling for busy")
    4aaaf3ab1509 ("mmc: sdio: Drop unused in-parameter from mmc_sdio_init_card()")
    4facdde11394 ("mmc: core: Move public functions from card.h to private headers")
    55244c5659b5 ("mmc: core: Move public functions from core.h to private headers")
    625228fa3e01 ("mmc: core: Rename ignore_crc to retry_crc_err to reflect its purpose")
    6ebc581c3f9e ("mmc: sdio: Don't re-initialize powered-on removable SDIO cards at resume")
    70562644f4ee ("mmc: core: Don't use ->card_busy() and CMD13 in combination when polling")
    716bdb8953c7 ("mmc: core: Factor out code related to polling in __mmc_switch()")
    7405df4c79cd ("mmc: core: Implement ->sw_reset bus ops for SDIO")
    7fbbe725378d ("mmc: sdio: Drop powered-on re-init at runtime resume and HW reset")
    9d4579a85c84 ("mmc: mmc_test: Disable Command Queue while mmc_test is used")
    aa33ce3c411a ("mmc: core: Enable __mmc_switch() to change bus speed timing for the host")
    cb26ce069ffa ("mmc: core: Clarify code which deals with polling in __mmc_switch()")
    f690f4409ddd ("mmc: mmc: Enable CQE's")
    fb09f44e290b ("mmc: core: Re-factor some code for SDIO re-initialization")

v4.4.220: Failed to apply! Possible dependencies:
    066185d69063 ("mmc: core: First step in cleaning up private mmc header files")
    099b64811609 ("mmc: core: Add a debug print when the card may have been replaced")
    247cfe535575 ("mmc: core: Add capability to avoid 3.3V signaling")
    29eb7bd01e80 ("mmc: card: do away with indirection pointer")
    2ed573b603f7 ("mmc: core: Clarify usage of mmc_set_signal_voltage()")
    3a3db6030b64 ("mmc: core: Rename ->reset() bus ops to ->hw_reset()")
    3c30e73977e5 ("mmc: sdio: Drop unused in-parameter to mmc_sdio_reinit_card()")
    48ab086d262e ("mmc: block: add missing header dependencies")
    4aaaf3ab1509 ("mmc: sdio: Drop unused in-parameter from mmc_sdio_init_card()")
    4e6c71788d6b ("mmc: core: Do regular power cycle when lacking eMMC HW reset support")
    4facdde11394 ("mmc: core: Move public functions from card.h to private headers")
    55244c5659b5 ("mmc: core: Move public functions from core.h to private headers")
    5b96fea730ab ("mmc: pwrseq_simple: add to_pwrseq_simple() macro")
    6ebc581c3f9e ("mmc: sdio: Don't re-initialize powered-on removable SDIO cards at resume")
    7405df4c79cd ("mmc: core: Implement ->sw_reset bus ops for SDIO")
    7fbbe725378d ("mmc: sdio: Drop powered-on re-init at runtime resume and HW reset")
    81f351615772 ("xen/blkfront: separate per ring information out of device info")
    9d4579a85c84 ("mmc: mmc_test: Disable Command Queue while mmc_test is used")
    c2df40dfb8c0 ("drivers: use req op accessor")
    d97a1e5d7cd2 ("mmc: pwrseq: convert to proper platform device")
    f01b72d0fd53 ("mmc: pwrseq_emmc: add to_pwrseq_emmc() macro")
    f690f4409ddd ("mmc: mmc: Enable CQE's")
    fb09f44e290b ("mmc: core: Re-factor some code for SDIO re-initialization")
    ffedbd2210f2 ("mmc: pwrseq: constify mmc_pwrseq_ops structures")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F081B5C89
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgDWNZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgDWNZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:25:56 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A992084D;
        Thu, 23 Apr 2020 13:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587648355;
        bh=cv6o0zmk/hxx4v8OAdATFe0wy5blln6IPVpTY4foZ+I=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Mv3VpH5ldFd4DtVd5oMs2GgYDsnZuOO+rOBumEtt5ZabfC9BUMR+ga70CeR7y/t5k
         UcZOvPINitIdkLSE0BHbJ6Z40yo5cf0SvE2FHFmzpKUEIQHmNgm2c+4WdCg6YjuRMV
         o/zzJk9GdQJYfcg/+vrvrB1ALu5QJNSes5qXQtLw=
Date:   Thu, 23 Apr 2020 13:25:54 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [RESEND PATCH v2 1/2] driver core: platform: Initialize dma_parms for platform devices
In-Reply-To: <20200422100954.31211-1-ulf.hansson@linaro.org>
References: <20200422100954.31211-1-ulf.hansson@linaro.org>
Message-Id: <20200423132555.93A992084D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.5, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.

v5.6.5: Build OK!
v5.4.33: Build OK!
v4.19.116: Failed to apply! Possible dependencies:
    cdfee5623290 ("driver core: initialize a default DMA mask for platform device")
    e3a36eb6dfae ("driver code: clarify and fix platform device DMA mask allocation")

v4.14.176: Failed to apply! Possible dependencies:
    186c446f4b84 ("media: arch: sh: migor: Use new renesas-ceu camera driver")
    1a3c230b4151 ("media: arch: sh: ms7724se: Use new renesas-ceu camera driver")
    39fb993038e1 ("media: arch: sh: ap325rxa: Use new renesas-ceu camera driver")
    b12c8a70643f ("m68k: Set default dma mask for platform devices")
    c2f9b05fd5c1 ("media: arch: sh: ecovec: Use new renesas-ceu camera driver")
    cdfee5623290 ("driver core: initialize a default DMA mask for platform device")
    e3a36eb6dfae ("driver code: clarify and fix platform device DMA mask allocation")
    f3590dc32974 ("media: arch: sh: kfr2r09: Use new renesas-ceu camera driver")

v4.9.219: Failed to apply! Possible dependencies:
    186c446f4b84 ("media: arch: sh: migor: Use new renesas-ceu camera driver")
    1a3c230b4151 ("media: arch: sh: ms7724se: Use new renesas-ceu camera driver")
    39fb993038e1 ("media: arch: sh: ap325rxa: Use new renesas-ceu camera driver")
    8fd708157a59 ("Input: tsc2007 - move header file out of I2C realm")
    b12c8a70643f ("m68k: Set default dma mask for platform devices")
    c2f9b05fd5c1 ("media: arch: sh: ecovec: Use new renesas-ceu camera driver")
    cdfee5623290 ("driver core: initialize a default DMA mask for platform device")
    e3a36eb6dfae ("driver code: clarify and fix platform device DMA mask allocation")
    f14434040ce0 ("Input: tsc2007 - add iio interface to read external ADC input and temperature")
    f3590dc32974 ("media: arch: sh: kfr2r09: Use new renesas-ceu camera driver")

v4.4.219: Failed to apply! Possible dependencies:
    166dd7d3fbf2 ("powerpc/64: Move MMU backend selection out of platform code")
    340f3039acd6 ("m68k: convert to dma_map_ops")
    3808a88985b4 ("powerpc: Move FW feature probing out of pseries probe()")
    406b0b6ae3fc ("powerpc/64: Move 64-bit probe_machine() to later in the boot process")
    565713840445 ("powerpc: Move 32-bit probe() machine to later in the boot process")
    5d31a96e6c01 ("powerpc/livepatch: Add livepatch stack to struct thread_info")
    63c254a50104 ("powerpc: Add comment explaining the purpose of setup_kdump_trampoline()")
    b12c8a70643f ("m68k: Set default dma mask for platform devices")
    b1923caa6e64 ("powerpc: Merge 32-bit and 64-bit setup_arch()")
    cdfee5623290 ("driver core: initialize a default DMA mask for platform device")
    da6a97bf12d5 ("powerpc: Move epapr_paravirt_early_init() to early_init_devtree()")
    f63e6d898760 ("powerpc/livepatch: Add livepatch header")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

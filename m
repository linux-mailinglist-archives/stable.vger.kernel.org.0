Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD44174078
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 20:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB1To7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 14:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgB1To6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 14:44:58 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F3D2469D;
        Fri, 28 Feb 2020 19:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582919097;
        bh=bK6ttLHxmZmdrgRp7OKx2+2nNyPUJ6Ag7mP003FTt0M=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=HysKkCrq2rxDZgTw7+s06M6TiFTN/Ah7jYe3kPJL42CjtxqEnZedO9Dva+e4/F0/Z
         Ysx2+bo158mYMC/OMKtcIVY70RETBOPCLWYmLTRDV437JhF+IG6CAVIPxYbMFtaGqF
         k4RBTkKAHlHfMAy0C9tUuyqXVYJGEAFKQxEMTm3Q=
Date:   Fri, 28 Feb 2020 19:44:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
To:     linux-mtd@lists.infradead.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mtd: spi-nor: Fixup page size and map selection for S25FS-S
In-Reply-To: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
References: <20200227123657.26030-1-alexander.sverdlin@nokia.com>
Message-Id: <20200228194457.A8F3D2469D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: f384b352cbf0 ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables").

The bot has tested the following trees: v5.5.6, v5.4.22, v4.19.106, v4.14.171.

v5.5.6: Build OK!
v5.4.22: Build OK!
v4.19.106: Failed to apply! Possible dependencies:
    1d5ceff25aa1 ("mtd: spi_nor: pass DMA-able buffer to spi_nor_read_raw()")
    2aaa5f7e0c07 ("mtd: spi-nor: Add a post BFPT parsing fixup hook")
    2bffa65da43e ("mtd: spi-nor: Add a post BFPT fixup for MX25L25635E")
    48e4d973aefe ("mtd: spi-nor: Add a default_init() fixup hook for gd25q256")
    50685024f273 ("mtd: spi-nor: split s25fl128s into s25fl128s0 and s25fl128s1")
    5390a8df769e ("mtd: spi-nor: add support to non-uniform SFDP SPI NOR flash memories")
    815541713730 ("mtd: spi-nor: Add support for mx25u12835f")
    b038e8e3be72 ("mtd: spi-nor: parse SFDP Sector Map Parameter Table")
    b9f07cc8207a ("mtd: spi-nor: don't overwrite errno in spi_nor_get_map_in_use()")
    c797bd81d10e ("mtd: spi-nor: fix iteration over smpt array")

v4.14.171: Failed to apply! Possible dependencies:
    1d5ceff25aa1 ("mtd: spi_nor: pass DMA-able buffer to spi_nor_read_raw()")
    2aaa5f7e0c07 ("mtd: spi-nor: Add a post BFPT parsing fixup hook")
    2bffa65da43e ("mtd: spi-nor: Add a post BFPT fixup for MX25L25635E")
    46dde01f6bab ("mtd: spi-nor: add spi_nor_init() function")
    48e4d973aefe ("mtd: spi-nor: Add a default_init() fixup hook for gd25q256")
    50685024f273 ("mtd: spi-nor: split s25fl128s into s25fl128s0 and s25fl128s1")
    5390a8df769e ("mtd: spi-nor: add support to non-uniform SFDP SPI NOR flash memories")
    65153846b18c ("mtd: spi-nor: add support for GD25Q256")
    815541713730 ("mtd: spi-nor: Add support for mx25u12835f")
    b038e8e3be72 ("mtd: spi-nor: parse SFDP Sector Map Parameter Table")
    b9f07cc8207a ("mtd: spi-nor: don't overwrite errno in spi_nor_get_map_in_use()")
    c797bd81d10e ("mtd: spi-nor: fix iteration over smpt array")
    e27072851bf7 ("mtd: spi-nor: add a quad_enable callback in struct flash_info")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

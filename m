Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC9524AA0B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHSX43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgHSX41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:27 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83318208DB;
        Wed, 19 Aug 2020 23:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881386;
        bh=30FnG0R0uTJZppd+GdCN9PaDYguSkAXnvSNc1Izoe7Y=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=oZKUVyqRcJkVFGDX2UvzvDQiJGNaNYhhouEdqWQqTaRqK73uZGXyLG7sUipb1c7h1
         y38DvGsZm3NDcBbJBptKeUX3yXe+VMUgrW34BU5/uFfL34sDGWjXFIippHa2FK4Ygx
         PUhuaOUTsst7OSkOkEaVDTmi31bTm+XZPcFayIVE=
Date:   Wed, 19 Aug 2020 23:56:25 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/9] crypto: caam/qi2 - add fallback for XTS with more than 8B IV
In-Reply-To: <20200806114127.8650-4-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-4-andrei.botila@oss.nxp.com>
Message-Id: <20200819235626.83318208DB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58.

v5.8.1: Failed to apply! Possible dependencies:
    528f776df67c ("crypto: qat - allow xts requests not multiple of block")
    a85211f36f3d ("crypto: qat - fallback for xts with 192 bit keys")
    b185a68710e0 ("crypto: qat - validate xts key")
    b8aa7dc5c753 ("crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")

v5.7.15: Failed to apply! Possible dependencies:
    528f776df67c ("crypto: qat - allow xts requests not multiple of block")
    a85211f36f3d ("crypto: qat - fallback for xts with 192 bit keys")
    b185a68710e0 ("crypto: qat - validate xts key")
    b8aa7dc5c753 ("crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")

v5.4.58: Failed to apply! Possible dependencies:
    64db5e7439fb ("crypto: sparc/aes - convert to skcipher API")
    66d7fb94e4ff ("crypto: blake2s - generic C library implementation and selftest")
    674f368a952c ("crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN")
    746b2e024c67 ("crypto: lib - tidy up lib/crypto Kconfig and Makefile")
    7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
    7f725f41f627 ("crypto: powerpc - convert SPE AES algorithms to skcipher API")
    7f9b0880925f ("crypto: blake2s - implement generic shash driver")
    91d689337fe8 ("crypto: blake2b - add blake2b generic implementation")
    b4d0c0aad57a ("crypto: arm - use Kconfig based compiler checks for crypto opcodes")
    b95bba5d0114 ("crypto: skcipher - rename the crypto_blkcipher module and kconfig option")
    d00c06398154 ("crypto: s390/paes - convert to skcipher API")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")
    ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D6124AA1B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgHSX4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgHSX4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:32 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04ADB214F1;
        Wed, 19 Aug 2020 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881392;
        bh=rAUkMixEoHXPMqidT/E+A5kXiu7RBG3wyH4hmu/8B3Q=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Yr99Quc9pHL2Ex0SyCftXhgwZo/hw8/HRs+X4KTHvyYtS7AlbrdlEa9+3ApyAH7sM
         t6bm4RHFT56mn4m5Jmn6yVZknWIeTIB33j4sWKpULr+EEAedICHsyTN08UWoujimas
         l9f1oXDORrDoQBo0PqLGCudCnIDtGN/tqyRhl8r4=
Date:   Wed, 19 Aug 2020 23:56:31 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH RESEND 2/9] crypto: caam/qi - add fallback for XTS with more than 8B IV
In-Reply-To: <20200806163551.14395-3-andrei.botila@oss.nxp.com>
References: <20200806163551.14395-3-andrei.botila@oss.nxp.com>
Message-Id: <20200819235632.04ADB214F1@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: b189817cf789 ("crypto: caam/qi - add ablkcipher and authenc algorithms").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193.

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

v4.19.139: Failed to apply! Possible dependencies:
    0a5dff9882e5 ("crypto: arm/ghash - provide a synchronous version")
    1ca1b917940c ("crypto: chacha20-generic - refactor to allow varying number of rounds")
    5ca7badb1f62 ("crypto: caam/jr - ablkcipher -> skcipher conversion")
    674f368a952c ("crypto: remove CRYPTO_TFM_RES_BAD_KEY_LEN")
    8a5a79d5556b ("crypto: x86/chacha20 - Add a 4-block AVX2 variant")
    99680c5e9182 ("crypto: arm - convert to use crypto_simd_usable()")
    9b17608f15b9 ("crypto: x86/chacha20 - Use larger block functions more aggressively")
    9dbe3072c6b1 ("crypto: caam/qi - ablkcipher -> skcipher conversion")
    a5dd97f86211 ("crypto: x86/chacha20 - Add a 2-block AVX2 variant")
    aec48adce85d ("crypto: caam/qi - remove ablkcipher IV generation")
    c3b734dd325d ("crypto: x86/chacha20 - Support partial lengths in 8-block AVX2 variant")
    cf5448b5c3d8 ("crypto: caam/jr - remove ablkcipher IV generation")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")
    db8e15a24957 ("crypto: x86/chacha20 - Support partial lengths in 4-block SSSE3 variant")
    e4e72063d3c0 ("crypto: x86/chacha20 - Support partial lengths in 1-block SSSE3 variant")

v4.14.193: Failed to apply! Possible dependencies:
    5ca7badb1f62 ("crypto: caam/jr - ablkcipher -> skcipher conversion")
    662f70ede597 ("crypto: caam - remove needless ablkcipher key copy")
    7e0880b9fbbe ("crypto: caam - add Derived Key Protocol (DKP) support")
    87ec3a0b1c2d ("crypto: caam - prepare for gcm(aes) support over QI interface")
    9dbe3072c6b1 ("crypto: caam/qi - ablkcipher -> skcipher conversion")
    cf5448b5c3d8 ("crypto: caam/jr - remove ablkcipher IV generation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

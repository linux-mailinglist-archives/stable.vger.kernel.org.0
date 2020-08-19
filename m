Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E2124AA4B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgHSX5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgHSX4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:45 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4D042245C;
        Wed, 19 Aug 2020 23:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881405;
        bh=5csEbGfAe6QX0a6KF+rn9xguJvIDrO+q6LpulHirWUI=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=VXt/dt7YOv3nVSCamXAOHN27e1Q9BcrAscLuNcZz6xIQSU0A5fKu2Kv+Rdj6Cj81i
         2G4rs5gBR65IAZ0ivcaOk9vXY+8vq50eVU0ZxU7ZwOzpW13rAGmCw3p+Y9dC/O3Cm6
         ae/jhABXahPUjbdMokOQhihkBhG65Eumro2YdrsU=
Date:   Wed, 19 Aug 2020 23:56:44 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andrei Botila <andrei.botila@oss.nxp.com>
To:     Andrei Botila <andrei.botila@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4/9] crypto: caam/jr - add support for more XTS key lengths
In-Reply-To: <20200806114127.8650-5-andrei.botila@oss.nxp.com>
References: <20200806114127.8650-5-andrei.botila@oss.nxp.com>
Message-Id: <20200819235644.C4D042245C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c6415a6016bf ("crypto: caam - add support for acipher xts(aes)").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232, v4.4.232.

v5.8.1: Failed to apply! Possible dependencies:
    528f776df67c ("crypto: qat - allow xts requests not multiple of block")
    9b21588c2c0b ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
    a85211f36f3d ("crypto: qat - fallback for xts with 192 bit keys")
    b185a68710e0 ("crypto: qat - validate xts key")
    b8aa7dc5c753 ("crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")

v5.7.15: Failed to apply! Possible dependencies:
    528f776df67c ("crypto: qat - allow xts requests not multiple of block")
    9b21588c2c0b ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
    a85211f36f3d ("crypto: qat - fallback for xts with 192 bit keys")
    b185a68710e0 ("crypto: qat - validate xts key")
    b8aa7dc5c753 ("crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY")
    da6a66853a38 ("crypto: caam - silence .setkey in case of bad key length")

v5.4.58: Failed to apply! Possible dependencies:
    4d370a103695 ("crypto: caam - change return code in caam_jr_enqueue function")
    9b21588c2c0b ("crypto: caam/jr - add fallback for XTS with more than 8B IV")
    b7f17fe28144 ("crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt functions")
    d53e44fe980b ("crypto: caam - refactor RSA private key _done callbacks")
    ee38767f152a ("crypto: caam - support crypto_engine framework for SKCIPHER algorithms")

v4.19.139: Failed to apply! Possible dependencies:
    0efa7579f3de ("crypto: caam - export ahash shared descriptor generation")
    1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries")
    226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
    8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
    94cebd9da42c ("crypto: caam - add Queue Interface v2 error codes")
    96808c596580 ("crypto: caam/qi2 - add CONFIG_NETDEVICES dependency")
    ee38767f152a ("crypto: caam - support crypto_engine framework for SKCIPHER algorithms")

v4.14.193: Failed to apply! Possible dependencies:
    0efa7579f3de ("crypto: caam - export ahash shared descriptor generation")
    1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries")
    226853ac3ebe ("crypto: caam/qi2 - add skcipher algorithms")
    8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
    94cebd9da42c ("crypto: caam - add Queue Interface v2 error codes")
    96808c596580 ("crypto: caam/qi2 - add CONFIG_NETDEVICES dependency")
    ee38767f152a ("crypto: caam - support crypto_engine framework for SKCIPHER algorithms")

v4.9.232: Failed to apply! Possible dependencies:
    1b008eedb0af ("crypto: caam - remove unused command from aead givencrypt")
    281669dfbabe ("crypto: caam - rewrite some generic inline append cmds")
    4cbe79ccb523 ("crypto: caam - improve key inlining")
    62ad8b5c0964 ("crypto: cavium - Enable CPT options crypto for build")
    64c9295b2320 ("crypto: caam - move append_key_aead() into init_sh_desc_key_aead()")
    8cea7b66b821 ("crypto: caam - refactor encryption descriptors generation")
    8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
    db57656b0072 ("crypto: caam - group algorithm related params")
    ee38767f152a ("crypto: caam - support crypto_engine framework for SKCIPHER algorithms")

v4.4.232: Failed to apply! Possible dependencies:
    1b008eedb0af ("crypto: caam - remove unused command from aead givencrypt")
    4cbe79ccb523 ("crypto: caam - improve key inlining")
    5ba1c7b5ffc1 ("crypto: caam - fix rfc3686(ctr(aes)) IV load")
    64c9295b2320 ("crypto: caam - move append_key_aead() into init_sh_desc_key_aead()")
    8c419778ab57 ("crypto: caam - add support for RSA algorithm")
    8cea7b66b821 ("crypto: caam - refactor encryption descriptors generation")
    d6e7a7d0c2c5 ("crypto: caam - Rename jump labels in ahash_setkey()")
    db57656b0072 ("crypto: caam - group algorithm related params")
    e11793f5dad8 ("crypto: caam - ensure descriptor buffers are cacheline aligned")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

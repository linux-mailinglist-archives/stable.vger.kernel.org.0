Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9954C17D099
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgCGXUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgCGXUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:38 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3880B2075A;
        Sat,  7 Mar 2020 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623238;
        bh=uHRQRAXK4XRCZaaNS5DZUyJH1Q0/dnt83aSmi8Pdv5s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=xVp1eOzmt+I/NvgjnQWd/3WaN7px71kBpNjdWq4Tv9sR64fpotVguE6dxvtqHHGy6
         EWCamHelYMuCnRWRRNjyjbGvniO0cvLlhjaWYtDMiWduakCFETICyjYVa2IppJTHbI
         9dLlznciNtRtK60AWd6CHLEs1IT1g7mUMrlZlnRQ=
Date:   Sat, 07 Mar 2020 23:20:37 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] slub: Improve bit diffusion for freelist ptr obfuscation
In-Reply-To: <202003051623.AF4F8CB@keescook>
References: <202003051623.AF4F8CB@keescook>
Message-Id: <20200307232038.3880B2075A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 2482ddec670f ("mm: add SLUB free list pointer obfuscation").

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172.

v5.5.8: Build failed! Errors:
    mm/slub.c:262:4: error: implicit declaration of function ‘swab’; did you mean ‘swap’? [-Werror=implicit-function-declaration]

v5.4.24: Build failed! Errors:
    mm/slub.c:264:4: error: implicit declaration of function ‘swab’; did you mean ‘swap’? [-Werror=implicit-function-declaration]

v4.19.108: Failed to apply! Possible dependencies:
    d36a63a943e3 ("kasan, slub: fix more conflicts with CONFIG_SLAB_FREELIST_HARDENED")

v4.14.172: Failed to apply! Possible dependencies:
    d36a63a943e3 ("kasan, slub: fix more conflicts with CONFIG_SLAB_FREELIST_HARDENED")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha

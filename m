Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C24E3D97D5
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 23:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhG1Vxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 17:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhG1Vxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 17:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C22B360F12;
        Wed, 28 Jul 2021 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627509229;
        bh=mMGfOJluYIDS3/nO6Lgq23HtvXrSdqzsgg2XCOX+cT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVG+aDHxdx/L1HlP2teZEGlGhY3BaRKeD5Sm8Y4d/40oRXy9BZVainSYdZGI50B7t
         09TcFoMvlcJ2ghVNuprwS9YHWygH/vFqzPBynQJ0ztkC50oXCsTPmQ2Hf3VmVGd8cK
         24JC17Ac2wUhLe1cNRn4R3iZxSthC7tFbUbP/yS/430bcX/SR4GSquNWAJX39byp/B
         XTuo1hJy0AjkhRz5aDdO0tN0FEhKcxPLgDGA2fZoE+i77CItJupSlCUZTxzTGjJOHC
         QMZEjDoO981DmZArRwqvSlMxjJJyfaWVfF6vfaBrMrDLHlVQoOwXgo6xKp4Z6UHxDV
         K58Ax2GamtuIQ==
Date:   Thu, 29 Jul 2021 00:53:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Adrian Ratiu <adrian.ratiu@collabora.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] char: tpm: Kconfig: remove bad i2c cr50 select
Message-ID: <20210728215346.rmgvn4woou4iehqx@kernel.org>
References: <20210727171313.2452236-1-adrian.ratiu@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727171313.2452236-1-adrian.ratiu@collabora.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 08:13:12PM +0300, Adrian Ratiu wrote:
> This fixes a minor bug which went unnoticed during the initial
> driver upstreaming review: TCG_CR50 does not exist in mainline
> kernels, so remove it.
> 
> Fixes: 3a253caaad11 ("char: tpm: add i2c driver for cr50")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
> ---

These are missing changelog. I guess tags are added, and nothing else?

/Jarkko

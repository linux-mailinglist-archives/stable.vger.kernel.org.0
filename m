Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11BB3E8EEF
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 12:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhHKKpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 06:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236837AbhHKKpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 06:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED1460E78;
        Wed, 11 Aug 2021 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628678699;
        bh=e1nMBviat3oZv8dcGpZUNDm8rLLWZk9Dvs1IW4vjDKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2uFEIGalLLdPyN0ScAhtMCwa0I93vEC9mcaOXKmPxowaWDHoHIMvAP829vpf7E1D
         351O6MT7e0FfHEY15fda0k00H/aKW4FhASHUR42xY71RSqNoc3whKzT3ijMs4OVjN3
         p9bC8WaeNnVEfTa1JmV3RAXh//0tRgS7R5KscbegmviUJtWv2FiBmOUKksgvE7G9Ua
         wkWNLiOPvzIQD2P/N9TEVdAJnPoN9fT3ukMeCsLWw2OyD+VhUYt/x7zuvKOigBQeyB
         PayFnuSHcvBBvL6/ezXiBFNI+XdB3MhqFnsbJLAMzF1hbvS5C51KMMCzLQFGoAoJfW
         5KTi8TEUuSCIA==
From:   Will Deacon <will@kernel.org>
To:     Andrew Delgadillo <adelg@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: clean vdso & vdso32 files
Date:   Wed, 11 Aug 2021 11:44:53 +0100
Message-Id: <162867629652.1666047.1258247021655645030.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210810231755.1743524-1-adelg@google.com>
References: <20210810231755.1743524-1-adelg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Aug 2021 23:17:55 +0000, Andrew Delgadillo wrote:
> commit a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
> changes the cleaning behavior of arm64's vdso files, in that vdso.lds,
> vdso.so, and vdso.so.dbg are not removed upon a 'make clean/mrproper':
> 
> $ make defconfig ARCH=arm64
> $ make ARCH=arm64
> $ make mrproper ARCH=arm64
> $ git clean -nxdf
> Would remove arch/arm64/kernel/vdso/vdso.lds
> Would remove arch/arm64/kernel/vdso/vdso.so
> Would remove arch/arm64/kernel/vdso/vdso.so.dbg
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: clean vdso & vdso32 files
      https://git.kernel.org/arm64/c/017f5fb9ce79

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

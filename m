Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF77A351875
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 19:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhDARpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235597AbhDARnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 13:43:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15426613C3;
        Thu,  1 Apr 2021 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617298419;
        bh=AwjHeODWWztoZqP0pqnYqcNUPdAY+S+5z0mcY8QTu9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHW4IGpWZtA9+4sifWOjW9o44JiHS1ZRRcFKLxoXutG/9Bb68eTfB4lg8KnKJeE3T
         aQXahsSWKkXbhhu6uFbmBhJcrMX0pCSpDFxMAH9xz5TqPFGj5s4s1s3z+x14wF9Nuu
         bklMJaBcvIgm7UDMuXBITHefBkhp+0jwjI/GTolRK8WWc+NPpHgtvwX4mC4lwzussO
         6Dxl7LGHyKEVBmFmjkjGz2lPEMKM0SjqsO9y9dEsTbkcnCblFBFStyR0ZwGlnCYqy9
         Bp5DEZ6q9vxzuxxjUoUOWAA+0xTq6ExmGpb/aR/TxcfHZ+PooV1k01deoIb6XsLvNV
         J/3v3VkhBSQCg==
From:   Will Deacon <will@kernel.org>
To:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: fix inline asm in load_unaligned_zeropad()
Date:   Thu,  1 Apr 2021 18:33:32 +0100
Message-Id: <161729737453.2267359.5680771151630291141.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210401165110.3952103-1-pcc@google.com>
References: <20210401165110.3952103-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Apr 2021 09:51:10 -0700, Peter Collingbourne wrote:
> The inline asm's addr operand is marked as input-only, however in
> the case where an exception is taken it may be modified by the BIC
> instruction on the exception path. Fix the problem by using a temporary
> register as the destination register for the BIC instruction.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: fix inline asm in load_unaligned_zeropad()
      https://git.kernel.org/arm64/c/185f2e5f51c2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EBE3CA499
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhGORmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 13:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGORmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 13:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953A4613C4;
        Thu, 15 Jul 2021 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626370754;
        bh=dm5XgR0ZOlve+UvKd1Q61R1Dv7jyuk8OCqm+SnpnuoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHe5JPnAFWyelwOTA6wKPo/4eoi/RPaUIQ+HZByoRqRdU+ZKeqxgHp8+2pSyhCPQh
         tlq0SKR/1lwzQXg0d61R4LM/PKVx7up2x9zqjcbwfdRGlaoKcUwNE2ONHBeRvV4GYm
         1Wi8UlJ0bFimIP2QDirUtCXLRKUjkYFQ9EfaiheEhbvER5FNDvO2rFn4E536TCdAL6
         5FJ+UHZdnmL2UBCDG9guLbBydtTg5mt3R/Jy84nKLLIsDutOm3f0FqGrTOFYHhm2xF
         R72VHILnybymoa+WwFbOqxr/waHqaxFpWL+8DkT2N08Qo4xurf1vIYMoASC7XprpyB
         FSYRBY9mVIYlw==
From:   Will Deacon <will@kernel.org>
To:     Robin Murphy <robin.murphy@arm.com>, catalin.marinas@arm.com
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen Huang <chenhuang5@huawei.com>, linux-mm@kvack.org,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Avoid premature usercopy failure
Date:   Thu, 15 Jul 2021 18:39:03 +0100
Message-Id: <162636655524.637200.10931507080931105968.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <dc03d5c675731a1f24a62417dba5429ad744234e.1626098433.git.robin.murphy@arm.com>
References: <dc03d5c675731a1f24a62417dba5429ad744234e.1626098433.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Jul 2021 15:27:46 +0100, Robin Murphy wrote:
> Al reminds us that the usercopy API must only return complete failure
> if absolutely nothing could be copied. Currently, if userspace does
> something silly like giving us an unaligned pointer to Device memory,
> or a size which overruns MTE tag bounds, we may fail to honour that
> requirement when faulting on a multi-byte access even though a smaller
> access could have succeeded.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Avoid premature usercopy failure
      https://git.kernel.org/arm64/c/295cf156231c

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

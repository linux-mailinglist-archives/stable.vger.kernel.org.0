Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02AA144225
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 17:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgAUQ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 11:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgAUQ2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 11:28:12 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C974F2253D;
        Tue, 21 Jan 2020 16:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579624092;
        bh=4UzYHa5pCOLLzLuPE1hryDQE3ptPI+2K4hzDi4WMV8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nbuen1xxYtJQ5ZQ+shM1vR4MWtLxWW0evvSoj9FtIWiafJ0Fggop0gK0zzej8goLk
         K+Du1bkTw7AenIcCgjxoOO1DjmeCVy2/ax/2nIcO8y8godcKmeasCNY4Hq068joF2i
         3+yMuFEdwJBXOa26meWZDeAD9P8nqTihrjwi29Rc=
Date:   Tue, 21 Jan 2020 16:28:07 +0000
From:   Will Deacon <will@kernel.org>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>
Subject: Re: [PATCH v2] arm64: kbuild: remove compressed images on 'make
 ARCH=arm64 (dist)clean'
Message-ID: <20200121162806.GA13501@willie-the-truck>
References: <20200121155439.1061-1-erosca@de.adit-jv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121155439.1061-1-erosca@de.adit-jv.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 21, 2020 at 04:54:39PM +0100, Eugeniu Rosca wrote:
> From: Dirk Behme <dirk.behme@de.bosch.com>
> 
> Since v4.3-rc1 commit 0723c05fb75e44 ("arm64: enable more compressed
> Image formats"), it is possible to build Image.{bz2,lz4,lzma,lzo}
> AArch64 images. However, the commit missed adding support for removing
> those images on 'make ARCH=arm64 (dist)clean'.
> 
> Fix this by adding them to the target list.
> Make sure to match the order of the recipes in the makefile.
> 
> Cc: stable@vger.kernel.org # v4.3+
> Fixes: 0723c05fb75e44 ("arm64: enable more compressed Image formats")
> Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> 
> ---
> v2:
>  - Added 'Fixes:', 'Cc: stable' and 'Reviewed-by' tags
> ---
>  arch/arm64/boot/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, I'll pick this up.

Will

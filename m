Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D033750E
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 15:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfFFNWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 09:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFFNWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 09:22:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EA520866;
        Thu,  6 Jun 2019 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559827372;
        bh=5DCnBlqkLCaf0QybhtzTbl/dW/HgkItPQ7Y1kIO+cog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xqop9KNyMyK39T6+MJ6Y3ZVxBI59s3koY6SaRwBpWEMFhjVm9x0ThRrrMaYyvSpfW
         lOcY8NbumVbUej6opAk3Xxoj0u+8j7XYDbtCjxg0wPM7kGSYIkAMTy30tw3eAiv6CF
         hW2eB+UNR/6D7MtU6z3jidFgwo82ejE3nzDToYVo=
Date:   Thu, 6 Jun 2019 09:22:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     eb@emlix.com, linux-efi@vger.kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        ndesaulniers@google.com
Subject: Re: [PATCH for-4.9-stable] efi/libstub: Unify command line param
 parsing
Message-ID: <20190606132251.GK29739@sasha-vm>
References: <20190606102513.16321-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190606102513.16321-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 12:25:13PM +0200, Ard Biesheuvel wrote:
>Commit 60f38de7a8d4e816100ceafd1b382df52527bd50 upstream.
>
>Merge the parsing of the command line carried out in arm-stub.c with
>the handling in efi_parse_options(). Note that this also fixes the
>missing handling of CONFIG_CMDLINE_FORCE=y, in which case the builtin
>command line should supersede the one passed by the firmware.
>
>Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>Cc: Linus Torvalds <torvalds@linux-foundation.org>
>Cc: Matt Fleming <matt@codeblueprint.co.uk>
>Cc: Peter Zijlstra <peterz@infradead.org>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Cc: bhe@redhat.com
>Cc: bhsharma@redhat.com
>Cc: bp@alien8.de
>Cc: eugene@hp.com
>Cc: evgeny.kalugin@intel.com
>Cc: jhugo@codeaurora.org
>Cc: leif.lindholm@linaro.org
>Cc: linux-efi@vger.kernel.org
>Cc: mark.rutland@arm.com
>Cc: roy.franz@cavium.com
>Cc: rruigrok@codeaurora.org
>Link: http://lkml.kernel.org/r/20170404160910.28115-1-ard.biesheuvel@linaro.org
>Signed-off-by: Ingo Molnar <mingo@kernel.org>
>[ardb: fix up merge conflicts with 4.9.180]
>Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>---
>This fixes the GCC build issue reported by Eike.
>
>Note that testing of arm64 stable kernels should cover CONFIG_RANDOMIZE_BASE,
>since it has a profound impact on how the kernel binary gets put together.

Should this fix be applied to 4.9 as well?

I see it in 4.14+

--
Thanks,
Sasha

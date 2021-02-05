Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2093103FF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 05:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBEEOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 23:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhBEEOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 23:14:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A80D264F39;
        Fri,  5 Feb 2021 04:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612498434;
        bh=YDU10+grliz9wniX7c94niF699EnqnVAeJ6cG3yeyPw=;
        h=Date:From:To:Cc:Subject:From;
        b=mDOBHhWgwnCtEWmIj6Jr3jgkgIzR+LkDnHHL3vtNUwjhDl55XrGXVBpx0jATJPBLM
         +F3wGgsoYE5ubrM/sgd5bPm29gEOxmFDaQ3FbB2UDAf7/N/1GHcLvXPuZTivd1T6nb
         0/SQ8TuQ9QVw4c5+wr88EbPrmqVOA+zcDF6X3w6gUSgsGaj+x+MWg3PO9WQKGhlUhn
         XXRlXmc7d78vnXag0hqcqhjwyKWZhNMBmuQm3+Fx16W75Hbzg15r6YcroY4wdtINPW
         9XKz16l4bREpDqbN0IfUR7yoDe1dxO75nmJcaEqdpq8OImdE4WBpHnEWgtMiFtwwlG
         08UvQkMOxgzgA==
Date:   Thu, 4 Feb 2021 21:13:51 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Apply 28187dc8ebd938d574edfc6d9e0f9c51c21ff3f4 to linux-5.10.y
Message-ID: <20210205041351.GA2494386@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit 28187dc8ebd9 ("ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN
depends on !LD_IS_LLD") to linux-5.10.y, as it fixes a series of errors
that are seen with ARCH=arm LLVM=1 all{mod,yes}config. CONFIG_LD_IS_LLD
was introduced in 5.8 so it currently does not need to go back farther
than 5.10.

Cheers,
Nathan

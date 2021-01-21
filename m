Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BBB2FEA9A
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbhAUMtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:32978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728429AbhAUMsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 07:48:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7274823A00;
        Thu, 21 Jan 2021 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611233291;
        bh=iTYwdS857L2XuQTJ6i07vI7vgKI4IbLS/V33dEr1FjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vtNhH7eyRp0MfN8Q9FWDZo3sTr+jmZVkeiLgN3JvPTSoTudN+WSqplarvWi75j7h9
         LJYWlgZRLE+moGESZRB2DEZ9gbCRb/Sv7WG7E3+Ie2h3kiJyMEZWKTC9jp/ycJLplp
         6puhiwC3YK+Qw8XmJ9phrmKbbaof3FKk7wWsZ4gw=
Date:   Thu, 21 Jan 2021 13:48:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Jian Cai <jiancai@google.com>
Subject: Re: 44623b2818f4 to 4.19
Message-ID: <YAl4CFZtgfIVdFI+@kroah.com>
References: <CAKwvOdk_U6SEwOC-ykaVTMu1ZmEjWC8cCiTetvU2k2dQ6WPCoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdk_U6SEwOC-ykaVTMu1ZmEjWC8cCiTetvU2k2dQ6WPCoQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 12:23:49PM -0800, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider cherry-picking
> commit 44623b2818f4 ("arch/x86/crypto/crc32c-pcl-intel-asm_64.S")
> to stable-4.19.y.  This will allow us to use LLVM_IAS=1 for Android on
> x86_64 allmodconfig.  The commit first landed in 5.8.  It has already
> landed in 5.4.74 as f73328c3192e.
>
> The backport to 5.4.74 (f73328c3192e) will apply cleanly.  Jian Cai
> sent it to 5.4 for CrOS, but we're trying to be a bit more aggressive
> in Android supporting 4.19+ with LLVM_IAS=1.

Now queued up, thanks.

greg k-h

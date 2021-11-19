Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A4A456F9F
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 14:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKSNdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 08:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhKSNdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 08:33:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A6261A07;
        Fri, 19 Nov 2021 13:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637328640;
        bh=B8x5TgLuonTjLI9voMBpfKdzdUzngPTVyw0SgA5Mk0Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=01ADNcT4F+EE/uZUlW+hhcYPzN5IRb/8chom1RW5PJF0Pv9WXdlSN2fmHNRHrZFfq
         W2NkqBS0irTD58tgUjGEDW63RhEvn2C0Hh4ie26HsPvPjh9L4IzNVbgWqe8O1vbp0e
         ge/h1+D4cjJJo4No1js1Vmk6IXTniJWwxi44FK5g=
Date:   Fri, 19 Nov 2021 14:30:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lucas Henneman <henneman@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>, llvm@lists.linux.dev
Subject: Re: backport of 14831fad73f5 for 5.10 and 5.4
Message-ID: <YZem/VtituWK2zkd@kroah.com>
References: <CAKwvOdmaGrk80s5T9uDMd-XEVTOUupaCxiU1mbtkk9K276KS5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmaGrk80s5T9uDMd-XEVTOUupaCxiU1mbtkk9K276KS5w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 11:30:38AM -0800, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider applying the attached backport of 14831fad73f5 to
> linux-5.10.y and linux-5.4.y.
> 
> 14831fad73f5 first landed in v5.16-rc1.
> 
> There was a minor conflict due to missing e35123d83ee3 ("arm64: lto:
> Strengthen READ_ONCE() to acquire when CONFIG_LTO=y") which first
> landed in v5.11-rc1.
> 
> It fixes a minor warning observed during `make mrproper` for Android
> kernel builds.

Now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12036458D25
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 12:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbhKVLSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 06:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234460AbhKVLSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Nov 2021 06:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACC80604DA;
        Mon, 22 Nov 2021 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637579737;
        bh=ZTbA0nnJ57D27bW7+lA47B18ObNRFFY7AzD4buhZe7M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yVvwnhnCnKxjCVdTP1v1oYCOBZhphnEPMPMXacPHQAiikX0PWgzgXDWklSaxNmGJK
         VkcWP/T20clDo+RJZwOq1ihZjQp47VUrsSjhGKQRY88fqBFIDtKntQkMa6skHdxGny
         8SzkMNMqW/8V3JDCLyqMPVuRnhpn84u6PjWR0eE4=
Date:   Mon, 22 Nov 2021 12:15:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Lucas Henneman <henneman@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>, llvm@lists.linux.dev,
        Pavel Machek <pavel@denx.de>
Subject: Re: backport of 14831fad73f5 for 5.10 and 5.4
Message-ID: <YZt71oaVVAzhNrG+@kroah.com>
References: <CAKwvOdmaGrk80s5T9uDMd-XEVTOUupaCxiU1mbtkk9K276KS5w@mail.gmail.com>
 <YZem/VtituWK2zkd@kroah.com>
 <CAKwvOdkZ1ydLs2VwvVLtT7QK+e1gNB0ZE5RqTxMY15QQvhxZ1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkZ1ydLs2VwvVLtT7QK+e1gNB0ZE5RqTxMY15QQvhxZ1w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 19, 2021 at 02:29:09PM -0800, Nick Desaulniers wrote:
> On Fri, Nov 19, 2021 at 5:30 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Nov 18, 2021 at 11:30:38AM -0800, Nick Desaulniers wrote:
> > > Dear stable kernel maintainers,
> > > Please consider applying the attached backport of 14831fad73f5 to
> > > linux-5.10.y and linux-5.4.y.
> > >
> > > 14831fad73f5 first landed in v5.16-rc1.
> > >
> > > There was a minor conflict due to missing e35123d83ee3 ("arm64: lto:
> > > Strengthen READ_ONCE() to acquire when CONFIG_LTO=y") which first
> > > landed in v5.11-rc1.
> > >
> > > It fixes a minor warning observed during `make mrproper` for Android
> > > kernel builds.
> >
> > Now queued up, thanks.
> 
> I'm sorry; I made a mistake.  As reported by Pavel in
> https://lore.kernel.org/stable/20211119214713.GB23353@amd/
> I missed part of the backport.  Attached is a v2.
> -- 
> Thanks,
> ~Nick Desaulniers



Now queued up, thnaks.

greg k-h

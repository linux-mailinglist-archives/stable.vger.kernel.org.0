Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70D1D0BAE
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbgEMJPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731864AbgEMJPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:15:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB6820661;
        Wed, 13 May 2020 09:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589361320;
        bh=0bsSl6rz+/AGkbDasiDen1WELBnu8wxRtKahkyw+uA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iB6olR/DDxvaNgKbLUpACSQQw3vYd7pwrCaPqH0jhlAoHjGBRajIu/vToVoS0XVyW
         JW99SdP0o4nmdd+aqn4L3nkBKfnYlzFgyIcFLH7KqnXlBj6eyf0Ji2qOMrSXje0GEJ
         X/+GsMe1s9HlCY3hBncrHpcKhMV3qrdUB59pGihw=
Date:   Wed, 13 May 2020 11:15:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Richard Kojedzinszky <richard@kojedz.in>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for 4.4, 4.9] binfmt_elf: Do not move brk for INTERP-less
 ET_EXEC
Message-ID: <20200513091515.GA774690@kroah.com>
References: <20200513085932.920902-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513085932.920902-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 05:59:32PM +0900, Nobuhiro Iwamatsu wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> commit 7be3cb019db1cbd5fd5ffe6d64a23fefa4b6f229 upstream.
> 
> When brk was moved for binaries without an interpreter, it should have
> been limited to ET_DYN only. In other words, the special case was an
> ET_DYN that lacks an INTERP, not just an executable that lacks INTERP.
> The bug manifested for giant static executables, where the brk would end
> up in the middle of the text area on 32-bit architectures.
> 
> Reported-and-tested-by: Richard Kojedzinszky <richard@kojedz.in>
> Fixes: bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>

Already queued up a few hours ago, thanks.

greg k-h

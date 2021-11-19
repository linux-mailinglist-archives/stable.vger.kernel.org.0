Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910C3456EE5
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 13:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhKSMi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 07:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhKSMi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 07:38:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BF3B619BB;
        Fri, 19 Nov 2021 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637325324;
        bh=Q/8XfwlgqZkL7qyt+Eo4KuzW8HvK1T1iBYvnkFqwP1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SWUmXFHFAUrDL0hsA4iKW6MrBhqoE/oEX31QHkqNWqCP5oUfcmvdwJTnA7LnM5WBZ
         rkqoN0eS0KwpHGbgrrgSd0/XbWLZYDfPW1LJ5jktKhGBzhkWkLkvdL7Amttd9L8lem
         c2C4LxWOuTgkcCwt1mHIesD730N7FrkzT31IY7y8=
Date:   Fri, 19 Nov 2021 13:35:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: Apply a52f8a59aef46b59753e583bf4b28fccb069ce64 to 5.15 through
 4.19
Message-ID: <YZeaCndfOGSZLHgX@kroah.com>
References: <YZKpVkYpYfYfHD50@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZKpVkYpYfYfHD50@archlinux-ax161>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:39:18AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> There is a build error with newer versions of clang due to a broken
> FORTIFY_SOURCE implementation, which has never worked:
> 
> https://github.com/ClangBuiltLinux/linux/issues/1496
> https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/1457787760
> 
> Please apply upstream commit a52f8a59aef4 ("fortify: Explicitly disable
> Clang support") to 5.15 through 4.19 to resolve this. It should apply
> cleanly.

Hah!  Oh the Android people are going to _LOVE_ this one...

{sigh}

I'll go do this now...

greg k-h

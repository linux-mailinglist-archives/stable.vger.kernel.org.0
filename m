Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BE82F75C3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbhAOJrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbhAOJrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 04:47:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C587235F7;
        Fri, 15 Jan 2021 09:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610704025;
        bh=/K/prrvKBC1WwWHgBg1M7kbuvitlk0kns6ZFOHNzQpY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qF5l4jRts5cl21m4P/CqLX4fq7LttQBLkT6gdXPDUzpNM1xDiF+JfwkpSu3tGPzym
         nd+gQxumq0iW6zF3Xxovm/1LwU75MTMdNZuLnVu8v+kmzpHDkzJqGzPtDGHpAi2buR
         Jsbd702+mLlSZLgO1r2fhR6MSGx0NPTcqQ08LAfQ=
Date:   Fri, 15 Jan 2021 10:47:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: Backports of eff8728fe69880d3f7983bec3fb6cea4c306261f for 4.4 to
 5.4
Message-ID: <YAFkluSq3mYYuB8z@kroah.com>
References: <20210113185758.GA571703@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113185758.GA571703@ubuntu-m3-large-x86>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 11:57:58AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply the attached backports of commit
> eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input sections") to
> 4.4 through 5.4. I tried to make the file names obvious. This fixes a
> boot failure on ARCH=arm with LLVM 12.

All now queued up, thanks.

greg k-h

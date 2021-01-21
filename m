Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B3E2FEA9E
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 13:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbhAUMsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 07:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:59960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730147AbhAUMo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 07:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D49223A04;
        Thu, 21 Jan 2021 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611233027;
        bh=y8fYJtMHsfJ52SgRuxhaVJfFYOC0KDqy9wIVWBYRyZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/ivS0EuCIOqvMdVwq4Gr+3s6h7WWtr4WUdTZcHu1SmXTDlJRmlO2FHfVA8vy607j
         8FYywa3mjK+FktHpnH/YbiUmVEhg6mXcD0ivIa56PAoRM/Ql4/ejxiyhNuCBpIjpFd
         iPk7k+fXznr43v/vFNWIBrCwNfQHQhvp9uPAlmF0=
Date:   Thu, 21 Jan 2021 13:43:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jian Cai <jiancai@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alistair Delva <adelva@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>
Subject: Re: 78762b0e79bc1dd01347be061abdf505202152c9 for linux-5.4y
Message-ID: <YAl3Afu4hXlhJQIv@kroah.com>
References: <CA+SOCLLdvphxVeH+SvaibixLxdwHd+sC-qc=JdLKQoTN-H0waQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+SOCLLdvphxVeH+SvaibixLxdwHd+sC-qc=JdLKQoTN-H0waQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 03:28:10PM -0800, Jian Cai wrote:
> Dear stable kernel maintainers,
> 
> Please consider applying the following patch for LLVM_IAS=1 support on
> Chrome OS:
> commit 6e7b64b9dd6d "elfcore: fix building with clang"
> 
> Please find in the attached a slightly changed patch due to missing
> upstream commit 7a896028adcf. This patch would fix an issue similar to the
> one fixed by another upstream patch (
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=070bd3a8ac55)
> that has been included in 5.4.

But 78762b0e79bc ("x86/asm/32: Add ENDs to some functions and relabel
with SYM_CODE_*") is in the 5.4.90 kernel release, so are you sure this
is still correct and will work properly?

And your subject is odd, as again, that commit is already in 5.4.90 :)

thanks,

greg k-h

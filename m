Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473861D0FB0
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbgEMK0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgEMK0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 06:26:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF93206D6;
        Wed, 13 May 2020 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589365597;
        bh=sTNPgdoO+x0wrjD9VkpNsMd79UhmU+VvDRd9wMbL294=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TWgY5pllkS0m86DFzZhCXMDGAvLQ9JrxGRZaUfS2OxuDiovRa70oGfYMAqg6tLVfA
         eWFcyD1MeQT4sNB+jnMnjhdpJ6GJOEQGhhnDynAvH/1ly9+96+U1snBOdVvR+KX1Do
         B4HNybb3rxuN7bwIqSg8ywd6Cvhumh45QFISiP4E=
Date:   Wed, 13 May 2020 12:26:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, stable@vger.kernel.org,
        lkp@lists.01.org, bpf@vger.kernel.org,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [selftests/bpf] da43712a72: kernel-selftests.bpf.make_fail
Message-ID: <20200513102634.GC871114@kroah.com>
References: <20200513074418.GE17565@shao2-debian>
 <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200513095835.GD102436@dhcp-12-153.nay.redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 05:58:35PM +0800, Hangbin Liu wrote:
> 
> Thanks test bot catch the issue.
> On Wed, May 13, 2020 at 03:44:18PM +0800, kernel test robot wrote:
> > Greeting,
> > 
> > FYI, we noticed the following commit (built with gcc-7):
> > 
> > commit: 77bb53cb094828a31cd3c5b402899810f63073c1 ("selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs")
> > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> 
> The author for this commit is Andrii(cc'd).
> 
> Mine is f1c3656c6d9c ("selftests/bpf: Skip perf hw events test if the setup disabled it")
> > prog_tests/stacktrace_build_id_nmi.c:55:3: error: label ‘cleanup’ used but not defined
> >    goto cleanup;
> >    ^~~~
> 
> Hi Greg, we are missing a depend commit
> dde53c1b763b ("selftests/bpf: Convert few more selftest to skeletons").
> 
> So either we need backport this patch, or if you like, we can also fix it by
> changing 'goto cleanup;' to 'goto close_prog;'. So which one do you prefer?

I don't know, I have no context here at all, sorry.

What stable kernel tree is failing, what patch needs to be changed, what
patch caused this, and so on...

confused,

greg k-h

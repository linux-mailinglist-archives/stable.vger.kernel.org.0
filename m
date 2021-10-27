Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EF243CF80
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 19:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbhJ0RQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 13:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232762AbhJ0RQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 13:16:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6042601FF;
        Wed, 27 Oct 2021 17:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635354835;
        bh=5nFkFj3PXJI9L7kyUHgFHRHds1LU0rOzwg8GbYHqQUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gpJp/TFHEcPkOE1H2svp5c74o3k34+JIcIdP41bW5qlGLlnIFGFIE2YEkzR1EKxa2
         Lu44iFjO9l8Yq0imBYViA9MQKJxcd6Fhyl632Ll2P19g79zmS8toGnysHyT9rzfDQu
         TJjTlKzS9h927I6S3uJilKTgz3iAs1dd7r7+aask=
Date:   Wed, 27 Oct 2021 19:13:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: Apply 091bb549f7722723b284f63ac665e2aedcf9dec9 to 4.19
Message-ID: <YXmI0cqUcAD7nrVF@kroah.com>
References: <YXl98bQRrJvVKdwC@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXl98bQRrJvVKdwC@archlinux-ax161>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 09:27:29AM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply commit 091bb549f772 ("ARM: 8819/1: Remove '-p' from
> LDFLAGS") to 4.19 (and earlier if so desired). LLD 14 will remove the
> '-p' flag [1] for reasons outlined in both the Linux and LLD commit,
> which will cause our builds to break [2]. I have verified that it
> applies cleanly back to 4.4, although we only build ARM kernels with LLD
> on 4.19 and newer, so it is not strictly necessary there.
> 
> [1]: https://github.com/llvm/llvm-project/commit/815a1207bfe121c8dcf3804a4f4638e580f63519
> [2]: https://github.com/ClangBuiltLinux/continuous-integration2/runs/4016787082?check_suite_focus=true

Applied now, thanks!

greg k-h

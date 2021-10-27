Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA5343CEBA
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhJ0QaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236091AbhJ0Q37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 12:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 244D760E73;
        Wed, 27 Oct 2021 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635352054;
        bh=FSXRRtjpyCZH8PlGwcOJ7JmJJyqnMpsnIJ2P+auNuMM=;
        h=Date:From:To:Cc:Subject:From;
        b=Uoejj0otusLIimAHXqzNXE9xdaUfwtApOHVfAaU+z7rL/7n2NBEAcuYJok7DGdepF
         4aGrGhzL5sYzHqDuHppwHOJ95xEAikjcpjrvLTwhIe90n7aqWbupR3Hl15Tp48uQms
         gL1XGszMxxsClIaQ53fZPOUxhshuiQhMXWWoa9udRU7VpPnq7rqv+kFwUs5nZHR8Rm
         FsxGYpaeZBTqqj7yb+rST+JUTUKkkseM8KyJD1XQEH8My06mOiM6rRkhgmPY2ncrF8
         NwIrjYxUV50SCm9gXWHInvr+C7omPGIh0RIENvgJvddfi7uzVB1SfMPrfjtpXO+mb+
         rSAZvSneMcnXg==
Date:   Wed, 27 Oct 2021 09:27:29 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Apply 091bb549f7722723b284f63ac665e2aedcf9dec9 to 4.19
Message-ID: <YXl98bQRrJvVKdwC@archlinux-ax161>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha,

Please apply commit 091bb549f772 ("ARM: 8819/1: Remove '-p' from
LDFLAGS") to 4.19 (and earlier if so desired). LLD 14 will remove the
'-p' flag [1] for reasons outlined in both the Linux and LLD commit,
which will cause our builds to break [2]. I have verified that it
applies cleanly back to 4.4, although we only build ARM kernels with LLD
on 4.19 and newer, so it is not strictly necessary there.

[1]: https://github.com/llvm/llvm-project/commit/815a1207bfe121c8dcf3804a4f4638e580f63519
[2]: https://github.com/ClangBuiltLinux/continuous-integration2/runs/4016787082?check_suite_focus=true

Cheers,
Nathan

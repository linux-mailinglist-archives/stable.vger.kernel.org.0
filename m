Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC8536FC07
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhD3OVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230383AbhD3OVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF3D61450;
        Fri, 30 Apr 2021 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792427;
        bh=2MLVY8umpquCRIgnNuKUEERUTogR3966Dj+quap+Ex4=;
        h=From:To:Cc:Subject:Date:From;
        b=MZu/g99/v3qmJWqURml31YvJuf2vFJEKk2mRw1dR6K9Zg90y6CAQh3qXFbLx9IBbB
         4LKL0+/4g1mCZuyaGUkmtJn/iR7trLueONiVpr4bOZpVEJvVifiAQntj44OBzWDcw8
         quN5iC+rGpCT4tOzAMyDc559hA1nbCHzh3oaoGuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 0/8] 5.4.116-rc1 review
Date:   Fri, 30 Apr 2021 16:20:14 +0200
Message-Id: <20210430141911.137473863@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.116-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.116-rc1
X-KernelTest-Deadline: 2021-05-02T14:19+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.116 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.116-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.116-rc1

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Update selftests to reflect new error states

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Tighten speculative pointer arithmetic mask

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move sanitize_val_alu out of op switch

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Refactor and streamline bounds check into helper

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Improve verifier error messages for users

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Rework ptr_limit into alu_limit and add common error path

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Ensure off_reg has no mixed signed bounds for all types

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move off_reg into sanitize_ptr_alu


-------------

Diffstat:

 Makefile                                           |   4 +-
 kernel/bpf/verifier.c                              | 233 ++++++++++++++-------
 .../selftests/bpf/verifier/bounds_deduction.c      |  21 +-
 .../bpf/verifier/bounds_mix_sign_unsign.c          |  13 --
 tools/testing/selftests/bpf/verifier/unpriv.c      |   2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |   6 +-
 6 files changed, 175 insertions(+), 104 deletions(-)



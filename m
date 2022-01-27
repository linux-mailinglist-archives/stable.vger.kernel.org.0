Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A634349E9AD
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbiA0SIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbiA0SIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:08:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAA1C06173B;
        Thu, 27 Jan 2022 10:08:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E4661CF0;
        Thu, 27 Jan 2022 18:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193C9C340E4;
        Thu, 27 Jan 2022 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306918;
        bh=s4mRV+14vZQZyKAfcdb2AqF32nDmOlMD1BWk47fg88A=;
        h=From:To:Cc:Subject:Date:From;
        b=PcRUNB8vytwQExhNVGKxBxy/Nc0BwjkjKqtH3zus9NFd0NE76oPbOeNZ4Fzw5RVNK
         c9Z5yPNv56P/qAA7lt24S+7cycwpeR2PONNIE7wsc0nrc4/O756945F8oIWJV4AMhK
         +40bfMUKz8OlmhS8p3u+JJShF8SlolNGaytnLmAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com
Subject: [PATCH 4.9 0/9] 4.9.299-rc1 review
Date:   Thu, 27 Jan 2022 19:08:18 +0100
Message-Id: <20220127180257.225641300@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.299-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.299-rc1
X-KernelTest-Deadline: 2022-01-29T18:02+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.299 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.299-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.299-rc1

Lee Jones <lee.jones@linaro.org>
    ion: Do not 'put' ION handle until after its final use

Daniel Rosenberg <drosen@google.com>
    ion: Protect kref from userspace manipulation

Daniel Rosenberg <drosen@google.com>
    ion: Fix use after free during ION_IOC_ALLOC

Stefan Agner <stefan@agner.ch>
    ARM: 8800/1: use choice for kernel unwinders

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: MMU: Use the correct inherited permissions to get shadow page

Paolo Bonzini <pbonzini@redhat.com>
    KVM: nVMX: fix EPT permissions as reported in exit qualification

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Initialise connection to the server in nfs4_alloc_client()

Dan Carpenter <dan.carpenter@oracle.com>
    media: firewire: firedtv-avc: fix a buffer overflow in avc_ca_pmt()

Tvrtko Ursulin <tvrtko.ursulin@intel.com>
    drm/i915: Flush TLBs before releasing backing store


-------------

Diffstat:

 Documentation/virtual/kvm/mmu.txt       |  4 +-
 Makefile                                |  4 +-
 arch/arm/Kconfig.debug                  | 44 +++++++++------
 arch/x86/kvm/paging_tmpl.h              | 44 +++++++++------
 drivers/gpu/drm/i915/i915_drv.h         |  5 +-
 drivers/gpu/drm/i915/i915_gem.c         | 72 +++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c     |  4 ++
 drivers/gpu/drm/i915/i915_reg.h         |  6 +++
 drivers/media/firewire/firedtv-avc.c    | 14 +++--
 drivers/media/firewire/firedtv-ci.c     |  2 +
 drivers/staging/android/ion/ion-ioctl.c | 96 +++++++++++++++++++++++++++++----
 drivers/staging/android/ion/ion.c       | 19 +++++--
 drivers/staging/android/ion/ion.h       |  4 ++
 drivers/staging/android/ion/ion_priv.h  |  4 ++
 fs/nfs/nfs4client.c                     | 82 ++++++++++++++--------------
 lib/Kconfig.debug                       |  6 +--
 16 files changed, 311 insertions(+), 99 deletions(-)



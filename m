Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9D6A0978
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjBWNGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbjBWNGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:06:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1105651A;
        Thu, 23 Feb 2023 05:06:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BADA3616DD;
        Thu, 23 Feb 2023 13:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671CDC4339B;
        Thu, 23 Feb 2023 13:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157571;
        bh=G5aqBteG6fQ/gaR2l1YmJbm2vwdmlTnnXrKPXVp2bhU=;
        h=From:To:Cc:Subject:Date:From;
        b=BJ5u8NLmh5IInuZKWM9xTBVLx2znvDhxvgoP38fKYv/E6nhHo+PnQ9amC0KJGRhf0
         a+Ztl3sqk5wyTmhBsoA1iMC0B+zyoCoZqwunsh+YLOYkoHQtessuFVjCi8X+j8hyce
         N64kaJYZEyWhcONB3+Z7enBCaki/NUFvFpP3Vgog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 00/11] 6.2.1-rc1 review
Date:   Thu, 23 Feb 2023 14:04:54 +0100
Message-Id: <20230223130426.170746546@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.1-rc1
X-KernelTest-Deadline: 2023-02-25T13:04+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.1 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.1-rc1

Eric Biggers <ebiggers@google.com>
    randstruct: disable Clang 15 support

Kees Cook <keescook@chromium.org>
    ext4: Fix function prototype mismatch for ext4_feat_ktype

Hans de Goede <hdegoede@redhat.com>
    platform/x86: nvidia-wmi-ec-backlight: Add force module parameter

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Add depends on CONFIG_POWER_SUPPLY

Paul Moore <paul@paul-moore.com>
    audit: update the mailing list in MAINTAINERS

Lukas Wunner <lukas@wunner.de>
    wifi: mwifiex: Add missing compatible string for SD8787

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: mcp-2221: prevent UAF in delayed work

Peter Zijlstra <peterz@infradead.org>
    x86/static_call: Add support for Jcc tail-calls

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Introduce int3_emulate_jcc()

Dave Hansen <dave.hansen@linux.intel.com>
    uaccess: Add speculation barrier to copy_from_user()


-------------

Diffstat:

 MAINTAINERS                                    |  2 +-
 Makefile                                       |  4 +-
 arch/x86/include/asm/text-patching.h           | 31 +++++++++++++
 arch/x86/kernel/alternative.c                  | 62 +++++++++++++++++++-------
 arch/x86/kernel/kprobes/core.c                 | 38 ++++------------
 arch/x86/kernel/static_call.c                  | 50 +++++++++++++++++++--
 drivers/hid/hid-mcp2221.c                      |  3 ++
 drivers/net/wireless/marvell/mwifiex/sdio.c    |  1 +
 drivers/platform/x86/amd/pmf/Kconfig           |  1 +
 drivers/platform/x86/nvidia-wmi-ec-backlight.c |  6 ++-
 fs/ext4/sysfs.c                                |  7 ++-
 include/linux/nospec.h                         |  4 ++
 kernel/bpf/core.c                              |  2 -
 lib/usercopy.c                                 |  7 +++
 security/Kconfig.hardening                     |  3 ++
 15 files changed, 166 insertions(+), 55 deletions(-)



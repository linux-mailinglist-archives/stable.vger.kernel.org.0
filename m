Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E970B1E46
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfIMNIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbfIMNIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:08:43 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 766642089F;
        Fri, 13 Sep 2019 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380122;
        bh=G/8/zSGcnabzQomBou+lc5kJ/m1z05L/8BmRmSk50vk=;
        h=From:To:Cc:Subject:Date:From;
        b=U6ZVwk7JTNZnzBdOcfR30p4uNJaRjSkf+NRIQzapizgDCY4qQ151cJJ58J1yOlQzY
         s1RgwXT9FB8S/IqXiiixW5vI7U5RSMEqF4uw2ajQ3fcwnpkq9Kg2kkxjX8YeUJPyad
         8ncuWhRZPDA/p/YV/jM5aQtn6Fl19I3mXrJF9/AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.4 0/9] 4.4.193-stable review
Date:   Fri, 13 Sep 2019 14:06:50 +0100
Message-Id: <20190913130424.160808669@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.193-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.193-rc1
X-KernelTest-Deadline: 2019-09-15T13:04+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.193 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.193-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.193-rc1

yongduan <yongduan@tencent.com>
    vhost: make sure log_num < in_num

Dave Jones <davej@codemonkey.org.uk>
    af_packet: tone down the Tx-ring unsupported spew.

Zhenzhong Duan <zhenzhong.duan@oracle.com>
    x86, boot: Remove multiple copy of static function sanitize_boot_params()

Nathan Chancellor <natechancellor@gmail.com>
    clk: s2mps11: Add used attribute to s2mps11_dt_match

Nicolas Boichat <drinkcat@chromium.org>
    scripts/decode_stacktrace: match basepath using shell prefix operator, not regex

Tiwei Bie <tiwei.bie@intel.com>
    vhost/test: fix build for vhost test

Cong Wang <xiyou.wangcong@gmail.com>
    xfrm: clean up xfrm protocol checks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix overridden device-specific initialization

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix potential endless loop at applying quirks


-------------

Diffstat:

 Makefile                        |  4 ++--
 arch/x86/boot/compressed/misc.c |  1 +
 arch/x86/boot/compressed/misc.h |  1 -
 drivers/clk/clk-s2mps11.c       |  2 +-
 drivers/vhost/test.c            | 13 +++++++++----
 drivers/vhost/vhost.c           |  4 ++--
 include/net/xfrm.h              | 17 +++++++++++++++++
 net/key/af_key.c                |  4 +++-
 net/packet/af_packet.c          |  2 +-
 net/xfrm/xfrm_state.c           |  2 +-
 net/xfrm/xfrm_user.c            | 14 +-------------
 scripts/decode_stacktrace.sh    |  2 +-
 sound/pci/hda/hda_auto_parser.c |  4 ++--
 sound/pci/hda/hda_generic.c     |  3 ++-
 sound/pci/hda/hda_generic.h     |  1 +
 sound/pci/hda/patch_realtek.c   |  2 ++
 16 files changed, 46 insertions(+), 30 deletions(-)



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172311EFA4A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgFEOQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbgFEOQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EF3F208A7;
        Fri,  5 Jun 2020 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366576;
        bh=JU4stAOq1lN3utFdATiHTwbtxQpBWg4NpI7D+Sezy30=;
        h=From:To:Cc:Subject:Date:From;
        b=EEKpefyiqVs562U9Gxl3ytexS5sctlwGJ4z2LkE/woU351lb2IQ/1dO8FarfTSNCM
         wb4Jr1iDrSvbRawJKkSxho4HwtskiZdQR0kJ7f/WkghAfWTrfFgcJQBSaxF+qz9agr
         +Ze5MlzgrjW5Rax+klKEds9KxmufLnMqFY+BL7zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 00/14] 5.7.1-rc1 review
Date:   Fri,  5 Jun 2020 16:14:50 +0200
Message-Id: <20200605135951.018731965@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.1-rc1
X-KernelTest-Deadline: 2020-06-07T13:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.1 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.1-rc1

Dan Carpenter <dan.carpenter@oracle.com>
    airo: Fix read overflows sending packets

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: set CPU port to fallback mode

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: staging: ipu3-imgu: Move alignment attribute to field

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: Revert "staging: imgu: Address a compiler warning on alignment"

Jérôme Pouiller <jerome.pouiller@silabs.com>
    mmc: fix compilation of user API

Daniel Axtens <dja@axtens.net>
    kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix use-after-free and race in crypto_spawn_alg

Matthew Garrett <matthewgarrett@google.com>
    mt76: mt76x02u: Add support for newer versions of the XBox One wifi adapter

Giuseppe Marco Randazzo <gmrandazzo@gmail.com>
    p54usb: add AirVasT USB stick device-id

Julian Sax <jsbc@gmx.de>
    HID: i2c-hid: add Schneider SCL142ALM to descriptor override

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: enable multi-input as a quirk for some devices

Scott Shumate <scott.shumate@gmail.com>
    HID: sony: Fix for broken buttons on DS3 USB dongles

Fan Yang <Fan_Yang@sjtu.edu.cn>
    mm: Fix mremap not considering huge pmd devmap

Brad Love <brad@nextdimension.cc>
    media: dvbdev: Fix tuner->demod media controller link


-------------

Diffstat:

 Makefile                                        |  4 ++--
 arch/x86/include/asm/pgtable.h                  |  1 +
 crypto/algapi.c                                 | 22 +++++++++++++++------
 crypto/api.c                                    |  3 ++-
 crypto/internal.h                               |  1 +
 drivers/hid/hid-multitouch.c                    | 26 +++++++++++++++++++++++++
 drivers/hid/hid-sony.c                          | 17 ++++++++++++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c        |  8 ++++++++
 drivers/media/dvb-core/dvbdev.c                 |  5 +++--
 drivers/net/dsa/mt7530.c                        | 11 ++++++++---
 drivers/net/dsa/mt7530.h                        |  6 ++++++
 drivers/net/wireless/cisco/airo.c               | 12 ++++++++++++
 drivers/net/wireless/intersil/p54/p54usb.c      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h    |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c |  1 +
 drivers/staging/media/ipu3/include/intel-ipu3.h |  7 ++++---
 include/uapi/linux/mmc/ioctl.h                  |  1 +
 kernel/relay.c                                  |  5 +++++
 mm/mremap.c                                     |  2 +-
 19 files changed, 116 insertions(+), 18 deletions(-)



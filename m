Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643A3650AE1
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiLSLnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiLSLnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:43:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC94DFF2;
        Mon, 19 Dec 2022 03:42:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F1F8B80D8A;
        Mon, 19 Dec 2022 11:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AA6C433D2;
        Mon, 19 Dec 2022 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450164;
        bh=YHgKCe475QoxneX3yV8hWm9VW3mas4cI7EVD50ou6j0=;
        h=From:To:Cc:Subject:Date:From;
        b=BMZPHRzvuCkK/bsAsoyG37wcxW+x/CO4PWZOF9r0Hc47ZNeKFKaHkmJWzOUAdY17p
         qmpkR2Da28dPCO4eXxU9WbNwFMX2/JG+B8uwkXf68WP+ORX8u6xe63iWacfPPOcYo2
         aq19GYdosxrvSGa+RBRCQ4mI3FPbyv1EMxKycP0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.84
Date:   Mon, 19 Dec 2022 12:42:32 +0100
Message-Id: <1671450152215246@kroah.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.84 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 -
 arch/x86/entry/vdso/vdso.lds.S                           |    2 +
 drivers/net/can/usb/mcba_usb.c                           |   10 ++++--
 drivers/net/ethernet/freescale/fec_main.c                |   23 ++++-----------
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c |    3 +
 drivers/nvme/host/pci.c                                  |    2 +
 drivers/pinctrl/mediatek/mtk-eint.c                      |    9 +++--
 fs/ksmbd/vfs.c                                           |    6 +--
 fs/nfsd/vfs.c                                            |    4 +-
 fs/read_write.c                                          |   17 ++++++++---
 include/linux/can/platform/sja1000.h                     |    2 -
 include/linux/fs.h                                       |    8 +++++
 kernel/events/core.c                                     |   17 ++++++++---
 sound/soc/codecs/cs42l51.c                               |    2 -
 sound/soc/fsl/fsl_micfil.c                               |   19 ++++++++++++
 sound/soc/soc-ops.c                                      |    9 ++++-
 tools/lib/bpf/libbpf_probes.c                            |    2 -
 17 files changed, 95 insertions(+), 42 deletions(-)

Amir Goldstein (1):
      vfs: fix copy_file_range() averts filesystem freeze protection

Charles Keepax (2):
      ASoC: cs42l51: Correct PGA Volume minimum value
      ASoC: ops: Correct bounds check for second channel on SX controls

Greg Kroah-Hartman (1):
      Linux 5.15.84

Heiko Schocher (1):
      can: sja1000: fix size of OCR_MODE_MASK define

Hou Tao (1):
      libbpf: Use page size as max_entries when probing ring buffer map

Jialiang Wang (1):
      nfp: fix use-after-free in area_cache_get()

Lei Rao (1):
      nvme-pci: clear the prp2 field when not used

Mark Brown (1):
      ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Nathan Chancellor (1):
      x86/vdso: Conditionally export __vdso_sgx_enter_enclave()

Peter Zijlstra (1):
      perf: Fix perf_pending_task() UaF

Rasmus Villemoes (2):
      net: fec: don't reset irq coalesce settings to defaults on "ip link up"
      net: fec: properly guard irq coalesce setup

Ricardo Ribalda (1):
      pinctrl: meditatek: Startup with the IRQs disabled

Shengjiu Wang (2):
      ASoC: fsl_micfil: explicitly clear software reset bit
      ASoC: fsl_micfil: explicitly clear CHnF flags

Yasushi SHOJI (1):
      can: mcba_usb: Fix termination command argument


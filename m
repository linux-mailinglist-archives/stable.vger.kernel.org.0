Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E9B650AE5
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiLSLnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiLSLnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:43:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA24FD06;
        Mon, 19 Dec 2022 03:42:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42F67B80D8B;
        Mon, 19 Dec 2022 11:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF33FC433EF;
        Mon, 19 Dec 2022 11:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450172;
        bh=x4n6XGsUWmrNOuVdtiWeQLCcXpRd1jug6cd6U22/suA=;
        h=From:To:Cc:Subject:Date:From;
        b=TtF5a7PjRFeD2MhMipjrMtTPQW/r2zzpjXV+TaOc1BYfrHXOsI9NFdEd5mrjikgNw
         GF18T5R5Tiy2wcDAAx0GSwuWjK0XyiMzJ3iTLzYXXNEL3hjaPQM5v4Ub5GGgbRh8Qi
         0G2pVKXRn2hXvtjGrwqAXKOJcsDnZ7VQjSNmkcJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.0.14
Date:   Mon, 19 Dec 2022 12:42:44 +0100
Message-Id: <1671450164220150@kroah.com>
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

I'm announcing the release of the 6.0.14 kernel.

All users of the 6.0 kernel series must upgrade.

The updated 6.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/x86/entry/vdso/vdso.lds.S            |    2 +
 drivers/net/can/usb/mcba_usb.c            |   10 ++++++--
 drivers/net/ethernet/freescale/fec_main.c |   23 ++++++-------------
 drivers/nvme/host/pci.c                   |    2 +
 drivers/pinctrl/mediatek/mtk-eint.c       |    9 +++++--
 drivers/rtc/rtc-cmos.c                    |   35 ++++++++++++++++++++++--------
 include/linux/can/platform/sja1000.h      |    2 -
 kernel/events/core.c                      |   17 +++++++++++---
 sound/soc/codecs/cs42l51.c                |    2 -
 sound/soc/fsl/fsl_micfil.c                |   19 ++++++++++++++++
 sound/soc/soc-ops.c                       |    9 ++++++-
 tools/lib/bpf/btf_dump.c                  |    2 -
 tools/lib/bpf/libbpf_probes.c             |    2 -
 14 files changed, 94 insertions(+), 42 deletions(-)

Alexandre Belloni (1):
      rtc: cmos: fix build on non-ACPI platforms

Charles Keepax (2):
      ASoC: cs42l51: Correct PGA Volume minimum value
      ASoC: ops: Correct bounds check for second channel on SX controls

David Michael (1):
      libbpf: Fix uninitialized warning in btf_dump_dump_type_data

Greg Kroah-Hartman (1):
      Linux 6.0.14

Heiko Schocher (1):
      can: sja1000: fix size of OCR_MODE_MASK define

Hou Tao (1):
      libbpf: Use page size as max_entries when probing ring buffer map

Lei Rao (1):
      nvme-pci: clear the prp2 field when not used

Mark Brown (1):
      ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Nathan Chancellor (1):
      x86/vdso: Conditionally export __vdso_sgx_enter_enclave()

Peter Zijlstra (1):
      perf: Fix perf_pending_task() UaF

Rafael J. Wysocki (2):
      rtc: cmos: Fix event handler registration ordering issue
      rtc: cmos: Fix wake alarm breakage

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


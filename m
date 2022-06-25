Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2B855AA8C
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiFYNmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiFYNmn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:42:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B0918B11;
        Sat, 25 Jun 2022 06:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA8E960B7B;
        Sat, 25 Jun 2022 13:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE28C3411C;
        Sat, 25 Jun 2022 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656164562;
        bh=/t62NNOj4R6qnvMfd7AngUWfSb0yk2bY1ohNuEHbaxs=;
        h=From:To:Cc:Subject:Date:From;
        b=Vh6KZXHJa1p1EcQI/NZ++N18uLsX/eDQZ8LMmhZ0D50lx0AT80MCF62kMJCraZZjj
         OtdTdcVl27SyQ1K9FFFF2fsa9F8vm67nF4KTsi30/yik55N34blAN2LWag9SPKbFde
         CdkAXhzVnr/1w8Oy6mN6M8o15g13Ym1ITkd/nrw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.50
Date:   Sat, 25 Jun 2022 15:42:33 +0200
Message-Id: <1656164554204142@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.50 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                 |    2 
 arch/arm64/mm/cache.S                                    |    2 
 arch/s390/mm/pgtable.c                                   |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c        |   30 ++++
 drivers/net/ethernet/microsoft/mana/mana_en.c            |    7 -
 drivers/tty/serial/amba-pl011.c                          |   15 --
 drivers/tty/serial/serial_core.c                         |   34 +----
 drivers/usb/gadget/function/u_ether.c                    |   11 +
 fs/zonefs/super.c                                        |   94 ++++++++++-----
 kernel/bpf/btf.c                                         |    5 
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c   |   14 ++
 tools/testing/selftests/bpf/progs/freplace_global_func.c |   18 ++
 12 files changed, 155 insertions(+), 79 deletions(-)

Christian Borntraeger (1):
      s390/mm: use non-quiescing sske for KVM switch to keyed guest

Damien Le Moal (1):
      zonefs: fix zonefs_iomap_begin() for reads

Greg Kroah-Hartman (1):
      Linux 5.15.50

Haiyang Zhang (1):
      net: mana: Add handling of CQE_RX_TRUNCATED

Lukas Wunner (1):
      serial: core: Initialize rs485 RTS polarity already on probe

Marian Postevca (1):
      usb: gadget: u_ether: fix regression in setting fixed MAC address

Nicholas Kazlauskas (1):
      drm/amd/display: Don't reinitialize DMCUB on s0ix resume

Toke Høiland-Jørgensen (2):
      bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
      selftests/bpf: Add selftest for calling global functions from freplace

Will Deacon (1):
      arm64: mm: Don't invalidate FROM_DEVICE buffers at start of DMA transfer


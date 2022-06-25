Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8BC55AA96
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiFYNnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiFYNmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 09:42:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE521AE;
        Sat, 25 Jun 2022 06:42:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5866261361;
        Sat, 25 Jun 2022 13:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37278C3411C;
        Sat, 25 Jun 2022 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656164572;
        bh=RQDVR4mTID4y5pbcpQf7RTMS+3IKYtpjI4kizSPDKSw=;
        h=From:To:Cc:Subject:Date:From;
        b=15gGt+J20jSx755IK1V0M34ac5hF98BXt3/rVrab8qVwHj+TNzcrFRD5yNb4n/ekB
         VmbM8w3VyQT+KO+8LA1oQlT/J5vGhhcJZX4eT6c6ydqIdkv8+7SM+hp55zCgQEOVG2
         TYRON6OxfRrkO7e7Z1dbpx++xNbijGb6a1yVdKME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.7
Date:   Sat, 25 Jun 2022 15:42:41 +0200
Message-Id: <16561645612100@kroah.com>
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

I'm announcing the release of the 5.18.7 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/nvmem/fsl,layerscape-sfp.yaml |   14 +
 Makefile                                                        |    2 
 arch/s390/mm/pgtable.c                                          |    2 
 arch/x86/boot/boot.h                                            |   36 ++-
 arch/x86/boot/main.c                                            |    2 
 drivers/net/ethernet/sun/cassini.c                              |    4 
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c            |    5 
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c                   |   10 -
 fs/io_uring.c                                                   |    2 
 fs/notify/fanotify/fanotify.c                                   |   24 --
 fs/notify/fsnotify.c                                            |   85 ++++-----
 fs/zonefs/super.c                                               |   94 ++++++----
 include/linux/fsnotify_backend.h                                |   31 ++-
 kernel/bpf/btf.c                                                |    4 
 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c          |   14 +
 tools/testing/selftests/bpf/progs/freplace_global_func.c        |   18 +
 16 files changed, 216 insertions(+), 131 deletions(-)

Amir Goldstein (2):
      fsnotify: introduce mark type iterator
      fsnotify: consistent behavior for parent not watching children

Christian Borntraeger (1):
      s390/mm: use non-quiescing sske for KVM switch to keyed guest

Damien Le Moal (1):
      zonefs: fix zonefs_iomap_begin() for reads

Greg Kroah-Hartman (1):
      Linux 5.18.7

Jakub Kicinski (2):
      wifi: rtlwifi: remove always-true condition pointed out by GCC 12
      net: wwan: iosm: remove pointless null check

Jens Axboe (1):
      io_uring: use original request task for inflight tracking

Kees Cook (1):
      x86/boot: Wrap literal addresses in absolute_pointer()

Martin Liška (1):
      eth: sun: cassini: remove dead code

Sean Anderson (1):
      dt-bindings: nvmem: sfp: Add clock properties

Toke Høiland-Jørgensen (2):
      bpf: Fix calling global functions from BPF_PROG_TYPE_EXT programs
      selftests/bpf: Add selftest for calling global functions from freplace


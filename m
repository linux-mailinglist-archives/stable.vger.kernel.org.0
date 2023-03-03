Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1106A9620
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjCCLZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjCCLYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:24:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DE55D89C;
        Fri,  3 Mar 2023 03:24:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A845B81699;
        Fri,  3 Mar 2023 11:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DE8C433EF;
        Fri,  3 Mar 2023 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677842657;
        bh=a5ZxME7HaovdZd85dPsZK1E+fNzWIY1jVoAT2gMl7IQ=;
        h=From:To:Cc:Subject:Date:From;
        b=q6PR9+uXOP6jAb6V6GDxL/TppoJzB6vK4PHWdCBKbkdX6WRv8fKpTHsyOBVGZNqhP
         QCDrPWiQuvUzSu0I4p8AojioXQISlM82raso/5NWcecFr5pcLhztoEd3l1InYKk8iE
         iDhaO4R/amWCiSzt4Kld8CCfbQqSUVtirNjYVYs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 6.2.2
Date:   Fri,  3 Mar 2023 12:24:04 +0100
Message-Id: <167784264418990@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 6.2.2 kernel.

All users of the 6.2 kernel series must upgrade.

The updated 6.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-6.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                    |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts |    2 
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts |    2 
 arch/arm64/crypto/sm4-ce-gcm-glue.c                         |   51 +++++-------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c           |    3 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c        |   24 +++++
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h        |    2 
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c         |    2 
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h             |   25 +++++
 drivers/net/wireless/realtek/rtw88/usb.c                    |   18 ----
 drivers/tty/vt/vc_screen.c                                  |    7 -
 drivers/usb/core/hub.c                                      |    5 -
 drivers/usb/core/sysfs.c                                    |    5 -
 drivers/usb/dwc3/dwc3-pci.c                                 |    4 
 drivers/usb/gadget/function/u_serial.c                      |   23 ++++-
 drivers/usb/serial/option.c                                 |    4 
 drivers/usb/typec/pd.c                                      |    1 
 net/core/filter.c                                           |    4 
 scripts/tags.sh                                             |    2 
 sound/pci/hda/hda_cs_dsp_ctl.c                              |    4 
 20 files changed, 124 insertions(+), 66 deletions(-)

Alan Stern (1):
      USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Carlos Llamas (1):
      scripts/tags.sh: fix incompatibility with PCRE2

Florian Zumbiehl (1):
      USB: serial: option: add support for VW/Skoda "Carstick LTE"

Greg Kroah-Hartman (1):
      Linux 6.2.2

Heikki Krogerus (1):
      usb: dwc3: pci: add support for the Intel Meteor Lake-M

Herbert Xu (1):
      crypto: arm64/sm4-gcm - Fix possible crash in GCM cryption

Kunihiko Hayashi (1):
      arm64: dts: uniphier: Fix property name in PXs3 USB node

Martin KaFai Lau (1):
      bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Nicholas Kazlauskas (1):
      drm/amd/display: Move DCN314 DOMAIN power control to DMCUB

Prashanth K (1):
      usb: gadget: u_serial: Add null pointer check in gserial_resume

Saranya Gopal (1):
      usb: typec: pd: Remove usb_suspend_supported sysfs from sink PDO

Sascha Hauer (3):
      wifi: rtw88: usb: Set qsel correctly
      wifi: rtw88: usb: send Zero length packets if necessary
      wifi: rtw88: usb: drop now unnecessary URB size check

Stylon Wang (1):
      drm/amd/display: Properly reuse completion structure

Thomas Weißschuh (1):
      vc_screen: don't clobber return value in vcs_read

Vitaly Rodionov (1):
      ALSA: hda: cs35l41: Correct error condition handling


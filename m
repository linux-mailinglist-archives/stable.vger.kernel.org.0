Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611906A72CE
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjCASKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjCASJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446723CE18;
        Wed,  1 Mar 2023 10:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C38EC6145C;
        Wed,  1 Mar 2023 18:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EABC433D2;
        Wed,  1 Mar 2023 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694170;
        bh=0skYakOmKGdaRdC9U5BM4vWbQIEgEKrv7NVrg6Y8nIg=;
        h=From:To:Cc:Subject:Date:From;
        b=RVvCI6vgdFIsEWeS1DqYmtioQTD3A/ZgTUhiH24fOj+9IbJzhPvJvM/+hNJ0vsPuq
         kmBRgyWYgQcKbrmXz5DIxh++P8WYyMT+WpyFr3tIb0WN+IvYh8dxmqn5lU6VOX9alw
         VaMTe87T51rH6Xn3z5T7IH+qWySOqZxJJVldHJ8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.2 00/16] 6.2.2-rc1 review
Date:   Wed,  1 Mar 2023 19:07:36 +0100
Message-Id: <20230301180653.263532453@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.2.2-rc1
X-KernelTest-Deadline: 2023-03-03T18:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.2.2 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.2.2-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Saranya Gopal <saranya.gopal@intel.com>
    usb: typec: pd: Remove usb_suspend_supported sysfs from sink PDO

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    arm64: dts: uniphier: Fix property name in PXs3 USB node

Prashanth K <quic_prashk@quicinc.com>
    usb: gadget: u_serial: Add null pointer check in gserial_resume

Florian Zumbiehl <florz@florz.de>
    USB: serial: option: add support for VW/Skoda "Carstick LTE"

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Meteor Lake-M

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: rtw88: usb: drop now unnecessary URB size check

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: rtw88: usb: send Zero length packets if necessary

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: rtw88: usb: Set qsel correctly

Carlos Llamas <cmllamas@google.com>
    scripts/tags.sh: fix incompatibility with PCRE2

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Properly reuse completion structure

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Move DCN314 DOMAIN power control to DMCUB

Thomas Weißschuh <linux@weissschuh.net>
    vc_screen: don't clobber return value in vcs_read

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: arm64/sm4-gcm - Fix possible crash in GCM cryption

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ALSA: hda: cs35l41: Correct error condition handling


-------------

Diffstat:

 Makefile                                           |  4 +-
 .../dts/socionext/uniphier-pxs3-ref-gadget0.dts    |  2 +-
 .../dts/socionext/uniphier-pxs3-ref-gadget1.dts    |  2 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c                | 51 +++++++++++-----------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  3 ++
 .../gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c   | 24 ++++++++++
 .../gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h   |  2 +
 .../gpu/drm/amd/display/dc/dcn314/dcn314_init.c    |  2 +-
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h    | 25 +++++++++++
 drivers/net/wireless/realtek/rtw88/usb.c           | 18 ++------
 drivers/tty/vt/vc_screen.c                         |  7 +--
 drivers/usb/core/hub.c                             |  5 +--
 drivers/usb/core/sysfs.c                           |  5 ---
 drivers/usb/dwc3/dwc3-pci.c                        |  4 ++
 drivers/usb/gadget/function/u_serial.c             | 23 ++++++++--
 drivers/usb/serial/option.c                        |  4 ++
 drivers/usb/typec/pd.c                             |  1 -
 net/core/filter.c                                  |  4 +-
 scripts/tags.sh                                    |  2 +-
 sound/pci/hda/hda_cs_dsp_ctl.c                     |  4 +-
 20 files changed, 125 insertions(+), 67 deletions(-)



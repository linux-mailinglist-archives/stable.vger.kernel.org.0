Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233C4651338
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiLST2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiLST2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:28:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C02615A2A;
        Mon, 19 Dec 2022 11:28:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD77860EF0;
        Mon, 19 Dec 2022 19:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62464C433EF;
        Mon, 19 Dec 2022 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671478093;
        bh=teECKoefw79gZR0qE8U2xEPKfSe0qunsHfE2NfEJ56E=;
        h=From:To:Cc:Subject:Date:From;
        b=QaL/+CC6AJ+Vs2fQmHANdDjdYyU0HlpvBHv4ykCR2c1enHvK+RYIY/J5xg2feHJcC
         SLhZzy+JLzDui0hAP1IGC2xbC1SnFGJpIdBLalCnNGyjyD1FSqlx8Pn4uGb7WUE3rn
         /5eRwA0hchamgjUXdgkpqhU4k7qwc4FhdTpo/ZUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.10 00/18] 5.10.161-rc1 review
Date:   Mon, 19 Dec 2022 20:24:53 +0100
Message-Id: <20221219182940.701087296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.161-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.161-rc1
X-KernelTest-Deadline: 2022-12-21T18:29+00:00
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

This is the start of the stable review cycle for the 5.10.161 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.161-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.161-rc1

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix u8 overflow

José Expósito <jose.exposito89@gmail.com>
    HID: uclogic: Add HID_QUIRK_HIDINPUT_FORCE quirk

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch 10E

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Add support for Acer S1002 keyboard-dock

Ferry Toth <ftoth@exalondelft.nl>
    usb: ulpi: defer ulpi_register on ulpi_read_id timeout

Tony Nguyen <anthony.l.nguyen@intel.com>
    igb: Initialize mailbox message for VF reset

Reka Norman <rekanorman@chromium.org>
    xhci: Apply XHCI_RESET_TO_DEFAULT quirk to ADL-N

Johan Hovold <johan@kernel.org>
    USB: serial: f81534: fix division by zero on line-speed change

Johan Hovold <johan@kernel.org>
    USB: serial: f81232: fix division by zero on line-speed change

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G modem

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: gadget: uvc: Prevent buffer overflow in setup handler

Jan Kara <jack@suse.cz>
    udf: Fix extending file within last block

Jan Kara <jack@suse.cz>
    udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size

Jan Kara <jack@suse.cz>
    udf: Fix preallocation discarding at indirect extent boundary

Jan Kara <jack@suse.cz>
    udf: Discard preallocation before extending file with a hole


-------------

Diffstat:

 Makefile                                  |  4 +-
 drivers/hid/hid-ids.h                     |  2 +
 drivers/hid/hid-ite.c                     | 26 ++++++++++-
 drivers/hid/hid-uclogic-core.c            |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c |  2 +-
 drivers/net/loopback.c                    |  2 +-
 drivers/usb/common/ulpi.c                 |  2 +-
 drivers/usb/gadget/function/f_uvc.c       |  5 +-
 drivers/usb/host/xhci-pci.c               |  4 +-
 drivers/usb/serial/cp210x.c               |  2 +
 drivers/usb/serial/f81232.c               | 12 +++--
 drivers/usb/serial/f81534.c               | 12 +++--
 drivers/usb/serial/option.c               |  3 ++
 fs/udf/inode.c                            | 76 ++++++++++++++-----------------
 fs/udf/truncate.c                         | 48 ++++++-------------
 net/bluetooth/l2cap_core.c                |  3 +-
 16 files changed, 108 insertions(+), 96 deletions(-)



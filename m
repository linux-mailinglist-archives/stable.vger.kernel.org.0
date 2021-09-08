Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51E4034C2
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 09:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345900AbhIHHID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 03:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346155AbhIHHIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 03:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3190B60ED8;
        Wed,  8 Sep 2021 07:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631084812;
        bh=NawRDVrjn/hTt54hJrfZVj7BaAKhQU4YZWbjTs1hIWg=;
        h=From:To:Cc:Subject:Date:From;
        b=ncMV7VjzcM1K3JpTvPmgeuXtIyubcoc5cMpXQSiakb0ypsJHmJPnHaroLF+QInUsa
         OjeCbxsxVNR30jEsSJR3VLWJGwyqtoCDpGKucLqOdQh6wq6uUxUtznzSaX6lJFFVVK
         t2G60aQ4wIajGlv+fWN+MEoZHvMagOI/HxG7t4vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.2
Date:   Wed,  8 Sep 2021 09:06:40 +0200
Message-Id: <1631084800230205@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.2 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 +-
 arch/xtensa/Kconfig                      |    2 +-
 drivers/hid/usbhid/hid-core.c            |   16 ++++++++--------
 drivers/media/usb/stkwebcam/stk-webcam.c |    6 ++++--
 drivers/usb/serial/cp210x.c              |   21 +++++++++++++--------
 drivers/usb/serial/pl2303.c              |    1 +
 fs/ext4/inline.c                         |    6 ++++++
 fs/ext4/super.c                          |    8 ++++++++
 sound/core/pcm_lib.c                     |    2 +-
 sound/pci/hda/patch_realtek.c            |   11 +++++++++++
 sound/usb/card.h                         |    2 ++
 sound/usb/endpoint.c                     |    9 +++++++++
 sound/usb/pcm.c                          |   13 +++++++++++--
 13 files changed, 76 insertions(+), 23 deletions(-)

Alan Stern (1):
      HID: usbhid: Fix warning caused by 0-length input reports

Greg Kroah-Hartman (1):
      Linux 5.14.2

Jan Kara (1):
      ext4: fix e2fsprogs checksum failure for mounted filesystem

Johan Hovold (2):
      USB: serial: cp210x: fix control-characters error handling
      USB: serial: cp210x: fix flow-control error handling

Johnathon Clark (1):
      ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

Michal Kubecek (1):
      HID: usbhid: Fix flood of "control queue full" messages

Pavel Skripkin (1):
      media: stkwebcam: fix memory leak in stk_camera_probe

Randy Dunlap (1):
      xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Robert Marko (1):
      USB: serial: pl2303: fix GL type detection

Takashi Iwai (3):
      ALSA: usb-audio: Fix regression on Sony WALKMAN NW-A45 DAC
      ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17
      ALSA: usb-audio: Work around for XRUN with low latency playback

Theodore Ts'o (1):
      ext4: fix race writing to an inline_data file while its xattrs are changing

Zubin Mithra (1):
      ALSA: pcm: fix divide error in snd_pcm_lib_ioctl


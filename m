Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5569D401BE5
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbhIFNAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243197AbhIFM7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328A661051;
        Mon,  6 Sep 2021 12:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933112;
        bh=cq+cJeHVZ2mwA3hpwYXmOiuj6RnJtKxW8lknh2iF6/s=;
        h=From:To:Cc:Subject:Date:From;
        b=wVRMPmaNdKDXeGqjoS3CY6Hu7IfsZQ0GSF3ZSktLyT+3eKQpxNEeuRXxFopjLOYoD
         5rSGmPzrrkIqDKh9bZnmYGoZAtHk8EKNkuF5seliyir1mPKQXcPZmnwR2T3Doc+PJw
         DLlarJVRChxDB6vTNAnl+QbCXLKmWFsZsyA3aZRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.14 00/14] 5.14.2-rc1 review
Date:   Mon,  6 Sep 2021 14:55:46 +0200
Message-Id: <20210906125448.160263393@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.14.2-rc1
X-KernelTest-Deadline: 2021-09-08T12:54+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.14.2 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.14.2-rc1

Pavel Skripkin <paskripkin@gmail.com>
    media: stkwebcam: fix memory leak in stk_camera_probe

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Work around for XRUN with low latency playback

Zubin Mithra <zsm@chromium.org>
    ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix regression on Sony WALKMAN NW-A45 DAC

Johnathon Clark <john.clark@cantab.net>
    ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup

Alan Stern <stern@rowland.harvard.edu>
    HID: usbhid: Fix warning caused by 0-length input reports

Michal Kubecek <mkubecek@suse.cz>
    HID: usbhid: Fix flood of "control queue full" messages

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix flow-control error handling

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: fix control-characters error handling

Robert Marko <robert.marko@sartura.hr>
    USB: serial: pl2303: fix GL type detection

Randy Dunlap <rdunlap@infradead.org>
    xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Jan Kara <jack@suse.cz>
    ext4: fix e2fsprogs checksum failure for mounted filesystem

Theodore Ts'o <tytso@mit.edu>
    ext4: fix race writing to an inline_data file while its xattrs are changing


-------------

Diffstat:

 Makefile                                 |  4 ++--
 arch/xtensa/Kconfig                      |  2 +-
 drivers/hid/usbhid/hid-core.c            | 16 ++++++++--------
 drivers/media/usb/stkwebcam/stk-webcam.c |  6 ++++--
 drivers/usb/serial/cp210x.c              | 21 +++++++++++++--------
 drivers/usb/serial/pl2303.c              |  1 +
 fs/ext4/inline.c                         |  6 ++++++
 fs/ext4/super.c                          |  8 ++++++++
 sound/core/pcm_lib.c                     |  2 +-
 sound/pci/hda/patch_realtek.c            | 11 +++++++++++
 sound/usb/card.h                         |  2 ++
 sound/usb/endpoint.c                     |  9 +++++++++
 sound/usb/pcm.c                          | 13 +++++++++++--
 13 files changed, 77 insertions(+), 24 deletions(-)



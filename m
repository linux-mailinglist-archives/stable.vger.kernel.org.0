Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6CFECCB9
	for <lists+stable@lfdr.de>; Sat,  2 Nov 2019 02:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKBBRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 21:17:48 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:51708 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKBBRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 21:17:48 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2019 21:17:47 EDT
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id A60982A258; Fri,  1 Nov 2019 21:12:15 -0400 (EDT)
Message-Id: <cover.1572656814.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/2] SG_NONE fix and cleanup
Date:   Sat, 02 Nov 2019 12:06:54 +1100
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Jonathan Corbet" <corbet@lwn.net>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Viresh Kumar" <vireshk@kernel.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        usb-storage@lists.one-eyed-alien.net, linux-doc@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-usb@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These two patches address some issues stemming from scsi-mq conversion.


Finn Thain (2):
  atari_scsi, sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE
  scsi: Clean up SG_NONE

 Documentation/scsi/scsi_mid_low_api.txt |  3 ++-
 drivers/ata/pata_arasan_cf.c            |  1 -
 drivers/scsi/atari_scsi.c               |  6 +++---
 drivers/scsi/atp870u.c                  |  2 +-
 drivers/scsi/mac_scsi.c                 |  2 +-
 drivers/scsi/sun3_scsi.c                |  4 ++--
 drivers/usb/storage/uas.c               |  1 -
 include/scsi/scsi_host.h                | 13 -------------
 8 files changed, 9 insertions(+), 23 deletions(-)

-- 
2.23.0


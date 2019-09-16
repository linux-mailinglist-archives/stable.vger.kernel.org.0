Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD54B3864
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfIPKlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfIPKlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 06:41:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E69206A4;
        Mon, 16 Sep 2019 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568630510;
        bh=8Lad/z99ogBj1xN6N+8h5kl/jayrtAAGiokaOeSOEas=;
        h=Date:From:To:Cc:Subject:From;
        b=QKCM+GcBTYZR0fuw3RuIu+62WS+0f5kh6rVtuDNzyApFDhg+OMpsdjsllpRTBwz/w
         /qGghW0lVVuDSDiiP3kWm/lZ9KdxFreDP9p4bp91uTqiGPW7xOTDRkial5k05/EL5M
         gRwuTbaHW3okkcT0al/yOoDOj+U8pKxYPO/wsZGU=
Date:   Mon, 16 Sep 2019 12:41:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.193
Message-ID: <20190916104148.GA1386623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.193 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 +-
 arch/x86/boot/compressed/misc.c |    1 +
 arch/x86/boot/compressed/misc.h |    1 -
 drivers/clk/clk-s2mps11.c       |    2 +-
 drivers/vhost/test.c            |   13 +++++++++----
 drivers/vhost/vhost.c           |    4 ++--
 include/net/xfrm.h              |   17 +++++++++++++++++
 net/key/af_key.c                |    4 +++-
 net/packet/af_packet.c          |    2 +-
 net/xfrm/xfrm_state.c           |    2 +-
 net/xfrm/xfrm_user.c            |   14 +-------------
 scripts/decode_stacktrace.sh    |    2 +-
 sound/pci/hda/hda_auto_parser.c |    4 ++--
 sound/pci/hda/hda_generic.c     |    3 ++-
 sound/pci/hda/hda_generic.h     |    1 +
 sound/pci/hda/patch_realtek.c   |    2 ++
 16 files changed, 45 insertions(+), 29 deletions(-)

Cong Wang (1):
      xfrm: clean up xfrm protocol checks

Dave Jones (1):
      af_packet: tone down the Tx-ring unsupported spew.

Greg Kroah-Hartman (1):
      Linux 4.4.193

Nathan Chancellor (1):
      clk: s2mps11: Add used attribute to s2mps11_dt_match

Nicolas Boichat (1):
      scripts/decode_stacktrace: match basepath using shell prefix operator, not regex

Takashi Iwai (2):
      ALSA: hda - Fix potential endless loop at applying quirks
      ALSA: hda/realtek - Fix overridden device-specific initialization

Tiwei Bie (1):
      vhost/test: fix build for vhost test

Zhenzhong Duan (1):
      x86, boot: Remove multiple copy of static function sanitize_boot_params()

yongduan (1):
      vhost: make sure log_num < in_num


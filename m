Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31F357870
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfF0AxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfF0Act (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:49 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3024421726;
        Thu, 27 Jun 2019 00:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595568;
        bh=Li+vIJnqrc/kPaTgtlczdnW8Xa77lC4PVo4VW35qzlc=;
        h=Date:From:To:Cc:Subject:From;
        b=LpVxVek8b/yKtYPAJ794bZnHpCIlLO5t8i10J5GMym1KkWokLxshNPbRhRRhIFXBg
         ZXaFDu53LvNzFz15gepYQ7IcXtgfhx829aAMBgfxLsaiPk6PYaqLZi1h7kA0bwkdmz
         mAt4UAlJWo4eHN8sA25L6AmNm3srtTvQredj0laQ=
Date:   Thu, 27 Jun 2019 08:32:24 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.4.184
Message-ID: <20190627003224.GA10733@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.184 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile              |    2 +-
 net/ipv4/tcp_output.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Eric Dumazet (1):
      tcp: refine memory limit test in tcp_fragment()

Greg Kroah-Hartman (1):
      Linux 4.4.184


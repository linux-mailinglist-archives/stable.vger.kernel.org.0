Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8947B1FF253
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 14:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgFRMu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 08:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgFRMu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 08:50:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB8C206F7;
        Thu, 18 Jun 2020 12:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592484625;
        bh=mH2WUMU2W0IAN261gTllCz6ShbMxBaQh+j3VCU1IBsI=;
        h=From:To:Cc:Subject:Date:From;
        b=SmWxU/4cZFOHNHAL1wyhzBu2kWokA1rjEX5nXXgqVZPMHo3mnCH5VaLQs70RW3pjz
         vtU07azgHkCIY3iluKNqoxwe1cKwivrSiP3RlWVw1y5zbzi1o93UkzcuDcEeeY6g2d
         Bo5tpka96Ahc6s1iopI56l4/gHMIfATKj4qtUSP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.7.4
Date:   Thu, 18 Jun 2020 14:50:16 +0200
Message-Id: <1592484616163232@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.7.4 kernel.

All users of the 5.7 kernel series must upgrade.

The updated 5.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.7.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                |    2 +-
 lib/vdso/gettimeofday.c |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 5.7.4

Thomas Gleixner (1):
      lib/vdso: Provide sanity check for cycles (again)


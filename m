Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD9D2A8402
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 17:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKEQw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 11:52:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgKEQw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 11:52:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3600C2073A;
        Thu,  5 Nov 2020 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604595146;
        bh=Ho4EcV+KYGZBezwFlr9f99jA64QPsyspaOoqolRqHhw=;
        h=From:To:Cc:Subject:Date:From;
        b=RzUJ+70loh41jinqlhjgW9t3/0Ga5eWj9MSjOWMYEI+ES+1UonOoaA1lxLOh5xgyd
         MjfL4iY3BJrUOcDtTbECV61gO7IipollmriK8CkmElVGogo1G21PWCfLu3rOkL1yWt
         eB/TadbsazwzOoEYN6T6H++VpKIECdPYXVl6683k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.6
Date:   Thu,  5 Nov 2020 17:53:13 +0100
Message-Id: <16045951328381@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.6 kernel.

This is a build-fix release, if 5.9.5 built properly for you, wonderful,
no need to upgrade.  If 5.9.5 did not build for you, then move to 5.9.6
please.  Sorry for the inconvenience.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                        |    2 +-
 sound/soc/sof/intel/hda-codec.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

Greg Kroah-Hartman (1):
      Linux 5.9.6

Pierre-Louis Bossart (1):
      ASOC: SOF: Intel: hda-codec: move unused label to correct position


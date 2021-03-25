Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02779348CAA
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 10:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhCYJWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 05:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhCYJVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 05:21:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8917761963;
        Thu, 25 Mar 2021 09:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616664101;
        bh=Rz8fTf5SS7Afrji/D1ge/Pcn/DZHsx/mGSgWSL0eIeo=;
        h=From:To:Cc:Subject:Date:From;
        b=k7Z3S5aHmtMIf/ypSXatXlK9qjoGh4FUA+9at88wyMI5SuLJvhH7SqahG+88bhdr0
         QiI8gZr4ws/g7K+D3DLniz5L1eNMBfYMyKTaZVaPTEtvcCa2Z97v8/YPprcFdH3kWA
         Sga3tOSZimUawawrYnvDvK4xSrWvCxVrDIMeVpbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.11.10
Date:   Thu, 25 Mar 2021 10:21:37 +0100
Message-Id: <16166640322331@kroah.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.11.10 kernel.

This is a "quick revert" of some 5.11.9 commits that caused noisy warnings to
show up in the kernel log of some systems.  If you do not have this issue, or
are not bothered by these messages, no need to upgrade.

The updated 5.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.11.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                     |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c |    2 +-
 include/drm/ttm/ttm_bo_api.h |    8 ++------
 3 files changed, 4 insertions(+), 8 deletions(-)

Greg Kroah-Hartman (3):
      Revert "drm/ttm: make ttm_bo_unpin more defensive"
      Revert "drm/ttm: Warn on pinning without holding a reference"
      Linux 5.11.10


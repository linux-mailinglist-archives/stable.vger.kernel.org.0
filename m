Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FA7424E04
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 09:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbhJGHXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 03:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhJGHXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 03:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D3036101E;
        Thu,  7 Oct 2021 07:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633591302;
        bh=T5X3O3Ttl1FJ6tLUan6hu1rrVLjeHL9BuU/yUyumt8U=;
        h=From:To:Cc:Subject:Date:From;
        b=wKQfz1n+0/1ytwFszrtYQGxH/xSbuSeIleiy8qiPlrisoKo3H4HB+aCkQsEoUFTj5
         wuHDSQMohsc/PPHmZyiVvHuVWBhGcdXQz//e3ovDddv3S+7rVH9v3Yy/VSR5L5QcZy
         CdxknqJTm3dcSYN0HCnxyYpO9CXxTezyRPtLyvIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz, hegtvedt@cisco.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.287
Date:   Thu,  7 Oct 2021 09:21:38 +0200
Message-Id: <163359121918232@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.287 kernel.

You only need this release if you are building for ARM64 and had build failures
with 4.4.286.  Thanks to Hans-Christian Egtvedt for the bug report.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                    |    2 +-
 arch/arm64/kernel/process.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      Revert "arm64: Mark __stack_chk_guard as __ro_after_init"
      Linux 4.4.287


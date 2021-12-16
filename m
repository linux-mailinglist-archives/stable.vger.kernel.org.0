Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57DB4778D0
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 17:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhLPQZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 11:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239675AbhLPQZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 11:25:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2B7C061747;
        Thu, 16 Dec 2021 08:24:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5039B824BA;
        Thu, 16 Dec 2021 16:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3289C36AE4;
        Thu, 16 Dec 2021 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639671897;
        bh=CnCI8qhi2jz7oSWFVspcGp2BSzGnWyugY9kc3qnG69U=;
        h=From:To:Cc:Subject:Date:From;
        b=g1X6Lwf+2BwJUQckbRNy5ft5bJ3mW6EQCWWP6Ur8XFgRygrCpg/e3wJPFe0AfRy8e
         3BifabkPiwSRBk5oNXZAzZBfKCXdyWxTAkLnJR1ynYt5k66HwTOjMbqAK5LWQhcxgt
         nL9mbxggWYLzs1DEQKS/tgGL5fjcEkdWqawhVMTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.86
Date:   Thu, 16 Dec 2021 17:24:53 +0100
Message-Id: <1639671855244236@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.86 kernel.

Only change here is a permission setting of a netfilter selftest file.
No need to upgrade if this problem is not bothering you.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Greg Kroah-Hartman (2):
      netfilter: selftest: conntrack_vrf.sh: fix file permission
      Linux 5.10.86


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A34774C8
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 15:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbhLPOjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 09:39:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41148 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238072AbhLPOjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 09:39:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A861161E26;
        Thu, 16 Dec 2021 14:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AB7C36AE4;
        Thu, 16 Dec 2021 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639665557;
        bh=NPVTqFZjyIBMuad6YQ4RfIVBa/Pydu6QfflmYdC85hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0brOj5e8bLSsUqmQ1wHQVTHvXDM4kAHxQ8cnv98/ijIETljGiKqFRbBgC9T3BtNnK
         cQ7p1OFI8+AlpsXaCm5hDGUpG7D+iFsFuCrXaFbriSUyJjr1TP3l6LSJ7nQwerooZD
         cquFO30F+J29H1/w3xlvAqxHTXf7VyDdniZy/Ydk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.9
Date:   Thu, 16 Dec 2021 15:39:06 +0100
Message-Id: <16396655015717@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1639665501240245@kroah.com>
References: <1639665501240245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 72344b214bba..e6d2ea920a1d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 8
+SUBLEVEL = 9
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
old mode 100644
new mode 100755

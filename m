Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71B24778DF
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhLPQZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 11:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhLPQZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 11:25:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB73C061574;
        Thu, 16 Dec 2021 08:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECC6461E8D;
        Thu, 16 Dec 2021 16:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D379CC36AE4;
        Thu, 16 Dec 2021 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639671937;
        bh=v6hMwNDz8Fap9Z0no0tqQJRkXDcVTyj9O76ZJlxYKsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHvJ6DfXZmLHwWyIButIjDj65kLZchdDzScSTd3aaCU30raQC6XmiM2lY6153ZA9V
         Cz0J4AKxeLsbZ482CituMZHx1EyDlacbSg2qCSFvFxYRQX+0Dkw7RdjW5gbuujcIGm
         +HatLCCsCTBLVUWdQnoa5Zmbl3bo0p4dIis9uDSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.166
Date:   Thu, 16 Dec 2021 17:25:21 +0100
Message-Id: <163967190349155@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <163967190312423@kroah.com>
References: <163967190312423@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4a7a89de832b..b1e5f7c6206e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 165
+SUBLEVEL = 166
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
old mode 100644
new mode 100755

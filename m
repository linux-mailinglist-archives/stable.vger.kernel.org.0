Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA024778D6
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbhLPQZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 11:25:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236632AbhLPQZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 11:25:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C0361EB1;
        Thu, 16 Dec 2021 16:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1709C36AE0;
        Thu, 16 Dec 2021 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639671905;
        bh=frmpYz0p+lJqxooSUqfBensbtk/ul/ZScNmanVEYkdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3kEiZCHUT4OLpU/KKUMewhC5B11iaFSjkZH0WlmyoF6vYB7dxyfLoxEy5fcxtKsM
         10+Ha97TZDvAVRpAcVNHOQ/QdE8YEbWrKM7RKVM3ygXAGy9DJfBoqae2bAwwaPIzNY
         OQMOhDngtbPCZH91HnBTYy9pvqPU5R7Zx1YDe/SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.86
Date:   Thu, 16 Dec 2021 17:24:54 +0100
Message-Id: <163967185592248@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1639671855244236@kroah.com>
References: <1639671855244236@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8de80228df3f..5c1a33f1ecad 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 85
+SUBLEVEL = 86
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/tools/testing/selftests/netfilter/conntrack_vrf.sh b/tools/testing/selftests/netfilter/conntrack_vrf.sh
old mode 100644
new mode 100755

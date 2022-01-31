Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FFA4A44B5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245489AbiAaLcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379034AbiAaL3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E68C0613F7;
        Mon, 31 Jan 2022 03:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3276124B;
        Mon, 31 Jan 2022 11:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F586C340EF;
        Mon, 31 Jan 2022 11:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627933;
        bh=AgPOBOfvS5rh6esfyxJqYzdLWLiDlum6qSzhShKCNRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZF0Lycock3AZPaoAUznL3TVpxL50o5/k+pWDXdxhlVANw/2Yx0hCw0/GfWfNaRHD
         WDo3VZ87WaOIZWQzSFfIRslSsQyrLNNhznieAACHYw+m2PCsDY6lfrf5xEB0wpjA9f
         8Kl+Xbzffc7a/eklqAsYDl7SOos+1UR2TJ2hszjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        "Maciej W. Rozycki" <macro@embecosm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.16 072/200] kbuild: remove include/linux/cyclades.h from header file check
Date:   Mon, 31 Jan 2022 11:55:35 +0100
Message-Id: <20220131105236.010981880@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d1ad2721b1eb05d54e81393a7ebc332d4a35c68f upstream.

The file now rightfully throws up a big warning that it should never be
included, so remove it from the header_check test.

Fixes: f23653fe6447 ("tty: Partially revert the removal of the Cyclades public API")
Cc: stable <stable@vger.kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: "Maciej W. Rozycki" <macro@embecosm.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/20220127073304.42399-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 usr/include/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -28,6 +28,7 @@ no-header-test += linux/am437x-vpfe.h
 no-header-test += linux/android/binder.h
 no-header-test += linux/android/binderfs.h
 no-header-test += linux/coda.h
+no-header-test += linux/cyclades.h
 no-header-test += linux/errqueue.h
 no-header-test += linux/fsmap.h
 no-header-test += linux/hdlc/ioctl.h



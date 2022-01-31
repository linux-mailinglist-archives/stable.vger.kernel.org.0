Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A1E4A4255
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358897AbiAaLLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57100 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376765AbiAaLJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8088AB82A6F;
        Mon, 31 Jan 2022 11:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1A8C340E8;
        Mon, 31 Jan 2022 11:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627341;
        bh=AgPOBOfvS5rh6esfyxJqYzdLWLiDlum6qSzhShKCNRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKIFdXZad/SISWHan7A6i+A8e+bANhSLORHkWd7bu2ayvxOH1GYWY3EvlYcE+K1zB
         Lo4RAnqM84Mx5YgYRgtsmsX2cLb8iv3F4l+ONn2W0YXKFc0k/BOsexcNll1Ffzwt7X
         e57mUjiv597iHcWehu+2oSzCllfYSq0qMrei5EbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        "Maciej W. Rozycki" <macro@embecosm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.15 052/171] kbuild: remove include/linux/cyclades.h from header file check
Date:   Mon, 31 Jan 2022 11:55:17 +0100
Message-Id: <20220131105231.792350190@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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



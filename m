Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF7E99BD8
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731752AbfHVR3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404751AbfHVR0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:49 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A96B2064A;
        Thu, 22 Aug 2019 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494809;
        bh=5u86D2mnbw9aSHt54t/7AtwNfywdza/lGyREW78gyl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+7oz9QuupO7tkC6XOwZ1kSavWUyGLz52jh56rFCFsI+UrsFX2FFlWYJb3P/MrwGi
         HaZ++k9fF7skZPFE3TIhr8UAYABYkSpZ13gBiz8tFKbtN194fsPey502LtIGw5z5Sl
         V2F9nFX5E0tAq/swsLj/ROXu8X1Ef6sMzX/tOxqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "Wan Yusof, Wan Fahim AsqalaniX" 
        <wan.fahim.asqalanix.wan.yusof@intel.com>
Subject: [PATCH 4.19 67/85] drm/i915/cfl: Add a new CFL PCI ID.
Date:   Thu, 22 Aug 2019 10:19:40 -0700
Message-Id: <20190822171734.100250801@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

commit d0e062ebb3a44b56a7e672da568334c76f763552 upstream.

One more CFL ID added to spec.

Cc: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20180803232721.20038-1-rodrigo.vivi@intel.com
Signed-off-by: Wan Yusof, Wan Fahim AsqalaniX <wan.fahim.asqalanix.wan.yusof@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/i915_pciids.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/drm/i915_pciids.h
+++ b/include/drm/i915_pciids.h
@@ -386,6 +386,7 @@
 	INTEL_VGA_DEVICE(0x3E91, info), /* SRV GT2 */ \
 	INTEL_VGA_DEVICE(0x3E92, info), /* SRV GT2 */ \
 	INTEL_VGA_DEVICE(0x3E96, info), /* SRV GT2 */ \
+	INTEL_VGA_DEVICE(0x3E98, info), /* SRV GT2 */ \
 	INTEL_VGA_DEVICE(0x3E9A, info)  /* SRV GT2 */
 
 /* CFL H */



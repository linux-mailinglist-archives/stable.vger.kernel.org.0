Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845074BE866
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348128AbiBUJOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348560AbiBUJLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:11:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105D827151;
        Mon, 21 Feb 2022 01:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A11D561249;
        Mon, 21 Feb 2022 09:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B261C340E9;
        Mon, 21 Feb 2022 09:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434217;
        bh=d/s8ayMpWGML2APfzZ5mEIE/nV/yXP2sKriiO11BR1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qK6XAOUyYnyJA6UUMhYJ6UJLzTIhrQD0/p9V+wBe31LrA3Oi11vFqe4w2NEX+zJNF
         4J6Bv0CdvQGClnCRPjKclOMW0vAe8iUe+xUpiji1N27KuCrm/DkKfSn8Ys+WtbTc4s
         AngPB76+fgUqlPKSpANozXlzR5A5pHk/fto8UTAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Siva Mullati <siva.mullati@intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [PATCH 5.10 051/121] drm/i915/gvt: Make DRM_I915_GVT depend on X86
Date:   Mon, 21 Feb 2022 09:49:03 +0100
Message-Id: <20220221084922.940254659@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siva Mullati <siva.mullati@intel.com>

commit d72d69abfdb6e0375981cfdda8eb45143f12c77d upstream.

GVT is not supported on non-x86 platforms, So add
dependency of X86 on config parameter DRM_I915_GVT.

Fixes: 0ad35fed618c ("drm/i915: gvt: Introduce the basic architecture of GVT-g")
Signed-off-by: Siva Mullati <siva.mullati@intel.com>
Signed-off-by: Zhi Wang <zhi.a.wang@intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220107095235.243448-1-siva.mullati@intel.com
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -100,6 +100,7 @@ config DRM_I915_USERPTR
 config DRM_I915_GVT
 	bool "Enable Intel GVT-g graphics virtualization host support"
 	depends on DRM_I915
+	depends on X86
 	depends on 64BIT
 	default n
 	help



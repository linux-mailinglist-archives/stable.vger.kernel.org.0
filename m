Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D30F2F53AF
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 20:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbhAMTwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 14:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbhAMTwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 14:52:40 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CCDC061575
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:52:00 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 3so2717377wmg.4
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bl2NbAFlNO0rmR55NGBteniGBiVR1P1/+g/0H6KCptw=;
        b=A5QdgsUx969tWCnXYFYtaRTMrg4CBi7WGAtENcxh3bkBMppGjXbJ219oZtU5xDuKLM
         oVkqqCAgFyBffIF2gKDv7yKHYEd1bIc9OUi4rw6G88bfP0+f6dx7VVOzgG/faG0e/ttl
         EPk/5ipqV36cnUttSKN+cXd7vTGLfZL/6NIBlGypDVN2979Pn+TOOzoGDHiRmAEDpZel
         +G3FWHhYrG5PA3tM0llvJIxRtd0Sm3lD1obtCYmR0mzlkunBrwQGRrFreowm1BpQhu0y
         utCqxEGP8thKU4sVoHi5B9V/aN6PI1QRlGhYTrxIBOikCB/bjXTS5jXQ1xTTuw2W8KSX
         tpww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bl2NbAFlNO0rmR55NGBteniGBiVR1P1/+g/0H6KCptw=;
        b=r3qqgTnsJnt1wS7D81ZawFh1TsBDbNytRW06nUBUJU2grMi40RE9koXxEorUL90BWU
         /T7ZIkRCJyezl98oGQaZCd6P2j5yHAbOCqhQrB5pAueLOcIWnp84c0LPrShG7gy4OA18
         50hFP5CCiWTEGk/dspixMGGyUeDxmQaw6AS5FG2HBZuAYH1y7fj1T6ThpL9AQFh+cX1S
         KVnOSEwQrlnJbmv+8YIBlZscuwtbHxWBcfZpfUdVFsWOyTnE8CMhCVBFfby/fRp5jN7X
         BQ3rIxsUirlzgn4z8UAOpIReMqSMwF1etsLqq+803TkJss94n0qw6yw2odn0Ubluu415
         m6+A==
X-Gm-Message-State: AOAM533oYQp4MyTmCUdsJ393ctzSbiYJ6gi1iy2go4j+2lU0V/9/K1f5
        dGUBz/ZE98SUYELcc508SipJiHi7WzSZBLNQ
X-Google-Smtp-Source: ABdhPJyc+4PdYwVy3fEGjj2OttYKhtilagwfZk6132hr6ZeXY9e+B1bPMCiOKIZHRkZcIHmj+n1cIQ==
X-Received: by 2002:a1c:dd83:: with SMTP id u125mr727041wmg.93.1610567519036;
        Wed, 13 Jan 2021 11:51:59 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id k1sm4708953wrn.46.2021.01.13.11.51.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Jan 2021 11:51:58 -0800 (PST)
Date:   Wed, 13 Jan 2021 19:51:56 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: Fix mismatch between misplaced
 vma check and vma" failed to apply to 4.19-stable tree
Message-ID: <20210113195156.zqfrut4vnsodd7wk@debian>
References: <1609152444157128@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pd46l2v2j6fqcdf5"
Content-Disposition: inline
In-Reply-To: <1609152444157128@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pd46l2v2j6fqcdf5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 11:47:24AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.14-stable.

--
Regards
Sudip

--pd46l2v2j6fqcdf5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-i915-Fix-mismatch-between-misplaced-vma-check-an.patch"

From 40f27238b7f9df7141f13443289995cc064a2328 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 16 Dec 2020 09:29:51 +0000
Subject: [PATCH] drm/i915: Fix mismatch between misplaced vma check and vma
 insert

commit 0e53656ad8abc99e0a80c3de611e593ebbf55829 upstream

When inserting a VMA, we restrict the placement to the low 4G unless the
caller opts into using the full range. This was done to allow usersapce
the opportunity to transition slowly from a 32b address space, and to
avoid breaking inherent 32b assumptions of some commands.

However, for insert we limited ourselves to 4G-4K, but on verification
we allowed the full 4G. This causes some attempts to bind a new buffer
to sporadically fail with -ENOSPC, but at other times be bound
successfully.

commit 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1
page") suggests that there is a genuine problem with stateless addressing
that cannot utilize the last page in 4G and so we purposefully excluded
it. This means that the quick pin pass may cause us to utilize a buggy
placement.

Reported-by: CQ Tang <cq.tang@intel.com>
Testcase: igt/gem_exec_params/larger-than-life-batch
Fixes: 48ea1e32c39d ("drm/i915/gen9: Set PIN_ZONE_4G end to 4GB - 1 page")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: CQ Tang <cq.tang@intel.com>
Reviewed-by: CQ Tang <cq.tang@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v4.5+
Link: https://patchwork.freedesktop.org/patch/msgid/20201216092951.7124-1-chris@chris-wilson.co.uk
(cherry picked from commit 5f22cc0b134ab702d7f64b714e26018f7288ffee)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[sudip: use file from old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 52894816167c..8b5b147cdfd1 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -380,7 +380,7 @@ eb_vma_misplaced(const struct drm_i915_gem_exec_object2 *entry,
 		return true;
 
 	if (!(flags & EXEC_OBJECT_SUPPORTS_48B_ADDRESS) &&
-	    (vma->node.start + vma->node.size - 1) >> 32)
+	    (vma->node.start + vma->node.size + 4095) >> 32)
 		return true;
 
 	if (flags & __EXEC_OBJECT_NEEDS_MAP &&
-- 
2.11.0


--pd46l2v2j6fqcdf5--

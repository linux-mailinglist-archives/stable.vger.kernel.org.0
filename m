Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E722F53B3
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 20:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbhAMTxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 14:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbhAMTxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 14:53:37 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A5C061786
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:52:56 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d26so3390709wrb.12
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xiqVidSRxlN5w7A3bp6I6DX9qfXnySu4Du9x0wKm4sw=;
        b=mkh4prUt9sIxYjakyD6NgGu7iNBHbM/6KoJWYlTPONknUdiSaXqW2HPObDaZT6uM3K
         o9NJpGo+OUDJqq3BJfmozukYg9vJuSfxmwDr6a8r+YdsoUg9rbVj/rvER1S58Kkn33U3
         IxblfR4x3nTUrjcD58Pw1G6JxcoGLXVNrEkdxUUEIwL7/Ik0tIh1m9cYz0BdD75LYdgA
         rOHCaQg3porns+yldWp+i51H+3gH5bM5PtOmN/Wc77tX4JytuU6VcBJJnR1ky2z/pLP1
         wi4oX04Q6O5a9NriRJ1hWFtLAGQJiXHHL6hrNbr0e97xt5UDwZVFdPnZEG0H2zJgSTJ7
         iuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xiqVidSRxlN5w7A3bp6I6DX9qfXnySu4Du9x0wKm4sw=;
        b=JqWMktpbYwRYn6BwSi0AhdL7Cg5prQojPieE4DgyKE3NaoLCbIZdHWSE4h7gKtaA/b
         I4L5DKTKW7YEH1PEpeZEQFPIJdDSy2duWCkAoshu0DTHduxYXWy0Wt92D3umuOVAYn9q
         502Uz+m+kVI6lXp5v4zICEHjyNGn7mmHeKGBJIZ3OzCNLxRKBrztoU0UsVItDZ8XGqFc
         1eTQAObsAnxlfPKgBf9mCBTDWiTyIKCjkMJUZMUP+LZ2NTaGFV1BY8MHDOdIryRRpOmn
         MyYIwOr2JJwMfK7M0D8bW5amM4s5WOs72QHt/JlY05hX6w1dhvAMs2E+vChRDl9Q3Tc2
         ZVUA==
X-Gm-Message-State: AOAM531yOL3TioFHAKKpvpXU3T5FsJClwbCmQ+FfevJRf0rkkkc0/fhU
        /ebMMPvvK8ej4pBaiW/alhM=
X-Google-Smtp-Source: ABdhPJzvSJrMIpS0PtZeK/tH4U2z3OI2L2bTdVioeAFheVo7P/ecp3BaZjS03dvu0goZnuudUR7opw==
X-Received: by 2002:a5d:4241:: with SMTP id s1mr4220947wrr.269.1610567575707;
        Wed, 13 Jan 2021 11:52:55 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id x18sm5791587wrg.55.2021.01.13.11.52.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Jan 2021 11:52:55 -0800 (PST)
Date:   Wed, 13 Jan 2021 19:52:53 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        matthew.auld@intel.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: Fix mismatch between misplaced
 vma check and vma" failed to apply to 4.9-stable tree
Message-ID: <20210113195253.htmzatals4cammak@debian>
References: <160915244223115@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="s4sacx2d5c4iykdr"
Content-Disposition: inline
In-Reply-To: <160915244223115@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--s4sacx2d5c4iykdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 11:47:22AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--s4sacx2d5c4iykdr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-i915-Fix-mismatch-between-misplaced-vma-check-an.patch"

From 75c1419e30b338dce49be12e4986ab6130e1b63b Mon Sep 17 00:00:00 2001
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
[sudip: use file from old path and adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 4548d89abcdc..ff8168c60b35 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -882,7 +882,7 @@ eb_vma_misplaced(struct i915_vma *vma)
 		return !only_mappable_for_reloc(entry->flags);
 
 	if ((entry->flags & EXEC_OBJECT_SUPPORTS_48B_ADDRESS) == 0 &&
-	    (vma->node.start + vma->node.size - 1) >> 32)
+	    (vma->node.start + vma->node.size + 4095) >> 32)
 		return true;
 
 	return false;
-- 
2.11.0


--s4sacx2d5c4iykdr--

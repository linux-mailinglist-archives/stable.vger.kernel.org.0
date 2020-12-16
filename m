Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A422DC188
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgLPNrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgLPNrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 08:47:40 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF13C0617B0
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 05:46:59 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id x22so2396046wmc.5
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 05:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8YfaZ+knJGYsLUpqpYlRAmQay6g26whldSnJ8y7ZGgI=;
        b=EGG4KZOLJHjitAMnNpq/lQpPAx7vl8wO0FunHPLHtyGLP8CsyPtT3OTv9LkP8gF2Kd
         ON/PxXdoHsXeWJvY5D2uDG5ShMxV8+vYwGDbPwCVTV7liCGTcumRoS82d6wVKYRn2qcu
         j39afd6OjHvwebsc0w7SLm7nA3GuMNbXzSL1ngTpKgtoHUgiv4cbF8qTHBjeeVCKJhkX
         Pp7lEOIqRC4hjOFpskGhoWeLv0DHAmlRhYSetaPcwro58caNa8eQYuw2venzkNdU8/D3
         DNLaT2TWmBt1FgcdCpzoSmrc9thIk6I301V7LV9mCoIl6Gtv8d1gKtkj1FJ3Jg7lPYuk
         YQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=8YfaZ+knJGYsLUpqpYlRAmQay6g26whldSnJ8y7ZGgI=;
        b=CBfm66cYw+3I60h0RpVjw95iENILgWLsivKBao+YrojTJ5xvrRtzQcNamBeQIvY8ju
         TziSsxr7aqWc6dJ2jgqtDc9d2JKwvb8cDrmDuA+gKnIgRNlWElunWl5fbZ6f7VEC3yUu
         2v/NquQGBPgaqXuTdZDzgmlwnBTsRXuV5nG9IHyOGrAC/rUlZYezICg98WlZdC+Enc2y
         RbZ9nGtewWfnxfXPX2qfSXmX7IHslGitGVmn2TudsFWU+7Tn6eYjErqTAXA1VFHi8ZcD
         73K62ewx9BTJqXUXsaQKD1yMvxn5M/CMvyroWPIsVYR89oCEsQd+ytnz82qjNfppDLV0
         cgmw==
X-Gm-Message-State: AOAM531rbMTtCysXLCMRAlDZZV5T85IomATWQQMLQIyvI8m5Z8qLOC4r
        t1FtKrA3VCgJvE34SUHaSkM=
X-Google-Smtp-Source: ABdhPJzUaJCzNV6rd2vqGR48+Y+3fPPaawTUSPZlIR7NF7Hx2rEYewk/l0+LEaJjWsoQflAyPEKXxA==
X-Received: by 2002:a7b:c259:: with SMTP id b25mr3511395wmj.40.1608126418411;
        Wed, 16 Dec 2020 05:46:58 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id i18sm3278126wrp.74.2020.12.16.05.46.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 05:46:57 -0800 (PST)
Date:   Wed, 16 Dec 2020 13:46:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     xiongx18@fudan.edu.cn, lyude@redhat.com, stable@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn
Subject: Re: FAILED: patch "[PATCH] drm: fix drm_dp_mst_port refcount leaks
 in" failed to apply to 4.19-stable tree
Message-ID: <20201216134655.6kkrltmgoy7mq24f@debian>
References: <1597912668169213@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5fsteojznx2m2ite"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1597912668169213@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5fsteojznx2m2ite
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, Aug 20, 2020 at 10:37:48AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply to 4.14-stable.

--
Regards
Sudip

--5fsteojznx2m2ite
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-drm-fix-drm_dp_mst_port-refcount-leaks-in-drm_dp_mst.patch"
Content-Transfer-Encoding: 8bit

From 75f965805eca0292c56d84a67436e9b6787234e6 Mon Sep 17 00:00:00 2001
From: Xin Xiong <xiongx18@fudan.edu.cn>
Date: Sun, 19 Jul 2020 23:45:45 +0800
Subject: [PATCH] drm: fix drm_dp_mst_port refcount leaks in
 drm_dp_mst_allocate_vcpi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit a34a0a632dd991a371fec56431d73279f9c54029 upstream

drm_dp_mst_allocate_vcpi() invokes
drm_dp_mst_topology_get_port_validated(), which increases the refcount
of the "port".

These reference counting issues take place in two exception handling
paths separately. Either when “slots” is less than 0 or when
drm_dp_init_vcpi() returns a negative value, the function forgets to
reduce the refcnt increased drm_dp_mst_topology_get_port_validated(),
which results in a refcount leak.

Fix these issues by pulling up the error handling when "slots" is less
than 0, and calling drm_dp_mst_topology_put_port() before termination
when drm_dp_init_vcpi() returns a negative value.

Fixes: 1e797f556c61 ("drm/dp: Split drm_dp_mst_allocate_vcpi")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200719154545.GA41231@xin-virtual-machine
[sudip: use old functions before rename]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index a0aafd9a37e6..c50fe915f5c8 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2706,11 +2706,11 @@ bool drm_dp_mst_allocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
 {
 	int ret;
 
-	port = drm_dp_get_validated_port_ref(mgr, port);
-	if (!port)
+	if (slots < 0)
 		return false;
 
-	if (slots < 0)
+	port = drm_dp_get_validated_port_ref(mgr, port);
+	if (!port)
 		return false;
 
 	if (port->vcpi.vcpi > 0) {
@@ -2725,6 +2725,7 @@ bool drm_dp_mst_allocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
 	if (ret) {
 		DRM_DEBUG_KMS("failed to init vcpi slots=%d max=63 ret=%d\n",
 				DIV_ROUND_UP(pbn, mgr->pbn_div), ret);
+		drm_dp_put_port(port);
 		goto out;
 	}
 	DRM_DEBUG_KMS("initing vcpi for pbn=%d slots=%d\n",
-- 
2.11.0


--5fsteojznx2m2ite--

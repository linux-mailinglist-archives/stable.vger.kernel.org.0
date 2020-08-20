Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90324B134
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHTIhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:37:37 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54301 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726723AbgHTIhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:37:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 51BB41941577;
        Thu, 20 Aug 2020 04:37:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DOAJf8
        75IgBEuMjyy3R9i5Le+56hpwREtPyzE+7zNlQ=; b=Pi/m7dwo9XfjKlGVFvcwwH
        Igov2BGIpteEczlISyRjQEsnlLIJuq//YShIMF1G8eFVgxFCxEUpsxmIZ+sowJKr
        fKzA3LfXCzR15QAeAiXqyydAhy73NSxD8r6TyqfB3GZAdtgs6pi3Lab0gxkavzBV
        tWpUCTKep/bWEvClcrUhxRQiqfonfmmnRdlLJWHPVhAADEkLUVO1YfaVJWmtquoK
        cf6GJ3Kqpi5cn00GX09dfpi48vjX8Lx7HT4ZBNIR/upKnnzkoCR7FwhJQrGZnva+
        wcGSXN/BjGOs6HSATMgkD7eu588Hs/eBTuY/yoUecsPohTGpFQZb6bCuCMpLE2Kw
        ==
X-ME-Sender: <xms:TzY-X8pp5oQPNCOHt3CmwcLrz_z1s2RFgBao3A8OL-kKlf2KhjzsMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TzY-XyqjVJM5YMQNB5e1GQgO4w90TDSCPPY688NrzTvYldA05sC78Q>
    <xmx:TzY-XxONuZPVLb1MOi6kRlfV76Y1O8IYdBwCXqwzQatzIgDdxiDwjg>
    <xmx:TzY-Xz6PJ2diXH1DXC3t9c8Rrj495_v1gESzB6j9A0DiyMICA8PBNg>
    <xmx:TzY-X1QEXi_pn72KIl7bQJiie8NjzxZnHe079sRSh9Vbpe192hX5Vg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D08703280059;
        Thu, 20 Aug 2020 04:37:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: fix drm_dp_mst_port refcount leaks in" failed to apply to 4.19-stable tree
To:     xiongx18@fudan.edu.cn, lyude@redhat.com, stable@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:37:48 +0200
Message-ID: <1597912668169213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a34a0a632dd991a371fec56431d73279f9c54029 Mon Sep 17 00:00:00 2001
From: Xin Xiong <xiongx18@fudan.edu.cn>
Date: Sun, 19 Jul 2020 23:45:45 +0800
Subject: [PATCH] drm: fix drm_dp_mst_port refcount leaks in
 drm_dp_mst_allocate_vcpi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 09b32289497e..b23cb2fec3f3 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4308,11 +4308,11 @@ bool drm_dp_mst_allocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
 {
 	int ret;
 
-	port = drm_dp_mst_topology_get_port_validated(mgr, port);
-	if (!port)
+	if (slots < 0)
 		return false;
 
-	if (slots < 0)
+	port = drm_dp_mst_topology_get_port_validated(mgr, port);
+	if (!port)
 		return false;
 
 	if (port->vcpi.vcpi > 0) {
@@ -4328,6 +4328,7 @@ bool drm_dp_mst_allocate_vcpi(struct drm_dp_mst_topology_mgr *mgr,
 	if (ret) {
 		DRM_DEBUG_KMS("failed to init vcpi slots=%d max=63 ret=%d\n",
 			      DIV_ROUND_UP(pbn, mgr->pbn_div), ret);
+		drm_dp_mst_topology_put_port(port);
 		goto out;
 	}
 	DRM_DEBUG_KMS("initing vcpi for pbn=%d slots=%d\n",


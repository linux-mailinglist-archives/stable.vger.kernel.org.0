Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF58B24B133
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgHTIhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:37:31 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:59823 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgHTIh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:37:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C195F1941580;
        Thu, 20 Aug 2020 04:37:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xab6bV
        Lg7/ilM1eeQc++vVpNPcpPFApGwM1YAIEvUFA=; b=mp0A/tKfh0olI+ZGLt+Tgr
        GEDJ9GoecaXxMircsfYCEUXrawXPf1hpoF7YKl+apio/B4x3i4cGEIIfb2OSaUqq
        PH3RaRXenEuX7Ud1bBTVhV267poa3wT0n8fc5LbwW+9JiRD3/WqR7iYQ43eVMEFJ
        AQujCoG26PsujazyrutN0Bnvr2InC7Yk4tDoZ9CkTDCENNx44kcPBz91gkYPu8zf
        DnU8PuxiX6vQ1Z9cawrqDI2Esakitj86EbP7O0nX3CivtZa7hMJYHadmpX3MmdT9
        AsPpbO1X0jkTRx4ITLsC/ezkcGrA2Qvm8ACphvBvgGFc6jI+zl5lXM1EjrXWs2xg
        ==
X-ME-Sender: <xms:RjY-X1EmMPZKue4OuBsq9YiArY596V_dqZjBZZoKI15uUyU3DRUSaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RjY-X6Uyj-0thmqsVhWFs9aa9v2pqAD8etecaF8ioL8Tr3GOoYU74A>
    <xmx:RjY-X3Im9YretQ6WpWQzRqZ3u0zkH45UfZUWUOh3jxV6DYDGOcix-A>
    <xmx:RjY-X7E25_zs5rxPv1L2VaBnbDbyq-7SjDhiX8XB_pnZBiF_H_GMfQ>
    <xmx:RjY-XycHsiaQHSaKIG7D44-erfmmXq4FOp8NGcKsdHiybCn6j0XDKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FA123060067;
        Thu, 20 Aug 2020 04:37:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: fix drm_dp_mst_port refcount leaks in" failed to apply to 4.14-stable tree
To:     xiongx18@fudan.edu.cn, lyude@redhat.com, stable@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:37:47 +0200
Message-ID: <1597912667167132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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


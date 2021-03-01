Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD9327B94
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhCAKHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:07:32 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:44199 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232068AbhCAKGj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:06:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5B1561940B76;
        Mon,  1 Mar 2021 05:05:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xjqwel
        qKCooyeKWR4uUeG/Y40qFF91QVdcCuJfMKqak=; b=e8bLhh7syLj74KtwccCqB+
        TydzSVoigrNt/hAJ+BDZCWHCmf9lLrTTZN9ISVJsWvCYMT8Z2QvVFfFLlWK+JhUu
        6HYqnvpuXyul4ZJCB/WpaNPpduSaeLIZic7G/gZJ0gRwlzj8k9RjJ3VBLXSPTZCt
        T3J+rKeP+NgKIT5a2haaw1Af/Xmt4BQvH0R5jJqyer4bU0LPSuNgCNejYpqfKoUw
        4xZ7dAJGsVzjghLvTAcJUg0w8Q2EG2zCBU4SwtVaxy3ka12D5xgx7myogwkS/teI
        RoBc6cmyhMZ9wf9TdSXb6eHDStxOLITzTtd0bu1KumdSZ7YD9M0GqpgV4MSB3Jbw
        ==
X-ME-Sender: <xms:Xrw8YMZvZKVwD7IlDPXDufj8GyiAuGj3HA4n_7GU6BHk9xmNZwZI9w>
    <xme:Xrw8YFXEkY5GthQd9p0vImvm04R41eSRPT4-CQOdAQ5RNbdbOd518Szd5RxMjxygu
    UplAfpRYwfGUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Xrw8YOhzl0gJuQ8sqxur5QCnPnUtEQ5wRMFcciIKb5Z-9VZtizykPw>
    <xmx:Xrw8YDW1FqI03AB6_RfAiX5a5b6zCuFFGFVWseSKqMziRijaeL2hxg>
    <xmx:Xrw8YFN46Uj6r678BTKtU29k2jpg5WBRPOCVl5kAGuSXzPkNZvGNfA>
    <xmx:Xrw8YBSxyHzbN4ofYf3pXOUPVksjskNAYZvMvdcIoNdXQFAaBKly9w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04AFE1080059;
        Mon,  1 Mar 2021 05:05:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: add green_sardine device id (v2)" failed to apply to 5.10-stable tree
To:     Prike.Liang@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:05:14 +0100
Message-ID: <161459311422488@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8bf0835132c19437e1530621b730dd4f29fe938e Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Fri, 2 Oct 2020 10:58:55 -0400
Subject: [PATCH] drm/amdgpu: add green_sardine device id (v2)

Add green_sardine PCI id support and map it to renoir asic type.

v2: add apu flag

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index cac2724e7615..6a402d8b5573 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1085,6 +1085,7 @@ static const struct pci_device_id pciidlist[] = {
 
 	/* Renoir */
 	{0x1002, 0x1636, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
+	{0x1002, 0x1638, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RENOIR|AMD_IS_APU},
 
 	/* Navi12 */
 	{0x1002, 0x7360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_NAVI12},


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664C6327B91
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCAKHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:07:20 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60811 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231594AbhCAKGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:06:17 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2D78B1940AF9;
        Mon,  1 Mar 2021 05:05:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 05:05:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9JZRXA
        Nxt/bljr9NKoOZ1SZSpuAsa4YqK625NlVPBfw=; b=FkUt1Yup++eOr+NDnVdKgR
        kZbRwdfg05KRiABd1ICPn0/CpIbd5pouig5odY/x7eqeJONRjUdpIBBXCAfg+AbA
        FozrgXUWGZ2sOmnTmQcaPSQq9m/B5jsoBwkoM43tWbioZCXWqJCXKGBjP/0Iid/A
        BD15FeooZxV5TnLjt2upB2injBCllZEdAluZ8V9vjJVJTsNdT25SuGw9Xu3UMQ/X
        vsetb+uXqq5NNad1cWs4RFmJo/42nJd4faVFFDg9mx5FDMx86su3hrl14RaW0UZd
        5UY92xIwWfmg9/8jEn691kGGNZZYGqaS2J3ujvs8j0koZ7y+X05W/a5iBqFF/yVQ
        ==
X-ME-Sender: <xms:Zbw8YPlhXQ2HzXiR-Y8o8knPp4knJFUNb_TLGp108VCOZF4ZksxLpA>
    <xme:Zbw8YKnwHr_nwgfZ4Psb-zmmGMX9Bzfe4R7EASFH6UIaDrzk7SI3LMkrLjxu8b5cv
    h4yvluSgWPuDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Zbw8YIvJkQAht-X2OTS1K4dothjmiwfL59btWdz8_RsTy54s7SUPEQ>
    <xmx:Zbw8YFkz25muJeOoORBel-YAmfaPtZh8DZOwlumCAjJTjcP_HMYRqQ>
    <xmx:Zbw8YLvcVWRcMnVuQh6eIOLFe460fX8ynHeX-vDWV6h6M6XbxTopBg>
    <xmx:Zbw8YF8C-mZz5eoRz_jhc6KN7i0F5PC_eivsJh73_BJtT5-BI0YbXA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB801240054;
        Mon,  1 Mar 2021 05:05:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: add green_sardine device id (v2)" failed to apply to 5.11-stable tree
To:     Prike.Liang@amd.com, alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:05:15 +0100
Message-ID: <1614593115224188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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


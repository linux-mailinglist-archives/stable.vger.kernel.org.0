Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE60541DB2
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382043AbiFGWTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381764AbiFGWSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:18:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDBD262AC5;
        Tue,  7 Jun 2022 12:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C95CF6192C;
        Tue,  7 Jun 2022 19:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3871C385A2;
        Tue,  7 Jun 2022 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629613;
        bh=BBg+mwCNWImlh+M2q37i5/XLQ4BevCr4QVoRF5vwmqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGoMej0NE1OFC0jT0d2cIBsb96zV5RxGE7iOA0PX29Cf9C0xS79wj2/0dXBUWznBH
         yYBdryLna3EfbYsk+Bc4v2jZTP0Nv7Q6HMN9Ppcb/wzF/ArG3sz55pp0d5V6rfwudM
         mYsKyTCAxrw9Jz+jXJon8W+BRVHj9uuedAVhwOgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 753/879] drm/amdgpu: add beige goby PCI ID
Date:   Tue,  7 Jun 2022 19:04:31 +0200
Message-Id: <20220607165024.717481003@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 62e9bd20035b53ff6c679499c08546d96c6c60a7 upstream.

Add a beige goby PCI ID.

Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1931,6 +1931,7 @@ static const struct pci_device_id pciidl
 	{0x1002, 0x7421, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 	{0x1002, 0x7422, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 	{0x1002, 0x7423, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
+	{0x1002, 0x7424, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 	{0x1002, 0x743F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BEIGE_GOBY},
 
 	{ PCI_DEVICE(0x1002, PCI_ANY_ID),



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910221B0B78
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgDTMzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbgDTMp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFF9C206E9;
        Mon, 20 Apr 2020 12:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386726;
        bh=mc8QGzgejHGAQSVajZ4w620iO9AXegRDU80/sbHxamI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=em2QSIIGaA/p4p3TOfpS237vDBzq+yEkGyg2v4mUb3Xy18d2XfyB6qx/yagUDJiVP
         Z05iXR5ctBMHg/ocU3BpjaiESs20bnMXmJxjRaSU0NfmG9Lc/jTC2/7AbbbPpwcTa/
         AeT+SFKvqr9ceJtqyvrYJUHuqT40gNZlANz7VZ9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.6 59/71] drm/amdgpu/gfx9: add gfxoff quirk
Date:   Mon, 20 Apr 2020 14:39:13 +0200
Message-Id: <20200420121520.881890837@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 974229db7e6c1f2ff83ceaf3022d5128bf62caca upstream.

Fix screen corruption with firefox.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=207171
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1175,6 +1175,8 @@ struct amdgpu_gfxoff_quirk {
 static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=204689 */
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc8 },
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=207171 */
+	{ 0x1002, 0x15dd, 0x103c, 0x83e7, 0xd3 },
 	{ 0, 0, 0, 0, 0 },
 };
 



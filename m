Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954E337C513
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhELPiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233514AbhELP3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447DF6193B;
        Wed, 12 May 2021 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832515;
        bh=8Ct/BJFqyqeK5kSHUxL759v575ZLbKd0mezRSUnDLb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJOhV0j6fdVJNHkBOsQMgSNVuJeWGnwB/HyqvCorYRVKgmmeuCXljHt4Uo4puVGxW
         bXyQjMLIGg+CBd5gHVwULyntfGyw0taMqfDWHDZ0Cpg/+EDUbtItTfiQy2tZ827GWO
         sXvqdcj3Ucoh77c1Jz7t4yYRLaAfOtd1e60OJGuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Ying <victor.liu@nxp.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/530] media: docs: Fix data organization of MEDIA_BUS_FMT_RGB101010_1X30
Date:   Wed, 12 May 2021 16:46:44 +0200
Message-Id: <20210512144829.467119107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit c451ee146d449bbe39835fc3d9007b7f06332415 ]

The media bus bit width of MEDIA_BUS_FMT_RGB101010_1X30 is 30.
So, 'Bit31' and 'Bit30' cells for the 'MEDIA_BUS_FMT_RGB101010_1X30'
row should be spaces instead of '0's.

Fixes: 54f38fcae536 ("media: docs: move uAPI book to userspace-api/media")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/userspace-api/media/v4l/subdev-formats.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/subdev-formats.rst b/Documentation/userspace-api/media/v4l/subdev-formats.rst
index c9b7bb3ca089..eff6727c69d3 100644
--- a/Documentation/userspace-api/media/v4l/subdev-formats.rst
+++ b/Documentation/userspace-api/media/v4l/subdev-formats.rst
@@ -1567,8 +1567,8 @@ The following tables list existing packed RGB formats.
       - MEDIA_BUS_FMT_RGB101010_1X30
       - 0x1018
       -
-      - 0
-      - 0
+      -
+      -
       - r\ :sub:`9`
       - r\ :sub:`8`
       - r\ :sub:`7`
-- 
2.30.2




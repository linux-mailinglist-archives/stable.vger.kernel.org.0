Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2698F37CDE1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343575AbhELQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243556AbhELQlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056FD61E48;
        Wed, 12 May 2021 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835485;
        bh=JQer6o2EdnI5O1/+Eap2sagsB4vfjjSTgE4AQnWpYas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMgOetJsIMv5uhCLiuOPekFwmJVOYUg/aP4ZWhZ+OFOP44rJ7yS3GMXoQRPhlpOtu
         6xApdUUFd5Q94+zfm2xCEe9ypgtq3ZNTIQqqGG+2kPjdQIk5qTFB907vLGimdzMVy4
         wc30J/a727oWvbk3emzKwEnHc9eEHhvevQjiU7YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Ying <victor.liu@nxp.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 363/677] media: docs: Fix data organization of MEDIA_BUS_FMT_RGB101010_1X30
Date:   Wed, 12 May 2021 16:46:49 +0200
Message-Id: <20210512144849.391970809@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 7f16cbe46e5c..e6a9faa81197 100644
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




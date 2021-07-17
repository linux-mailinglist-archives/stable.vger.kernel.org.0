Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74A73CC4F9
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhGQRsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 13:48:00 -0400
Received: from aposti.net ([89.234.176.197]:56774 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhGQRsA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 13:48:00 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 0/2] drm/ingenic: backports for v5.10.x
Date:   Sat, 17 Jul 2021 18:44:44 +0100
Message-Id: <20210717174446.14455-1-paul@crapouillou.net>
In-Reply-To: <1626352148199179@kroah.com>
References: <1626352148199179@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Here are two patches for the ingenic-drm driver that couldn't be applied
to the stable v5.10.x automatically. I backported them manually so that
they can be applied there.

Cheers,
-Paul

Paul Cercueil (2):
  drm/ingenic: Fix non-OSD mode
  drm/ingenic: Switch IPU plane to type OVERLAY

 drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 20 +++++++++++---------
 drivers/gpu/drm/ingenic/ingenic-ipu.c     |  2 +-
 2 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.30.2


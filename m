Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0734911B4EA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732718AbfLKPX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732556AbfLKPX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20BD524671;
        Wed, 11 Dec 2019 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077807;
        bh=XGyI+LgxkYxAty6h+VcHbdk6av8Guw2rvj2UsdveNNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjUPYItfCXY4EGR8xUUt5sUBj/Z2VEpWEW1Z3W0VPrfdyYv0c20thouDo9RRqJ6x5
         4pGChjY2+l65RDaSQt5+c5hmszrYadzMzJn7KZ3lfPrrm+T9y1uYtiLrjs0AQt1ACq
         COluLuugE99eQqZ7+/EhT20ZsaJJrVzBTOArfzZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/243] kbuild: disable dtc simple_bus_reg warnings by default
Date:   Wed, 11 Dec 2019 16:05:13 +0100
Message-Id: <20191211150349.364778287@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 70523a3ce5ff928faa43bb2cad554dc63438e3e7 ]

The updated version of dtc has a bug fix for simple_bus_reg warnings
and lots of warnings are generated now. So disable this warning by
default.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.lib | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 61e596650ed31..a232741e3fd3b 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -252,6 +252,7 @@ DTC_FLAGS += -Wno-unit_address_vs_reg \
 	-Wno-alias_paths \
 	-Wno-graph_child_address \
 	-Wno-graph_port \
+	-Wno-simple_bus_reg \
 	-Wno-unique_unit_address \
 	-Wno-pci_device_reg
 endif
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502F249A91D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322142AbiAYDU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353468AbiAXUIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:08:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6B43B8159B;
        Mon, 24 Jan 2022 20:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB37C340E5;
        Mon, 24 Jan 2022 20:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054886;
        bh=3U9VP1OuruVXeNmVCUIDrfmA01G3vDMoXgFxbdOhwwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqdSBf8oY1aiQmZMKKsMkwY6mY7n01tIbWfY4MueVLRLT0p6agy8m+29ZfSflhZSG
         5lBBwChQSM6o4kfLWmpsBReNkbaiD/T2lc08xdU2u1VIUxIFZDdgZ7rqzuAyYHGW09
         XuW2ZUmScSHcKu8HygxZiFspoR3/V+qinE/6y0xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 503/563] powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
Date:   Mon, 24 Jan 2022 19:44:28 +0100
Message-Id: <20220124184041.865223836@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

commit 0d375d610fa96524e2ee2b46830a46a7bfa92a9f upstream.

This block is used in (at least) T1024 and T1040, including their
variants like T1023 etc.

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi
@@ -79,6 +79,7 @@ fman0: fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfc000 0x1000>;
+		fsl,erratum-a009885;
 	};
 
 	xmdio0: mdio@fd000 {
@@ -86,6 +87,7 @@ fman0: fman@400000 {
 		#size-cells = <0>;
 		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
 		reg = <0xfd000 0x1000>;
+		fsl,erratum-a009885;
 	};
 };
 



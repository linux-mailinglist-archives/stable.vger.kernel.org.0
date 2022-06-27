Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836AE55D097
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiF0Lec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiF0Lcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:32:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C904E95A3;
        Mon, 27 Jun 2022 04:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54FD0614E6;
        Mon, 27 Jun 2022 11:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6D3C3411D;
        Mon, 27 Jun 2022 11:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329370;
        bh=y9i6OcD3+jttfol87JifqvXY8ddQ2O+EJsT5yNM2FLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jky/vpF1yIa1he5wVsRCrQnlq4VbdLC+ekAKH5h317VVi8ubqnhp+5v/yWZkZIQO
         p2bhYUZnsI9TR6KrregwFeqeM0mvF9qXosezEFNBAjE/PMg4oeZdBj9AwVwrzGcZbn
         NjCayxX5iPkgHIFY3bbxXosYNWltMe9jwC1TZ/PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Haibo Chen <haibo.chen@nxp.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/60] iio: adc: vf610: fix conversion mode sysfs node name
Date:   Mon, 27 Jun 2022 13:21:46 +0200
Message-Id: <20220627111928.723166638@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit f1a633b15cd5371a2a83f02c513984e51132dd68 ]

The documentation missed the "in_" prefix for this IIO_SHARED_BY_DIR
entry.

Fixes: bf04c1a367e3 ("iio: adc: vf610: implement configurable conversion modes")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Acked-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/560dc93fafe5ef7e9a409885fd20b6beac3973d8.1653900626.git.baruch@tkos.co.il
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-iio-vf610 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-vf610 b/Documentation/ABI/testing/sysfs-bus-iio-vf610
index 308a6756d3bf..491ead804488 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-vf610
+++ b/Documentation/ABI/testing/sysfs-bus-iio-vf610
@@ -1,4 +1,4 @@
-What:		/sys/bus/iio/devices/iio:deviceX/conversion_mode
+What:		/sys/bus/iio/devices/iio:deviceX/in_conversion_mode
 KernelVersion:	4.2
 Contact:	linux-iio@vger.kernel.org
 Description:
-- 
2.35.1




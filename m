Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E624160A418
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiJXMFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiJXMEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F40B638EF;
        Mon, 24 Oct 2022 04:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F82561257;
        Mon, 24 Oct 2022 11:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50F1C433C1;
        Mon, 24 Oct 2022 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612221;
        bh=gpxEK+/vB6oxf9o8QTiRM6M4RrtZn3Orj865Dz+D9bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoF4x5x8EwTLSAWggp8PbjUnNCa3Fr02fZWnucgfmyeEwzImMB/Z274kJtq4txfDQ
         rc48QO1WE8m7zdxrw2H3X8E1K6CnhwovYAwz2A/It1uujXuxhWKDcX39fY4+znYB90
         U3xy9IjVmfwtxyMuBWE/Q54fYQknxmDiqaj1qX7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/210] iio: ABI: Fix wrong format of differential capacitance channel ABI.
Date:   Mon, 24 Oct 2022 13:30:33 +0200
Message-Id: <20221024113000.755261631@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 1efc41035f1841acf0af2bab153158e27ce94f10 ]

in_ only occurs once in these attributes.

Fixes: 0baf29d658c7 ("staging:iio:documentation Add abi docs for capacitance adcs.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220626122938.582107-3-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-iio | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index e21e2ca3e4f9..c6573a733a68 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -135,7 +135,7 @@ Description:
 		Raw capacitance measurement from channel Y. Units after
 		application of scale and offset are nanofarads.
 
-What:		/sys/.../iio:deviceX/in_capacitanceY-in_capacitanceZ_raw
+What:		/sys/.../iio:deviceX/in_capacitanceY-capacitanceZ_raw
 KernelVersion:	3.2
 Contact:	linux-iio@vger.kernel.org
 Description:
-- 
2.35.1




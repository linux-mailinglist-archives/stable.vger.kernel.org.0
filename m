Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF260B05E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbiJXQFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiJXQEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C50937B2;
        Mon, 24 Oct 2022 07:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63441B81673;
        Mon, 24 Oct 2022 12:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B877AC433D6;
        Mon, 24 Oct 2022 12:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614337;
        bh=bALNRABvlhgzd60APy0WYdB6i+5E0MSGrsOz6JFb/UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySjTDaAsQznVhqrOllCw3P46ArGZ8KYk3jsquQKyMVLjy1jYL9dpbB0061jG/Xbo3
         3OTB1BUUs+l0ZjE1F0nYdLZnAxeixvHrliykX6WuvSfWpYRDr/W1kdpHJj9ADL+utc
         w0oIg3uRTSDjyzwCX6igmXeJbqN6CrUaazc+zDuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/390] iio: ABI: Fix wrong format of differential capacitance channel ABI.
Date:   Mon, 24 Oct 2022 13:29:47 +0200
Message-Id: <20221024113030.852781144@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
index df42bed09f25..53f07fc41b96 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -142,7 +142,7 @@ Description:
 		Raw capacitance measurement from channel Y. Units after
 		application of scale and offset are nanofarads.
 
-What:		/sys/.../iio:deviceX/in_capacitanceY-in_capacitanceZ_raw
+What:		/sys/.../iio:deviceX/in_capacitanceY-capacitanceZ_raw
 KernelVersion:	3.2
 Contact:	linux-iio@vger.kernel.org
 Description:
-- 
2.35.1




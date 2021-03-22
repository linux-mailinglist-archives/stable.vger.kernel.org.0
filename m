Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D14234435C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCVMtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232781AbhCVMsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EAE3619CE;
        Mon, 22 Mar 2021 12:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417057;
        bh=uFl12llNey8jZ4WUj3Y1oy/2jmWRLZ16uf3zAC9MiZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrtVavaw5JENz5zBWmfBsrrBpfajQ4kCHgSRhJcC/vL7KxJfreickyE0zvS73pxt6
         q0XgbmuIDlVuBXDPB8cweOt68v9VEiPsGTm4g198wh9BR9afBF5AmqCKtElplt1mJN
         Fq/3W+1GByLO65zUvGkqi99A12SuP23szPWMhZxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 02/43] ASoC: ak5558: Add MODULE_DEVICE_TABLE
Date:   Mon, 22 Mar 2021 13:28:16 +0100
Message-Id: <20210322121920.012292994@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

commit 80cffd2468ddb850e678f17841fc356930b2304a upstream.

Add missed MODULE_DEVICE_TABLE for the driver can be loaded
automatically at boot.

Fixes: 920884777480 ("ASoC: ak5558: Add support for AK5558 ADC driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1614149872-25510-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/ak5558.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -396,6 +396,7 @@ static const struct of_device_id ak5558_
 	{ .compatible = "asahi-kasei,ak5558"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);
 
 static struct i2c_driver ak5558_i2c_driver = {
 	.driver = {



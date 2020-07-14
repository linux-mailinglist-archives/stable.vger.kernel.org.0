Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EAD21FB33
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbgGNS7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731015AbgGNS7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36DE722AAD;
        Tue, 14 Jul 2020 18:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753183;
        bh=SXlYzLsz9dhO9CyQdO/wT3TBVWr11Ev50rKITBMCMrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtkgOS0vjYcv9IPZVOs2H3D6Q5aVF1Rf2UjqJTXu16bXv0Rm1i3TXnwhEeK6PSgRu
         dpcvtKYeeMCb5pCdZK49Hlrk+e47Qv2zvpNC45Ju4pQevMk1p37vcumwI3JPuhp4Ih
         e+J6o/N1AV6VO4yxV6is3a985fxpNrm1RC/cSOHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.7 151/166] mmc: owl-mmc: Get rid of of_match_ptr() macro
Date:   Tue, 14 Jul 2020 20:45:16 +0200
Message-Id: <20200714184123.058656156@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <mani@kernel.org>

commit f8884711f78fa946041cf04492e218c377479a9c upstream.

Remove the 'of_match_ptr()' macro to fix the warning when CONFIG_OF is
not selected.

drivers/mmc/host/owl-mmc.c:677:34: warning: unused variable 'owl_mmc_of_match'
[-Wunused-const-variable]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20200621025330.10561-1-mani@kernel.org
Fixes: ff65ffe46d28 ("mmc: Add Actions Semi Owl SoCs SD/MMC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/owl-mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/owl-mmc.c
+++ b/drivers/mmc/host/owl-mmc.c
@@ -689,7 +689,7 @@ MODULE_DEVICE_TABLE(of, owl_mmc_of_match
 static struct platform_driver owl_mmc_driver = {
 	.driver = {
 		.name	= "owl_mmc",
-		.of_match_table = of_match_ptr(owl_mmc_of_match),
+		.of_match_table = owl_mmc_of_match,
 	},
 	.probe		= owl_mmc_probe,
 	.remove		= owl_mmc_remove,



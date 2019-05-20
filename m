Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBC423408
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbfETMWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388450AbfETMWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3192520675;
        Mon, 20 May 2019 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354956;
        bh=AJzAOBfK+W+9PiPw6Q1YZyS50a4r863se8XmdD4S8UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhHEWdVGj3cd4IyLgza+JmH5uqqPkzQbLVem2BfZt4i+EFhdu8oyzg/PnHLe27jbi
         Lwih/8MTVDTXojDcch7xB43iL/bW9OpGJ2apWaeWooPj+CdGCV6Ke8CZ1bXnNbIm4q
         v2SZDl9ITHFkru/cZTO+vy7vYwam/UD7QpcbfiZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 041/105] ASoC: fsl_esai: Fix missing break in switch statement
Date:   Mon, 20 May 2019 14:13:47 +0200
Message-Id: <20190520115249.867360413@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: S.j. Wang <shengjiu.wang@nxp.com>

commit 903c220b1ece12f17c868e43f2243b8f81ff2d4c upstream.

case ESAI_HCKT_EXTAL and case ESAI_HCKR_EXTAL should be
independent of each other, so replace fall-through with break.

Fixes: 43d24e76b698 ("ASoC: fsl_esai: Add ESAI CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/fsl_esai.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -251,7 +251,7 @@ static int fsl_esai_set_dai_sysclk(struc
 		break;
 	case ESAI_HCKT_EXTAL:
 		ecr |= ESAI_ECR_ETI;
-		/* fall through */
+		break;
 	case ESAI_HCKR_EXTAL:
 		ecr |= ESAI_ECR_ERI;
 		break;



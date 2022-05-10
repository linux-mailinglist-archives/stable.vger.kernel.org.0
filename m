Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAE2521A32
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244078AbiEJNyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244563AbiEJNuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:50:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1016D296BE5;
        Tue, 10 May 2022 06:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 308A2B81DA2;
        Tue, 10 May 2022 13:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9937CC385C2;
        Tue, 10 May 2022 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189815;
        bh=qZfQrZp8pLBCTKq6lhsb6lISQ6IGdkGbv/mKIdtS2W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02m076KelgR5BaPjjpGlYBSmYIUm3zkwAziR1/mMTMkOuqYhFID/5Ynbi7XlS3nA4
         vYUBw6owbFqhRVWvOHLAoSN8EJ23xtupg+EDbdHht5jY66eV2UaZBDOZ1I+2xv4+G4
         78qvw/BWbJle7NI3/zviF1+cgKMrIDmGkkQ0hpJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 036/140] ASoC: rt9120: Correct the reg 0x09 size to one byte
Date:   Tue, 10 May 2022 15:07:06 +0200
Message-Id: <20220510130742.650010284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

commit 87c18514bb8477563a61f50b4285da156296edc4 upstream.

Correct the reg 0x09 size to one byte.

Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1650608810-3829-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt9120.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/rt9120.c
+++ b/sound/soc/codecs/rt9120.c
@@ -341,7 +341,6 @@ static int rt9120_get_reg_size(unsigned
 {
 	switch (reg) {
 	case 0x00:
-	case 0x09:
 	case 0x20 ... 0x27:
 		return 2;
 	case 0x30 ... 0x3D:



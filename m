Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48E14095DB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhIMOpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345113AbhIMOnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:43:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 352A16321C;
        Mon, 13 Sep 2021 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541433;
        bh=fV11o18AQIheQuZcOCTElcYXX41bK2Jq8EtZ+jE9Vyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPqpY36DHAZf6g84MSiLqUL18Cc2vmiR1v2qOOdno0mF3buCrOCP7HjcYy3CQCxiL
         LLMShuNmz7lj+QemY3ooBzTLmXyzXaD5o4dALB15f8M96dYgxrdBm0J75VN8tBjy/c
         0j193DZFioJ1Tkz9Da6QR2dcVTXBzdT9DSIqzJwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 295/334] ASoC: rt5682: Remove unused variable in rt5682_i2c_remove()
Date:   Mon, 13 Sep 2021 15:15:49 +0200
Message-Id: <20210913131123.401737663@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit a1ea05723c27a6f77894a60038a7b2b12fcec9a7 upstream.

In commit 772d44526e20 ("ASoC: rt5682: Properly turn off regulators if
wrong device ID") I deleted code but forgot to delete a variable
that's now unused. Delete it.

Fixes: 772d44526e20 ("ASoC: rt5682: Properly turn off regulators if wrong device ID")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210813073402.1.Iaa9425cfab80f5233afa78b32d02b6dc23256eb3@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5682-i2c.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -294,8 +294,6 @@ static void rt5682_i2c_shutdown(struct i
 
 static int rt5682_i2c_remove(struct i2c_client *client)
 {
-	struct rt5682_priv *rt5682 = i2c_get_clientdata(client);
-
 	rt5682_i2c_shutdown(client);
 
 	return 0;



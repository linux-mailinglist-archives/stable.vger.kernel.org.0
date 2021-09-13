Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64940409379
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245581AbhIMOV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344151AbhIMOSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:18:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B937361B1E;
        Mon, 13 Sep 2021 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540716;
        bh=fV11o18AQIheQuZcOCTElcYXX41bK2Jq8EtZ+jE9Vyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djgTMbZbSUuL/+CTllqcFNsPUL+sa8FJYxmJxjrApeTaCaCZIYxP+qST91HdA8RtM
         7Md+KqXnv/ZvgXhrUWzVUD93tJp9nyJE80SqwFpi2GAdSW6NSh3hOmmeG0TfXXHdvz
         M43Oie4hJkKTug3yVdA7QJGZ82jXL+WNSVn9no48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.13 264/300] ASoC: rt5682: Remove unused variable in rt5682_i2c_remove()
Date:   Mon, 13 Sep 2021 15:15:25 +0200
Message-Id: <20210913131118.260495773@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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



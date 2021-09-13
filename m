Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69B408FFF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242882AbhIMNsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242994AbhIMNqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 623E4610CF;
        Mon, 13 Sep 2021 13:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539921;
        bh=4y0BWiAPuG5WjVF9EqcZpo9VKbgVNnrNoSR9nsvPPBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFn0AGBB69Jru05i4lAEIEDa1+qNWKPtWVTAV+NTJB6P0qoaT9/hscnJsO0s0hiI8
         J4lJbS/q7qoP4cpBkizDB3GESb6F6QXUcWT6j0JeFwxKAJfVIUaRXP6PEdR3P83Vr6
         BHktWJVldYZhNGdvNLpJxBaKwRC3mKwZbNKJQAj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 215/236] ASoC: rt5682: Remove unused variable in rt5682_i2c_remove()
Date:   Mon, 13 Sep 2021 15:15:20 +0200
Message-Id: <20210913131107.681509215@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
@@ -289,8 +289,6 @@ static void rt5682_i2c_shutdown(struct i
 
 static int rt5682_i2c_remove(struct i2c_client *client)
 {
-	struct rt5682_priv *rt5682 = i2c_get_clientdata(client);
-
 	rt5682_i2c_shutdown(client);
 
 	return 0;



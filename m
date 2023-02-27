Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9146A41A3
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 13:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjB0MXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 07:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjB0MXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 07:23:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D090CA2E;
        Mon, 27 Feb 2023 04:23:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DFFED1FD63;
        Mon, 27 Feb 2023 12:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677500582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnCaGxLM9o5v+srx8eCrRSPyZtndDAvxj3Myw/6GoFE=;
        b=kSqbc45voUU9N4EwiF4i9ogkNjInIHniJKd0yh7TKyJSCW/hIbKboorkfvFrJddZF7/stG
        G3nBFqlHdRktKR1Qci5EOg0yp4MBI5ndVd93D+GHXcEyLWp2MYqI/DOC1VW7S4sdOIooKG
        9y4D/YWil/RnqxtIZc4jzdwBIVhLy8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677500582;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnCaGxLM9o5v+srx8eCrRSPyZtndDAvxj3Myw/6GoFE=;
        b=E5KYuE3Z7IQPbA1dtW4HUc4hR1sBmAC7ihHsLMXNw9t9dCMek9YZRATadX9BZFuQL3rd4z
        hhS5xmc3wtr+VhCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69DAA13A43;
        Mon, 27 Feb 2023 12:23:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ISg+GKag/GMVPgAAMHmgww
        (envelope-from <jdelvare@suse.de>); Mon, 27 Feb 2023 12:23:02 +0000
Date:   Mon, 27 Feb 2023 13:23:00 +0100
From:   Jean Delvare <jdelvare@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Allen Ballway <ballway@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, groeck@chromium.org,
        alistair@alistair23.me, dmitry.torokhov@gmail.com,
        jk@codeconstruct.com.au, Jonathan.Cameron@huawei.com,
        cmo@melexis.com, u.kleine-koenig@pengutronix.de,
        linux-input@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 10/25] HID: multitouch: Add quirks for
 flipped axes
Message-ID: <20230227132300.4a3c3fad@endymion.delvare>
In-Reply-To: <20230227020855.1051605-10-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
        <20230227020855.1051605-10-sashal@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, 26 Feb 2023 21:08:33 -0500, Sasha Levin wrote:
> From: Allen Ballway <ballway@chromium.org>
> 
> [ Upstream commit a2f416bf062a38bb76cccd526d2d286b8e4db4d9 ]
> 
> Certain touchscreen devices, such as the ELAN9034, are oriented
> incorrectly and report touches on opposite points on the X and Y axes.
> For example, a 100x200 screen touched at (10,20) would report (90, 180)
> and vice versa.
> 
> This is fixed by adding device quirks to transform the touch points
> into the correct spaces, from X -> MAX(X) - X, and Y -> MAX(Y) - Y.
> 
> Signed-off-by: Allen Ballway <ballway@chromium.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hid/hid-multitouch.c             | 39 ++++++++++++++++++---
>  drivers/hid/hid-quirks.c                 |  6 ++++
>  drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 43 ++++++++++++++++++++++++
>  drivers/hid/i2c-hid/i2c-hid.h            |  3 ++
>  4 files changed, 87 insertions(+), 4 deletions(-)
> (...)

Second rule of acceptance for stable patches:

 - It cannot be bigger than 100 lines, with context.

Clearly not met here.

To me, this commit is something distributions may want to backport if
their users run are likely to run the affected hardware. But it's out
of scope for stable kernel branches.

Thanks,
-- 
Jean Delvare
SUSE L3 Support

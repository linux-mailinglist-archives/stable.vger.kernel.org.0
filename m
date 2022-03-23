Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCB74E5A98
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 22:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiCWVZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 17:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiCWVZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 17:25:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A367C1E3F3
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:23:56 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p26-20020a05600c1d9a00b0038ccbff1951so516315wms.1
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 14:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wYcsz20+3jLYknEv3uzDTgkYwHMSr0SLXnWndP/MGP8=;
        b=luYJnpxlDxSVIhmOPt1sfSct+EbdAQUFaatfzCbJzZPgB12IqlooKPla9dWL7TX6TK
         lsIV60p3dz/tG6h1/isqGFBNAw0RrK/7nudCpb8R1T08HsEiPOLYW8/ypQdNechszAmt
         TKijt1OydIyxcFTXgARqyeRY9aY3vSld7GBz7oNImThPQnMz+Us3+U2c4/In+Jem207d
         xzv6ABFDp1QGDTHUP4BNsT0nsvxjGTY3odH3qgfJ82LjkQyRpLecDyscRknu6uMdp7Rc
         dmNX5eUqH3Q1nBQTcpxoY193jwa6iXGpeA0y4G/rrWFTm0rIadYfp1QmHIrAme3jbyK8
         X9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wYcsz20+3jLYknEv3uzDTgkYwHMSr0SLXnWndP/MGP8=;
        b=OHoitTkS4nL7c94rcDUSlKoNOyeWmW1MSgRi/rHpMGnUS4MIy8G3k3k4NPlNoCVPCc
         BDnXLKwnKEmDlLt0hrAVFcKlIxn575tFo3srPUDI2gnZgAFKduZ37lOw+JbjUJn/0REe
         cIBFUPNxZsmGWN78Bh8ykVF6krsCIQa9vih+wbngDOOakC+9PfHatOHKs3abBRF6MUrA
         oDnGSlTq3pCVXcW+2Qc/uBq8YQ4a9iVxmY+PfNg1jTyPoLLh5Prwq74puhO80TdCVvU8
         QXzexPL1UjFbQ/uWthWiKru5c7jATnbhgGnkm+v7o1DEMWR66IBYs6vXCDoBjitvHcY1
         4mkQ==
X-Gm-Message-State: AOAM53191vw+Mz5rXx96sUMUHYyPBr32cG9+2NngmC8b1r45v+5bAqrl
        bUo1FRU3NE69w9XDkxUBWU0=
X-Google-Smtp-Source: ABdhPJx8/AzbNGF0VS2q71JR8LaNWvIgbY8iIsJZ7INw3ONh0afDu4dtTQVkxNtdkVFnB22Ea94Zuw==
X-Received: by 2002:a7b:c5d1:0:b0:37f:a8a3:9e17 with SMTP id n17-20020a7bc5d1000000b0037fa8a39e17mr11114987wmk.109.1648070635071;
        Wed, 23 Mar 2022 14:23:55 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id o6-20020a05600002c600b002057f1738fcsm875002wry.110.2022.03.23.14.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 14:23:53 -0700 (PDT)
Date:   Wed, 23 Mar 2022 21:23:52 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     oliver.graute@kococonnector.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] staging: fbtft: fb_st7789v: reset display
 before" failed to apply to 5.10-stable tree
Message-ID: <YjuP6J0feY3S5kDD@debian>
References: <164603174124116@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6qtFpttiDqkvmIfg"
Content-Disposition: inline
In-Reply-To: <164603174124116@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6qtFpttiDqkvmIfg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 28, 2022 at 08:02:21AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply to all other stable trees.

--
Regards
Sudip

--6qtFpttiDqkvmIfg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-staging-fbtft-fb_st7789v-reset-display-before-initia.patch"

From dbe34d547c408290155c305f2cbd4a266c062391 Mon Sep 17 00:00:00 2001
From: Oliver Graute <oliver.graute@kococonnector.com>
Date: Thu, 10 Feb 2022 09:53:22 +0100
Subject: [PATCH] staging: fbtft: fb_st7789v: reset display before
 initialization

commit b6821b0d9b56386d2bf14806f90ec401468c799f upstream.

In rare cases the display is flipped or mirrored. This was observed more
often in a low temperature environment. A clean reset on init_display()
should help to get registers in a sane state.

Fixes: ef8f317795da (staging: fbtft: use init function instead of init sequence)
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
Link: https://lore.kernel.org/r/20220210085322.15676-1-oliver.graute@kococonnector.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/staging/fbtft/fb_st7789v.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/fbtft/fb_st7789v.c b/drivers/staging/fbtft/fb_st7789v.c
index 3a280cc1892c..0a2dbed9ffc7 100644
--- a/drivers/staging/fbtft/fb_st7789v.c
+++ b/drivers/staging/fbtft/fb_st7789v.c
@@ -82,6 +82,8 @@ enum st7789v_command {
  */
 static int init_display(struct fbtft_par *par)
 {
+	par->fbtftops.reset(par);
+
 	/* turn off sleep mode */
 	write_reg(par, MIPI_DCS_EXIT_SLEEP_MODE);
 	mdelay(120);
-- 
2.30.2


--6qtFpttiDqkvmIfg--

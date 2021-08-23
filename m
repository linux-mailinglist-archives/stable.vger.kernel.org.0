Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CAE3F51B6
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 22:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHWUJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 16:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhHWUJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 16:09:39 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01EAC061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 13:08:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so803682wmi.1
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 13:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7LiRu4PIH0ubU8GTZuvZ9u6h4KY+q3h34fhj7D/RjOA=;
        b=CPiW+MzXU827pvwEBvJnjC5ZfIvNhgfgriCLREQ88B2B1EeH7NMveQBk3jIo6+t1oT
         T/E63OJL295t3IFabi3mhcH52dOC/Nb+gP/9IiRATjjjYE14bmYrV2DLznqbdU8J2xfj
         k0cJ5n4Dzb5r21KzAY+zdonATVyNj+un6QBizKZgbZoK9q8OxRDocp3SYO7SIKHfXHOD
         nHAdL28nlK+vmS848fgz3Tp4PjzyXv5TdKuCu1iXDZ+8OMzqARbP1Ke3m8LGpH8X8C2v
         QRTnqQDdH6lYScf29lvhR8prdQd16nWc1XRUlAhpWhThr/N0pQHFUV5agLqkMu6vOJDW
         SFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7LiRu4PIH0ubU8GTZuvZ9u6h4KY+q3h34fhj7D/RjOA=;
        b=iFwJXTB+7hmKKBVrKspnQa8xIyUTPTSsNVptcASnddIhyvgph9+meCiSVqV4LFeqS2
         j8PUa8QhMEKOG3+GujEexvH/YM18X7zRy5BOygK5gD9TgvIKYsK+xGBcC0E8K9Bk3oPw
         Bc6hCG6qjJjmBREIo1a55wDvtaNJtU0WzdGu+h5/wOtdDHlZxWwixjwV4vAZTh5HkXyv
         tB0DQ4m5sX4zkN3Rf5nM/h+YOGTvcW30xG3PnqzBjw5JzqPlLssntPoihXCYvz8oLsqw
         bP273RLrNsSWPH8pBKiY0TR/+62zMc3LcgcE4N156ZC/8OAyJkFoP4coyjsRQgBSZbPs
         Mz9g==
X-Gm-Message-State: AOAM532x67pGFh89ZSzPVQyz9txOtEDVCPT2Mbfq/P6k4lse3HdArUPC
        nLqbBYdaF5u0COklVJSZsYAuTTK1VYcpUw==
X-Google-Smtp-Source: ABdhPJypO2csecJMFThmsywa42nPQlFTtzc6TQ5/IYb/LckQrU9AIGb4HFP5tCisw0HnuMM+hUk1Dg==
X-Received: by 2002:a1c:f30b:: with SMTP id q11mr326066wmq.91.1629749334453;
        Mon, 23 Aug 2021 13:08:54 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id k18sm176147wmi.25.2021.08.23.13.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 13:08:54 -0700 (PDT)
Date:   Mon, 23 Aug 2021 21:08:51 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     keescook@chromium.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lkdtm: Enable DOUBLE_FAULT on all
 architectures" failed to apply to 5.10-stable tree
Message-ID: <YSQAU7wKRAFv2yET@debian>
References: <162635641192154@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8GutRLrt9EvviL1A"
Content-Disposition: inline
In-Reply-To: <162635641192154@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8GutRLrt9EvviL1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, Jul 15, 2021 at 03:40:11PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--8GutRLrt9EvviL1A
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-lkdtm-Enable-DOUBLE_FAULT-on-all-architectures.patch"

From d896b17de566fca9dd4c83ac2ac2e6dce1185b67 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Wed, 23 Jun 2021 13:39:33 -0700
Subject: [PATCH] lkdtm: Enable DOUBLE_FAULT on all architectures

commit f123c42bbeff26bfe8bdb08a01307e92d51eec39 upstream

Where feasible, I prefer to have all tests visible on all architectures,
but to have them wired to XFAIL. DOUBLE_FAIL was set up to XFAIL, but
wasn't actually being added to the test list.

Fixes: cea23efb4de2 ("lkdtm/bugs: Make double-fault test always available")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210623203936.3151093-7-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/misc/lkdtm/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 97803f213d9d..c802db9aaeb0 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -173,9 +173,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(USERCOPY_KERNEL),
 	CRASHTYPE(STACKLEAK_ERASING),
 	CRASHTYPE(CFI_FORWARD_PROTO),
-#ifdef CONFIG_X86_32
 	CRASHTYPE(DOUBLE_FAULT),
-#endif
 };
 
 
-- 
2.30.2


--8GutRLrt9EvviL1A--

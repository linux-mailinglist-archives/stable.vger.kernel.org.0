Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C42368B7A
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 05:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbhDWDT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 23:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhDWDTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 23:19:23 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEE8C061574;
        Thu, 22 Apr 2021 20:18:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so502098pjv.1;
        Thu, 22 Apr 2021 20:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1/TOrEqrwiXCSug3JBIyA4BD91Pmv7587CTqOps2XDY=;
        b=TQ7Ne3vCRWtywSF3nUHKF94uyp5ZkhtJsazryURn2C2aAYQq5H2hpC2SSQmuR5svqJ
         bZpT4BFgTIVR60BWeRfTb9E+vcyIsICYRm4W1F2ZMm1Jhe3jWqG6tFwPPtBpGIB5WmDh
         WxFY9Ck66dGb984u478SuWKkPDvBnPVZYhtkSXwlBORwKemE3XNc/IirV26QPsaek7Eh
         cy/7Wc7hk/bMqIpTIwgH5nM+qbiiPw8Ep/H8l9U9bKQQJSNNVYDldLnyxLCseqguPw4e
         9F9qGS5AcTfHEYpwGDLRYWw4tE3VeZpt66Cutfh0Mwt5ln6pcFqvv9v579PmW5HW+9aE
         NTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1/TOrEqrwiXCSug3JBIyA4BD91Pmv7587CTqOps2XDY=;
        b=Q2db9jXk8FlFFFFDuFqEu0NdwIOKDix+CB/d8am1MVBgkMsC1UcfOewf5fij8O4TLJ
         O5FShagqn214WydmchrQggeBF4esPM0pRsZ6Hl+gXhxKbJeG86mFqVVcg13OQFhBDVfy
         mtRM5yi35JKjdvvHn6hoCPNRGNrriT6TUUJtDr2e5SkDwZj9zEt7/7c0sGDzFuunyHfn
         4VRq4bCKQ9+1kK11K/+wKfdCdRHBxaVtfxMjoxsqQudECFE2YtFt7dybmyRtrHczKmUR
         cr7IqBuJOthTZmjG1j+D++2DeRodv4RX7DdQe8l3Z/TiaBSVY3HmRU5lh++KklnKw/4L
         jSLA==
X-Gm-Message-State: AOAM530r8h//SmUQxjQJf0mmIWvfhIqPAYlx96VzqCY6mwgz+BexTrG7
        cSs5WYzpKfx/oWoVwJ6uWaR0HBnw6OEIPw==
X-Google-Smtp-Source: ABdhPJxff3tR4yY7sdTwZtTCRQzRKpJpoAOfT1Sx3ddOtQYaR9khz9GX9EEwNWkAQweH7dTTixPKOQ==
X-Received: by 2002:a17:902:b785:b029:eb:7a1b:5016 with SMTP id e5-20020a170902b785b02900eb7a1b5016mr1684048pls.51.1619147922248;
        Thu, 22 Apr 2021 20:18:42 -0700 (PDT)
Received: from atulu-nitro ([171.61.238.200])
        by smtp.gmail.com with ESMTPSA id x14sm3484694pfo.171.2021.04.22.20.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 20:18:41 -0700 (PDT)
Date:   Fri, 23 Apr 2021 08:48:34 +0530
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mchehab@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: gspca: stv06xx: Fix memleak in stv06xx subdrivers
Message-ID: <20210423031834.GA3338@atulu-nitro>
References: <20210422160742.7166-1-atulgopinathan@gmail.com>
 <20210422215511.01489adb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422215511.01489adb@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 09:55:11PM +0300, Pavel Skripkin wrote:
> Hi!
> 
> On Thu, 22 Apr 2021 21:37:42 +0530
> Atul Gopinathan <atulgopinathan@gmail.com> wrote:
> > During probing phase of a gspca driver in "gspca_dev_probe2()", the
> > stv06xx subdrivers have certain sensor variants (namely, hdcs_1x00,
> > hdcs_1020 and pb_0100) that allocate memory for their respective
> > sensor which is passed to the "sd->sensor_priv" field. During the
> > same probe routine, after "sensor_priv" allocation, there are chances
> > of later functions invoked to fail which result in the probing
> > routine to end immediately via "goto out" path. While doing so, the
> > memory allocated earlier for the sensor isn't taken care of resulting
> > in memory leak.
> > 
> > Fix this by adding operations to the gspca, stv06xx and down to the
> > sensor levels to free this allocated memory during gspca probe
> > failure.
> > 
> > -
> > The current level of hierarchy looks something like this:
> > 
> > 	gspca (main driver) represented by struct gspca_dev
> > 	   |
> > ___________|_____________________________________
> > |	|	|	|	|		| (subdrivers)
> > 			|			  represented
> >  			stv06xx			  by "struct
> > sd" |
> >  	 _______________|_______________
> >  	 |	|	|	|	|  (sensors)
> > 	 	|			|
> >  		hdcs_1x00/1020		pb01000
> > 			|_________________|
> > 				|
> > 			These three sensor variants
> > 			allocate memory for
> > 			"sd->sensor_priv" field.
> > 
> > Here, "struct gspca_dev" is the representation used in the top level.
> > In the sub-driver levels, "gspca_dev" pointer is cast to "struct sd*",
> > something like this:
> > 
> > 	struct sd *sd = (struct sd *)gspca_dev;
> > 
> > This is possible because the first field of "struct sd" is
> > "gspca_dev":
> > 
> > 	struct sd {
> > 		struct gspca_dev;
> > 		.
> > 		.
> > 	}
> > 
> > Therefore, to deallocate the "sd->sensor_priv" fields from
> > "gspca_dev_probe2()" which is at the top level, the patch creates
> > operations for the subdrivers and sensors to be invoked from the gspca
> > driver levels. These operations essentially free the "sd->sensor_priv"
> > which were allocated by the "config" and "init_controls" operations in
> > the case of stv06xx sub-drivers and the sensor levels.
> > 
> > This patch doesn't affect other sub-drivers or even sensors who never
> > allocate memory to "sensor_priv". It has also been tested by syzbot
> > and it returned an "OK" result.
> > 
> > https://syzkaller.appspot.com/bug?id=ab69427f2911374e5f0b347d0d7795bfe384016c
> > -
> > 
> > Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New
> > subdriver.") Cc: stable@vger.kernel.org
> > Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
> > Reported-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
> > Tested-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
> > Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
> 
> AFAIK, something similar is already applied to linux-media tree
> https://git.linuxtv.org/media_tree.git/commit/?id=4f4e6644cd876c844cdb3bea2dd7051787d5ae25

Oh, my bad. Thanks for pointing it out. The syzkaller page of this bug
hasn't been updated. I will send an e-mail and mark it as fixed.

Regards,
Atul

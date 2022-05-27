Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9655368EE
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 00:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiE0Wim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 18:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiE0Wil (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 18:38:41 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B75562130;
        Fri, 27 May 2022 15:38:37 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-f2c296d320so7382278fac.8;
        Fri, 27 May 2022 15:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k3Y4avxoaaKPGPle+GNBPWTChiAPZ6ALAr72jSGIW10=;
        b=m8Y5rMgamx/hT+UG/gbLqMrP54vi0TOb0g5Pk2elATpz8YW2/wperpxnVtxpd4gIDb
         xaVKH6DA76/AviRLJYQCjDA7NiUOOsINplfsoZUvbaqvS6WJYDLZn8JwGJ1NubSzFxUq
         giNtCNH0cjR6ccP5KXsPnKkfAsVjhoo6LPzy/0TwGvIM7MopfDU+Gjjs4oNSoediADBx
         KgduGxVuzAJGzhtYZ2qK/IKP/sKp/cqqi0TFlmASnny8a17+CfQ0o5r2RH7gHnfexfNO
         IdaEFtjOEBX8o5kvxss5FNNBbn3+y+RmmYzRtp9rqkTzJ2T411YlqedRin34AS/xlyMK
         Vevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=k3Y4avxoaaKPGPle+GNBPWTChiAPZ6ALAr72jSGIW10=;
        b=xBTlLGl/24fqzrtSM0e+ffY4V0AuirklnqGJbYF67NP4cMw7JXaP/xgsgixDmcbGhh
         AqMQft7GDulQQPJxIYY3xsrXx/5z4B4l3aenkYQA01Rfu/N1BRrHHlLPj/U71pfREXl+
         RS8gdkFWtbwS3oEM8rmAhT9vENAr2HQE1STil9h3vWQsMtPR9dPKO9U/xwQWZ8Vvw3rH
         YXzoqgY4Im6mWFJ0N6v+y1rQ7XWnhnO4p1WkeUjYJ6xN4YIvH6MZseKTg0u45Qw6Nfrr
         WcimO0RiSDPXFgBLGp/RVxm8EZkGcVUDY8gkgM80s778wlstkNn5swgFiKjb++44oy3c
         Cl/w==
X-Gm-Message-State: AOAM531+JrgrBCn4OyXnVHaAUMfe5J6ynHHQ8bpT9chefJWxAVKZGu6v
        7V+3yVLT7/cdL8RwfYKH3L6ehO8Wjy9/bw==
X-Google-Smtp-Source: ABdhPJytWw5RLHSyyTjicayYEhMX9aOn90YdL1tPdSZJb2JL0KnEfFJzboTFhaN/tI0e7Di1GUF/sA==
X-Received: by 2002:a05:6870:c152:b0:f2:c400:e583 with SMTP id g18-20020a056870c15200b000f2c400e583mr5095834oad.159.1653691115856;
        Fri, 27 May 2022 15:38:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p14-20020a9d4e0e000000b0060b39282e7esm2311826otf.35.2022.05.27.15.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 15:38:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 27 May 2022 15:38:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Chris.Paterson2@renesas.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
Message-ID: <20220527223833.GA3166370@roeck-us.net>
References: <20220527084828.156494029@linuxfoundation.org>
 <20220527141421.GA13810@duo.ucw.cz>
 <YpD0CVWSiEqiM+8b@kroah.com>
 <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
 <YpE+S2H301IsZYzv@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpE+S2H301IsZYzv@zx2c4.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 11:10:35PM +0200, Jason A. Donenfeld wrote:
> Hi Guenter,
> 
> On Fri, May 27, 2022 at 09:59:14AM -0700, Guenter Roeck wrote:
> > Given that we (ChromeOS) have been hit by rng related
> > issues before (specifically boot stalls on some hardware), I am quite
> > concerned about the possible impact of this series for stable releases.
> 
> The urandom try_to_generate_entropy() change from 5.18 wasn't backported.
> 

Was it not backported on purpose or is it missing ?

Thanks,
Guenter

> zx2c4@thinkpad ~/Projects/random-linux $ git diff linux-5.10.y:drivers/char/random.c master:drivers/char/random.c
> [...snip...]
> @@ -1292,6 +1311,13 @@ static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
>  {
>         static int maxwarn = 10;
> 
> +       /*
> +        * Opportunistically attempt to initialize the RNG on platforms that
> +        * have fast cycle counters, but don't (for now) require it to succeed.
> +        */
> +       if (!crng_ready())
> +               try_to_generate_entropy();
> +
>         if (!crng_ready()) {
>                 if (!ratelimit_disable && maxwarn <= 0)
>                         ++urandom_warning.missed;
> 
> 
> 
> Jason

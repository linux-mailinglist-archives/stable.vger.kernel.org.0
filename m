Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF28536B06
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 08:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349008AbiE1GDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 02:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345565AbiE1GDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 02:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34E0E89;
        Fri, 27 May 2022 23:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ACC66006F;
        Sat, 28 May 2022 06:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841F9C34100;
        Sat, 28 May 2022 06:03:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="K0OIAWzO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653717813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GF7VjLFgiF5zpZMXcSFyff94LimgXWs95WRATQEPxYA=;
        b=K0OIAWzOqREoXV9uGyMOvgB9b3b4MKsd7E0R7IdiEAhnAxGWy/Nw7IrtjgEoS45IlY3GVg
        HfGMR0igEsV9VNvqIwRAJd5syulQWm+501dqvMp8Xry/N6g448HDjhDyxEa4WLFzgpto0J
        KLoI7wtPPm4PY/9ZGuw0tjsUWOyeaE8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bccbbaf2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 28 May 2022 06:03:33 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-300312ba5e2so66819067b3.0;
        Fri, 27 May 2022 23:03:32 -0700 (PDT)
X-Gm-Message-State: AOAM533sX327+L83sWenjLaQENk444s/4aev3yqGERjYXz420IEWYlgq
        LMTsnF8TTCFwGvv13K7sNUJKTWVCDcUe8qWcCAU=
X-Google-Smtp-Source: ABdhPJx7kIdKfof/beGFj7bZoDoFCT+m+IGoZWZAq4FGS7cKeiLX9j0Z6DV1TlAe6vL1n0gnzC/HhlozxgVDZ8q7uF4=
X-Received: by 2002:a0d:cd04:0:b0:300:4784:caa3 with SMTP id
 p4-20020a0dcd04000000b003004784caa3mr19079647ywd.231.1653717811259; Fri, 27
 May 2022 23:03:31 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:6403:b0:17b:2ce3:1329 with HTTP; Fri, 27 May 2022
 23:03:30 -0700 (PDT)
In-Reply-To: <20220527223833.GA3166370@roeck-us.net>
References: <20220527084828.156494029@linuxfoundation.org> <20220527141421.GA13810@duo.ucw.cz>
 <YpD0CVWSiEqiM+8b@kroah.com> <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
 <YpE+S2H301IsZYzv@zx2c4.com> <20220527223833.GA3166370@roeck-us.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 28 May 2022 08:03:30 +0200
X-Gmail-Original-Message-ID: <CAHmME9pPc12jRM4rbuE1Z=TjMg3YdWr3g1dJfifi1YjLQqUdDg@mail.gmail.com>
Message-ID: <CAHmME9pPc12jRM4rbuE1Z=TjMg3YdWr3g1dJfifi1YjLQqUdDg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Chris.Paterson2@renesas.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/28/22, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, May 27, 2022 at 11:10:35PM +0200, Jason A. Donenfeld wrote:
>> Hi Guenter,
>>
>> On Fri, May 27, 2022 at 09:59:14AM -0700, Guenter Roeck wrote:
>> > Given that we (ChromeOS) have been hit by rng related
>> > issues before (specifically boot stalls on some hardware), I am quite
>> > concerned about the possible impact of this series for stable releases.
>>
>> The urandom try_to_generate_entropy() change from 5.18 wasn't backported.
>>
>
> Was it not backported on purpose or is it missing ?
>

On purpose, on account of the concern that you expressed. Hence I
mentioned it in response to your message.

Jason

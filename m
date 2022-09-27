Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADAA5EC5C0
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 16:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiI0OTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 10:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiI0OTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 10:19:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11BD1BEA41;
        Tue, 27 Sep 2022 07:19:29 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v4so9520058pgi.10;
        Tue, 27 Sep 2022 07:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=1k+WbA5Peo/QB6AV3gjOxaZe9lawD0esmwFLYqlz13Q=;
        b=VXpKNUMhgO6/1cMl1MdGwit2h3KRk7yEPnyWbHUNxdsB4S9G13wQeQA/1CtZ44NdGo
         vXmYAXBVv+Roy6l1fUs1DUyxiYV3LrHKIql9Q+Qh2/HTFIPdlwQhe42s7wxJNa0oOteV
         tS+xcwrVEiW3qd3LnS0/uvRQwDULvMb8iBY7UO5XdkjRiZJT1N4RYSKlfLXcav4Ad4MT
         4LMuZqY5emI535uZDpVfJqcQUb6ak9D7sT4AY2PyGIFcfZbDC3SigfTLSMML687rRvcp
         gD3hjDZnZ4S8WF0SZfykEWkB5uzVvl9GcP/0tsdhEMqiSHWf6nG8w9SOpSOibTiSDstI
         MYVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=1k+WbA5Peo/QB6AV3gjOxaZe9lawD0esmwFLYqlz13Q=;
        b=fzlt9cjNsIJb8Go+zCPb12MEgFZJfsUzFf22lajZo5vXjYPtOh43HP0B6C15MGUKPw
         UAfkOaG5oxnO8can4VCBJlJslT2ZEg1H1yQIRezcU8J0CiqzaPqDiEMz7ljWCO6sgGVg
         KqDmHnAGVm8G9R71KemsVk5o/lSLtaw1UvwKJOsd4y/GQF22UbRf0sjfJTtTaMzoiE2c
         zzmadlUWCFj6Xya7zTjBm4KgfK1PQzCaD8CxvHY766U6wtHZUY1WIQx/RLDUZDlSFDpK
         QatKlcbQ+wFf438pQ+Axn650pyYtWsG9BDHUejCryVs4vnV+z5yh/YM5LhEatJdsTYGN
         hcNQ==
X-Gm-Message-State: ACrzQf1Wh66TQTyXTyvx312WeM1gT+wOdlcb21HD/zI1Cy/deZwdbkdv
        HzFzNPFl92quz4vZCHIoFSg=
X-Google-Smtp-Source: AMsMyM6u3nhKLNRBUfSuIEdCJXHIZoy9gc8LkWwDQUvOtQLkMWWylN7Az3QFYQ8y0L3hgJewM+mrXg==
X-Received: by 2002:a05:6a00:158f:b0:546:b777:af17 with SMTP id u15-20020a056a00158f00b00546b777af17mr29208355pfk.51.1664288368922;
        Tue, 27 Sep 2022 07:19:28 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:9739:ab49:3830:2cbb])
        by smtp.gmail.com with ESMTPSA id r11-20020a63ce4b000000b00438c0571456sm1584446pgi.24.2022.09.27.07.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 07:19:28 -0700 (PDT)
Date:   Tue, 27 Sep 2022 07:19:25 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc:     linux-input@vger.kernel.org,
        Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org, kernel@puri.sm,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, stable@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: Re: [PATCH v2 RESEND] input: keyboard: snvs_pwrkey: Fix SNVS_HPVIDR1
 register address
Message-ID: <YzMGbUQz4YPM5diz@google.com>
References: <4599101.ElGaqSPkdT@pliszka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4599101.ElGaqSPkdT@pliszka>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 08:25:12AM +0200, Sebastian Krzyszkowiak wrote:
> Both i.MX6 and i.MX8 reference manuals list 0xBF8 as SNVS_HPVIDR1
> (chapters 57.9 and 6.4.5 respectively).
> 
> Without this, trying to read the revision number results in 0 on
> all revisions, causing the i.MX6 quirk to apply on all platforms,
> which in turn causes the driver to synthesise power button release
> events instead of passing the real one as they happen even on
> platforms like i.MX8 where that's not wanted.
> 
> Fixes: 1a26c920717a ("Input: snvs_pwrkey - send key events for i.MX6 S, DL and Q")
> Cc: <stable@vger.kernel.org>
> Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

Applied, thank you.

-- 
Dmitry

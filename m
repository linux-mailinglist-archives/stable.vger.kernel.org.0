Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBC6EE5B5
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbjDYQ1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 12:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjDYQ1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 12:27:38 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E540D3C0A
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 09:27:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-2f4c431f69cso3643390f8f.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 09:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682440056; x=1685032056;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ThXNwWJ5kvGSUlG1mhiS7f9U8bFnCped+QeJMpdW98E=;
        b=ekZsjRN9FcQ2zVLed+4Az2S4gbJ+wK2XeaK4kISzZDy7scWEw2GgXU9qWsTdDHcbD0
         WJVDwns+TAntcpxUSei5URv20LB50yvX52ZCof9+EfJZgErbafS4xa8keFfk9T5GOKX3
         pmzL7LBjpoT1lUengSFRWiPxqPoidl6Dq6XJ1RSiU8d0NMLG4Dz/Am9eMylIu1nj73s4
         AhpfOFdckUxyhh+sHpb8IyIebKnUv7/N7YfS3XrPGGlF8qiIFr/YMRAb65eGi1/jN8bY
         +4tPyYWzlQyZ+yM1Kkk90sLnmcZJww65jPd/t+05b4z3M0o04qxxYE2EuLVwOQK3cigM
         YE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682440056; x=1685032056;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThXNwWJ5kvGSUlG1mhiS7f9U8bFnCped+QeJMpdW98E=;
        b=gKJPuE6ujg+zoybh9awDu8u0ztJlBNlYxi8TUOahQYIIxLqX8f/n12gAET41qH1M05
         9qaI3VICHG0wDt1XrWgHlpNZDbCnnx6NGJaV5yon/QZS/0c+5uAhwjFdl2m4/DPYY+O+
         evQzWBfarRfEae6IAkNaUAHVgEMjfKjSS2rXmwnAUCBfFPn8vTbO7W5euAq3jMNPNJYa
         oZjHVhi12SQPBaFup/lef2wcXmKOOGsN5dIhjuNk6yu2pkO/s+VIr9Su/FGq2iO7zDu7
         ALXN9eRDZ4yVGry/nJymTJWULXqMqODKo4I85iPSazCxxg5LLo1Ea1OOcEYMDSy8MjC7
         qoIQ==
X-Gm-Message-State: AAQBX9cZmEOXKXnV0h3eCAJQzJ8Hh5DWlYyTV3t92zFcMMcF8hqqYcsL
        fCQaWFVnXuzFVzARz3m6HQUTAepafc+a792L7Kw=
X-Google-Smtp-Source: AKy350bOGKh4R3VOmUemF6T6xwElLCjcW2eh35Oc0RNnfuRlLDGyEmRodawFRL+lBxyC87yNvyNBcYY7Pe/ReBtTGuM=
X-Received: by 2002:a5d:4147:0:b0:2fe:e137:dbad with SMTP id
 c7-20020a5d4147000000b002fee137dbadmr14453171wrq.51.1682440055885; Tue, 25
 Apr 2023 09:27:35 -0700 (PDT)
MIME-Version: 1.0
References: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
 <ZEfoC9UDzniw6mo_@kroah.com>
In-Reply-To: <ZEfoC9UDzniw6mo_@kroah.com>
From:   Kristof Havasi <havasiefr@gmail.com>
Date:   Tue, 25 Apr 2023 18:27:24 +0200
Message-ID: <CADBnMviZ4Q3LpUUfnGYrM6aiPQFLD6ohC1qjetJp0RcDGTTYsg@mail.gmail.com>
Subject: Re: Does v5.4 need CVE-2022-3566 and CVE-2022-3567 patches
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Apr 2023 at 16:47, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 25, 2023 at 04:08:30PM +0200, Kristof Havasi wrote:
> > Hi there,
> >
> > I was evaluating CVE-2022-3567 and CVE-2022-3566 which both
> > revolt around load tearing and reference an ancient Kernel commit:
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >
> > I am not sure whether they are applicable to the v5.4.y branch as well.
>
> I do not know, what specific commits are you referring to?  CVEs mean
> nothing, they are not valid identifiers, sorry.
>
> And have you tried applying them to the older kernels and testing to see
> if they solve any specific issue?
>
> Or better yet, why use the older kernels, why not stick to the most
> recent one?  What is preventing you from switching?

Thank you for the quick response!

I meant the following commits:
f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 and
364f997b5cfe1db0d63a390fe7c801fa2b3115f6

The v5.4 kernel is used in an embedded device where due to certification
processes a quick upgrade of the Kernel isn't realistic until at least
another year.

The patches are quite small, I could cherry-pick them on the latest v5.4 tag,
and the kernel builds... only for
f49cd2f4d6170d27a2c61f1fecb03d8a70c91f57 USER_SOCKPTR
isn't available in 5.4, so I sticked to `char __user *`.

I will get a device tomorrow and try whether I can netcat between them
via IPv4 and v6.
Any other tests, which would be needed?

Best Regards,
Kristof

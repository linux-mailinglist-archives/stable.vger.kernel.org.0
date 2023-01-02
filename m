Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE7165AC94
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 01:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjABANQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 19:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjABANP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 19:13:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC05F38
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 16:13:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id i9so38067303edj.4
        for <stable@vger.kernel.org>; Sun, 01 Jan 2023 16:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mteC07Bn6RQTXsg3Wfwpvg5tP0U+esoeXxxYnZXRRg4=;
        b=gK3ZFM2yrgRvX7wkYLIoAnK/S7TvWbEvbIISVssJqBE4yPF7qQ6M6IhjgCTOll2DJs
         7D+ZlNDz2oGnTcu5gvPMyGR1jAe2JmBZ2vx9DAdVTIyhVwjPFSOLVY0aCggn9ehAh/3o
         SFcZx59gogHrNSsMZwwl7LuMDb/Ln8Rq8kJu7GV/00sQtYS3k/eoISf3vpmcZUzoH+Ns
         w6bWS+v/73xK86VHjolrwOG1DdvUeRjpfu4roqXk1OA5WvUUXkGehwTCxnO6AEFXZtpJ
         vsAaOCLf9Pe0897pNMDIjeGomvJxoAa+Qb7PFbslSca01lMh5qgtHiOzmjeC4W79ScAC
         hldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mteC07Bn6RQTXsg3Wfwpvg5tP0U+esoeXxxYnZXRRg4=;
        b=Eb8Vdu6DC9Dq1HIvOPudUbmKKrQ0zZq2H2TuBhad4fiQwTZ/yBVv8wvGFHIH53pVjf
         TdYJcbvXNEZSlnEoH+1lw/P5W0REtcj1AZzH4gippf5R2ZL34jffjMOse1twQlGKELzn
         q4xngKKztvSM6x793yPa+qTHXIz2UnWVzZfwUDv657+pqFRqDZT+je3dMk2Gg5CSkv4R
         NOPJR/ZYiXP6QRmoxzBjNq8jOEcv5x9jbgXA8gOQ4PCJC8R7xXAQMJUgyE2ozW8IId6c
         FH8yOcwo9w11DoMuNP7PKTOxJdb0f5wC0jlcTS81ycxWT72TXTo9brqgNJhRGLHDRj0A
         VeOw==
X-Gm-Message-State: AFqh2koBy7QhfQ69oec/xS6tmELAxBccjUqy+dl1Q6Eqt7m7t4fmirqS
        s/GqBF7tz675G2n1iVcA+3o=
X-Google-Smtp-Source: AMrXdXuxgoTmb+/b9swIOblOZF+D4kCUAp/Sr/7ZH3rY1WlWDrY8q77iJZgTdX+pJzkfACJbVO1TsQ==
X-Received: by 2002:aa7:c659:0:b0:48c:7e42:844c with SMTP id z25-20020aa7c659000000b0048c7e42844cmr5269081edr.10.1672618390818;
        Sun, 01 Jan 2023 16:13:10 -0800 (PST)
Received: from poseidonas.localnet (213-10-96-25.fixed.kpn.net. [213.10.96.25])
        by smtp.gmail.com with ESMTPSA id p22-20020aa7d316000000b004643f1524f3sm12055692edq.44.2023.01.01.16.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 16:13:10 -0800 (PST)
From:   Pavlos Parissis <pavlos.parissis@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        =?utf-8?B?xYF1a2FzeiBLYWxhbcWCYWNraQ==?= <lukasz@pm.kalamlacki.eu>
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Date:   Mon, 02 Jan 2023 01:13:09 +0100
Message-ID: <2519789.f74NuczQXU@poseidonas>
In-Reply-To: <4c7bdbc1-0337-9cf2-8957-94a5f702a49c@pm.kalamlacki.eu>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu> <Y7FefVRwIQZWUosS@kroah.com> <4c7bdbc1-0337-9cf2-8957-94a5f702a49c@pm.kalamlacki.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday, January 1, 2023 11:38:36 AM CET =C5=81ukasz Kalam=C5=82acki wrot=
e:
>=20
> On 1.01.2023 11:20, Greg KH wrote:
> > On Sun, Jan 01, 2023 at 10:12:12AM +0000, =C5=81ukasz Kalam=C5=82acki w=
rote:
> >> Allright, my kernel config is available here:
> >> https://kalamlacki.eu/KERNELS/kconfig-6.1
> >>
> >> Compilation on 11th gen i5 core cpu using command:
> >>
> >> make -j 9 bindeb-pkg
> > As we have both stated, we are not the people to be discussing this
> > with as the kernel source is not the problem at all, so there's nothing
> > we can do here, sorry.
> >
> > Have a good new year!
> >
> > greg k-h
>=20
> I am aware Greg that this is not kernel release issue and rather gcc but
> it occurs during kernel compilation and many people can have this issue
> too and that is why I am discussing about it here.
>=20
> Willy: Debian stable has gcc in version 10.2.1 as states my buildinfo
> from compilation of kernel 6.1.1 as it can be checked here:
> https://kalamlacki.eu/KERNELS/BUSTER/linux-upstream_6.1.1-1_amd64.buildin=
fo.
>=20
>=20

I had the same issue with you as I am using Debian 11 (bullseye) and follow=
ed Willy's suggestion to use the toolchains available on https://mirrors.ed=
ge.kernel.org/pub/tools/crosstool/, that solved my problem for compiling 6.=
0.16 version as well.

6.0.X kernel versions are already available via backports, so I think the f=
ix to GCC version, that bullseye utilizes, will come to bullseye quite soon=
 as the kernel package maintainers will see the issue when they will try to=
 release 6.0.16 version to backports.

This issue was a strong reminder for me to switch back to the toolchains fo=
r compiling the kernel. I do acknowledge that it is quite convenient for us=
ers to just use the GCC that is available from the distribution but using t=
he aforementioned toolchains ensures a smooth experience with compiling the=
 kernel.

My 2 cents,
Pavlos






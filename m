Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767CE6ACB31
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCFRsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCFRsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:48:51 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198A3433F;
        Mon,  6 Mar 2023 09:48:11 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id c19so11421221qtn.13;
        Mon, 06 Mar 2023 09:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678124858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p1eWPKJ51eNrRfxr8qpuMzBvGQcCgHtk6iQFk59WM4Q=;
        b=kU6ZdNt4/JNsj5FLXVbb6eSpPM6wvFVtR+1XIOxFAz9rylhl4Clv+MaMsvMnhAEG+1
         73a/PEjugV8ItdHRKPv4qEGEs0QV6KYWNM8h1I5ueexEhjEKla96FEl1i2xmijBwdgNO
         0FQ2WqUN/tbJbN94M2whMpPqaEPd5WBca8RT7pWVGg/oO7/Hp9NhlSuU1IF+F9Kxd+Jt
         Pb8oiBGq6yCoSZtTlSc9f/4Q2KB4YQxizsqU7olT+eJ3jOLQ0LsSGZGmNqq44foHK5ed
         MVLPcsRwJU+uDTkjTizZPxZU0YDpFm68U3uDYxk3F/S+H+jSpJnnk+wFWGK8/6sGVZC9
         JqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678124858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1eWPKJ51eNrRfxr8qpuMzBvGQcCgHtk6iQFk59WM4Q=;
        b=5GYI4G10cgc7DMeaficWGON+0m3xkEDXgZBjjK4bGOrP7OIjRav01phlcQdGb6IW75
         8lFn4AhIkfLcFF3Re6KNLUBAngTTefFXPLWW5IdUEmLYrHiYyq0T+eHNlOfMpSQ2PXzt
         qyYU2wc5Qih783AY96VgYgy6UhI53fyc1WLT0Y42c1Du9/Q8zLcVHwt5d7LKjR4QFe3p
         b59QDc4fXyRCz7Xlw8z654LGa20T5HBhdzrkPh4NbdvCr8JK8pL1SKR+L8oFm05AhCpo
         G1Xy9eYSTuLhGtWXXmtaTUiCi5odv3QAIsSa4Dr4n46onAo7np/fyv3UibbFAt95IYM7
         mv1Q==
X-Gm-Message-State: AO0yUKWJ4rTs/B1/Pd6nY3OlgHFwqU3B+/70gXwR8FaAr13UUsPVTR35
        pZxFY9HA7y3Tc5BV3Ja6VZ8=
X-Google-Smtp-Source: AK7set8j8NYHOzIg2YdsTAT6Tz9KFRAPslskDrFAAN58RYGKSTcYRAAey1lBpiMdZD2wEXVAi1UweA==
X-Received: by 2002:a05:622a:8:b0:3bf:cfa6:55a1 with SMTP id x8-20020a05622a000800b003bfcfa655a1mr20480979qtw.12.1678124858595;
        Mon, 06 Mar 2023 09:47:38 -0800 (PST)
Received: from mjollnir ([137.118.186.11])
        by smtp.gmail.com with ESMTPSA id s184-20020a372cc1000000b0074235fc7a69sm7807445qkh.68.2023.03.06.09.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 09:47:37 -0800 (PST)
Date:   Mon, 6 Mar 2023 12:47:32 -0500
From:   Storm Dragon <stormdragon2976@gmail.com>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Iurii Zaikin <yzaikin@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Request to backport "sysctl: fix proc_dobool() usability" to
 stable kernels
Message-ID: <ZAYnNEimr6WwoWEl@mjollnir>
References: <20230210145823.756906-1-omosnace@redhat.com>
 <9563010d-a5cf-49e2-8c51-f2e66f064997@t-8ch.de>
 <ZAQDxbTlaIoKb9yB@mjollnir>
 <09ee7747-3038-4d6c-b063-f0349fa52b6e@t-8ch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/j6BFlRkvo3AYZi8"
Content-Disposition: inline
In-Reply-To: <09ee7747-3038-4d6c-b063-f0349fa52b6e@t-8ch.de>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/j6BFlRkvo3AYZi8
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 05, 2023 at 03:06:12AM +0000, Thomas Wei=C3=9Fschuh wrote:
>Maybe it would also make sense to open a ticket to ArchLinux to enable
>CONFIG_LEGACY_TIOCSTI again, as per the kernel default.
>
>In accordance with the options help text:
>
>"Say 'Y here only if you have confirmed that yout system's userspace
>depends on this functionality to continue operating normally"
>
>Could you create such a ticket if think it's necessary?

The ticket has been created. The link is:

https://bugs.archlinux.org/task/77745

Thanks,
Storm


--/j6BFlRkvo3AYZi8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEjjImGMhZhYoKESBfW+ojcUPdwZMFAmQGJzEACgkQW+ojcUPd
wZMN6w/+L7tA7xu1mricIdiBEVjlUlfhOfOaYN9Mzy0JJyPtF5sYhyBx9eozJzqp
LIdDqKx5Vn4rgpE9sGaCEWayLP+4YpHgpitkuZCiUHR5vfeOn1r7iqwKPx1qetPZ
S4LYFqSnZLgM1V29X1WG4JiJ6ek7fLwGEroohnvzUZSoDbGvGAPqeCd1fl0OZq3o
EabBruycpoA9v10aw7ImL0hqtwKQQkDSvaazwAstQDRTyU4iB8SagU0Qntbzf09S
d4WGSMnP2zXR57L1UlyD4uW143WICS0yB7V3aKUu+NZtdZfuh+fKyz4eWQ93aVYm
n/PizuO49lAiJmw1pr0QdiKCyTzpH0Uqt+XW42PRMXANQ788oXtDhZWyhEwvgqru
cQdbf4rmSU8Krt2C1MqrZwlMXCMBn8kaM0Kt6SxbuOR8NttibVi4idkGLHtJmSdN
mJ8FA8MAE0HlIL6mSQhflCOJtfFiVdAeWrQ2/8FIew+A2TDMn4c943Ab9ycmWoUy
iFOe5VKjeM3pQXMZ1c16wI9UtSeyBt7UdTYL/5I+uZtSFosFAM0psokenxkkh/pO
W0GumhF9xXF1OQEzVJF1YRbH89ia7VgCo0uSnOJ8j3T6ib51gBHCQsWt5hgUQr9d
XlJ4YarcAU7aFqflr1koKlMib5Yv8bvxEgQBpAvPY7DDnRvyoQk=
=w2CO
-----END PGP SIGNATURE-----

--/j6BFlRkvo3AYZi8--

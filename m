Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167CA6AADEB
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 03:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCECvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 21:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCECvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 21:51:54 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EABBDBE3;
        Sat,  4 Mar 2023 18:51:53 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id s12so7114866qtq.11;
        Sat, 04 Mar 2023 18:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677984712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ssCYvtaMVUQ0bmw1fetXjwle40pFXJeB7ey4NrJBqrQ=;
        b=L/9CcqJZ7Y5BAl0Ax9MPPhrNlQgvW3zEkoD4r82QJJquzpLd6cqCyGtFASHbyoxEaN
         Kq4g/JSvx25DUFqHEn6PdTiz/ZNmv+0KrVTUWX6DdWKVObnUT+/JkEJd6LITLSpHteTs
         yegG3m2mV4lnjr9N0h4Ymteef5GniACR1FOETLPr5pP92zJFVCYjwm6pSFV8xT14p5q/
         BklZD+qpaufBMqHvRwvBVJZ5I5wrULchn0dXS2LLShNORtX9KWYxQtcKV0i0I6L2/Mat
         oCxVrMFLj9cy02yk/7VaYyqDv3IkNAYpngDM6CoBNKgZY5oqLfZpiH/sgp3WkXgt2/b+
         uxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677984712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ssCYvtaMVUQ0bmw1fetXjwle40pFXJeB7ey4NrJBqrQ=;
        b=veV/Ytb8Kor5UtoJ0XVli64oDZNHiZ/toai+aMZBwrGE+yzfPXQw28ouT80T5lKgQs
         urYoK2uGBiE8WMbktGrpxod/1bbOSQmAyAHYPXMk1q2LcyiyeWrQ0GjjUzBjddXRbtzn
         Nok0c90IV4uKyEqAbYmelin/asHTNbTA+9y/j/IceftIxoaVUikm3OSI2iIPzOEQyVnr
         j0VeBvkcRdRoLQg+br164E7UdkPvm7ewfLJVe7olX1mZq5wqHGe/vVK2xqrUsY77Iwy4
         kqC92xAzsXqhGug/P3b8x+xXbut8h2xJnwsN1anAukxq6dok8aqCuaqZkbk2lVlGaTJe
         jyZg==
X-Gm-Message-State: AO0yUKW0h7WSLOBdnxlcK4Ibkq9jMM58DjiSuVz5RJYu12PIzRhZmG0H
        gYNbHMfADqJ2Dx69YeeeUGI=
X-Google-Smtp-Source: AK7set/VqxZ7BmSwhGh+efpD8a+Y30Joz0UpEE4EGI/VqfPjIzhq+yGFK6IS8axEZ03yCT2gRGSumA==
X-Received: by 2002:a05:622a:34d:b0:3b8:6c8e:4f85 with SMTP id r13-20020a05622a034d00b003b86c8e4f85mr12249702qtw.43.1677984712374;
        Sat, 04 Mar 2023 18:51:52 -0800 (PST)
Received: from mjollnir ([137.118.186.11])
        by smtp.gmail.com with ESMTPSA id m18-20020ac866d2000000b003bfbfd9a4aesm4832188qtp.56.2023.03.04.18.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 18:51:51 -0800 (PST)
Date:   Sat, 4 Mar 2023 21:51:49 -0500
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
Message-ID: <ZAQDxbTlaIoKb9yB@mjollnir>
References: <20230210145823.756906-1-omosnace@redhat.com>
 <9563010d-a5cf-49e2-8c51-f2e66f064997@t-8ch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UVi+2tY/WTbx02tm"
Content-Disposition: inline
In-Reply-To: <9563010d-a5cf-49e2-8c51-f2e66f064997@t-8ch.de>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UVi+2tY/WTbx02tm
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 05, 2023 at 02:18:11AM +0000, Thomas Wei=C3=9Fschuh wrote:
>This ioctl is used for the copy-and-paste functionality of the
>screenreader "fenrir".
>( https://github.com/chrys87/fenrir )
>
>Reported-by: Storm Dragon <stormdragon2976@gmail.com>
>Link: https://lore.kernel.org/lkml/ZAOi9hDBTYqoAZuI@hotmail.com/

I believe this will also cause some loss of functionality in brltty as
well:

https://brltty.app

--UVi+2tY/WTbx02tm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEjjImGMhZhYoKESBfW+ojcUPdwZMFAmQEA8EACgkQW+ojcUPd
wZPc2Q//a9VEtvVqYy4h12/VmQ3O8jFGugQlKeslrPQiks3i3MyA0xyfcLPa1ukW
89GU9S/vCOd+WKiatL2dd9kJ5DrK46i/N5k4LcENUShOtfgmoIjwAsM9G8/mnve6
Kg3l6O7JXbZMBJSn1nbvD4+iT7tS5Kfxe07JpKXAX0ihKutQTVN8PLdWs5OFDlAq
vdRARVyI6rk0crAAinbx04rnQeOYeEl31eGlJ/zRg/MytdlMHVur/8uCpcf/sWoa
RtKRVQDqgBiuM63cEhxpBwXWGzqwsGjjmQ3kBqNFtNm5y4dgKrmnoCcm5RCeVm00
LYL6zUOVZdkKKcyI/C1Nvt2b9/ULW21HtOYpXnpHNpNwFdrNZTJ9Zx3UBWR60/uY
0V5nSC0ne/CDrbGnDj9wYLGxc7YxJ3WJbSxuh3hMmbURerlaAfMB7x8yNWawCZSB
UNLXoNxTy6swYiIR/7FWXb70ocO/e2UYz8/ahAiCABx1r9gkUtB0fo/+27u8HstF
Q/S+mWez7542dHYtEAUMcmEEFTVaU+7sq5teGF826mZUTHYsr1sdVT9vM866QTZ8
r3OlKIvU+1jNo/BjNQuHkf5ESkF6arimGj0oKmF/p9uiSriWLvtmHnr/L7MmmA2v
XhX6SU0SA+JGI9lUlPmYHMgaQtgRu7vXOd/l/Rp7DBzY4eI+S7w=
=Z8di
-----END PGP SIGNATURE-----

--UVi+2tY/WTbx02tm--

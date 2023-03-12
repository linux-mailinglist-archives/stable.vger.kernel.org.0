Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D646B65F6
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 13:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCLMcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 08:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCLMcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 08:32:35 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D0129417;
        Sun, 12 Mar 2023 05:32:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so14354177pjb.3;
        Sun, 12 Mar 2023 05:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678624354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sND63swE3tBvJlsdtMNxv0m+o+JUrRtvihmOX2Gic3I=;
        b=pgIzP1JPRczXPCKWe0RuYuLwuVSOxJG5FQY4lgWTnW9eRZj4igu22CwleVLE/dxw/D
         6jjEu2AvHsPw4tVgHBqEPRxD4nqByPBLvY7jrdaRcDZ6roiELMNckXg3yiUnfONO+rKg
         Ywcy+qGbVvsurohPHe8BWmQ138u/783B875dHDZCnS8++2b3VBY3pt6gi+51YqsdoOr9
         LXatPxvnmcZNGbyigvZvbv7VgX7d/jQDvYSsWsYwt/vXWwKC1CKGc6ro3Pip2mED+X9N
         3MaywbA/2MbGO/YHDhkPYqJdUmH2n8CmqX0ptNTscsrfFW2cty4OqQkkziZZ8sZkCO0L
         x/RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678624354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sND63swE3tBvJlsdtMNxv0m+o+JUrRtvihmOX2Gic3I=;
        b=WSwi9NZZmuE+L7XpGg0JwzfOlobfUz6sA2HFVaZJ+zJale6APEXcWVPzeGCc1BETs3
         fHp7/AUkrN76EulnJ2J3OBC+etxwEemL5C3Wdrr/vUh1yGOgTD2sZBT9/1MiEF3TLk+l
         Yn8bfbg3l2AwK2TIxc9e1eTSdxntZZibtHm9g3MYYlgU3xKKrtS8TpaAKM8NlXb2tlF3
         tbXUxaRrN0+uMxuKwWBz3fedetp0rJSxcOZnTp2SNA2iFK1DO6PIW/rU9f+GHaRJuI9j
         568I+0uMdDeLrBYj1wT7vYIU7slH0DHBtlF93J3J7yvHZ7GYQjXwoYBRpkEEM2XEH6lz
         hIYQ==
X-Gm-Message-State: AO0yUKWSflB9LgrYisuVIuDf5xOMstF0zFmiS+yAFpZUmA1EzWBz5wn+
        lA41VAeyCR/ZSGqekvKhKs5ci/+GJHE=
X-Google-Smtp-Source: AK7set/I6J5J92BebizjRXQdDtVWHlDjuxTQ+5goQo357inr1/1+zIVqFAkwnhxAV/lPvrB+t2J6cQ==
X-Received: by 2002:a17:90b:4b04:b0:234:656d:2366 with SMTP id lx4-20020a17090b4b0400b00234656d2366mr31418701pjb.42.1678624353763;
        Sun, 12 Mar 2023 05:32:33 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id gn3-20020a17090ac78300b0023cfa3f7c9fsm689336pjb.10.2023.03.12.05.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 05:32:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 410EC1066D5; Sun, 12 Mar 2023 19:32:28 +0700 (WIB)
Date:   Sun, 12 Mar 2023 19:32:28 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>, "A.P. Jo." <apjo@tuta.io>
Cc:     Stable <stable@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bricked LTS Kernel: Questionable i915 Commit
Message-ID: <ZA3GXFkD0kSpP/mn@debian.me>
References: <NQJqG8n--3-9@tuta.io>
 <ZA2zkz8J6fuJsisw@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HsMEdJ1+ndKwvu/u"
Content-Disposition: inline
In-Reply-To: <ZA2zkz8J6fuJsisw@kroah.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HsMEdJ1+ndKwvu/u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 12, 2023 at 12:12:19PM +0100, Greg KH wrote:
> There's a second report of this here:
> 	https://lore.kernel.org/r/d955327b-cb1c-4646-76b9-b0499c0c64c6@manjaro.o=
rg
> I'll go revert this and push out a new release in an hour or so, thanks!

Hi Greg,

The report link above got 404'ed (the report was sent as HTML email).

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--HsMEdJ1+ndKwvu/u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZA3GVwAKCRD2uYlJVVFO
o9yMAQD21ZBXiCvbVEND7wefVTmYNT18xAKyuej8Z1gWJt0iygD+NieLKbB1kh8G
4OADd/n771CREsNR3G7xtdQ2mwkijwc=
=dUgr
-----END PGP SIGNATURE-----

--HsMEdJ1+ndKwvu/u--

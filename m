Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCDC6D20F0
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 14:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjCaMxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 08:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjCaMxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 08:53:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C12E1F7B0
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 05:53:04 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u10so21126084plz.7
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 05:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680267184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CVxRCxxe4MgOh3iHSg8qyeW7PQknzHcN28eqVpS/Gjk=;
        b=ZM0TvA4m0KzX/hZZE7s4oQxR5q9VSXrC1byHc8GbBSH6PB3fR+9Nbvbpa7S6LKFJJq
         eiYjtHtmjV0OskZOasd4l5Pt11/raPx1PDcZVfALh86hTUIJtg9pI0rw3UzEax4sNosS
         KZwfe0DaiWMzL3lYAjFM1JeaqFojKDgeykP8dXPEV1XBW20gbX2dQ57Qifqg+Je+wqMn
         oX8jdPo3hVT3GsMnqqjeDrRX2qtJ6kPASjOZhHJpSXzT58y1cIkVyAPhUB0B/idkVEdX
         PAbM+YcuASlKCRN+w0VeyLKr4vd4YhvIXr9pTUZQMrfHxYCEjakwwNBS5VA+cb9VMpIg
         /6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680267184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVxRCxxe4MgOh3iHSg8qyeW7PQknzHcN28eqVpS/Gjk=;
        b=aC3aGlnOVWegSUmibTPhmdP73JGq7FSN6dVx87k0cv7XIjZw+fGGJweVGPZZd0rTzo
         8CkN6UgMB2E9WDwj6YlxaLMby5xlbnL466cNUVR2eeTyk24SA6L9if+AMHprb+9f7Keu
         t9ixGoH/PQsNEJVFqhZLD7RTp/txN3Z8ANOxGt6ZUxtj15v7JsCnL9720swFAXhlqdTg
         fP6zieBogWsKuW2JTYMWYO0Tq0PpTdZC9S5aqQ/KEDLoaN0c+fzm0UfE+UTetCtMBIKR
         k4oB/uXQ1yusOCGM7kCi41NI34B7dxAY8E/M5r7nmJMjxonZvcgdJsvEt/4QslnBPO1F
         lxxA==
X-Gm-Message-State: AAQBX9eULscwWw3PO47hP+qNoB6J3AKs2zUpiOe5BDX4TVjqtgbW4mWg
        iuRjOGEUFGRs0waJLxP9Ev5sKMzKoYjIug==
X-Google-Smtp-Source: AKy350br9Pb8Uzt7gMaOJsj6ZUi7o4gE5zMnjfM0TxmbHN+tNFNkuRCvGMPtsIovzCt1o6xXr+Wr2A==
X-Received: by 2002:a17:903:32c7:b0:1a2:8871:b408 with SMTP id i7-20020a17090332c700b001a28871b408mr9243116plr.36.1680267184023;
        Fri, 31 Mar 2023 05:53:04 -0700 (PDT)
Received: from debian.me (subs10b-223-255-225-236.three.co.id. [223.255.225.236])
        by smtp.gmail.com with ESMTPSA id ji13-20020a170903324d00b0019f53e0f136sm1486473plb.232.2023.03.31.05.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:53:03 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id BF321106745; Fri, 31 Mar 2023 19:52:59 +0700 (WIB)
Date:   Fri, 31 Mar 2023 19:52:59 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Ilari =?utf-8?B?SsOkw6Rza2Vsw6RpbmVu?= 
        <ijaaskelainen@outlook.com>,
        "linux-stable.git mailing-list" <stable@vger.kernel.org>
Subject: Re: linux-5.15.105 broke /dev/sd* naming (probing)
Message-ID: <ZCbXq4hPerntRpLb@debian.me>
References: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UTj3IGu1aVtm7eGJ"
Content-Disposition: inline
In-Reply-To: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UTj3IGu1aVtm7eGJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31, 2023 at 10:52:55AM +0300, Ilari J=C3=A4=C3=A4skel=C3=A4inen=
 wrote:
> As I attached a USB SSD into CentOS 9 Stream computer, after a short
> while it swaps /dev/sdb into /dev/sdc and the I/O gets ruined.

Is this a kernel regression?

Anyway, for future reports please at least see
Documentation/admin-guide/reporting-issues.rst in kernel sources. Also,
if you have a problem with distro kernel (CentOS in this case), please
report to support channels provided by the distro. Last but not least,
when replying, don't top-post; reply inline with appropriate context
instead.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--UTj3IGu1aVtm7eGJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCbXpwAKCRD2uYlJVVFO
ozoeAQCjMAPTUIAxATXiJmbbPiJZkAyz0H/CqyDTfpuq08eKVgEAyY+NYF6f0KdT
+wq+jreyM7bXP5f6+gY1UUT4F1gptQo=
=5iqD
-----END PGP SIGNATURE-----

--UTj3IGu1aVtm7eGJ--

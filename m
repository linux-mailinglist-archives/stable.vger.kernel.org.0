Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0608F6762C2
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 02:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjAUBuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 20:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUBuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 20:50:20 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E130F3646C
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 17:50:19 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z194so3284843iof.10
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 17:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VLHJF4L9W5QYSBHNpgVMrBd8iplWhsj/lauaSoRpBuM=;
        b=BOAJNz4liJDwzcqwZbWx6mCC3Chdo+8E0wFnsdBN5OdCjxbQwsXNKEo9iZaJWTSY2T
         nB2byckNZY+wUeIw5QRJctea+6l2jyrR5aVUj8hENmKDd7raqifLjGKgAK9CQ1I5n1Cj
         AsCe2r8ozgridnCXoYnR4wlA/4LTnWWEeVSE9OMT/mIsCa5cGwngG9dMT9wi4mIujnNG
         iQOQBgAY88pQy5c8SI1ALVsbQGwLalzQQRUFaRvossXDJ5/M1J1TUCxnE+ANfeFCCeMG
         Ziap46u13UXUvxtFDNHYowPGcj8dCn0QPuA6y+Lv/DPyMRM4IApRgf71rZyy/iBP7tye
         oXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLHJF4L9W5QYSBHNpgVMrBd8iplWhsj/lauaSoRpBuM=;
        b=N+BriCUFv1aSYiHmiadGBrLQ4SYRKgBaIAqKIIp2P1zi5cKg7atFvHQkCYihdYHmo1
         lGREprGL6lXPUXbSHaXW+MzP0orGqaZgor5OPSkdyu8aw5VO9qgrT5FJW1nDLEnJNxgK
         GdGmkwdG2hHdQ9tiaBMMJ8tlCcXfRSfnkYWlzQ2A/F5qUcJc9scDv12bQQxY6kqDrtX9
         93QX6BN3klReaYJKP3hfjReddzxhsdDfXSEKsOGH7b6hMsiMAahhSc8tYXN8BotjY2Dr
         xam2/IKD/VfRpKfIA89p9EhZ4P4s4/304kkzcEGoUiFauvnwvfz6OWKgUOuX5dMXcNoh
         N2zg==
X-Gm-Message-State: AFqh2kow8JQMHHg3k5cqgqmPb+t2JZJMEqT1A4DiZII3fnum8p69uKlg
        wyN2pd0+mvv49SkvHTT85qy9TdMEzxc=
X-Google-Smtp-Source: AMrXdXufJCF7WYBIWfuK5yVSgyC/wsjckUVRGkqg1DWGmYn8Ba/0FhsUe/m6cR5u/Yc+mjhjRRhT0Q==
X-Received: by 2002:a05:6602:96:b0:6de:9711:9962 with SMTP id h22-20020a056602009600b006de97119962mr10875188iob.5.1674265819256;
        Fri, 20 Jan 2023 17:50:19 -0800 (PST)
Received: from pek-khao-d2 (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id p69-20020a022948000000b003a607dccd1bsm2702694jap.17.2023.01.20.17.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 17:50:18 -0800 (PST)
Date:   Sat, 21 Jan 2023 09:50:13 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 5.15] cpufreq: governor: Use kobject release() method to
 free dbs_data
Message-ID: <Y8tE1fkJN5BvhWym@pek-khao-d2>
References: <20230120042650.3722921-1-haokexin@gmail.com>
 <20230120214032.uzq6dgpzhfi7quol@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LUpczh5tNKke8z0J"
Content-Disposition: inline
In-Reply-To: <20230120214032.uzq6dgpzhfi7quol@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LUpczh5tNKke8z0J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2023 at 02:40:32PM -0700, Tom Saeger wrote:
>=20
> applies but has build error:
>=20
> /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_govern=
or.c: In function =E2=80=98cpufreq_dbs_data_release=E2=80=99:
> /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_govern=
or.c:393:49: error: implicit declaration of function =E2=80=98to_gov_attr_s=
et=E2=80=99 [-Werror=3Dimplicit-function-declaration]
>   393 |         struct dbs_data *dbs_data =3D to_dbs_data(to_gov_attr_set=
(kobj));
>       |                                                 ^~~~~~~~~~~~~~~
> /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_govern=
or.c:393:49: warning: passing argument 1 of =E2=80=98to_dbs_data=E2=80=99 m=
akes pointer from integer without a cast [-Wint-conversion]
>   393 |         struct dbs_data *dbs_data =3D to_dbs_data(to_gov_attr_set=
(kobj));
>       |                                                 ^~~~~~~~~~~~~~~~~=
~~~~
>       |                                                 |
>       |                                                 int
> In file included from /home/tsaeger/workspace/linux/linux-5.15.y/drivers/=
cpufreq/cpufreq_governor.c:20:
> /home/tsaeger/workspace/linux/linux-5.15.y/drivers/cpufreq/cpufreq_govern=
or.h:49:65: note: expected =E2=80=98struct gov_attr_set *=E2=80=99 but argu=
ment is of type =E2=80=98int=E2=80=99
>    49 | static inline struct dbs_data *to_dbs_data(struct gov_attr_set *a=
ttr_set)
>       |                                            ~~~~~~~~~~~~~~~~~~~~~^=
~~~~~~~
> cc1: some warnings being treated as errors
>=20
>=20
> 5.15.y first with:
> ae2650865127 ("cpufreq: Move to_gov_attr_set() to cpufreq.h")

I managed to forget this commit.

>=20
> then
> a85ee6401a47 ("cpufreq: governor: Use kobject release() method to free db=
s_data")
>=20
> compiled clean

Thanks Tom.

Kevin

>=20
>=20
> Regards,
> --Tom

--LUpczh5tNKke8z0J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmPLRNUACgkQk1jtMN6u
sXHtrggAgiQzJpL93/C2KdsIxaMYq4q2OLwULm9jn3Q9kuoJjYzvdCbcnB+d3iuh
g62+WOfK7sJF6WSPLdZX4KyC4yIVXL9U8sWMYvLLyY9BhSR8ELk2zdUnEQcwfdc6
w/AU0Iy8yQFUCXyvrmTfPlpXL+BzKmHckN1cwsie985HeYJO99gTisUYC318Bn7k
zouMqQq46iGEZiBxsf1k1r/vNRpGCPRE7g4ZvA8pV6HbEq3CH7foFKz/Zbz99Ztx
XWI4RQhUTaZyKL1FnCqjrv/HDjmmVnmNGMSJ2IwQLzn9CijWOzpvTsGcmWFU8SiD
Du/V3hxpJchua3bWD6/Kaa7gcAs7+w==
=QDia
-----END PGP SIGNATURE-----

--LUpczh5tNKke8z0J--

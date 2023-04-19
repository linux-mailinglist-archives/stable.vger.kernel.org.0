Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B246E722A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 06:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjDSESM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 00:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjDSESL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 00:18:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85530448C;
        Tue, 18 Apr 2023 21:18:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b5c4c769aso3073996b3a.3;
        Tue, 18 Apr 2023 21:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877890; x=1684469890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1yOlmeuohL1y9HWwOAFFBHf0wIhbGMAUILl4Etf+xaM=;
        b=g9XFVOwTjnRDWpVUdboPuxWJfvxBkfOMlRJdLs9teGzJRpKulIKhsyauD7KhA8Ekg2
         mpPKfY4w28TdgGzFsqhbszZNyiZHeH3PVlhT0PjAM0m97jmt358oN79pKoypnHqbDEFW
         xPM6hdmSmji/hkD50tsDFj2qW2tvsi04D+2rcKCRvABqOXJ7A7XN4NLZtZWGVfIptKJl
         uI+1KCTyVW3gZE5bbHZR9ubkFBED5fPPch7D1SDUAdBYmLnQesJC8OuR3Sgh8VApXRMc
         29Tco9juXr+sEfqjS6TXxmZ6WYjjhLZEph2N4epdjC1fFbEL31fAFbbnBjNtZxUI3oLt
         rPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877890; x=1684469890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1yOlmeuohL1y9HWwOAFFBHf0wIhbGMAUILl4Etf+xaM=;
        b=PkHe5L2ef3fsCQxu5wPnyaV7eVG3KrPPfqcR1PviPVWbARaBATHX0Sbqdm8SKfNORZ
         oIa5L3LBBfn9ohuOvD/mz79MFQkucmuI8jOesoQIs2kmeRoz8OrLIjQlnf72eRMaKooA
         cKkpybxtQ60DVlUpQ4qnpI9YjRX/8Y1S1D/teSLBOX/lQ1Uuvcu4SLh97/QI2A9qvmpK
         VK0PhchfRDeGibMVFR/5CVu8KydYNrKS2oH6HZ9j+vtnZlD7UneK0j+/YHsoChAur3fR
         HcGOTFKCcALmqNOW7Orr9e/rBGVEPPR3TkYfwtWvyNP7iSE7HObmxFJ3XUIcIaYv5Itk
         l4Gw==
X-Gm-Message-State: AAQBX9ed1BIViw4kENM7H4tjlvtij/XfORUYPJ89wuG9r57D/4sSKR6M
        sJKWjq1lzkK/ZltONM2hE8s=
X-Google-Smtp-Source: AKy350atE/YK8xeOWPxEnBYau7lN2rbNThIlRZKxpoHVtBY0Iq/1BSox5hJ7WghB/cEHT2XXDpa4Jw==
X-Received: by 2002:a05:6a00:139f:b0:63b:8e12:7075 with SMTP id t31-20020a056a00139f00b0063b8e127075mr2246843pfg.31.1681877889814;
        Tue, 18 Apr 2023 21:18:09 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id e18-20020a62aa12000000b0063d37a45829sm1167463pff.63.2023.04.18.21.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:18:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 82DFE10673E; Wed, 19 Apr 2023 11:18:06 +0700 (WIB)
Date:   Wed, 19 Apr 2023 11:18:06 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Tom Saeger <tom.saeger@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Yu Zhao <yuzhao@google.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
        Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <ZD9rfsteIrXIwezR@debian.me>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
 <20230418165105.q5s77yew2imkamsb@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1l6DxsxNS5bMd6S1"
Content-Disposition: inline
In-Reply-To: <20230418165105.q5s77yew2imkamsb@oracle.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1l6DxsxNS5bMd6S1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 10:51:05AM -0600, Tom Saeger wrote:
> > Tom Saeger identified that the below commit moves it out of ifdef.
> >=20
> > commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> > Author: Yu Zhao <yuzhao@google.com>
> > Date:   Sun Sep 18 02:00:07 2022 -0600
> >=20
> >     mm: multi-gen LRU: kill switch
> >=20
> FWIW - partially backporting (location of cgroup_mutex extern) from:
> 354ed5974429 ("mm: multi-gen LRU: kill switch")
>=20
> fixes x86_64 build for me.
>=20
> Regards,
>=20
> --Tom
>=20
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 45cdb12243e3..460ba084888a 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -433,6 +433,8 @@ static inline void cgroup_put(struct cgroup *cgrp)
>         css_put(&cgrp->self);
>  }
>=20
> +extern struct mutex cgroup_mutex;
> +
>  /**
>   * task_css_set_check - obtain a task's css_set with extra access condit=
ions
>   * @task: the task to obtain css_set for
> @@ -447,7 +449,6 @@ static inline void cgroup_put(struct cgroup *cgrp)
>   * as locks used during the cgroup_subsys::attach() methods.
>   */
>  #ifdef CONFIG_PROVE_RCU
> -extern struct mutex cgroup_mutex;
>  extern spinlock_t css_set_lock;
>  #define task_css_set_check(task, __c)                                  \
>         rcu_dereference_check((task)->cgroups,                          \
> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-inter=
nal.h
> index d8fcc139ac05..28c32a01da7d 100644
> --- a/kernel/cgroup/cgroup-internal.h
> +++ b/kernel/cgroup/cgroup-internal.h
> @@ -165,7 +165,6 @@ struct cgroup_mgctx {
>  #define DEFINE_CGROUP_MGCTX(name)                                       =
       \
>         struct cgroup_mgctx name =3D CGROUP_MGCTX_INIT(name)
>=20
> -extern struct mutex cgroup_mutex;
>  extern spinlock_t css_set_lock;
>  extern struct cgroup_subsys *cgroup_subsys[];
>  extern struct list_head cgroup_roots;

Yu, would you like to provide formal backport? Or maybe take Tom's
diff above and ACK it?

--=20
An old man doll... just what I always wanted! - Clara

--1l6DxsxNS5bMd6S1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9rfgAKCRD2uYlJVVFO
oxE1AP4/yqKP+7NfVKxZa3LJ3PAlg3lg8WKyBlBEhDzI2U/cWwD/a/+Hgb0Y/fqS
4SDj9K66itlA57r83DXzZFh4U2pXbAc=
=vtL5
-----END PGP SIGNATURE-----

--1l6DxsxNS5bMd6S1--

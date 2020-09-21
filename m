Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4DC271E55
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 10:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIUIuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 04:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgIUIuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 04:50:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92C9C061755;
        Mon, 21 Sep 2020 01:50:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x22so3864815pfo.12;
        Mon, 21 Sep 2020 01:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=WGZPvNZ6AV/nbZDpa0AhDOJ7MJQfLtXPAyzzNP7GSmI=;
        b=azJctfI68YJCLulsccoZaFy7rZQJ+Friy8H6IQgGvx+NoUdUvSDRePKKc0LsZOKAiE
         hfBcDCH1Qz4UaHs8bfIuJ5kUi6Atb+8t48nVr5PZxm71a/Y5cNfxy2TyDcViVYLbsz7V
         HSy39BF/ZJJ11CBcKqtINMQFKvkp9LUh9uN/N12qYt15Oeh7l05rfl516lNjPi8Nr+IS
         flLVAJ5sD4A8RWVOv77hnlAvp5CgXlLP97xoCglESzYo69scCqfSLaE0ePq17DOsR6cP
         K4aVPV8IGCDEr0smLs0nU8FljAGPkhDyWma4KPwsIga3K3skAMqBTayX6+wzjoBmeBx0
         0OsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=WGZPvNZ6AV/nbZDpa0AhDOJ7MJQfLtXPAyzzNP7GSmI=;
        b=h2mnHe/fR4C+LPrrlz5kiCBO4WNSZ9874EGohHBf8M+Wn43NgljmR26kjKiOn55aVh
         xzh9z+qJC6hkwps1jxtXvT2XBf0D6P/xMZuJJ3BMvqlqTjcVLNVO5vWNsd4qH6h+uKLO
         a5yGliDwTGHIy8QVB0uWw4Ua9D4KJleOehkSHuLR9Tz5JbMoh4EpCnfA7svg1lK39+hV
         4Zj2LtC8z+bqiVmzIgzk1pZ7I95Q1eeo7Z1TvNYA6tS4o8Gz3rfV031PcXtKKr5+UHd8
         zhaAt4DjSypQn8eFA1qhhGNWad5BJXhMLAKpo3ou2Tsh468CZK3rBoTHhFRFEjnA0F9C
         l/cA==
X-Gm-Message-State: AOAM531r9wzJVexogykGR1Ob2gpEJkWfX+caRrGoGrDMwMG+CRpp3bZJ
        r70uz64m2xakU9TLQAjCCSs=
X-Google-Smtp-Source: ABdhPJwKrtp2q8bS+ncENJczUdH2aZZ+0GiHQClvxQKFk5ML2cC4iNlg0w7e67PTihFKrex0ZDhcpw==
X-Received: by 2002:a05:6a00:8c5:b029:13e:ce2c:88bd with SMTP id s5-20020a056a0008c5b029013ece2c88bdmr43001094pfu.0.1600678216079;
        Mon, 21 Sep 2020 01:50:16 -0700 (PDT)
Received: from Slackware (sau-465d4-or.servercontrol.com.au. [43.250.207.1])
        by smtp.gmail.com with ESMTPSA id kt18sm9948148pjb.56.2020.09.21.01.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 01:50:14 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:19:48 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Stuart Little <achirvasub@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com,
        lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
Subject: Re: PROBLEM: 5.9.0-rc6 fails =?utf-8?Q?to_?=
 =?utf-8?Q?compile_due_to_'redefinition_of_=E2=80=98dax=5Fsupported?=
 =?utf-8?B?4oCZJw==?=
Message-ID: <20200921084948.GA20254@Slackware>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Stuart Little <achirvasub@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com,
        lkft-triage@lists.linaro.org, Jan Kara <jack@suse.cz>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
 <20200921073218.GA3142611@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20200921073218.GA3142611@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:32 Mon 21 Sep 2020, Greg KH wrote:
>On Mon, Sep 21, 2020 at 11:34:17AM +0530, Naresh Kamboju wrote:
>> On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
>> >
>> > I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-750=
0U CPU @ 2.70GHz). The config file I am currently using is at
>> >
>> > https://termbin.com/xin7
>> >
>> > The build for 5.9.0-rc6 fails with the following errors:
>> >
>>=20
>> arm and mips allmodconfig build breaks due to this error.
>
>all my local builds are breaking now too with this :(
>
>Was there a proposed patch anywhere for this?
>
>thanks,
>
>greg k-h

I don't know Greg,but it builds for me with these config :

bhaskar@Slackware_14:14:31_Mon Sep 21:~> cd /data/linux
=E2=9C=94 /data/linux [master|=E2=9A=91 1]
14:14 $ grep DAX .config
CONFIG_NVDIMM_DAX=3Dy
CONFIG_DAX_DRIVER=3Dy
CONFIG_DAX=3Dy
CONFIG_DEV_DAX=3Dm
CONFIG_DEV_DAX_PMEM=3Dm
CONFIG_DEV_DAX_KMEM=3Dm
CONFIG_DEV_DAX_PMEM_COMPAT=3Dm
CONFIG_FS_DAX=3Dy
CONFIG_FS_DAX_PMD=3Dy


and it gets booted by qemu ....like this=20

[    5.134563] devtmpfs: mounted
[    5.164729] Freeing unused decrypted memory: 2040K
[    5.314950] Freeing unused kernel image (initmem) memory: 1600K
[    5.316543] Write protecting the kernel read-only data: 26624k
[    5.327037] Freeing unused kernel image (text/rodata gap) memory: 2040K
[    5.331005] Freeing unused kernel image (rodata/data gap) memory: 876K
[    5.331861] rodata_test: all tests were successful
[    5.332872] Run /sbin/init as init process
[    5.694654] EXT4-fs (sda): re-mounted. Opts: (null)
[    5.695839] ext4 filesystem being remounted at / supports timestamps unt=
il 2038 (0x7fffffff)
Starting syslogd: OK
Starting klogd: OK
Running sysctl: [    6.974188] random: crng init done
OK
Initializing random number generator: OK
Saving random seed: OK
Starting network: [    8.293018] hrtimer: interrupt took 4569776 ns
OK

Welcome to Buildroot_Linux
Bhaskar_Thinkpad_x250 login: root
# uname -a
Linux Bhaskar_Thinkpad_x250 5.9.0-rc6-Slackware #1 SMP Mon Sep 21 11:42:03 =
IST 2020 x86_64 GNU/Linux


~Bhaskar

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAl9oaSgACgkQsjqdtxFL
KRWNQwgAmjlpIbY42uBabMCy++pqyyzc4Jq9sz9SHbENTdvsPvBV6FPDleUI6DMP
3egPCVbC5vEB19r6MYqFuq4L9Y7kuXdDd3P+52v8/gJ7HOOQDDd4lIG0YCyxH1RI
Lx7Lb/9/WTISo2JYsqlrgaPY8PWjF+aGZrN24TFXuH6YlSTf+ck24RfZxPoRtAO9
kTp9s4HBHPXlQcHHBscLIRdq9sGlHbYew3VxtlGz0DhP9bbMOuvER8Ick3Y+rGSb
DyUfgPU3T8Q/SinM51LUBR7WGqAoi1x4DjcAp1ZGOXB0AF5XKz2nLkvAbwBe2bqH
NF1e9TEZ4GLiQK4oKjhvXvl58jz1JA==
=yKt3
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--

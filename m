Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA08550420
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 13:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiFRLFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jun 2022 07:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiFRLEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jun 2022 07:04:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE36A193E8;
        Sat, 18 Jun 2022 04:04:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A11A1F99B;
        Sat, 18 Jun 2022 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655550271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJMP/vq8QN0402dYS33way0QQugXiCZk/ovuT6fnfP0=;
        b=YPJ4LuOeKMO1iZqFMsIPmq59eu/pUdng+PJtayn5SXQ4gfjg+Qe1QFn/KkDLX1pS5VCrz+
        7sjJMLY6CSt6VTm7hEB+MvXK6ITVBimK9+yL9eP+dnF9DdQGCiCHc+psyJ6Y49QyKm+o31
        BlJLsNcRvPfoPQF+7P+5O5AZD5Srh/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655550271;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJMP/vq8QN0402dYS33way0QQugXiCZk/ovuT6fnfP0=;
        b=8h+zJWONo1uXpWLOQbyfsRNR5kEvA3SXdTJGsLLWkVZNdX4ISpPKKO65ti/IuEwomPjI1i
        cs3JPJCCCBE9pvBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D8C21342C;
        Sat, 18 Jun 2022 11:04:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id W4E0JTixrWK/LAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 18 Jun 2022 11:04:24 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220618104925.GA3644@duo.ucw.cz>
Date:   Sat, 18 Jun 2022 19:04:22 +0800
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, baijiaju1990@gmail.com,
        oslab@tsinghua.edu.cn, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6497730E-D4D2-4FB3-B95B-E1DAB2C2B287@suse.de>
References: <20220607164948.980838585@linuxfoundation.org>
 <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
 <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
 <20220618104925.GA3644@duo.ucw.cz>
To:     Pavel Machek <pavel@denx.de>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8818=E6=97=A5 18:49=EF=BC=8CPavel Machek =
<pavel@denx.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi!
>>>>=20
>>>> This is the start of the stable review cycle for the 5.17.14 =
release.
>>>> There are 772 patches in this series, all will be posted as a =
response
>>>> to this one.  If anyone has any issues with these being applied, =
please
>>>> let me know.
>>>>=20
>>>> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
>>>> Anything received after that time might be too late.
>>>>=20
>>>> The whole patch series can be found in one patch at:
>>>>        =
https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.14-r=
c1.gz
>>>> or in the git tree and branch at:
>>>>        =
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git =
linux-5.17.y
>>>> and the diffstat can be found below.
>>>>=20
> ...
>>> We will bisect and let you know more details about this reported =
problem.
>>=20
>> The bisect script pointed me to this commit and  reverted and tested =
and
>> confirmed.
>=20
> Can you add some printks into that? Because I'm pretty sure this patch
> does not break anything. (It should not fix much, either.)
>=20
>> commit 1883088ed4a0d5cc9cea500ca4e89a354ab32c11
>> Author: Jia-Ju Bai <baijiaju1990@gmail.com>
>=20
>>    md: bcache: check the return value of kzalloc() in =
detached_dev_do_request()
>>=20
>>    commit 40f567bbb3b0639d2ec7d1c6ad4b1b018f80cf19 upstream.
>>=20
>>    The function kzalloc() in detached_dev_do_request() can fail, so =
its
>>    return value should be checked.
>>=20
>>    Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached
> ...
>=20
>> +++ b/drivers/md/bcache/request.c
>> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
>> bcache_device *d, struct bio *bio,
>>         * which would call closure_get(&dc->disk.cl)
>>         */
>>        ddip =3D kzalloc(sizeof(struct detached_dev_io_private), =
GFP_NOIO);
>> +       if (!ddip) {
>> +               bio->bi_status =3D BLK_STS_RESOURCE;
>> +               bio->bi_end_io(bio);
>> +               return;
>> +       }
>> +
>>        ddip->d =3D d;
>>        /* Count on the bcache device */
>>        ddip->orig_bdev =3D orig_bdev;
>>=20
>=20
> So... for patch to make any difference, memory allocation has to fail
> and ddip has to be NULL.
>=20
> Before the patch, it would oops in "ddip->d =3D d;". With the patch, =
you
> do some kind of error handling. Even if it is buggy, it should not do
> more harm than immediate oops.

I just receive this single email and don=E2=80=99t have any idea for the =
context and what the problem is. Where can I see the whole conversation?

BTW, maybe commit 7d6b902ea0e0 (=E2=80=9Cbcache: memset on stack =
variables in bch_btree_check() and bch_sectors_dirty_init()=E2=80=9D) is =
necessary, how about trying to add it in?

Coly Li



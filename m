Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9D255204E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiFTPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 11:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243373AbiFTPQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 11:16:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848BF65AD;
        Mon, 20 Jun 2022 08:06:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3FFDD1F8D4;
        Mon, 20 Jun 2022 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655737565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vNpnaLHq5djaVo7KGcO8jIbELchA6oBGBaoWMyiA0M=;
        b=NIA+A4AMgk4do6w1FIcx4eDF7kJj+MiAf5V0D+ocGdoNZaLWBhzxIOk5EaxBF/K2DbwyUW
        9oUlUG1Nn0x99lc4H8q5SbwyztQtyW7nbSHBgXI2YGx7fko0QtPMVXmJ1Roqq7kOmXATxy
        vbKrSwUCgnJ4HJ1PHzRvcaZAJNYY/EE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655737565;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vNpnaLHq5djaVo7KGcO8jIbELchA6oBGBaoWMyiA0M=;
        b=EAY4cmSGJEEyz1CQwI1dSxhSKiJ4u70WQ9C6rF3PaIiWbzUP8RcXFlWk3YguJvL03yLBEw
        h1LTpy4Es7iKq1CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0B6213638;
        Mon, 20 Jun 2022 15:05:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l9vELNaMsGLMcQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 20 Jun 2022 15:05:58 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
From:   Coly Li <colyli@suse.de>
In-Reply-To: <YrBHh5/FOUWXv3ho@kroah.com>
Date:   Mon, 20 Jun 2022 23:05:54 +0800
Cc:     Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@denx.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        baijiaju1990@gmail.com, oslab@tsinghua.edu.cn,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <83F4613E-1B83-4DD8-B46E-DB94097A007E@suse.de>
References: <20220607164948.980838585@linuxfoundation.org>
 <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
 <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
 <20220618104925.GA3644@duo.ucw.cz>
 <6497730E-D4D2-4FB3-B95B-E1DAB2C2B287@suse.de>
 <20220618113703.GA10888@duo.ucw.cz>
 <186E5519-55D4-48EE-8599-2C863BEC3918@suse.de> <YrBHh5/FOUWXv3ho@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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



> 2022=E5=B9=B46=E6=9C=8820=E6=97=A5 18:10=EF=BC=8CGreg Kroah-Hartman =
<gregkh@linuxfoundation.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, Jun 18, 2022 at 07:57:01PM +0800, Coly Li wrote:
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8818=E6=97=A5 19:37=EF=BC=8CPavel Machek =
<pavel@ucw.cz> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hi!
>>>=20
>>>>>>  Fixes: bc082a55d25c ("bcache: fix inaccurate io state for =
detached
>>>>> ...
>>>>>=20
>>>>>> +++ b/drivers/md/bcache/request.c
>>>>>> @@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
>>>>>> bcache_device *d, struct bio *bio,
>>>>>>       * which would call closure_get(&dc->disk.cl)
>>>>>>       */
>>>>>>      ddip =3D kzalloc(sizeof(struct detached_dev_io_private), =
GFP_NOIO);
>>>>>> +       if (!ddip) {
>>>>>> +               bio->bi_status =3D BLK_STS_RESOURCE;
>>>>>> +               bio->bi_end_io(bio);
>>>>>> +               return;
>>>>>> +       }
>>>>>> +
>>>>>>      ddip->d =3D d;
>>>>>>      /* Count on the bcache device */
>>>>>>      ddip->orig_bdev =3D orig_bdev;
>>>>>>=20
>>>>>=20
>>>>> So... for patch to make any difference, memory allocation has to =
fail
>>>>> and ddip has to be NULL.
>>>>>=20
>>>>> Before the patch, it would oops in "ddip->d =3D d;". With the =
patch, you
>>>>> do some kind of error handling. Even if it is buggy, it should not =
do
>>>>> more harm than immediate oops.
>>>>=20
>>>> I just receive this single email and don=E2=80=99t have any idea =
for the context and what the problem is. Where can I see the whole =
conversation?
>>>>=20
>>>=20
>>> Discussion happened on stable@vger.kernel.org mailing lists, =
archives
>>> should be easily available. Copy went to lkml, too.
>>=20
>> Hi Pavel and Greg,
>>=20
>> Thanks for the hint, I see the context. I cannot tell the direct =
reason of the kfence regression, but it is worthy to have this patch in,
>> - commit 7d6b902ea0e0 ("bcache: memset on stack variables in =
bch_btree_check() and bch_sectors_dirty_init()=E2=80=9D)
>>=20
>> I am not sure whether it is directly related to the kfence issue, it =
corrects potential unexpected stack state in some condition. Hope it may =
help a bit.
>=20
> Added where?
>=20
> confused,

I will post the patch to stable list for specific version. Thanks.

Coly Li


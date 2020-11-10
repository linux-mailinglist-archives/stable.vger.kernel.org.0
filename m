Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589902ADC90
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 18:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgKJRFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 12:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJRFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 12:05:08 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165C2C0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 09:05:08 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id h6so10734372pgk.4
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 09:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ARzTiK+sQyDUDGROkMkvVoqLNH5IAalueu9KJKRl/Ko=;
        b=pr7OepwKU0ShNjw7/QvY/VFNMqn/aDxrppDkAZEkF/vfqDIao0VDzVYOwQbgNEQUdt
         24e7UPReWtokklYcz2o7auuV6Fn+C7hgpzS4YggDdxY/52I7dENm6tTo1BBNFjDvSrWw
         vXIyfrov0HRXpxVoQ5C8wapn0rIoGnoa/WuyG2xWNV8+x50N+tqYqZFgGqIekZR2y6jF
         JY2vC4chePbOSA6d6+lQtzffeLce3/9sJyGBsn2IuAxogFO+D1uvwOlP0pzYy8h4EfTX
         FKBptbdW9MNODfGO2SuFHCOs5+wrtClnG+QMkX/XzP1oYvyxiIhgE6aW5FB6iG8zj1Wx
         GvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=ARzTiK+sQyDUDGROkMkvVoqLNH5IAalueu9KJKRl/Ko=;
        b=Y2opruSt3aWr3fTcaphATPMFQ3UzTcqrIjTMX8ArkkIX2P2pxZUMhxIX/+JKYAPe6j
         JnLAbtLbpFP686FORuGDLXBDmafzgEg1Nj0V9gs69hppxOwixYAJoVmEhA0GwRTs+Ewv
         AdHUcM4Ks5S9Q7RYO0MSDiSAg5c6Rj+pS1lcYhJn+KMSGm3GTfny/s27W8ljCiK1vXh9
         F9fAGHp/PRegtCjl2SRd/6ekoA1WS5H1O9Vy+7jaT+Tt8WNSMFF3JTag7ydr51+hJLpn
         cNvq46eDnmdlb08AXLUljEyf7wBV+GYS5mPfFY/qwXPUMkKRYLisnddI1qH/FbLVYU6K
         E28A==
X-Gm-Message-State: AOAM532ZuM/Wk2WkRKCB1ry7iDuTdeGpzHLham9y1tleoneg2uCh5S94
        Fe7INxn+4sO6EQXriuIaZctN22QmvCd+1FTmIdQ=
X-Google-Smtp-Source: ABdhPJz/+pyOkcvmX7a4QL0CDYY6FeIfVzqaZXlv2xiFkH/YODRUAd7UR7CK65YrLjA0zRquSwvoOPOYpx0RH1Sh2cI=
X-Received: by 2002:a17:90a:5310:: with SMTP id x16mr64880pjh.62.1605027907699;
 Tue, 10 Nov 2020 09:05:07 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90b:f83:0:0:0:0 with HTTP; Tue, 10 Nov 2020 09:05:06
 -0800 (PST)
Reply-To: moneygramdepromo@gmail.com
In-Reply-To: <CAFg1WMzEiSb3CNQBpfikkRYbNw0VCTp8czw=uxnPm-Xrt1KXqQ@mail.gmail.com>
References: <CAFg1WMwyjNScaJdNVxZBqjCszGFGfM1_PnuVD5ks4JCQ=Ho0wQ@mail.gmail.com>
 <CAFg1WMwt6B2TiZAagSEahcWCLrXj_uTcN-T2E4DC3m5G-Au2nQ@mail.gmail.com>
 <CAFg1WMxeO-CoaugBVoKKTYhn6wV=YOXnmvaiBg-ZhkEuHGyj-Q@mail.gmail.com>
 <CAFg1WMxo+pFPqT+Zi2igH0xTVo0eV0xZfNccm2b-kRYOviwa=g@mail.gmail.com>
 <CAFg1WMw7vyeqbg-MneyPns+XgsaZRrUTYQj7ztA0pTh0LBNFYQ@mail.gmail.com>
 <CAFg1WMxzgNk95tOdjrq2wpLqMq5NibTS3z2MQ6U4G8TKXh+WqQ@mail.gmail.com>
 <CAFg1WMx8L3FSZXkCCwtTQEUAzqKaGKq2dibJ2TQObXT3jvyZvQ@mail.gmail.com>
 <CAFg1WMwaduHu_3A3S42Lfr5Ys2eURd-AaOusAQnXVaCK7ivxzQ@mail.gmail.com>
 <CAFg1WMxsMCptuXqCUu84O+ztfDa83e9q4n8b_xJucvr2WRQodA@mail.gmail.com>
 <CAFg1WMxZgxzSrQFbH4pi_o1XLWmUtAX_KF2ocKn6Tqz6c3j=BQ@mail.gmail.com>
 <CAFg1WMxdAQyBJA5ruP135vMAHKoCG2OtrgibkO0YuVh2h+gYWw@mail.gmail.com>
 <CAFg1WMxAcuOKHdgjWVHgS91NSgVoqu90_LZbDrz244COQNFNUg@mail.gmail.com>
 <CAFg1WMxOmyzPXWGng1eTo_s4BnGqj+rAcHcAHqnjWKEyNiScBA@mail.gmail.com>
 <CAFg1WMz0MUsoQ=ML5Mo_MmBBNQC4DOSSb-rNifw2qbcxeFSSig@mail.gmail.com>
 <CAFg1WMx1Q_ujFgWxzo-YjZ=tdXUtprDB11yNQRcjbpJZHWWUyQ@mail.gmail.com>
 <CAFg1WMwA5Pr_sQ8pVhM5ZkTOBYLMm75jWCZdNXB6t+n8SfA8gQ@mail.gmail.com>
 <CAFg1WMysr1z=sTn32M5WnFZo0r6x6D-kCWMd2GEO63WpwtjSYg@mail.gmail.com>
 <CAFg1WMyQsDvvkpiud70L2XUeTE+bz4ZfDMCY2m4_ork9a0swsQ@mail.gmail.com>
 <CAFg1WMzuYS7WqJPhsFp90aPqTutMa12wrGOkXK7jOXdb6D05TA@mail.gmail.com>
 <CAFg1WMx1zJjZzPMPf_nFZPi0061sWu0M2yK2PA+qwxT01jE1Zw@mail.gmail.com>
 <CAFg1WMxS+c9Opu3Lc-eRBZQAt9EW43g2HbWxU5zD=WHn=3WKdA@mail.gmail.com>
 <CAFg1WMyT09BuNGr-5KgCN=63SGUhghnwWoDzigpM5QamqsmDCg@mail.gmail.com>
 <CAFg1WMwOuC9xQBd7mWQhLwujxD7D3u1dyiMe09xd_vxkQEEgRA@mail.gmail.com>
 <CAFg1WMz=XeoorXyeaduJVtBxvzhangp5z9k7RD42E0Yz438=eA@mail.gmail.com>
 <CAFg1WMyXGLm0FiO6U7ES6FtjSpPHfBZ8ObBrKPMP9qFOWstn9g@mail.gmail.com>
 <CAFg1WMz2BWPdoqhE9ZWeVhs234Wib+L1R81KcZARUFH4WCk-Gg@mail.gmail.com>
 <CAFg1WMw8zbC0Dkvc2C=n3WdH9ogUF8=Ad4ow6+tcdrx=wJAwrw@mail.gmail.com>
 <CAFg1WMxLzpofcdeUVFMU7byt_6mi4R1RO3gZQ06V0f0y628q_w@mail.gmail.com>
 <CAFg1WMxim31oC2565f-2E1KbPT9rO-t=__crN5RAM_JhPYybQA@mail.gmail.com>
 <CAFg1WMzsaOeAzJZm9mG2z3CvDA_11oivn__QvarGLPHYfpGkZA@mail.gmail.com>
 <CAFg1WMw4JcuKAyHKvbXtGHJScQChr=p=Y9e5Evso80Pf4CSYaw@mail.gmail.com>
 <CAFg1WMzN51+5Nx8nVf+wd-DHnMkMgS0cJgj5ugVkcjuvfi_8YQ@mail.gmail.com>
 <CAFg1WMywbvhAXUPzKJEoL+x8tLVHzAG22-pHjbC2C4oGxa5-4Q@mail.gmail.com>
 <CAFg1WMztxM3JyZiKLeMu1zdHE1zO1A-qomumF9GB7-2X_VmAHQ@mail.gmail.com>
 <CAFg1WMzYhD3RL203XBDtMz-QKsiFtS2VPyp9gQDZjSy86uMshQ@mail.gmail.com>
 <CAFg1WMxiU3-6nVo0EKhPoy-JnGErw52EZOid0Be79scy7+LLXw@mail.gmail.com>
 <CAFg1WMxF2crCygmtkKxGrhi0fyS4vo89p0DrtRyyzFwgq+6b3A@mail.gmail.com>
 <CAFg1WMzV52+nH5PjpM_JKs4_pN2W66rJWWWv2Ghg-MfXX9Lp7Q@mail.gmail.com>
 <CAFg1WMy6TuH8jvmXnhyYTnSwG93Rogm5rH2QjSusZPE3Yk4ogg@mail.gmail.com>
 <CAFg1WMwFD3NWvv3wVbP-gmqSA-EKXYEA-J+4BiaWy_nrss2row@mail.gmail.com>
 <CAFg1WMxMWGzKCV0Z+8rnLJWJHtWvLuDCP-mp+0CxeXtr6KDSsA@mail.gmail.com>
 <CAFg1WMwuUpT3wOgpNoq=Pomf7uCwGH+RbYByE8=5y3iSE3_j+w@mail.gmail.com>
 <CAFg1WMyyhhjKPM-XdQzqAYuULAqR79hnNbu-cNmTvxN=umS_wQ@mail.gmail.com>
 <CAFg1WMyD_ZKqJv8FWJpqLsxvTjjQd3un84CU-FyAqdKV19zh=w@mail.gmail.com>
 <CAFg1WMzrmSrD7CNkm7YgDm5s=JkaKUpOaB88xVxuEQqRHKVKcQ@mail.gmail.com>
 <CAFg1WMxVq2NuS=t3QQBFRGnCaRqmrP0=khfNgBwCBE_cHOfQMQ@mail.gmail.com>
 <CAFg1WMy0fx7cvUSewQWrkDePCZOS_-P8xghGR9XmtVD_t9yajw@mail.gmail.com>
 <CAFg1WMwhdgikf+UG-Vw3zH8eVhObAYN++BF=aUmB0NoNdhDvMQ@mail.gmail.com>
 <CAFg1WMzqpXdk3d4b_yEOboMitQR+st570ZsNEOzWCcE7MoBSUQ@mail.gmail.com>
 <CAFg1WMz663Xd+630ZxC9ocu9-U8O6V2hsLJs6GwGW53_+vYwJg@mail.gmail.com>
 <CAFg1WMyC38LXi3JMvMnEaPXQAfRdZmvt0AphfoFAJmih12rzcg@mail.gmail.com>
 <CAFg1WMw7vbZ4Nh5gcULYR=TTjUPjOzu8dpCcEpnEGL5xoPeGEg@mail.gmail.com>
 <CAFg1WMwKdS+-Hd_1LixoM1kkgDi-Ows665sA6ywXNB9zbhJDmg@mail.gmail.com>
 <CAFg1WMw_sfWgnt_Ez4CC+4eN3683KWObUWLiy7JY0CeSv+F0+Q@mail.gmail.com>
 <CAFg1WMwFQfnn=EjHBX0zumpVvUNmC3ktACupcmibvRqoDOOt9Q@mail.gmail.com>
 <CAFg1WMwvMZBayhvTAwxjU3yw1DsEuFLBbhCuDPVVoWEOhg7EUw@mail.gmail.com>
 <CAFg1WMzLP4McbbgOkVV0oTzwipReRV9i=N2Au13u+BOiutQZKw@mail.gmail.com>
 <CAFg1WMz4dpEJe2BeqgbBb1xBOURiWSt9d-ch=8-HUR-t+fxqgw@mail.gmail.com>
 <CAFg1WMz9f+QDxo2Q-duRoQoqrViqdRGVQDq=Qdm=8wTR8tpHcg@mail.gmail.com>
 <CAFg1WMzppA2WFFc8VszH1M1uqmX+wpt3eun99AW3cjy88gr0LQ@mail.gmail.com>
 <CAFg1WMxYcd=ByzS+aSW-d7CbmysbKrbAtE-0ZVx43bhtiOWKZg@mail.gmail.com>
 <CAFg1WMyrE9W1-LdWD1Yzh79Y=S1ZtDTeQitzFP7DrrYGCVwY3g@mail.gmail.com>
 <CAFg1WMzna=-M4E1roa64FkZ8gusp1yCPtOLbkqjsnYAS1bRZyQ@mail.gmail.com>
 <CAFg1WMwfiz3XA+qdRhOn9jcLq5K-uFj-EsN=kaTne8LOprMrLg@mail.gmail.com>
 <CAFg1WMyXW2a+EOMEi72HSYsEwHmPCfYt3PR+7UdztiNscjJjCQ@mail.gmail.com>
 <CAFg1WMw3z35ZSq=Y97qHtsoYeGLQYM4Ne+pjTgLQnOhFZK6t1Q@mail.gmail.com>
 <CAFg1WMxJOo2HF8aOzLaWd3KR0DPCCCR_c0S6fsUkxKSNkQjJiQ@mail.gmail.com>
 <CAFg1WMzjLyRNtFRb2hrnhT3Z3P3dYA2NTNfWYh7NyrXKtDwt-w@mail.gmail.com>
 <CAFg1WMxXvi=aoMsS8g8=-mqyMuesEgPXbBsEAx3z8nZAvZj3zQ@mail.gmail.com>
 <CAFg1WMwWY3T6nvegSsz9=r07=k9UR-BWLgR5yn40vBv2n07m8Q@mail.gmail.com>
 <CAFg1WMwRiX9JMkkiQE1PAF6j-0nq3czG2kyqEX3MouXECWxpxQ@mail.gmail.com>
 <CAFg1WMy6jc+pFPXMQJpKE2VO58xarrOLpQp9xenoeZPVaLH=kA@mail.gmail.com>
 <CAFg1WMy7QQDzasWakES9yhC+QTCkh5L__yTVwQLO4L5tNqh2+w@mail.gmail.com>
 <CAFg1WMwU_qxtGBm83eJHUqjrmUwXUVGw-YhhT5Wka6rxJu8EdA@mail.gmail.com>
 <CAFg1WMw2oXEQJ5wU6D2CuXmPiSgVLhVkj3FPVyx5OPuAZL=ZfA@mail.gmail.com>
 <CAFg1WMymkXM7MFHCSuU6M79QBT769qEfCXWH8nCkh+4vxXsfpw@mail.gmail.com>
 <CAFg1WMyej_PNy352d-r4OHuG8enNbggzngn_D6U4RrmZAaF8Lw@mail.gmail.com>
 <CAFg1WMy1zMpANgO0uuPtOo96GKYUj1M7XNzUigKMiV4-fDYddg@mail.gmail.com>
 <CAFg1WMy8TZKK_7J5DOMhZvVYCK+q_Vbr7fzePOadby2a_B__sw@mail.gmail.com>
 <CAFg1WMzYDBLCU-59Ggu33wjnbpL=7dnmkDqfbqu8AbuHbH-z=A@mail.gmail.com>
 <CAFg1WMy9TEGtgOEmqw2M1D6L3DjcUppOOkTJahaD4BL1PG9qJQ@mail.gmail.com>
 <CAFg1WMyROgGb4u54puu15_+DkyTvuwoxsKd98=aYq3M0svEj2g@mail.gmail.com>
 <CAFg1WMyOGjhh-eYsXKo7tDzUSHaqptn95XLZV4Bwqd49eHcm8w@mail.gmail.com>
 <CAFg1WMxcMc5z63fB7RZg=ZB2e2BtK8qiKaHBxB5-cWnhuKhrcg@mail.gmail.com>
 <CAFg1WMzsUUCW=i4R7O8H2jsOT+JQN-GFvPNxgmYDX3JOPW2HQw@mail.gmail.com>
 <CAFg1WMxcyjLFytjJ-_eM4Ma16yNm3u8sMyPzUd+HvpeNMGbqvA@mail.gmail.com>
 <CAFg1WMwarGfUW+LGr5jUnr5QgoxAxRnNEwqq2kdGwFk8BZS_Vg@mail.gmail.com>
 <CAFg1WMzJvRzx45uhKsT6ZvWM=8v3gA58Jv=6z1XQfaV3kOfwvQ@mail.gmail.com>
 <CAFg1WMwXNAf8ek=h_jUD5-jfK_a4h4TA0yxXbU_+FDtXa34OLw@mail.gmail.com>
 <CAFg1WMxSPC5cVifAwug_n5zKTiVedzUq5xsdWxpZkZpLEktxzQ@mail.gmail.com>
 <CAFg1WMx7CthEwLUMnH0JzY=2hFbFNqix=MWQHGdN2uXvCwr1fA@mail.gmail.com>
 <CAFg1WMxgsJVK9oFPmDiNLW5nAF+05VtD8ULMgTwproq-+TXYpg@mail.gmail.com>
 <CAFg1WMxTVH8Jx3GfZO6gVbRsg_huZ68j7VOE+wN8-BPvttsjtA@mail.gmail.com>
 <CAFg1WMy_DZaj1c4xkRFni_AQF80fNrTvOh++HZ3qEgOL-VdNDQ@mail.gmail.com>
 <CAFg1WMz4LiXZqZ1MHhFfdyMaV2rJy_TUWgnaNhqFz-XJqNNv_A@mail.gmail.com>
 <CAFg1WMyepg2WYz2CwU_Y6q9tJY7w5OhHc+0uf32OC+HC2_sP9w@mail.gmail.com>
 <CAFg1WMxBTBn9RCHDOifR6ByGfoj-KvLPVOOs=bvEhRVD6But5g@mail.gmail.com>
 <CAFg1WMyY-jE8O2sdf1-MBWmBJJ1i8ZURbG3Qci50gGSzTtc=og@mail.gmail.com>
 <CAFg1WMxYXY5M=Y4r7SscZcgV0RgT_a5jPEahNgr7OnuO5VEAuw@mail.gmail.com> <CAFg1WMzEiSb3CNQBpfikkRYbNw0VCTp8czw=uxnPm-Xrt1KXqQ@mail.gmail.com>
From:   Alexander Holmes <bobomor10@gmail.com>
Date:   Tue, 10 Nov 2020 18:05:06 +0100
Message-ID: <CAFg1WMzEdqNeDOK+xyKcZLmLCTHns5geW=X3mqPP3PM+pmhyvQ@mail.gmail.com>
Subject: CONGRATULATIONS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Congratulations

This is MoneyGram International Inc. we are contacting you concerning
your winning fund $950,000.00 USD, your e-mail won $950,000.00 dollars
through Internet contest, lottery bonus under MoneyGram International
Inc. Worldwide. The lottery bonus was contesting once in a year and we
are doing it to promote this company MoneyGram International Inc. The
last contest was made through internet by people=E2=80=99s email worldwide,
for example. USA, CANADA, RUSSIA, EUROPE, ASIA, AFRICA, UNITED
KINGDOM, GERMANY, TOGO, SOUTH AFRICA, UAE, ETC

We are contacting you because you are among the winning people and
your winning code is [HJMR07378]. You are advice to contact our branch
office in Togo, West Africa. Through MoneyGram Email: (
moneygramdepromo@gmail.com ).
Agent Mr. Nelson Agboko. Phone: +228 79541985.

You will contact us with your info, such as below.
Surname ::::::::::::::::
Middle name :::::::::::::::::
Name ::::::::::::::::::::
Home address :::::::::::::::::::::
Phone number :::::::::::::::
Passport or ID card copy :::::::::::::::::

Regards
CEO: W. Alexander Holmes
MoneyGram International Inc.
Headquarters: Dallas, Texas, United States

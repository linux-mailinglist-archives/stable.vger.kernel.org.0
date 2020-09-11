Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DF7265C04
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgIKIzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 04:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgIKIzc (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 11 Sep 2020 04:55:32 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A38C061573
        for <Stable@vger.kernel.org>; Fri, 11 Sep 2020 01:55:31 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ay8so9151697edb.8
        for <Stable@vger.kernel.org>; Fri, 11 Sep 2020 01:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=LbkVP7ji35e7Vce4zJMPV38JxqpXDCDGGIKr73dfGuc=;
        b=OB6dzBcdoHsbBEcMwMdl3Gpo9cYSVPxGD3L9orTRcsIwIfLEU0tMVNYX5Ag4AbyUPh
         4NT7NLil1a0eKoos9tKlPZzOV2M3jhCf/l8GMnVEEQkIHLhuQGB82rtFH2kpdOv45BTD
         IEQEaRxkBkY0bnc5pu3TQuqrMXkq08tpDH54Z0NRLBzhfGvxEZcfdOrMsgVrM9M4MlYM
         XCWB33Mc29fqgPyvElJRilbgPiEl71KsJyIy4WHi/EE88toArq+kgAlR0/0rNi5JVIkf
         GIrG3EtMZnnNbI2ccbfXZv+fuhUX1YHFaNraA6Nut2tlk9PxVPZspmtJ4Xb+BZPcR9vr
         zcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=LbkVP7ji35e7Vce4zJMPV38JxqpXDCDGGIKr73dfGuc=;
        b=rQl5EOEHXAKDBbgxB6014ryXuFPF/9+kzozDCTJQOMCUyAklJl1SZm6LkAuK99R8GQ
         fxIfX+XvYhmGMx363iKB2JMPzNYfZsYZV6f4B1qgZIzY3fxVJGuvAVfs2buRC0KzSLbF
         pQMS3gOq4izziuMLeJbOW9Ec7Z7GgHAqbFrbEKBRfhG46iBgXNnmzzTjUORrTQVpJiRP
         3BWtbufpRQkWGJQEeQVgyzeilo1ADVGhG1bZklALUYRV+QpN701R6bZDrm9Z1EgjExTR
         du+8YLX39Tnu+zBAo6F1VvPSxpQFNsZeLxhEPKR6ucbGC8uuU5GyYYcfc1czFQTycng+
         hfEg==
X-Gm-Message-State: AOAM532MPGhU2uqiUXjhvJS8SO3A9IennKtdA0JT0OTvxUh3y2q4q23O
        FXn0GKk4Ro/ZhE4bRtQ+03WVRjCfHZXUA9GsTZw=
X-Google-Smtp-Source: ABdhPJyTyz2id3c9dIFm9Mcmf7ibkgK7gU6/bMPilC86g1onVb6O21zcf7XjkCS+C53bwlywIjO6G4x/uhKzkuX2V/Y=
X-Received: by 2002:aa7:c053:: with SMTP id k19mr900384edo.326.1599814529704;
 Fri, 11 Sep 2020 01:55:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:795c:0:0:0:0:0 with HTTP; Fri, 11 Sep 2020 01:55:28
 -0700 (PDT)
Reply-To: kennethhjj51@yahoo.com
In-Reply-To: <CAA3sF1dE-Be6nyk8PeU_7z50mNVHQ+ibr-VkG9mYOeSt-aJGWA@mail.gmail.com>
References: <CAA3sF1dJaTwj0qRs8SSjNKPv0g=LmpYduNxEwFvR3=yEQyhxJQ@mail.gmail.com>
 <CAA3sF1cMWWEYya2bmtzjw-t44pQnpjvkovbMJt1-yaMSdxeGvQ@mail.gmail.com>
 <CAA3sF1fzN+qfV4LPcBvHGqTdjkRABosk60aptBTSae+m+u=Czg@mail.gmail.com>
 <CAA3sF1fUDH8uZ4v-jipi5wirU683=R2+7RsBpfDu2MPBHhaXCA@mail.gmail.com>
 <CAA3sF1eRHsXd5YC8U+vcMK_8SfR93YnLaE8Vu-Y9+iNufcKGHQ@mail.gmail.com>
 <CAA3sF1c3K=jZ7cYfE1He5fcbAjHH0Y-R0-NOtS7Tjm1jMDWG8g@mail.gmail.com>
 <CAA3sF1djGjxKwzLMN7OvjNa9_EyD=4pSPH-9+FRhNoRwqqADBw@mail.gmail.com>
 <CAA3sF1etwoSqAX1eDMbhg6kx_Xr-rWWEq_mybibnsA65Y4H1EA@mail.gmail.com>
 <CAA3sF1e=_=sommRgto8iXSSgUO=_OFo-LHuEf=AvGAFTn8=WwA@mail.gmail.com>
 <CAA3sF1fwJHqmKJ1c__8RLHJnmsuZHwUo5zBD6Ta6Q2kXPGaomA@mail.gmail.com>
 <CAA3sF1fCMOdm4ya5CZX6QT1-nJLhQXmZw4dwQpNnewz_8wA=+g@mail.gmail.com>
 <CAA3sF1d_q9uSXyXiJxMMaFZfARyCzDm2YeOmCTRHzXdHuo2mvg@mail.gmail.com>
 <CAA3sF1d2zAFrVBFgyk+aZ5PMW9rddrmoxh3_OyKa00ZcK+-gKw@mail.gmail.com>
 <CAA3sF1faSqy5GGcPQfLmY=6Ag0vX_PpVR1S85Whh2TRj7SLfog@mail.gmail.com>
 <CAA3sF1cZXFWBzoEWhoaQp=XR=4Z=SgXmPw4YiJ6JcpHWQtHiYQ@mail.gmail.com>
 <CAA3sF1e-31bFQixNFoTQkdp8SVxFMdwyBooPzZfc+Q8XCGJQiw@mail.gmail.com>
 <CAA3sF1eqgfP-rvJHQwoOAxD0LOF0oLkkHGHZN2CoRthfPuu6Ag@mail.gmail.com>
 <CAA3sF1d+0B2UkXiBwhJe1cAL8fAE8Yez=NdHFouD8SuHqphHmw@mail.gmail.com>
 <CAA3sF1eY3b=d3s7a8C-z93=r-B12Jm+TKVow9XHOW5B=2MD13g@mail.gmail.com>
 <CAA3sF1fUYoZCab8Z-p12HD-ynw+Ez3H2jk1TYZrbQPK2T-_A8w@mail.gmail.com>
 <CAA3sF1fS2+=biX1otvATXuY0ZETSyv-FNOWbm6rLYR29W3YKrQ@mail.gmail.com>
 <CAA3sF1eJAC=9F4kdpVa59JQpbcUDRq01knObQWsZeoXmqe0MQg@mail.gmail.com>
 <CAA3sF1eBjkdG3V8rqPev-T4BL9UGUw+sVysTE8C8pAKEePEoKg@mail.gmail.com>
 <CAA3sF1f96VQVq26aZ8u5Xk3Fka0xJW_0TGGQ5yNrr_fNfnGuqg@mail.gmail.com>
 <CAA3sF1dQHgOrVTZVwFOU4FcPaSi8Wc-2B+THJHABj5y5+hE5fg@mail.gmail.com>
 <CAA3sF1cak9Ax7B0ox4EpZkhP+qjKtahMKhDfLxYB0O3=2h8eXQ@mail.gmail.com>
 <CAA3sF1e393dkPsMh+8jBwjk82kGeEvDr=00jBQdErezHnqP+jA@mail.gmail.com>
 <CAA3sF1cagu54c8SNcvAjfvwPtos5AUq+6WKndAktixzkC-yELA@mail.gmail.com>
 <CAA3sF1d9gyHHozqhefGd2+kUs6FyY_YZtN1Lj78rTJdNZSDxTQ@mail.gmail.com>
 <CAA3sF1eJp=k9Nr3F8hw0g-kJdMuOdQQMP_3gafE5TPrJRNxwYw@mail.gmail.com>
 <CAA3sF1cP1uAkAazb5g71rQAprqWbdictUz245BjgavkABJGC8g@mail.gmail.com>
 <CAA3sF1fSW15j_LCKPf6hoqFkC1S+iZF7-kq21ahmThPgyx4xPg@mail.gmail.com>
 <CAA3sF1cfnWiXHOyNSpE3y83ZhE+WxUz1puPWv9shXBe8jVB3zA@mail.gmail.com>
 <CAA3sF1dK+JLJqisFusk8fGFFLRiF64kRFoKa0XiEmNoTbqhD3w@mail.gmail.com>
 <CAA3sF1crKEV-+0wRLqCq+KnNJ51iXKVCx5ayEkedXKs0eGYA4A@mail.gmail.com>
 <CAA3sF1c6TgTwQcpO0HMgSYeS_TDSf5KveDegKqfaOtYjQNn_yg@mail.gmail.com>
 <CAA3sF1cgZ4+=dDN4XEVwO138QY25xHrgDGoh2orOFLeMYU=VzQ@mail.gmail.com>
 <CAA3sF1fqYKZxSsqJQLC4+QakGKZXCpAtdmc63iZittyirpr04w@mail.gmail.com>
 <CAA3sF1eGufq3HH2DBq3zBj0rvgtDiaXHLz03v2rT=k=pMaL_nw@mail.gmail.com>
 <CAA3sF1dRnYQpnh=i5RqYBJwkhHDq7nJsHNdrrXX2JoHRm0+s8Q@mail.gmail.com>
 <CAA3sF1c3_GW-usU+NHjS98sb8LmRzE03gSj+7zkBrJhLQi0fuw@mail.gmail.com>
 <CAA3sF1cNvh1tfHfzfySF0YR7W7e_JhD5Fq=JrHmWmCZawP6N-A@mail.gmail.com>
 <CAA3sF1e4iY29m+ztQ+soqqM7UtT6E+HeUCjOEiL7pBAYV97ASQ@mail.gmail.com>
 <CAA3sF1du6g5kw6_hQxGi9qzmSLHjE_qJgmupfYi3mGe1rBWUGQ@mail.gmail.com>
 <CAA3sF1csMLBaA0fGrsDQeaObW=1YhO=TkhQAaGqnAorvvcjiCg@mail.gmail.com>
 <CAA3sF1f2uch4U0B5eqitmQVAquB6dp_2kKEHPxaDwkZLu9hYOQ@mail.gmail.com>
 <CAA3sF1f6m730NBeudit1GFOSQOgQBi5CVEMhp2+Kbj3AnNE-RQ@mail.gmail.com>
 <CAA3sF1eaHsUSPp8GzfNcgSrMZNtFmzFfjoDWLW0KfS_F3GCKmw@mail.gmail.com>
 <CAA3sF1fT3iyEzbH5ZYW0A+O6R6NDkEgwvqBhctQcJOfg2mMEfg@mail.gmail.com>
 <CAA3sF1fq-2nEAb2QdKn=d2X+Cayo6-X4U0zzb=v95r==10stQg@mail.gmail.com>
 <CAA3sF1dd19+d+midPDi=nxCGtHwaje=4DtcgGCb_iPWTOFxSXw@mail.gmail.com>
 <CAA3sF1et2W0wshjs=_C4SrjFfo4eYVH9RajBahwvt8gPz30YPQ@mail.gmail.com>
 <CAA3sF1fMbPsuBfywBPaQhjD-3m7vn7rxYVM--DpNLuF=pU_vXg@mail.gmail.com>
 <CAA3sF1fuceXwyru63BQrJQ-tSa-kh1VugWCamf00+Jb7xC-n_g@mail.gmail.com>
 <CAA3sF1dDseepjqJNgEhN+Hd=8kp6LcvBo9TmybbJHiugK3vsrg@mail.gmail.com>
 <CAA3sF1dOOajGs928U2EiMMfByMTD_ZsHkDB_o+98cmW1xbjbOQ@mail.gmail.com>
 <CAA3sF1dF_pxwA=HV=uMAor7nU8_UvHutysKmgnQrgJMQbTHcnQ@mail.gmail.com>
 <CAA3sF1dh+-1KcpDXky4FpV3sP8V=po+PZbaRyM9AWC8r0yP49A@mail.gmail.com>
 <CAA3sF1fW-gGb-GGkU785vZXkO7SWLGdEB=RpQmC+r7mbyrNZJQ@mail.gmail.com>
 <CAA3sF1d-MsSgN_PWFdZvcyVLxtZ1wd0hO5pi=HQJiBnRfE_NDw@mail.gmail.com>
 <CAA3sF1ehEUPjvr7XgY8dWAHL-E1LS_8-MJ-E6Rg3-keZWnkMZg@mail.gmail.com>
 <CAA3sF1eLqH8RNYsWf9yM1YVG_VakLdyerYcUDBYoAwSFOySKQw@mail.gmail.com>
 <CAA3sF1fPXHCbWvszTK_nsPc44-2GpN7EgEEX1PVVES63coc+pg@mail.gmail.com>
 <CAA3sF1e1mxNJcYKgjEqabcfHep==L441YSd9TEW4TPOiymeQHA@mail.gmail.com>
 <CAA3sF1dAdLr63KiK4VqkS3yWt7wuSp8dytchJu-kPxFtu-BUvw@mail.gmail.com>
 <CAA3sF1eHCiZLp1if=WNNRVNGEXv-WFZCxxTLjBV-RGtTNjhO4w@mail.gmail.com>
 <CAA3sF1f_eMYFNs5jLJH5kkULFkf8OSHszDwPwMrEcW5xR8rekw@mail.gmail.com>
 <CAA3sF1eNhaECgwthU9M8iY2C-DYeRSWN4wsXt5ZkyShfuJbnzA@mail.gmail.com>
 <CAA3sF1c8+W1F38SkoKbJLC6YiJ_fTmf_gsFLxTBJtKk_WZz3Jw@mail.gmail.com>
 <CAA3sF1dscxMmgf+cCsGw8QbpSi5sDUEohBfyTjr7PAv818MprA@mail.gmail.com>
 <CAA3sF1d6e11Y-DM6k70F316NPhJkOvVqPU2DYfRbW=0sjZLJaA@mail.gmail.com>
 <CAA3sF1cw6YKUz+NZ5HTL6RD=GCSEd5Wq35wFoZJu=3wsyssJkA@mail.gmail.com>
 <CAA3sF1cgbYpdq3=rHXd5dsTdZCNEjm7qJkvWucEd8ocr4o51xw@mail.gmail.com>
 <CAA3sF1eQWaVXmW6x07ZAzvs6dHp9EaKTgCBrvCiLrQmD7Gu_mQ@mail.gmail.com>
 <CAA3sF1ed-6K0-N_cQd+eA+d_m6NJzBTyzYKZRdzXQco17Wfjqg@mail.gmail.com>
 <CAA3sF1dp5=xD6+Edv6mYRUeYVHV6ktpz-yXL0KaepcGtA2P0nA@mail.gmail.com>
 <CAA3sF1cLSAZ3urv+jAcU0iGSu2GEF7dN15U1mgH1b9+1NOFhAQ@mail.gmail.com>
 <CAA3sF1c=OXHPOdXx75qFUrsB899TsRqqB3uv5aUfS82BrDBT4w@mail.gmail.com>
 <CAA3sF1d3QSTb82JuZUvf_cbffKxdm0_pHC3sqQLASk+wK3A-nQ@mail.gmail.com>
 <CAA3sF1fkJ1Pb2rg4WcjXQ4vwg9qDmJH0=Xb3afHtMO=w2+zUaA@mail.gmail.com>
 <CAA3sF1docGFpxVnDs8MT3rFMvu+Ep9O4=FeJzru1Hkk87EgOGg@mail.gmail.com>
 <CAA3sF1d4viHPVsaft5acpJV9x16amOe9SaMXpy34T9f8JA1R-g@mail.gmail.com>
 <CAA3sF1dubPf5AOUzjExgkdXUsYXVbCsLrTa33oM+oCi_d+Azrw@mail.gmail.com>
 <CAA3sF1fABecF1f9775jAB6_4a9zMyDdC2apWSNS8r4g=t83=zg@mail.gmail.com>
 <CAA3sF1cWAmEiVgPx9fnZcMRMQbe+eYFS2VYNPMgyVomea9-GEg@mail.gmail.com>
 <CAA3sF1eTF0duNGXfq2WtEbEnBiGd8dmT4DMzuzrFFm41Lr9o0g@mail.gmail.com>
 <CAA3sF1fmE2gfJ-_5TvUstsVKL1PQGupb7YtufdKxKtbHhAd3ZQ@mail.gmail.com>
 <CAA3sF1fpEqC2U6Wb9UqfgupHbSrSXFJ+gSQonQp+aNu7VcFfKA@mail.gmail.com>
 <CAA3sF1fW5snWimqKFw1PeKxohTmg-SG8fqysoMHagT4YJxqD3w@mail.gmail.com>
 <CAA3sF1fZy61WU5WxWxML2TuAxGxqmFmktv5_gHmhbH7cAhM=qQ@mail.gmail.com>
 <CAA3sF1dDGAXLT6HosPC-1Ui9SrnJ=t3Gh_wZo8VjqP8FcT60+Q@mail.gmail.com>
 <CAA3sF1eU-F12aSujzMXoBSV4dFAUPRcVNvNk6=bk1kpnY6zTVw@mail.gmail.com>
 <CAA3sF1fRzvuAmX94QtETF5na9+EzueB2Cb3hUZuG8fXO0xctRg@mail.gmail.com>
 <CAA3sF1dC4Yx+6hBxVYRjV2hk-BiX7VznfC8rYWOU88eHvFD1hg@mail.gmail.com>
 <CAA3sF1eKke-1+8+KV4EhVDA9Yya7KTjnS0ztcdhE4pvp0oOd7g@mail.gmail.com>
 <CAA3sF1ejGE2qWOA+EFWajTHGR4QB+sMN3m85DEVoUTEw6Che_A@mail.gmail.com>
 <CAA3sF1fTxHasWQ8Aos+rPbXZ5PS2GAxmYiVqMWv7u0Pa-COGYA@mail.gmail.com>
 <CAA3sF1et=fU+rqbFuppobte-rnHjTF43QPu5vk1XnSyyuqCQLw@mail.gmail.com>
 <CAA3sF1dcaEdc-pL9tbV2TB2vZVSFxcRoRnDX6+ynQjPWRPvOTA@mail.gmail.com> <CAA3sF1dE-Be6nyk8PeU_7z50mNVHQ+ibr-VkG9mYOeSt-aJGWA@mail.gmail.com>
From:   Kenneth Johnson <deliveryexpss5@gmail.com>
Date:   Fri, 11 Sep 2020 08:55:28 +0000
Message-ID: <CAA3sF1dcUrmR+zBo8N_F1T3GanbowDHkfkdQ8yvj--7FxwYGpQ@mail.gmail.com>
Subject: INVESTMENT MANAGER.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greeting,
I am Kenneth Johnson working with a business consultant.
There is a transaction of $1.4 billion dollars here that own by Arab
man if you have interest you need to come down to Gambia discuss
percentage with him.
Regards,
Kenneth Johnson

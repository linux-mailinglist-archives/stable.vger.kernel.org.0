Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2606665DF5E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 22:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbjADV4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 16:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235356AbjADV4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 16:56:45 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECE712AF2
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:56:44 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id j9so18024179qvt.0
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 13:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uiMizveEgyDAGlc0W47uncAUcG6L03VuImc0GvuoYxE=;
        b=p5o31y9OsfjdpSiAXjzA+5r3R6ImKBKWr6A445Wii0OKqT8FI8/3S9RS83PfqF/OJ3
         Gb03T74TU3VScnWn2RbvEiUKGUWUcGMRlVfSPgVQzPF4AJuwP4FNpPzqQ4WnLwh89iM0
         5mP8EDBDZsGvzmdVl1znYSmNzyBLGcBJ2ahHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uiMizveEgyDAGlc0W47uncAUcG6L03VuImc0GvuoYxE=;
        b=DFiD0iZsXgZVJvz6eJs+EJFiagxeXs/STRuizDjvc6yy1OaS63fOzhWzExKMKmReZK
         eZpryZE+6ebKysyH2AWXORVfVZFvoIxzr9ORZSqjOAwGaPsgrn5o1Ax9d6kge0W/F0V0
         OBL0E3ty1V1Jvpui/WQQ96eC8DDdlboQSdvUdXcEYTe/2bneLdxBow5Qgq2XpuaHX3ZZ
         GrsDvlO0XJf+6CbPcXUq7duPR6hnSrAgZAEf5cEvngXk08Sx6kjhlSrsGVrhIpc3fp+/
         Q5+jwsirqJU+nlkG/PFMzcSTWwvCcXtYzo42aRMQX1sB9C60eGUacZ/3cMyNUEWjDWG/
         R3lQ==
X-Gm-Message-State: AFqh2kqBpmfJTC7uho68pVT6605+7xIyvx74yQnVklLKfZLv4db6aMLk
        I58abirXJj+lEVB1ijOB+PVeMQ==
X-Google-Smtp-Source: AMrXdXs79DFhcOSo+x56due1wHHvPGqJzQtSjupgBYYgCdttjXsSb8ARar1FCsCF27OcTCqQ1ind4g==
X-Received: by 2002:a05:6214:4386:b0:4c7:47f:5511 with SMTP id oh6-20020a056214438600b004c7047f5511mr73638855qvb.48.1672869403574;
        Wed, 04 Jan 2023 13:56:43 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id bn35-20020a05620a2ae300b00702311aea78sm24196850qkb.82.2023.01.04.13.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 13:56:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Date:   Wed, 4 Jan 2023 16:56:31 -0500
Message-Id: <7BA3F66A-097C-44F2-AAC8-35ADBEAE7E12@joelfernandes.org>
References: <Y7UOtInxdmaIP9nH@kroah.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <Y7UOtInxdmaIP9nH@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 4, 2023, at 12:29 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.or=
g> wrote:
>=20
> =EF=BB=BFOn Tue, Jan 03, 2023 at 04:16:07PM +0000, Joel Fernandes wrote:
>>> On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.162 release.
>>> There are 63 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>=20
>>> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
>>> Anything received after that time might be too late.
>>>=20
>>> The whole patch series can be found in one patch at:
>>>    https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10=
.162-rc1.gz
>>> or in the git tree and branch at:
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git linux-5.10.y
>>> and the diffstat can be found below.
>>>=20
>>> thanks,
>>=20
>> Testing fails. Could you please pick these 2 up?
>> https://lore.kernel.org/r/20221230153215.1333921-1-joel@joelfernandes.org=

>> https://lore.kernel.org/all/20221230153215.1333921-2-joel@joelfernandes.o=
rg/
>=20
> That is not a regression from 5.10.161, right?

Yes it is not.

>  This release is only for
> the io_uring stuff to make sure that backport was done correctly.
>=20
> The current "to apply" queue for the stable trees is very large right
> now due to everyone waiting to get tiny things into -rc1 instead of
> before then, so the above two are still not yet queued up, sorry.

Sure not a problem, I can resend again later if it is still not queued.

Thanks,

 - Joel


>=20
> thanks,
>=20
> greg k-h

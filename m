Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B511E6A95A4
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 11:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCCK4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 05:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjCCK4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 05:56:30 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26781CAEF
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 02:56:28 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id i34so8587329eda.7
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 02:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1677840988;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCgWCG5DsxU28RYhUjEAQmRf7L6QjPKsDL6qK3oeiow=;
        b=8aLpAdlOJ1VmbvbCpN4q+onlU3iw99/N9A2t0OsoVG9nGRxUAvBmd/pihObn3CUp7h
         0k+jOGxiTvQB1V3CrdTUXCfr6E9rpumey5++pRHMx4MWA5ac4cQMxQjShDTEjTehSD+B
         YYCElBMpo9NdCvVpfTImMMFXbsPpfwsjq4DGbr6RkpFrTmwof8bwHml3bPbNJ4CPv62N
         WWKIqqodENgtMKKJKypllpm+9bq1SmsIBWBjWWuhXhFz0esvOOTMB1CSBSm23brmAaZE
         pE3653mezHkeGrbEm5t8faHOEVYkA5rQzJ4WiaJKeeYg6J9/71Uphofptzmv7V/49RfA
         ubOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677840988;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RCgWCG5DsxU28RYhUjEAQmRf7L6QjPKsDL6qK3oeiow=;
        b=bxSw/H+jJGT33ROjzEZmVa1QDC6TXJeturpjFyPOdOi8zXCrqUlf5Eq+OQA37e6l7x
         yO+HSZ9iWrW5i2H8TmNs9JjaaZ+wlk1Yt5Io+WTA5xE34/LWmbCO7+XPdtHq8WxCCP2c
         CBEBgp9HTcr+IFa3biHfO1oe9VlU1f7KwKHMTVSRJejIRx3G8AHcn/vuL7N6g1SxQ2Bj
         MjUDiTYqeLiAwmfz1ExvilD3YUqkU5u7tc9e3kqcGe2PGdUn1RYaLTC10iPAcP4IBbLP
         c2YtvWrwlvm4pwr1OZgZieepxqt1WNSeES47REyRZA2pwg4PAyVqvrvpTQzj2l30HuKd
         TAag==
X-Gm-Message-State: AO0yUKUPGDU+nC5eV/q7zCkD6Ou1RhI3akk173xhdb3qN2t45aLIgBNq
        WDnS97WUmQZg1p1BhT88FucqEw==
X-Google-Smtp-Source: AK7set/xIPiWL3AlgCF0YQlLwT4m3F3tdqoznTC5uNP5lRNBSUQKC8fEeTJL6WNpDiS6m71NUzouGQ==
X-Received: by 2002:a17:906:6c9:b0:8b1:77bf:5b9f with SMTP id v9-20020a17090606c900b008b177bf5b9fmr1181424ejb.13.1677840988312;
        Fri, 03 Mar 2023 02:56:28 -0800 (PST)
Received: from [127.0.0.1] ([194.110.115.73])
        by smtp.gmail.com with ESMTPSA id s4-20020a1709062ec400b008f89953b761sm827475eji.3.2023.03.03.02.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 02:56:28 -0800 (PST)
Date:   Fri, 3 Mar 2023 11:56:26 +0100 (GMT+01:00)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, mptcp@lists.linux.dev,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Message-ID: <b4cb0542-df0c-48ae-b791-8c0a601f6ec0@tessares.net>
In-Reply-To: <ZAHLYvOPEYghRcJ1@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org> <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com> <ZAB6pP3MNy152f+7@kroah.com> <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com> <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com> <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com> <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com> <ZAG8dla274kYfxoK@kroah.com> <3d92e773-896c-43c3-94ae-cb7851213c55@tessares.net> <ZAHLYvOPEYghRcJ1@kroah.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <b4cb0542-df0c-48ae-b791-8c0a601f6ec0@tessares.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

3 Mar 2023 11:26:46 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:

> On Fri, Mar 03, 2023 at 10:47:33AM +0100, Matthieu Baerts wrote:
>> Hi Greg, Naresh, Paolo,
>>
>> Thank you for the new version and for having reported the issue and runn=
ing MPTCP selftests!
>>
>> 3 Mar 2023 10:23:06 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>>
>>> On Fri, Mar 03, 2023 at 02:34:05PM +0530, Naresh Kamboju wrote:
>>>> On Fri, 3 Mar 2023 at 13:34, Paolo Abeni <pabeni@redhat.com> wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> On Fri, 2023-03-03 at 01:32 +0530, Naresh Kamboju wrote:
>>>>>> =E2=80=A6
>>>>>
>>>>> I read the above as you are running self-tests from 6.2.1 on top of a=
n
>>>>> older (6.1) kernel. Is that correct?
>>>>
>>>> correct.
>>>>
>>>>> If so failures are expected;
>>>
>>> Shouldn't the test be able to know that "new features" are not present
>>> and properly skip the test for when that happens?=C2=A0 Otherwise this =
feels
>>> like a problem going forward as no one will know if this feature can be
>>> used or not (assuming it is a new feature and not just a functional
>>> change.)
>>
>> All MPTCP selftests are designed to run on the same kernel version
>> they are attached to. This allows us to do more checks knowing they
>> are not supposed to fail on newer kernel versions and not being
>> skipped if there is an error when trying to use the new feature. If
>> there are fixes, we make sure the stable team is Cc'ed. If there are
>> API changes, it would be visible because we would need to adapt
>> existing selftests.
>
> "Features" are not usually limited to specific kernel versions (think
> about the mess that "enterprise" kernels create by backports).=C2=A0 And =
if
> they are, running a userspace test should be able to detect if the
> feature is present or not by the error returned to it, right?=C2=A0 If no=
t,
> then the feature is mis-designed.

Thank you for the explanation. (I didn't know these tests had to support "e=
nterprise" kernels.)

For features where the userspace explicitly asks to use them, that's easy. =
For events that are only created from a specific kernel version, that will =
be harder but it is maybe a sign that something else is missing on our side=
 :)

>> That's how we thought we should design MPTCP selftests. Maybe we need to=
 change this design?
>
> Yes, please "skip" tests for features that are just not present, do not
> fail them.

It might take a bit of time but we will look at that. I think we don't even=
 check MPTCP is available before starting the first test, we just assume it=
 is there if someone explicitly starts these tests :-)

>> Is it a common practice to run selftests' latest version on older kernel=
s?
>
> Yes.

Thank you, I didn't know (and I don't know if it is well known by kernel de=
vs and maintainers).

Cheers,
Matt
--
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

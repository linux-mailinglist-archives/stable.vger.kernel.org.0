Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A586A9465
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 10:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjCCJrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 04:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCJri (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 04:47:38 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0D310248
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 01:47:36 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id d30so7980535eda.4
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 01:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1677836855;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQ+INM3VwliGTzVvk8H3UaLOz2MRWdPHZPc0Z190kHc=;
        b=XDBR6dAdhp+6/U+LjGMvYZn2aMQ2GnSbRRuR4GsOvgRKx7Pq5mh379K9R+fVVz/2AV
         Pt8eGvvvS5rRLT971V9cHyljbebo70nc6rNqS+bDj7I5m/cZB8PlBZkgQmheTFzbCINp
         P+sfOrEiyYsLxEd/+4aMtUpK3bYWmjhl2QPEYp2Am0WfvcbZ7oyMUr/KUOq2o6vqtPoo
         kiEzMko5dfpltTFxj8QTJDM1p3MGr0LWeB27uOlPXSq9KgFYott3o3uM5cBpiO2TLG3a
         RuO1D5W6Kwjp9rvTmDckSi9QzBH08pwWQ+/uWs5SXy7TRN2N6toezs3DjhN47MNsZKb0
         k/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677836855;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LQ+INM3VwliGTzVvk8H3UaLOz2MRWdPHZPc0Z190kHc=;
        b=X3bu/mPwZ/UivT2v15mv7RANCiLVjmB7Txjwi3OfkKu+cc8MDJSFjUicncP/6qygCv
         W7lvB4efhKgxyHzr1P00SDixqUQhUJxLeZFJ7+58Jr0jTjNtaCAZ9J5Sx8Rxx4/JyzHg
         wWJ/w0QZqmFR33r8eXmjZ0fBsOYaQ19OB6eTBricL8fCQHNfwH33NRusm9Kq5Bf4yYge
         zZ8bTjMvE2f6Ss3YUcduKwDPtgzPOxe0hN8l9WsXfJebDiVkMU9WcTqNA0AoyRpXvNaw
         FDXV2WF271I8q/csH+1LiLTnCFR6dRzDJMeEfK0jl7QBqUa6AsnSQbxTxYKK/fQz9WaC
         ZAyA==
X-Gm-Message-State: AO0yUKUWKfGvoaEepZxtErRV2Yt6ImSTldB4jwP1kSVKdAEUtCuZWZ/s
        MgC1S81+Krs9mgVXB5vIk5k6kA==
X-Google-Smtp-Source: AK7set9pHwKcED+DJNcPo6PEgMw4W5FOluoDPONxOKOnJv1Q+C1tUrW42StaSvzVymezAExY/UwGRw==
X-Received: by 2002:a17:906:cccf:b0:8b2:c2fc:178e with SMTP id ot15-20020a170906cccf00b008b2c2fc178emr842246ejb.74.1677836854760;
        Fri, 03 Mar 2023 01:47:34 -0800 (PST)
Received: from [127.0.0.1] ([194.110.115.73])
        by smtp.gmail.com with ESMTPSA id g14-20020a170906c18e00b008b1b86bf668sm773251ejz.4.2023.03.03.01.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:47:34 -0800 (PST)
Date:   Fri, 3 Mar 2023 10:47:33 +0100 (GMT+01:00)
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
Message-ID: <3d92e773-896c-43c3-94ae-cb7851213c55@tessares.net>
In-Reply-To: <ZAG8dla274kYfxoK@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org> <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com> <ZAB6pP3MNy152f+7@kroah.com> <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com> <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com> <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com> <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com> <ZAG8dla274kYfxoK@kroah.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <3d92e773-896c-43c3-94ae-cb7851213c55@tessares.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Naresh, Paolo,

Thank you for the new version and for having reported the issue and running=
 MPTCP selftests!

3 Mar 2023 10:23:06 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:

> On Fri, Mar 03, 2023 at 02:34:05PM +0530, Naresh Kamboju wrote:
>> On Fri, 3 Mar 2023 at 13:34, Paolo Abeni <pabeni@redhat.com> wrote:
>>>
>>> Hello,
>>>
>>> On Fri, 2023-03-03 at 01:32 +0530, Naresh Kamboju wrote:
>>>> On Thu, 2 Mar 2023 at 16:30, Naresh Kamboju <naresh.kamboju@linaro.org=
> wrote:
>>>>>
>>>>> On Thu, 2 Mar 2023 at 16:00, Greg Kroah-Hartman
>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>> =E2=80=A6
>>>>>
>>>>> ....
>>>>>
>>>>>> =E2=80=A6
>>>>>
>>>>> Me either.
>>>>> That is the reason I have shared "Assertion" above.
>>>>>
>>>>>> =E2=80=A6
>>>>>
>>>>> We are running our bisection scripts.
>>>>
>>>> We have tested with 6.1.14 kselftests source again and it passes.
>>>> Now that we have upgraded to 6.2.1 kselftests source, we find that
>>>> there is this problem reported. so, not a kernel regression.
>>>
>>> I read the above as you are running self-tests from 6.2.1 on top of an
>>> older (6.1) kernel. Is that correct?
>>
>> correct.
>>
>>> If so failures are expected;
>
> Shouldn't the test be able to know that "new features" are not present
> and properly skip the test for when that happens?=C2=A0 Otherwise this fe=
els
> like a problem going forward as no one will know if this feature can be
> used or not (assuming it is a new feature and not just a functional
> change.)

All MPTCP selftests are designed to run on the same kernel version they are=
 attached to. This allows us to do more checks knowing they are not suppose=
d to fail on newer kernel versions and not being skipped if there is an err=
or when trying to use the new feature. If there are fixes, we make sure the=
 stable team is Cc'ed. If there are API changes, it would be visible becaus=
e we would need to adapt existing selftests.

That's how we thought we should design MPTCP selftests. Maybe we need to ch=
ange this design?

Is it a common practice to run selftests' latest version on older kernels?

Cheers,
Matt
--
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA2D6A968F
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 12:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjCCLj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 06:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCCLj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 06:39:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC98241E5
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 03:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677843553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v1Ct/6nINkmWZSFMigoxMFMstImpmSCqjjI/pBizmA0=;
        b=WSJ9KZpK4vih8azuewSkt/m8tva5TYHJ7JGhLYzj3q9hsBZ2evR073WBJq8FRuo3AE6YaK
        eSIK8x4Ft2Xa1PQunq3PPPAlKj+XoLmVobSEgQ+TnpTvtdKzypO6hOGYzTGY3bRLOoDUY7
        HPclpe5BwkKQH584WwUMLdQP8moISOw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-xZBJokcMN7KXmn68soc5iw-1; Fri, 03 Mar 2023 06:39:11 -0500
X-MC-Unique: xZBJokcMN7KXmn68soc5iw-1
Received: by mail-wm1-f69.google.com with SMTP id l16-20020a05600c1d1000b003e77552705cso873487wms.7
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 03:39:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677843550;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v1Ct/6nINkmWZSFMigoxMFMstImpmSCqjjI/pBizmA0=;
        b=ZaMw5hKVfodOJ/acdcKH7EHsEG32aAyVIxxr+aUaPuMNZTjA5I/8pEiScleHmdnZBZ
         zAhOmTM2jLuTSiWyafyCdNOUqdQmk7dI4gbZRUpXUuUpFXw5FjiGaHtOmC014nLlkXI8
         I/jWezbVTH60587lpN2S1PSgMa0dyyadWRUEpy/P+IAzT+o1W3ftPOsbNJfVVVeQNDFk
         rb6EaBQuBOhD1yVln1LjZAJpAUZAGLhuIlse1ilLXvTskGa3VzR4p/cMiA6SQixIBwSQ
         HvuPm8LATPO3Kt5++J5kyi9WYPxKLmVA7xs1vAmb1L8YucVtAf+mg3naE9RlCsgbx3kA
         570Q==
X-Gm-Message-State: AO0yUKV/00pkoNjdXb1cqvoWHHrNG9LhyUTR0fN5eQrqhdHwKknFuwTR
        CsCzd4/prjItV9WH190PHIurq6s7Vl0oRdyoZBo4ISK4trUxMHuxDTGDVu6ZLpVk5XoWezoEuOZ
        9I80vZQuy6iBzHWhT
X-Received: by 2002:a05:600c:3b07:b0:3eb:2e2a:be82 with SMTP id m7-20020a05600c3b0700b003eb2e2abe82mr1246713wms.2.1677843550663;
        Fri, 03 Mar 2023 03:39:10 -0800 (PST)
X-Google-Smtp-Source: AK7set9mwcWeiYEjlmyu4x2ILE7IqBBjOngusHgtCAMB0AGXHzaXoDMdecgdiEJ4F2mFuYU5V0UiRg==
X-Received: by 2002:a05:600c:3b07:b0:3eb:2e2a:be82 with SMTP id m7-20020a05600c3b0700b003eb2e2abe82mr1246704wms.2.1677843550405;
        Fri, 03 Mar 2023 03:39:10 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id s8-20020a7bc388000000b003eb2e685c7dsm5725689wmj.9.2023.03.03.03.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 03:39:09 -0800 (PST)
Message-ID: <28afc90c1b8b51a36ced5b6026d1a64aeb7c0b14.camel@redhat.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
From:   Paolo Abeni <pabeni@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        mptcp@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 03 Mar 2023 12:39:07 +0100
In-Reply-To: <ZAG8dla274kYfxoK@kroah.com>
References: <20230301180657.003689969@linuxfoundation.org>
         <CA+G9fYtDGpgT4dckXD-y-N92nqUxuvue_7AtDdBcHrbOMsDZLg@mail.gmail.com>
         <ZAB6pP3MNy152f+7@kroah.com>
         <CA+G9fYsHbQyQFp+vMnmFKDSQxrmj-VKsexWq-aayxgrY+0O7KQ@mail.gmail.com>
         <CA+G9fYsn+AhWTFA+ZJmfFsM71WGLPOFemZp_vhFMMLUcgcAXKg@mail.gmail.com>
         <9586d0f99e27483b600d8eb3b5c6635b50905d82.camel@redhat.com>
         <CA+G9fYuLQEfeTjx52NxbXV5914YJQ2tVd8k4SJjrAryujPjnqA@mail.gmail.com>
         <ZAG8dla274kYfxoK@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2023-03-03 at 10:23 +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 03, 2023 at 02:34:05PM +0530, Naresh Kamboju wrote:
> > On Fri, 3 Mar 2023 at 13:34, Paolo Abeni <pabeni@redhat.com> wrote:
> > > I read the above as you are running self-tests from 6.2.1 on top of a=
n
> > > older (6.1) kernel. Is that correct?
> >=20
> > correct.
> >=20
> > > If so failures are expected;
>=20
> Shouldn't the test be able to know that "new features" are not present
> and properly skip the test for when that happens? =C2=A0

I was not aware that running self-tests on older kernels is a common
practice. I'm surprised that hits mptcp specifically. I think most
networking tests have the same problem.

Additionally, some self-tests check for known bugs/regressions. Running
them on older kernel will cause real trouble, and checking for bug
presence in the running kernel would be problematic at best, I think.

> Otherwise this feels
> like a problem going forward as no one will know if this feature can be
> used or not (assuming it is a new feature and not just a functional
> change.)

I don't understand this later part, could you please re-phrase?

Users should look at release notes and/or official documentation to
know the supported features, not to self-tests output ?!?

Thanks!

Paolo

p.s. for some reasons I did not receive the previous replies, I had to
fetch the conversation from the ML archives.


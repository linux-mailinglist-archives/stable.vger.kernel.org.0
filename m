Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6E454B3A5
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbiFNOmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbiFNOl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:41:59 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C98225298
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 07:41:58 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id b8so929865qvi.11
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FBsZJFfpfTeF9JUcVAhkVMjBn3G9FWkdqOitqRjeTkA=;
        b=Nw4/U/zDi3yolySIU6Pf0+mc8ZYWTR1g9iXKkWkNo4YH+XYnYKnfM8Mhc47gVTlPFg
         wYeilpZ17ETv/zyPPDSOVZUS8Ln7bozQQkHOqitiMXubV12PB09DzbSl8PWdehW0gC8g
         us1rRb7LiCcb88tMdyHD0HbZeu1PayV3j7+UQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FBsZJFfpfTeF9JUcVAhkVMjBn3G9FWkdqOitqRjeTkA=;
        b=n4tyy77Ve4ttjK5BeIgnL9n42PpJQvhkGyePDtw6255ualSlfW0FgkWRM0v+IUHC0g
         ZwiA+t35eYyVHDdtUPMgtpkOQTTiOws54wqaFgMbPFW2X9brdHl4jOBwXPvG2q1vHRe+
         8K9TpJd1F0Myk7aANXq+JlE45Bqv4alYtGEiJmxGEV6z/BqkFgMzYbUp/tf/UIjBqxd3
         DTVh+CcwYXFKldccq/0TZTc5DPrmscZDowIlZG3G5UrKXyyt9EXabzDv1PiMSjPj12NK
         YIkMIdgnl8gGtHbEIPAooxj3dQNe5LneGqg3oPc3zwFlCxqRHTug23KzNgllsU8KBgbp
         3DJg==
X-Gm-Message-State: AJIora+0Xjp9qoaTNlQSdmPsJjyKev0o7wtCRXaRGKio+zOeFHsWe3D2
        YwYP80YFqqwU7jA2TDdRUPqHUT57X/qG88ncNJkmqA==
X-Google-Smtp-Source: AGRyM1vJ92Vo75c4DoJJBH5aByVMKqEEEphgbI+LTHkb8egrgbULuEYkh8X+tbX399hKIkNcNyK1Z/jC0VCggy9TUxs=
X-Received: by 2002:a05:6214:e6e:b0:468:cbab:dcd8 with SMTP id
 jz14-20020a0562140e6e00b00468cbabdcd8mr3597488qvb.71.1655217717411; Tue, 14
 Jun 2022 07:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181233.078148768@linuxfoundation.org> <CAK8fFZ68+xZ2Z0vDWnihF8PeJKEmEwCyyF-8W9PCZJTd8zfp-A@mail.gmail.com>
 <YqgsDXdY3OttH8Mc@kroah.com>
In-Reply-To: <YqgsDXdY3OttH8Mc@kroah.com>
From:   Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date:   Tue, 14 Jun 2022 16:41:31 +0200
Message-ID: <CAK8fFZ5SP4zAra2X8B3Q9zkhQGMfif+y-oEvkpR4fDpL8_upKg@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=C3=BAt 14. 6. 2022 v 8:34 odes=C3=ADlatel Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napsal:
>
> On Tue, Jun 14, 2022 at 07:56:36AM +0200, Jaroslav Pulchart wrote:
> > Hello,
> >
> > I would like to report that the ethernet ice driver is not capable of
> > setting promisc mode on at E810-XXV physical interface in the whole
> > 5.18.y kernel line.
> >
> > Reproducer:
> >    $ ip link set promisc on dev em1
> > Dmesg error message:
> >    Error setting promisc mode on VSI 6 (rc=3D-17)
> >
> > the problem was not observed with 5.17.y
>
> Any chance you can use 'git bisect' to track down the problem commit and
> let the developers of it know?
>
> thanks,

I tried it, but it makes the system unbootable. I expect the reason is
that it happened somewhere between 5.17->5.18 so I'm using an
"unstable" kernel.

Is there some way I could bisect just one driver, not a full kernel
between 5.17->5.18?

Jaroslav P.

>
> greg k-h

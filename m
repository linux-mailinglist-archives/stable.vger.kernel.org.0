Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3D4D2442
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 23:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiCHW2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 17:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241588AbiCHW2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 17:28:40 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDF6DF21;
        Tue,  8 Mar 2022 14:27:43 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id u3so658899ybh.5;
        Tue, 08 Mar 2022 14:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aSMng1r6YjOAee+dAY6//eCefHSkP2I3JjBP1oWQxRg=;
        b=q3uiZE17K5cFw81g4rRpSe8E/+9wtX2qPZn7LpHns+YaxgO/kWSOiyEAwuqBzipu+V
         2m3KorASjgl3YKvSrO91pfuFgHshrr5peMdqESH85XJhk8iShkg+wRafioTL3SIGRcQI
         yzrpxcVrRAVnUpIYAtPphjqdSmdZ38aJcTJvgoIdlhy8O8McKj2A6OqSyVuvFn9pbIpt
         jpoWr5MKjgU0ZzuRN3JUoM4RVHgblEpNLVRFMqs74j/3IGpZK9QqXILo7Z4vtEyneoVg
         DNK5f30Va8jCWponJZs5CncrWFfZfPXRB6L+7f/Q1Mg7R+W1jQpxiCThQNDCaLRc5USi
         QVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aSMng1r6YjOAee+dAY6//eCefHSkP2I3JjBP1oWQxRg=;
        b=hNLaJyTBMB47CtcqHIBadyTcAANUZUcrXBpE+MqVeUprSbzOulZoM7AdogAuo+Qy53
         EIsp1l3lFnduHo69WrKwni1qKR2Wth2j/FVosKzrA6ch2Uy3FkGiHDO7ju0icFyGjwkl
         yZiS5QkLr+Eu2RwiGVwAeW65N3u6C7OKkW+5hbECKzesefO9swfgfetwx5cYIGJUsC80
         zlGxSTPmw2ePQ8Bz8KA44AeUj2+APSS/QZv8ue7VCySNdfxp6ChvQuzVBLuEDWTrlwEG
         8oQ9kUbttvUqfnUNolQRTDzaWk8vlpn4+iQI9KgOSTmI0Qtul6JMJcCF1w1fFmPQqxiP
         H1wg==
X-Gm-Message-State: AOAM531g+8uVz1SIrYeUf9DeH+4/jzUqh9ErmSW8bvIWvI15hM95MTp7
        3ycLRWtvVmkaUpweJZEEjkUnJPMzpPA9VPAyXwA=
X-Google-Smtp-Source: ABdhPJxKmcGmC/yQ0zmUDBoYPdak5GwjSOLmmPUkVZWES9yLFunHu/+8ajzgMQOkfPJtbNrIyJEKy6gc80/S1Z3MXP4=
X-Received: by 2002:a25:7504:0:b0:629:308e:9d95 with SMTP id
 q4-20020a257504000000b00629308e9d95mr11553190ybc.106.1646778462706; Tue, 08
 Mar 2022 14:27:42 -0800 (PST)
MIME-Version: 1.0
References: <20220307162207.188028559@linuxfoundation.org> <Yid4BNbLm3mStBi2@debian>
 <CADVatmPdzXRU2aTeh-8dfZVmW6YPJwntSDCO8gcGDUJn-qzzAg@mail.gmail.com>
 <CA+G9fYv74gGWQLkEZ4idGYri+F9BFV1+9=bz5L0+aophSzDdVA@mail.gmail.com> <YifFMPFMp9gPnjPc@kroah.com>
In-Reply-To: <YifFMPFMp9gPnjPc@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 8 Mar 2022 22:27:06 +0000
Message-ID: <CADVatmMs_+YN3YAajL95fy98iEgoeb-7qXA_ZJ7K3QsdHGG=oA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 8, 2022 at 9:05 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 08, 2022 at 11:08:10PM +0530, Naresh Kamboju wrote:
> > Hi Greg,
> >
> > On Tue, 8 Mar 2022 at 21:40, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > On Tue, Mar 8, 2022 at 3:36 PM Sudip Mukherjee
> > > <sudipm.mukherjee@gmail.com> wrote:
> > > >
> > > > Hi Greg,
> > > >
> > > > On Mon, Mar 07, 2022 at 05:28:50PM +0100, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.15.27 release.
> > > > > There are 256 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > >
> > > <snip>
> > >
> > > >
> > > > Mips failures,
> > > >
> > > > allmodconfig, gpr_defconfig and mtx1_defconfig fails with:
> >

<snip>

>
> Ah, I'll queue up the revert for that in the morning, thanks for finding
> it.  Odd it doesn't trigger the same issue in 5.16.y.

ohh.. thats odd. I don't build v5.16.y, so never thought of it.
Just checked a little now, and I was expecting it to be fixed by:
e5b40668e930 ("slip: fix macro redefine warning")
but it still has the build error. I will check tomorrow morning what
is missing in v5.15.y
Please delay the revert till tomorrow afternoon.


-- 
Regards
Sudip

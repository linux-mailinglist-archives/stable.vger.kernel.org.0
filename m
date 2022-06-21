Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A7D552F8D
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347417AbiFUKRd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347576AbiFUKRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:17:32 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ED4286FE
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:17:32 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-317741c86fdso123895287b3.2
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jt1qYG8DE2ay5oF/w7RNJ0046FQ5/XIHNLYAjXBPX34=;
        b=GRbCfW34moazNoRcIIH0J89TYfE81WZHBTUdVrWDtnw3SART9I5IOu7yyzmY1XWGM7
         lz6dzdN1gdnbyMKCugBD4mC8gKExNn7JjCX3dyUBtIr8K8f8xBC59S5H7nL1nCL7nSU/
         F3Wbb7+JzIyjAToxjjvxWi4tDR9BzfQIMUDzhNvC3990fy3hhTQRGOobW8qoeOk9VaTL
         LatLgcEn+TSrdCcglDNLaF0AX9rd9CXY6Gz374Kw2gjQrgPFHKfW/Z9AQmwqqjvlFv1o
         BOqnYgYrmHLzU06LrNGPx09hhvNN32s0ZdUte5ApqVkKfbcbR3dEbBVCAG11j6tWOAit
         +pwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jt1qYG8DE2ay5oF/w7RNJ0046FQ5/XIHNLYAjXBPX34=;
        b=3jaSDA5Fd4NQoRm5spqM5F50jpGYwmCE01R+d2Xn/wDyGGtR2r1v9XxPHQeYK7SlU6
         6jUphRtjEZ1tvKFRny5KL+oTzmRpVwkkoMsKxv69eimafKn3G8cdO1Cd6hUsnsR6Gl0L
         7jI+qQOj2IARjF0FkyeJSYEcSPAnr4MnMb/MNDBvLTJTfBSVwUQGM9f/e18OazgMTSQt
         kkI/845oXjsVNDB+o+H6ZmmqcCTCZmfxHFIlIp9V51K5xqw5kCLuPhDr7bw+4x65pB8B
         ikgTwnUjeouYzUmkGdT1Jv6JuPKUEMOAtSZF6b2K9+Ulk9Rk5GwEQWtzWqlrTHkFgpVL
         yYOQ==
X-Gm-Message-State: AJIora/2q70kX3NGh37VMeV01g9dAfhK1sJTKlPi7GIbIheeV+fcv5MI
        yF1D/gvyFzsQt2+ksOMRITGwuH8TmkQaT4/0VS+G3/mQ0qM=
X-Google-Smtp-Source: AGRyM1syOd6rE6eo3iUGnoVnyj1fYz4FgNO2QA8jeeSO+vaJ8/3zCnZUDdPJAefcm7dQguAdKZs0UyXSZOK13KS81go=
X-Received: by 2002:a81:25cc:0:b0:30f:ea57:af01 with SMTP id
 l195-20020a8125cc000000b0030fea57af01mr32358701ywl.488.1655806651377; Tue, 21
 Jun 2022 03:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <YqxguwkPJhyvKbRk@debian> <YrBILWzY4ziMl7xE@kroah.com>
 <0a063bd4-e719-6179-fd44-356617026539@suse.cz> <YrFfF4O/y/MjZTsJ@kroah.com>
In-Reply-To: <YrFfF4O/y/MjZTsJ@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 21 Jun 2022 11:16:55 +0100
Message-ID: <CADVatmMs+2h75OFKXQrJaqtNZV_6=wm0yo828FF_uwrTswjm1A@mail.gmail.com>
Subject: Re: patch request for 5.18-stable to fix gcc-12 build
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jslaby@suse.cz>, Stable <stable@vger.kernel.org>
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

On Tue, Jun 21, 2022 at 7:03 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 21, 2022 at 07:03:20AM +0200, Jiri Slaby wrote:
> > On 20. 06. 22, 12:13, Greg Kroah-Hartman wrote:
> > > On Fri, Jun 17, 2022 at 12:08:43PM +0100, Sudip Mukherjee wrote:
> > > > Hi Greg,
> > > >
> > > > v5.18.y riscv builds fails with gcc-12. Can I please request to add the
> > > > following to the queue:
> > > >
> > > > f0be87c42cbd ("gcc-12: disable '-Warray-bounds' universally for now")
> > > > 49beadbd47c2 ("gcc-12: disable '-Wdangling-pointer' warning for now")
> > > > 7e415282b41b ("virtio-pci: Remove wrong address verification in vp_del_vqs()")
> > > >
> > > > This is only for the config that fdsdk is using, I will start a full
> > > > allmodconfig to check if anything else is needed.
> > >
> > > Now queued up, thanks.
> > >
> > > I don't think 5.18 will build with gcc-12 for x86-64 yet either, I'm
> > > sticking with gcc-11 for my builds at the moment...
> >
> > FWIW Tumbleweed compiles using gcc 12 since around 5.17.5. (Obviously, with
> > CONFIG_WERROR unset.)
>
> Yeah, I want to be able to set that value again, it helps out a lot with
> testing stable patches to ensure that nothing got accidentally
> backported improperly.

Sent another mail with the request, but just for information in this
thread, the following seems to be the last for x86-64 allmodconfig
(v5.18.y) to build.

ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out
by GCC 12")
32329216ca1d ("eth: sun: cassini: remove dead code")
dbbc7d04c549 ("net: wwan: iosm: remove pointless null check")


-- 
Regards
Sudip

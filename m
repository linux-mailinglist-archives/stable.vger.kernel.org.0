Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B44365CA17
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 00:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjACXAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 18:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjACXAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 18:00:38 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37B713F57;
        Tue,  3 Jan 2023 15:00:35 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z11so30232657ede.1;
        Tue, 03 Jan 2023 15:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7t0cKhaIlP1FC/fSvNTaDmX7GdHTbT3PBblRW/MDDSU=;
        b=fff3Ylyj6mA8CkFJXoYpmgV68j1IhsciHYHzS2YZKdF4MncvQXqjo+5O+cV++IxS3c
         EXbi1XpeITKKAoeV8nNNaLygVxiP0tlKbZ6BUHQYXJJzyxgHAhzM2tkaEnuNKc2B/vhz
         HyM4rpqSpUmCEBaKq9ABZBvIfHnGsEJw0AeuRJtXoCV7Q6mvLNLlyPpQXqt4/cPFcvqR
         s/B0ZSlhPx/BBUno3LbMyACAoelXq789M+fOjU+bwHamyY0NQxTSe5YHpBuJXYlZXyyp
         JONtdSh+8Q2blCH8b3yIzJSeeWOF5Ru4zX+exlN7Kwxqk6AB51u7PkyHQqh+PHDv+jQv
         MxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7t0cKhaIlP1FC/fSvNTaDmX7GdHTbT3PBblRW/MDDSU=;
        b=pcMAUq78sLcEcfKtjEkN9xGPjLXqJ/HFJJLXGNIrJGskpSK2aQt8PoVjLpiGw5laY2
         CqZMqtZhTGgRmiX0SZrGr8un+s8N+XzbxLY2MUCGamJ8P5fRpTYvZyUutuiBnou45/OI
         8X5KWFHaevhgSAu3lQvExVaCT8eyqTEx3df/tsYczKVM5sF/hSF5lNbyJ4ZytypS/VhT
         v2D4IgKwDlkskL3LiCUvjq8B5HnMisljS3vPT2aG4ySPXpArWH/Hew5f8O/BvTsLWP3y
         AYRrc0F9WuGbCDGlqKQzZBZF6eD0yZybrJKQe3gRtsnGEvuYwvy3H0Gd0bchELsfPpSx
         gkBA==
X-Gm-Message-State: AFqh2kqHlcJ/vy4YZlOi5WCY0g3POsdgHLWJX7HGIaUjCCAJWr0XHs6v
        2a1LibI3ou2yM/JZIIGw9unXIt7z6UlfuSv9TJFZ3DVg
X-Google-Smtp-Source: AMrXdXtL+LrfDkGxeFJwcG6Ini1fZxJpmMYUjU+MKgEHTzJz5ibDhYKUiTE5BFKHQ9nrTplK9cTZgigpsV2gr87sH9s=
X-Received: by 2002:aa7:ccd3:0:b0:467:b88c:f3af with SMTP id
 y19-20020aa7ccd3000000b00467b88cf3afmr4554700edt.24.1672786834397; Tue, 03
 Jan 2023 15:00:34 -0800 (PST)
MIME-Version: 1.0
References: <20230102110552.061937047@linuxfoundation.org> <Y7QFW7O0xqSYTzyl@debian>
In-Reply-To: <Y7QFW7O0xqSYTzyl@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 3 Jan 2023 22:59:58 +0000
Message-ID: <CADVatmPJrRsKTNyzWYeU10k+3eycd1bXTnwAaF7KKOR+h6mwYw@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Jan 2023 at 10:37, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.0.17 release.
> > There are 74 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> > Anything received after that time might be too late.
>

<snip>

>
> mips: Booted on ci20 board. VNC server did not start, will try a bisect
> later tonight.

bisect pointed to 2575eebf1bd2 ("net: Return errno in
sk->sk_prot->get_port().") introduced in v6.0.16
Reverting it on top of v6.0.16 and 6.0.17-rc1 fixed the problem.

This is also in v6.1.y but the issue is not seen there, and I am
trying to figure out why.


-- 
Regards
Sudip

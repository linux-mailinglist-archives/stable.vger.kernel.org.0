Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375DD59607B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbiHPQmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbiHPQmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:42:00 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417A580B6D;
        Tue, 16 Aug 2022 09:42:00 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-324ec5a9e97so166060327b3.7;
        Tue, 16 Aug 2022 09:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xeI0TzK7TK0zOEsbG6w8WUZfEt+fMLx/8nyM8dycqjI=;
        b=Ftkf1ROMDdlV3/9K7TB2tg6pY2hQKbTPyf/EpRiny7tAw/SRAjDCB74od/ghS9ARPm
         Bw1xjiZY5YpqBcbvi4x7SFjMDOiFH6sFiPqVbG77G4OKbCwv4Ly9poSQf2Oa7uzrFhXd
         v4v2unVqZNPFJBUJJb3TTr7OinVM3ZGETHBIOJ/KvZ93UEklsH8gX4tlwlU+wn4TGr5Q
         fEu6fXtP+pJ57P2wUt5kHXHHVlbg8BOILerOwtQNEqsfODLn1b1GU/weIvjGt9M1kiNJ
         B0dgYK3WP7Guccld77BPPS86+T+qoM9IfrBG/3uh+l3F7o75x1a8B7o9hUF3h4/hvDju
         /RZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xeI0TzK7TK0zOEsbG6w8WUZfEt+fMLx/8nyM8dycqjI=;
        b=ckt0UajRJUGJrHqnv5tFPjmYc1OVA18mItxh9/vhQMje6pQoAQ3G3GxjbHLS9M3fq9
         ZadZjqfUq/CgyN03vKZkG8i1S7jMFc0vNKU/yuudpA1he/cCg6L0RbYiYuqxqMpXSzGm
         y+OkIesGhAerKr8/TlGF3Hd3WwoKPkjW6Mn0g2xvCRlJ3QHSAdy/+ADJvetPB/uEEmaF
         WUadBZi+QDC7LSC6TawuSRf7386t8pm/XoR+9oJkv3sO1yu4OBWIsLgXweB2lhiDl3C3
         w1x+sMwM2xGHDr88I4vojHSPI8ygAfFJtAbmVsZuOPSkYnJjmuZeEnfPp5XwXO0oxCVb
         Vnxg==
X-Gm-Message-State: ACgBeo1sthbUfqqT5CjCDAZHmXWUVv5uY7ezFJ9YQDStGzSw28R1RwqX
        2aIwP+thmepACEbp2lcuUMlsn+jX4Bf9XDugDGGxZf+ghocGxQ==
X-Google-Smtp-Source: AA6agR4cAOtB/f5xqyWkMsEsljYa28EwSVdxAj5FkYgOXffRCMEssEVMFvEd7JGtQnZCYa/zML47222vuaQfRehsM74=
X-Received: by 2002:a0d:ca09:0:b0:333:dd2c:8ba3 with SMTP id
 m9-20020a0dca09000000b00333dd2c8ba3mr2421408ywd.488.1660668119463; Tue, 16
 Aug 2022 09:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220816124604.978842485@linuxfoundation.org> <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
 <YvutIhMRZW/nKOPi@kroah.com>
In-Reply-To: <YvutIhMRZW/nKOPi@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 16 Aug 2022 17:41:23 +0100
Message-ID: <CADVatmM4ZH0PvPiFrdwqXg5y-w4Z3=7YqLz9SW54ygScoODPmQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
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

On Tue, Aug 16, 2022 at 3:43 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 16, 2022 at 03:34:56PM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Tue, Aug 16, 2022 at 1:59 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.18.18 release.
> > > There are 1094 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > > Anything received after that time might be too late.
> >
> > The hung task problem I reported for v5.18.18-rc1 is not seen with rc2.
>
> Nice!
>
> > The drm warning is still there and a bisect pointed it to:
> > 4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> > pm_resume")4b8701565b59 ("drm/vc4: hdmi: Move HDMI reset to
> > pm_resume")
>
> What drm warning?

Reported for mainline now, at
https://lore.kernel.org/lkml/YvvHK2zb1lbm2baU@debian/

>
> > I have not noticed earlier, the warning is there with mainline also. I
> > will verify tonight and send another mail for mainline.
>
> Ah, ok, being bug compatible is good :)
>
> > Also, mips and csky allmodconfig build fails with gcc-12 due to
> > 85d03e83bbfc ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
> > regression").
> > Mainline also has the same build failure reported at
> > https://lore.kernel.org/lkml/YvY4xdZEWAPosFdJ@debian/
>
> Looks like they have a fix somewhere for that, any hints on where to
> find it?

There is a fix in the bluetooth tree master branch but it has not
reached mainline yet. I will check which commit has fixed the failure
and ping the bluetooth maintainers.


-- 
Regards
Sudip

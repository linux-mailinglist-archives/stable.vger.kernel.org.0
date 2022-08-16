Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD21B5960B3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiHPQ6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiHPQ6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:58:35 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC813F4E;
        Tue, 16 Aug 2022 09:58:34 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-324ec5a9e97so167287987b3.7;
        Tue, 16 Aug 2022 09:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+wxpwIG1XMVzetGmgkuAAiY0ICSFtFwah7TPym6pCh4=;
        b=oYg/XAIicHWDmXC2vlJtGRIbcIdHfzyCn4h5GzUdHyXOv+6YZpCboAWGd3KyFlKE3u
         5X4A3YWOnqVCLSujQBVUAzCNH3/gKWk6Oh9XBJKasCbDU6qXAbMKyRfjG27TQ3vIMfV7
         dUQl8PQHqBqfzpkbMHp20GH/fiJVAN4NMVBCbB2EKa7nMKSs892jFrAkuc/2mXwk6FfD
         yZSR3icujGAU6TwPyEQRlxpImuL+Bbckuv63myBS1UXWQ5GLISO3g1qpqG6ZEzQ9MK1k
         JNBusIiQTTr0nmOIcplabKz2VLBWRxDKvQ3hTU/fv6PpSXzoOag+qthuigZkxf3pnxul
         q17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+wxpwIG1XMVzetGmgkuAAiY0ICSFtFwah7TPym6pCh4=;
        b=Bq/IZPXHkXdS9qv/zxa3rIAGeolNgmToLxXeAgCv0MwbSVuLvbU8Cf33TplXlokM82
         LLj5t57akbb2xTevNfSED5Lso9NGsPTbHCUCG+fbtx1SzlVs8XWt1BOTSPJbu4lpoqfw
         g9lDOhig3PnmURIV8ImO/epiqAnZmjPnsgj1slrdhy7QTpRCEl/80LG1LUStZIEjoEEw
         qc5WGtMJ1p+HMjsbgrnkUrhEuDFOwLDSaYDvKC5InlYUo9e1GstTi0Zz7f3RqFWYMhm6
         QPenZ9jMqqJIj9IB9Leqw6wF79BNIp25/6U5319GTVEtkbg8MSC+tEXfGpgPm3K+FLab
         VLdA==
X-Gm-Message-State: ACgBeo3P/AocVoyZ4UXgYj33UDt8DXOa6lhWOodBWMtn7sEJdr9RRPEu
        l+zXvwI5v9i5/NFAcjQPVshJFWULaFY2UeE0YNg=
X-Google-Smtp-Source: AA6agR4sxYCput2tzcr7FOAo4wMbp7YmP8f6lKe0YfONddnhF5AOfZ5e2huqtkCFf1N+32s95KGz/1snYDmSkilbc0A=
X-Received: by 2002:a0d:f846:0:b0:324:cb8a:e0ff with SMTP id
 i67-20020a0df846000000b00324cb8ae0ffmr17732739ywf.478.1660669114060; Tue, 16
 Aug 2022 09:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220816124604.978842485@linuxfoundation.org> <CADVatmPOCPfHQHEuwVmOb5oeN2HfWWMztVok3qvoq7Ndndb14A@mail.gmail.com>
 <YvutIhMRZW/nKOPi@kroah.com> <CADVatmM4ZH0PvPiFrdwqXg5y-w4Z3=7YqLz9SW54ygScoODPmQ@mail.gmail.com>
In-Reply-To: <CADVatmM4ZH0PvPiFrdwqXg5y-w4Z3=7YqLz9SW54ygScoODPmQ@mail.gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 16 Aug 2022 17:57:58 +0100
Message-ID: <CADVatmP2L05SoUNKEbfF0-msB_Bz+dga+PDAK6Ncx5OTJL0oaQ@mail.gmail.com>
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

On Tue, Aug 16, 2022 at 5:41 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> On Tue, Aug 16, 2022 at 3:43 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 16, 2022 at 03:34:56PM +0100, Sudip Mukherjee wrote:
> > > Hi Greg,
> > >
> > > On Tue, Aug 16, 2022 at 1:59 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.18.18 release.
> > > > There are 1094 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >

<snip>

> > > Also, mips and csky allmodconfig build fails with gcc-12 due to
> > > 85d03e83bbfc ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
> > > regression").
> > > Mainline also has the same build failure reported at
> > > https://lore.kernel.org/lkml/YvY4xdZEWAPosFdJ@debian/
> >
> > Looks like they have a fix somewhere for that, any hints on where to
> > find it?
>
> There is a fix in the bluetooth tree master branch but it has not
> reached mainline yet. I will check which commit has fixed the failure
> and ping the bluetooth maintainers.

No, sorry, bluetooth master branch does not have the offending commit.

So, there are two prospective fixes.
https://lore.kernel.org/lkml/20220811124637.4cdb84f1@kernel.org/
and
https://lore.kernel.org/linux-bluetooth/20220812055249.8037-1-palmer@rivosinc.com/T/#m31035e486a2fc7d4f927073295a945743b77a55a


-- 
Regards
Sudip

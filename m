Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49324598B40
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiHRSeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 14:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiHRSd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 14:33:59 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEBE3ED50;
        Thu, 18 Aug 2022 11:33:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x23so2205259pll.7;
        Thu, 18 Aug 2022 11:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0G+MNwZPdu7nDAjzhpc0BZJ//VhJQrF/VMJ0HoUI71U=;
        b=QsB0EaNuA6DeH+2PPtb3I5UiWoe/iZeAKfbM7TT6rl5V+BbrA6/BSlnELwQMNSGCN3
         YABqSVKDTqRCHtH4bbMojYMnbkoWCu/3Hma/kpYLWwaP2aXOmR8nzuS5RZZXmXBln4lr
         BLiSCp42aEuh6ZpRVObYvHu9niwPBtULbQBFhtcljMkTYkPCvLJx9pcDynzSuy8sVxSV
         AwESClvi2kl0M/3mrtL5I+KmAJFdTYR6b1esz6IbqUlq2H2yFNHVZohhTCqFS6ygwg/G
         Vcdi7GP3dmL5GDj25+Hwgij/kjdSsO4OmBjthJvmV9IvkGIsUc0rGrxqjxkOv/FHaIHH
         rpnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0G+MNwZPdu7nDAjzhpc0BZJ//VhJQrF/VMJ0HoUI71U=;
        b=sF6b7j9tpIsME+sar/gG8eODvNevBI6RaA18eJTurpx3BR8z+56b9YGg2sbKBrkAL2
         G9mumHdtCxg0ZLQj4qJ61W8aSVgww0U3VIBhmZLdCZ2/Gq8aWdzwDAqxyxq1R6VtDmui
         o5UUn8TlTwPbX7BmF9hM6fF8GJSgaoFAtEiADSWvSAZkvP8y2T3OKA+iyXfn54dIyLN6
         WAsDcvXKBoBZKlopy/gMmOGvloLZamjCJXQ3xhCrJ1x7eX5YAWTbKYX9CRXrKYHXYgMT
         yCROcTrGhl6NIpeTCqKlD22bjKu23iLhE3BhSIsF66UQ+rzg3tJJtpXDtSS1RdQbGfHm
         +JWg==
X-Gm-Message-State: ACgBeo363vgyLTGmYVOAtHMSE8B44xFUbVRien3VEW0qkzT/E7sPomGL
        FIGB+SWX1Eyc++VYdDOlblWVb5eSpN6zq6eCIp8=
X-Google-Smtp-Source: AA6agR5OOLeBPJqavrXLl1cr+dy8fiXYyPbPBZJ+iNV6tD9JT7p31d7niFGbXNPecrW2sn0SX80bDoOfu9o57tpnwzQ=
X-Received: by 2002:a17:902:d50b:b0:172:a41f:b204 with SMTP id
 b11-20020a170902d50b00b00172a41fb204mr3636592plg.70.1660847638528; Thu, 18
 Aug 2022 11:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAPXMrf-C5XEUfOJd3GCtgtHOkc8DxDGbLxE5=GFmr+Py0zKxJA@mail.gmail.com>
 <Yv3M8wqMkLwlaHxa@kroah.com>
In-Reply-To: <Yv3M8wqMkLwlaHxa@kroah.com>
From:   RAJESH DASARI <raajeshdasari@gmail.com>
Date:   Thu, 18 Aug 2022 21:33:47 +0300
Message-ID: <CAPXMrf-E0di5=0RpNRXUEF3VRtQNSqoaAZ9bzGq9jMtiQ3xgXQ@mail.gmail.com>
Subject: Re: bpf selftest failed in 5.4.210 kernel
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        jean-philippe@linaro.org, df@google.com
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

I tried with git bisect between v5.4.210(bad) and v5.4.209(good).
Everytime I did bisect I compiled the kernel , booted my instance with
the new kernel and ran the selftests after trying out for 3 times ,
git bisect pointed to the  below commit as a first bad commit.

git bisect bad
9d6f67365d9cdb389fbdac2bb5b00e59e345930e is the first bad commit
commit 9d6f67365d9cdb389fbdac2bb5b00e59e345930e
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Wed Aug 3 17:50:03 2022 +0300

    bpf: Test_verifier, #70 error message updates for 32-bit right shift

Thanks,
Rajesh Dasari.

On Thu, Aug 18, 2022 at 8:24 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Aug 17, 2022 at 09:22:00PM +0300, RAJESH DASARI wrote:
> > Hi ,
> >
> > We are running bpf selftests on 5.4.210 kernel version and we see that
> > test case 11 of  test_align failed. Please find the below error.
> >
> > selftests: bpf: test_align
> > Test  11: pointer variable subtraction ... Failed to find match 16:
> > R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2;
> > 0xfffffffc)
> > # func#0 @0
> > # 0: R1=ctx(id=0,off=0,imm=0) R10=fp0
> > # 0: (61) r2 = *(u32 *)(r1 +76)
> > # 1: R1=ctx(id=0,off=0,imm=0) R2_w=pkt(id=0,off=0,r=0,imm=0) R10=fp0
> > # 1: (61) r3 = *(u32 *)(r1 +80)
> >
> > For complete errors please see the attached file. The same test case
> > execution was successful in the 5.4.209 version , could you please let
> > me know any known issue with the recent changes in 5.4.210 and how to
> > fix these errors.
>
> Can you use 'git bisect' to find the offending commit?
>
> thanks,
>
> greg k-h

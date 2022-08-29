Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5415A5770
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiH2XMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 19:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2XMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 19:12:14 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B8883C6;
        Mon, 29 Aug 2022 16:12:12 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x23so9412903pll.7;
        Mon, 29 Aug 2022 16:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZwVsWXOwwYEEpUv6m5fgKYoyOmt1BwQtfeczkdkZpCs=;
        b=qPywl4xMHWPOr0zGTtcrtrf0YGQV8q/uYLtaLlLPjeSloIE6OvrOqTPtQrg0CnEkEm
         8kPKpxQhckd1d/lEn18xkVMCYJgING7XN33bxA5TcWRgIVGvbxnALKvseNGAU4/jxRzJ
         u/6KpAwLz8pBK/rf0hnAGsvJdi3tOnHzi0U0KqxQyoFPNmkQXXHzO/5M2FsThyWq1Vjy
         3j+hgZNaH+cfzh36t3Emu15X4dR8TbG7/TS1J7Mtmc2liqLyRtEvnMgtEIF0l8UL9Nxw
         zSFrLIFDWQLgRag/CI4at0AAqrelEnNzTTFQ73nS3Rwp/Sxoa2I6UU42j0OX7IsxAlhg
         0Feg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZwVsWXOwwYEEpUv6m5fgKYoyOmt1BwQtfeczkdkZpCs=;
        b=D/aBYsVRwDL/3lypPLN8by7OVhHtFESrYQPilPZxsKZioi654DKnwhaOeFLK//4dSA
         egISZWBR5+yPhVCH9qp3fORuxWEcvRd9F/gC7Xf9WmDc4VThc3qr1pWOJ4qR2bGUeosJ
         T0j5czLUWBVrAPsnIPWrO5yjCijowg/FwgUCzZzReJOql8J7vEufT1HB5fw/63irff2d
         /hqc6YbxrxoF3xZiAU20PapU0C67/Yw9xVlX5Jfhzl8Oh5RggwQNQ2C4hd/bKvo89t96
         3IzEORr+S7NxDxcfphpCU3XW+UWvkgW/lAhP89A14swhPY4AjTSZ/f7yNmaxhSsVA7ZN
         lo6w==
X-Gm-Message-State: ACgBeo1E1jCLvaCHzQL/a79iSWsi3b7xKT5IGiL+8t9J7Pp8lGrHS1jX
        78NIgUfu9+KVrQiRcyX0TuPEi3fGXciRch+r7Vk=
X-Google-Smtp-Source: AA6agR52uIldYwkYoblfXhVNue3TjQChj+8KZq5WatZsLri72LTejhFGT8zRaQgf+fLNCDlHUDG843C5do3MComXL98=
X-Received: by 2002:a17:90b:1a88:b0:1fd:6a42:3eb9 with SMTP id
 ng8-20020a17090b1a8800b001fd6a423eb9mr18827337pjb.154.1661814731700; Mon, 29
 Aug 2022 16:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220829105808.828227973@linuxfoundation.org>
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 29 Aug 2022 17:12:00 -0600
Message-ID: <CAFU3qoYxktno-uxeLzKDwQEpMVG_T+u6M+6wWcLGnjFRTixJVw@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 1:03 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Aug 2022 10:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.692 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 8.521 [sec]

       8.521891 usecs/op
         117344 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

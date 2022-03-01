Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBFA4C80BC
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 03:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiCACHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 21:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiCACHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 21:07:49 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3909265;
        Mon, 28 Feb 2022 18:07:09 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 195so17024202iou.0;
        Mon, 28 Feb 2022 18:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2KeC3dPcvSnqfOGtSJ6PTl3rXghVvrXOECFwNaRwPk=;
        b=URIn1AIiPNy9XLaaw4GWCDPP7qgAf+N+7am6NvzO1wgIL/YaVo3T/BUDf2XUGy5wCr
         H8eU7QNNieStYksb6bJRr+CsJStvfeZemHduSyIjOKDv0lxVkV7RBwNOjPQIozE/g/mn
         94MvEXWpzopvZcny31wk5b8Gxxq/onSqVqw9a3nHRmav1usA0gSyEz3MBs7JEpE934sx
         Ij1NgbMG1318AQfGOfclKKJjAhuccwQ/oP1EUQ7LPQVpEbiMHQVwhFBWKOER1hb0uliV
         L6WbwAB23R/TNk0mkSes5JsZOlv3Ucn84iEX41ZiSaRrdFqiG48j2SWV+4JVdmN0Of7g
         pZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2KeC3dPcvSnqfOGtSJ6PTl3rXghVvrXOECFwNaRwPk=;
        b=KpSw9sPuxVClXG07Wxn/Jn5U7a5ZFKAREyKvdwAwlKo/S1DEfrRtza/fLlijYiWiw+
         in7acrKGgQHBVF4Ktx50FBLpTAjw9Ofw4P1LADWz2AwzV8PhzR28S+3Dy91Gldcv4iih
         ep/c1ZRgQYJM6Zilu6z+FW0NejLQT1V6vnpumBwimbKn2ZpGYkmbOGxEA1WxphCZHmjl
         ZvpgZQeERvYiErhKr1sf47CObgOAPJDNzAVNC4/ZLqacSAe9afQO8qY8AuXXg/PLCoKE
         ZqBtaddpVTa05J9pB5/PRCX+tiQrH9EzxDHxvnm7CARGqP8z/KrFCqBT82+4fEbNm5bI
         Zjhw==
X-Gm-Message-State: AOAM533B/xkkyUxM3608tsuO3+ifN8ED8a7zQb+OPasapSHbSOi3DdtA
        ya7cUAkXAPwzbMvuHp+y/NxuplZ47TDMO0U8hIU5/u+BzoM=
X-Google-Smtp-Source: ABdhPJxoQF5Pmp8NsbIbh59REDAg7MpqlSYZJrwcgKhRYSOURFDYR8cWDnC3SNfGfvEY4E4Oldit4ZEJzORqyF2h7ug=
X-Received: by 2002:a05:6638:268c:b0:306:7cbc:b536 with SMTP id
 o12-20020a056638268c00b003067cbcb536mr18658604jat.196.1646100428650; Mon, 28
 Feb 2022 18:07:08 -0800 (PST)
MIME-Version: 1.0
References: <20220228172359.567256961@linuxfoundation.org>
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 28 Feb 2022 19:06:58 -0700
Message-ID: <CAFU3qoaMvo25QMatDkn6cQLd0=s13=T=MH++GQTJmjxOOTUhYg@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
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

On Mon, Feb 28, 2022 at 10:47 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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

     Total time: 0.440 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 6.990 [sec]

       6.990131 usecs/op
         143058 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

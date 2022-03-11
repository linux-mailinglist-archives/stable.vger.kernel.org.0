Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496F14D58B2
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 04:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345893AbiCKDMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 22:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbiCKDMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 22:12:52 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A76E1A2717;
        Thu, 10 Mar 2022 19:11:50 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q11so8782336iod.6;
        Thu, 10 Mar 2022 19:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdI5I1OFt3VEd9Bi1D2+rlxHCTOR7F6TW/3ddnGABGI=;
        b=Di7co66q9GUmgtr7HV1VE4mIprk/TTqbfVAfjURthcTSUd4Spv6ddGyB24R7TvkDAU
         0OTi1WSJ37jrGL5tYDR0qVnZqB26X9WQD62PdmXf3HGvOcpuDlq8ZF2jDa44zVcskzdf
         7gXPa8yCti3/hx1k0L71KPHSRPPuGuyngOc1ztmxdv4MsLz4E/cxgzMb8d7sn60HNK7C
         MLgccfykQS9M2tCTWz4DD/8G/1wsty0V5G024qQY9S5AWXqoC3p97Pynm5+3nbxQN7SD
         nTsJ4OllH8nIiHbk8vckXgg9++ZYRt3HKq8mT0XJa7VKl2S6BIeguZL+NX0OaclpZfE2
         RZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdI5I1OFt3VEd9Bi1D2+rlxHCTOR7F6TW/3ddnGABGI=;
        b=o+FP7RHhNuc+fuqxng28dx691jmNTMLkwBvF7zbrXiZ72nYVkMHlnJvY6588WMXjny
         5udlWsPfEbGqpPXfe5IpB59jsKcrhS8T5xmJzKwduYizRfHQ6E3nbzUtuElJ8IdFkmB9
         tMO6aXHlNHqyMXWnMz1Yjfk+oATqanqmbAI7qk8yNocPsxKBxB//PADx2hipM4/9DM0T
         bEZZ0EpmBGmBKuXvknWa2oK8c6FtujydY9L4ffIqE1tfV3H1G0sSajkmalDhPKYH39EL
         sBfG9WICZAyrZGBMKk77qand3+hni+eKq25CJ6S1K6dym+GnAMjsUdKIPlNEH1XprC5X
         jmqQ==
X-Gm-Message-State: AOAM533wrbMmT1Tz5wzBrXm2xqHXpmZyd50VUqcIOVUQnV6UxSznAP3F
        bwxn2QE76jhet00i0i+qhu82MJt0UI7C+gOONu1m6+VnJps=
X-Google-Smtp-Source: ABdhPJwv1OsldqQxCZl2SyZrLMJJjWq3cCbyhZiH79FQnopMc1wOpcdXZ92hu4MgiPaoMcgo4EWFkcqtjZNZp+/0jeo=
X-Received: by 2002:a5d:8898:0:b0:645:e689:3381 with SMTP id
 d24-20020a5d8898000000b00645e6893381mr6539285ioo.179.1646968309416; Thu, 10
 Mar 2022 19:11:49 -0800 (PST)
MIME-Version: 1.0
References: <20220310140811.832630727@linuxfoundation.org>
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Thu, 10 Mar 2022 20:11:38 -0700
Message-ID: <CAFU3qob1-Jx9o3JEAf=wBQ=syGpTWBt5eP3F=8UJkA=ABTgBOA@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
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

On Thu, Mar 10, 2022 at 7:37 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
>
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc2.gz
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

     Total time: 0.441 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 7.078 [sec]

       7.078003 usecs/op
         141282 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

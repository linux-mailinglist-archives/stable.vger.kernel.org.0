Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECBB558BBC
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 01:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiFWXbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 19:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiFWXbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 19:31:33 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767B84CD42;
        Thu, 23 Jun 2022 16:31:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so4076134pjm.4;
        Thu, 23 Jun 2022 16:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G8uvmsgy7tKpYTYF4RCFXyQXCqKu9/cpSt5fM/godCg=;
        b=QoqbadbpYvua79jKA1e8HKKa2RSZg9jg2vVL/1OgdoYqw77LekWuyCUxRGk1+Bnmgx
         FJRgD3B8S3brg7Hyli/YjbLNtUiFgSHkRIWTrNIFeF7YgusO4vE7lBWUrV6JCWglbBHt
         /1OnyS2k7USziX8NluIQaRxhMElJ/IWVrRAlQXiikLqdEa5i2IMHNxo+307ZtluPqYvt
         1UfRe6KhKqUtC+EW3+bVJX6cB4Ac6kZY9xhRt5MefEvYwzmZBdfMCoXf1tgXZVrnVYV/
         96ZcWTMYFLmbkr1/7PxmhqiU44odT3a6DAy6jkbhmFRd/y3V4FA3KgJabxg03ZPacXJ6
         wNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G8uvmsgy7tKpYTYF4RCFXyQXCqKu9/cpSt5fM/godCg=;
        b=IyRDJ0LMrVIGBYuUtOddbCQZnxQt7cdSL14M6OGaFlVDnzZ8OepAs/JNN/zTZljue1
         m3GcHAGDZGrduokKX9dcSaMgZLCO8P4hTR0sZsKQ8mvH6sBPA1KzP96V2XQRaFl8Dkiy
         QlGkRuxqGckRW5D5mxGbzuyg/Gp3MCjmLbOby1AgkPo4SNvrRZ7ris+wjsnYs+VCBqtv
         BLv2dh/xmHvGSl6JThR741L6LFAk/TTrOyGqfwFbh1cJOewoUjZ+ZZqo+xtEdJ9UvchS
         ofXXUNLgNbE6fid1CTBYC+68MoYW3UBud/w2hbrWDl3rL987IGkIwJX+cayW485d9Ibu
         e24g==
X-Gm-Message-State: AJIora8v7nZE9yWyNlD9JNPPdaiWxPqpNYBwEp3y83Mq+k+0bdOiKicj
        ASvewSnUF6zoBd6BJQS3jsuOKw6MDEffNFZP1gE=
X-Google-Smtp-Source: AGRyM1sDqNf/bu1FMaz6ChuqzIB8B4ie2YvUmdSLChNgWLpXqYmj0D+cecoUTMe+m+1LVfHFOe4iKJY51tIRHzn2/SU=
X-Received: by 2002:a17:902:7204:b0:16a:22f1:f87 with SMTP id
 ba4-20020a170902720400b0016a22f10f87mr23538065plb.3.1656027091703; Thu, 23
 Jun 2022 16:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164322.315085512@linuxfoundation.org>
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Thu, 23 Jun 2022 17:31:20 -0600
Message-ID: <CAFU3qoZm+Bc9B6gnNk-HMZbHH3gKoT0pg9x1Arp14bTMPwerrQ@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
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

On Thu, Jun 23, 2022 at 11:51 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.7 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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

     Total time: 0.428 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 6.844 [sec]

       6.844414 usecs/op
         146104 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

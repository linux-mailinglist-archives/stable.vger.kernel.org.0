Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2833750624B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 04:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiDSCuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 22:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiDSCub (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 22:50:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3EE22294;
        Mon, 18 Apr 2022 19:47:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso963413pjb.5;
        Mon, 18 Apr 2022 19:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a+wHVK29LDVy7SxLBvCwVBdQJHc4Fv66Un/DLd7GdIU=;
        b=EPAUYLXLpvIcVgLSvF2C1u7aquurVlYmkwoD7CmpONM/DyuW7tveuUmI3HXV8/OJZ6
         JzFnqE+rXW3294qF6W2pvfFL6XTAscseXZHXQymiZakEZTNG8Bp14G/74vsN13OnEcn5
         yDmQ+NbxLGD5z/2ll8AtuRDbDahBioht+b4kBTdzH0CZOF/mTqr1mxOgYfKV0V7Yfipk
         WE960jj9jz5xh3eH3FpJ0vD6wLx3PsxqzsAhDN8+cFaG8yocYR0AAYmRSbSndM2PWDHj
         BVrdIchF3UGIsJQT1jk+Nq7L4CoQb4/F6d24eFVo1VLA4XUxBPkCbH4vXbCXvsSQnpil
         gVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+wHVK29LDVy7SxLBvCwVBdQJHc4Fv66Un/DLd7GdIU=;
        b=7MRaq+DCDNtboDuEn2REPqqU5lrE5u8Y03Ik5LjP+mB+puO78GRwnZlkXfmZAGplj9
         A5eaqh9cfJRNaY2GMdKGZozHAMe+onF6B/mWdfeGnrTFM556QBiA1H9ul5/FCQ6Sy9ji
         Pa/+nTiYw6Gk34VPM8C+O0o2q7hUMAPYZK3tGvCbynPqZndtgofdJkOLf7noXtNKYmOc
         66YaKg932+x4yDI970gzRmNonXtzLEQ8DGmaUiyv3Z53zTLuVTVgbln8bOtW3DKq9/Uu
         SGgj+sM5hxMyPZjqauEW+t1a5bTp77hYuL63Hwa0IFsq8v4bOgkSwAnGghQSHkgJSQRL
         Rahw==
X-Gm-Message-State: AOAM5306g0hYjzpjdbv/9iqad52vdIhSXTm1M37DsGdo8iZqt7BXfHbl
        WS+KfN0rXvhURF/LQx9X8yaSetGtcgicoYfDgL4=
X-Google-Smtp-Source: ABdhPJw7YRwGSwQupWrSfz2cM76J2ASB2zcBDQRirJF3pBWZsLo8GW0qfKwKHzBrQA9leokynQfgo+BjznRGycwvuJ4=
X-Received: by 2002:a17:90b:17cf:b0:1d2:8430:13a5 with SMTP id
 me15-20020a17090b17cf00b001d2843013a5mr10593061pjb.154.1650336470546; Mon, 18
 Apr 2022 19:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220418121203.462784814@linuxfoundation.org>
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 18 Apr 2022 20:47:39 -0600
Message-ID: <CAFU3qobi4Pgg-yz3NtfJkAi+s9xgCASR7sGjp-63zE_LwoqqiQ@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
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

On Mon, Apr 18, 2022 at 8:25 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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

     Total time: 0.435 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 8.614 [sec]

       8.614146 usecs/op
         116088 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

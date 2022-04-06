Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8612B4F5AB5
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 12:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347910AbiDFKEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 06:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244241AbiDFKEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 06:04:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9138340BF62;
        Tue,  5 Apr 2022 18:36:33 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o20so642927pla.13;
        Tue, 05 Apr 2022 18:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQGt0hnIOOf7L1JuGQZGg/PcLeKIC3qip1gbK+mzCmQ=;
        b=N5sYcPCxeFzL+oR6KcDkZZPbAtqkL7S5r/QcUwlEHafidZcrSl0JxLSg4JdgUN9HwP
         h16r3YCdRmpRkncFnQSoNxGZKKx69bfEoEHZ+fOVw2V8891iLIHMqg3rSZUFMlsoJGkp
         OAPGxAFEqpTpsdxL6PX10XpmyHSLPo8wiK70IFuOHa+8rO7d0hc9cy4BXfrm5+I1Oeqx
         wh2JEb8r4MoGNYhkSLQO468DG0of51JTHZsL5sTV/OBOvIiXzFLmqH1PzWBRq7BIYFGl
         1Y2RhKY5EVPOK7KVgANGkc5K1cIzht5gWbb4KPsWkyx/IUpFUfjGHhOoEbumyysrHigd
         jGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQGt0hnIOOf7L1JuGQZGg/PcLeKIC3qip1gbK+mzCmQ=;
        b=VvLYFbuZX1bfOygnhJNBiPcC0p+7P5KvTCu5o9QDpNVJhDsaZReLmTH9u1uyhwTvjO
         CbFYG0V4WUivh8/IbhgpudmT6hxuuUiOlLklAYMALRBnVdhWszEN5WZtHPcOFx/uJOTi
         FHTX3O4tz64BFIrtjUofiXr/CXPcnX+GbOGYlBGvXYE3HEa5KZJK5UHZ0WjmX2V0zO64
         WU+KFGitmIaMtEU+8BKrp2cJalvUpH91TzmajLfzryRCS7cAhf3Twku2mHluV4xKTRYO
         Z4d3sLv9hz3b5C4tXYMLuKnE2fPVIk85r/3rnxZwpLBpHDB53Ri6ZOTB5wlZ7BB971/q
         Yctw==
X-Gm-Message-State: AOAM532Xyh8jBMPr8n/9zdleesHlJqjS627VTCF8fqc11UGIU6D99uda
        dhai6+Y0v8u4fJOivQCgcIkb+6eHIKGLa6sh+Rk=
X-Google-Smtp-Source: ABdhPJw5QFM+vNDCFa2VadQ1b8E1P6bLhj+BMc/5gCwJv919kaUP05fclMh98ha1+H76fQksEzyOCgJcGXD0VIDz0A4=
X-Received: by 2002:a17:902:da84:b0:154:3b08:4523 with SMTP id
 j4-20020a170902da8400b001543b084523mr6437007plx.65.1649208992907; Tue, 05 Apr
 2022 18:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070407.513532867@linuxfoundation.org>
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 5 Apr 2022 19:36:21 -0600
Message-ID: <CAFU3qobksUSEOs9BQFFKieWH2HrpFqDVj+iKJOsrESy5MhLGgQ@mail.gmail.com>
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
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

On Tue, Apr 5, 2022 at 12:40 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc1.gz
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

     Total time: 0.440 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 8.552 [sec]

       8.552299 usecs/op
         116927 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8A7531FD3
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 02:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiEXA2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 20:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiEXA2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 20:28:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DF58AE41;
        Mon, 23 May 2022 17:28:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ob14-20020a17090b390e00b001dff2a43f8cso681327pjb.1;
        Mon, 23 May 2022 17:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BdqPu1HPMj+H8IaZVIz2FokWfX+Ex1sG3tG20G/V3C0=;
        b=MdDX2JcEH7gtQONMR82aGNBa3VeZu1R0Ve0twvRjh67Ao16tvP0Yu/aePJlGnZHM4B
         ymWGjKryHSU3xW501ydx4xWPX2D3RthaeCyNDW/Pc0thpvQy5tHqla3Yx+tcNLehoNRs
         PvoCYyzLPeKLuQja49+PTFPbWcuromSzWo6iL/r3DaZvllOo7WcQK5zeRuptSpv9pEMd
         LS0CeRxRsavYaMO5vNq6CSdfHKJJkkcJcuOjvSgBkvQgvOevdY+aIGra/toN79TCC4y4
         jzhKf4Nn4ayK1V/v4XF00XKa44ikb9IQfH6W9nS5dacEN62q1wO1MQpY7IXTOQGHMPHY
         zITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BdqPu1HPMj+H8IaZVIz2FokWfX+Ex1sG3tG20G/V3C0=;
        b=iKWk4W7rRjKXrDQAztGL1ecs6kgv10yvoIbqS4hOEJQJMeSJ4nQs4VWVrQRsQD4BqX
         h+bcvcSr1QPib3fx0UCE4qEYdIfUKh/pmV5nilbJK6XpSLhzK2gjKhGvp5RMGlO9A92s
         IsKS2zbiEOCPbwsweEb4wwJG1AtD0+uWZoX+w8YisRCsXaoHCGYWdV+O6/08LOSX2TjG
         hE4K3SrsBZrHywibdBB0+XF5jyuukC+2y41QHTsAsC1r0TWjvvlYKp7vQEyScULm8ae+
         BJ6ucy7G3wFuomHSF3oTtomKZae+sP4q7rhPE7eLGhnW2XwjbwRUqoJfYeBtwMdGlQzM
         t0ng==
X-Gm-Message-State: AOAM533zs0OmAppHNL3QAvUdEnvSEDbcfS3t9HYpds8EXgjdj0In3BHO
        whvvOOGjPIRTl/nvqCau5EVpBnsBqHZ6xmqxFTE=
X-Google-Smtp-Source: ABdhPJzRS4sJAryFS/ZRwzCFIVs9l2otRn7s2vNmhg50MjjZNLwuRZ0UpZZ8XABNDXl/uT5Rf4nQpjrgIO7GCd5JVkw=
X-Received: by 2002:a17:902:728c:b0:161:f216:4f3c with SMTP id
 d12-20020a170902728c00b00161f2164f3cmr18992723pll.65.1653352122501; Mon, 23
 May 2022 17:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220523165830.581652127@linuxfoundation.org>
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 23 May 2022 18:28:31 -0600
Message-ID: <CAFU3qoaDVbor3raNLvK=EMOp+82Ac2=6yT5_vgwUT_LeSCC6Qw@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
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

On Mon, May 23, 2022 at 11:08 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.10-rc1.gz
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

     Total time: 0.442 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 7.127 [sec]

       7.127568 usecs/op
         140300 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

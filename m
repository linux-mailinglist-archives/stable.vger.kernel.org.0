Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646C859AA04
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 02:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiHTAXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 20:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbiHTAXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 20:23:11 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAC91156EE;
        Fri, 19 Aug 2022 17:23:09 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v4so4851657pgi.10;
        Fri, 19 Aug 2022 17:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Xe4VbL2jqgD5CcQ609//xbHgw20boLRg9M4XsWj3VMA=;
        b=Ld5/qmJY1FuaBN9j1iyKMDP145ttEvFtyTiZMpUOM5Y7AF458c9lsyZD1ceP1o1Nky
         ZDcYFizJ7nV26y/YW7pKpk/7HbvaswjYAYHJJK44IeE6gORgrYnBJZ20DWQWO1S7qFMd
         68QWoZwPIWsCcmB88ZdXcOL9bHJAwBv09n2WksGdl1tJ/kP4CqpS4HBxGubjdbl3Rv+D
         6xs4rx24xkgDRvj2dsEplY5GyGO9Devp1nXitH6EXV3zBdsk9VEzhJNuDi8vSWMiGQuI
         syhNucaBU0CQQuTfZ0O24Rz5rEvpcgUCC16j7ai/g7Pi5hvYFuhjl/jF1P1tlX82lgLT
         M35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Xe4VbL2jqgD5CcQ609//xbHgw20boLRg9M4XsWj3VMA=;
        b=Sk6tactaWkaEO2NDGa3OzEX4gdl4ReCwp1dmfetu8dpTwE1uR4ZYhTdX8fXgYSSbhp
         ICG8b7Tu9i4CKKJzAzwfTdyHLjk7o7+9x3KAO1AP/nE1/xeU7WY3Tfd1i7ENpoYyZGo7
         cfa1ouQMddwsuYE8X3YFEcWH2HdE3YZrZIYsSSAilx1HIEk9N75NniDGZLOAt9znGzD+
         Atu3K1Oq/kWdU4WmbLDPaOC3ztSNf60+pZtTFeB8vXlTS+YmM8GL3iLs+PqAwvzWldJY
         1RpSG3ZEVHcJRwffzzVnbSUbO4DnI0BWozW/QOsC+tQ6Vi3lu+yGtlFDoYThljHlqGXr
         r5Rg==
X-Gm-Message-State: ACgBeo0aocd1x7awI1f4QrlTApcvOfeBlh91QZAfFnr5OIXa2l0TzhTi
        Ddw0YgtSPQs+AzFgEkwbVkImuV8Y4VDFMpGxj9c=
X-Google-Smtp-Source: AA6agR7ieUjFy3CIJ1+HpnfSrZAmkabVA7T41Hk+CP7606zflENLXdDEgeFvf2rqYt1rSoXsLaXVGpVfeh0Bbo2E6CM=
X-Received: by 2002:a63:ee49:0:b0:428:8e10:200a with SMTP id
 n9-20020a63ee49000000b004288e10200amr8206739pgk.453.1660954989178; Fri, 19
 Aug 2022 17:23:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220819153711.552247994@linuxfoundation.org>
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Fri, 19 Aug 2022 18:22:57 -0600
Message-ID: <CAFU3qobqz5XCcXBFHoi3=J_3JtJAX0F0y69-5Zo34-eAyJ9Bjw@mail.gmail.com>
Subject: Re: [PATCH 5.19 0/7] 5.19.3-rc1 review
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

On Fri, Aug 19, 2022 at 10:54 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.3 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.3-rc1.gz
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

     Total time: 0.734 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 10.845 [sec]

      10.845776 usecs/op
          92201 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

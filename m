Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5C34BEE43
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 00:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiBUXgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 18:36:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiBUXgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 18:36:18 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AAD2558D;
        Mon, 21 Feb 2022 15:35:54 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id j5so8546592ila.2;
        Mon, 21 Feb 2022 15:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QsU1doQuLDWMomjns2YITOt0nS0W9JINmgNgQg1HhGw=;
        b=nykv/uzsyVHKdVYpJn/szfh8lKKmFsx3tu6pV7fTBO2Cdb5JDbslKqMPPMQvlK4MuW
         7ZTbTGdMiHJNbOXBnX6AIBJ2o38kyf3fEduK1v75XgXa1cp0abeS0pXVWvGMcxcQ0KMj
         7n+GsjCunrYZPJXGlp369nEIAtWEnrQDz3l7g7qWxY9cHApwj/F7EUe/wpW4XFZKp4/x
         aKDIh6XuH8ulNE4I2prwiZ5PbHkewPZ+DKwj+CRjRxhowP+5ZO/bY4USsLkBpQaUsp2g
         bufHdnHuE7rQb06Wj/9+zOKvaKxCKt80QdFwaJCRVi+RNIwIT37xTOS6lmoC4KqVidek
         PT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QsU1doQuLDWMomjns2YITOt0nS0W9JINmgNgQg1HhGw=;
        b=e2ybT1TKtwzmYxTQzSbUMlUfzvL/QV9ku5boWGXDFgqADjeXWgUlMuVuYdZZTW56fP
         CYBbK/DqJ4t75uhn2a1vBj1OQC3S+pFBrkWZGoM+1oLqlkPEaCH8RlI42axFJDMTyyxM
         Ru1UxRfTWzkgyDkV3pDyfIi/r+wg2O8yxxSa0nBbT7GMmk2jV5xZehG+0GKSkcECs6up
         GJk69d9JbLj2iEokZV36764JQYE2+qVKRIHIXncRifjwLQPeYGmVc0Qz7ZtxfFKqvMJd
         xSx7a22LthepVyTNeNyX2xt7AXOEyBj1O+Moy9nn3/qi4joWpccGxUusRLNz3lY2yfTl
         B5kg==
X-Gm-Message-State: AOAM532Izk6wCQpw6dM+yQ3Bl+t9IRtqQWCdIetGpnHdyOwANYEcIyCg
        UzkIugXGkJWonq2AmJeldgFeHgyahyu+unt7N0c=
X-Google-Smtp-Source: ABdhPJw0Xv9v2mvaCvorY8c9mCVmFThM9k9j5cX2G3ihw1xx8TiKJ6Ie868SWze7xswxB9Dw/aN2HBJJKIUtTzvUXrU=
X-Received: by 2002:a05:6e02:b4c:b0:2be:a7be:cffe with SMTP id
 f12-20020a056e020b4c00b002bea7becffemr17160826ilu.225.1645486553793; Mon, 21
 Feb 2022 15:35:53 -0800 (PST)
MIME-Version: 1.0
References: <20220221084934.836145070@linuxfoundation.org>
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 21 Feb 2022 16:35:43 -0700
Message-ID: <CAFU3qoa7JwdHrJzTFWY4NfnHXqErA1suJg4eLbWC=tMo9hN9wA@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
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

On Mon, Feb 21, 2022 at 9:01 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
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

     Total time: 10.147 [sec]

      10.147192 usecs/op
          98549 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

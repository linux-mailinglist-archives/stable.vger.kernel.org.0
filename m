Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911685EB549
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 01:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiIZXPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 19:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiIZXPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 19:15:40 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0DD1571A;
        Mon, 26 Sep 2022 16:15:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso14020159pjk.0;
        Mon, 26 Sep 2022 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=c0fXvFvJOMIuTW4Z1E9aZYOrlWggN7xn6Sje0P0ztw4=;
        b=L8FFJsvHhrYDH+/ryVaqyUY9YfSfkXUPPtSCSdU4ScsxN9xZbGH58PguB8wSKgpJjQ
         cmDWs570PtG28ZAa1kMxk/XFpYueIogH5B5Jqq6+01FZFq8AOi+aE9SpEOFdlnlwhZVE
         k6mx6/fwd8QU1B89cAN9/JP50btsDqfpCCe7wHRVvz7tCH3O1zNqvnIdA9P8rct8njhV
         9ua7CihT1iDDiDJ7Wk896l9rhnq3ATZkkvcAw7q1YKnpr7SZl0Z7j/Pf3pnZbZXZfVET
         A9OJ0sxHdSOsz/meY9+hYnzOAnYTh8LhsDH7PhOU+xQAJmiiAmHf54xpLB+KhZ5GsaXj
         noHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=c0fXvFvJOMIuTW4Z1E9aZYOrlWggN7xn6Sje0P0ztw4=;
        b=U1tQfeVswahZ+RcPVyQkutbN2a9uGX7D18cGIDwnkcQNYgd6bkBO9SdTM/OomByIj/
         UsdgvpmF3rUWft13DjvASHr0DqOVcAfXllo8dVPoDFIWbZmvLqXeoGCOi1AXYwLJ4jzw
         sJe0c3oCRIqpm98b3mJX+TGofkwkIHYM+SbuvxXtbI8t8BUBJ6OFq+chAQ0yQLvyTF6h
         MzFd96mH6xs2Xv8q50leuUouxFah/LfKsHc1j79dAdKo7c1LyfqOcsu3XfIsd9Tbk0pF
         MxLc8jTd2VyWpsbwotMpJUsH3nW+FZvGedO5Vn/YP5l9Kzmo04vJAm0R0Th5lU2EuOs8
         S/6Q==
X-Gm-Message-State: ACrzQf05A1dyS4qNPPaTVOio/G+SY14e2AhJCeQj0lji2Nq5zAR0a29p
        ffZxJRgZ1k3d07MslzchlfoqbB2KZJMrGApikOsryGeJ6cI=
X-Google-Smtp-Source: AMsMyM7FuX+/K6pOAbClGEJu8hWNRd8BvtEhOWIVIYrbeo7aN2Du4l47VrBDTZSovvibkpebWmR9sRgC6NaqoFM/p2o=
X-Received: by 2002:a17:90b:1a91:b0:203:c2:7102 with SMTP id
 ng17-20020a17090b1a9100b0020300c27102mr1225821pjb.154.1664234133155; Mon, 26
 Sep 2022 16:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100806.522017616@linuxfoundation.org>
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 26 Sep 2022 17:15:21 -0600
Message-ID: <CAFU3qoZb89Xbz0oP3U9jU_ahx9vn31qWezHWVW7+5heAQ5pE3w@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 8:56 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
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

     Total time: 0.693 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.496 [sec]

       9.496474 usecs/op
         105302 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan

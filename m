Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F326510A0
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 17:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiLSQlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 11:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiLSQlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 11:41:37 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B27763F7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 08:41:34 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id c184so9275990vsc.3
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 08:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iJFqCYck12q41gp2BCtFkTuz3GQTAghzhiKGOBGpjEc=;
        b=CiKFu0HDhnyIYksvm9ZXoIv575lx5Zj2V2PFNZnzuwF+whYQ/V0H3Ow+Zfwf9sVJv7
         sV/HZUTeocWkHJObZaE47V6eyGKImp1yAPC7HWqgxdKGlk9f9aoNMVTqtWwUXl6eukYi
         TuL1Cl1ct8YTpofNmCu5UEvcDrt/Q0fwLUBYvkBZby39lb0dvfHHoVgHaSeasCnVjajz
         pCzefLpTPVdb/o/aT2lS/xVPVMXJQIXqKbrl/04B8iKHrljcAyEcn1cEqWoUyHvyJj/V
         hU/pa7h+8Qy/MlKBEbxM+CTV/Y1rtiYo81iRw4yPCa+rMD/ZBYWzT+jpRAXw3lD4Ujvl
         YWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iJFqCYck12q41gp2BCtFkTuz3GQTAghzhiKGOBGpjEc=;
        b=Tb6UuD3sQiqy4nfAxCsrOhv7NaNbI5Ese3t4zGNlEL76CqTOroOc6kG6n7UB6Xwpq7
         N4Iw2Ks0wv5YTszOnbkZr48BzkUj766YUjGzWzvpwNQBXBJ5rvZG5Ruevj0mX2k0a57B
         NJ04ATurVh4k1eAw9zun3q4tCtvlt+yZ72g1/VkJkY9Es2058rbvTzbu89ImvhCq8a4a
         gIPVbObfe/cal/dKFGSQzSRjMF9C6FnVDW6vPA68MlI+V4Gj5udCo0CJLuLNaYe3uWks
         wqeIT/ufGtPAg6ImIMnbTByQF+0E5Aem47/xiTGoCNYRHLw2xcvBJEAe8jtE7cQH0PRM
         KVcg==
X-Gm-Message-State: ANoB5plGCuujgnsdp4qzOICl/steJKTF5nI7N2xP3lCd8O6aC7XRGZKA
        m0cSA0SRDzn6J6zolzaZjs1XqSU9lCjoTutxbDXSi0Yh8FkoAG0y
X-Google-Smtp-Source: AA0mqf7DPjRJseGW3vgtA2tpBokH8F8ideOFReeajbG/uP2TVf6wN+RkQVt3+nnQgKjSyH+6AWKdUj/H7Y2hPjPcADs=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr3615664vsv.9.1671468092990; Mon, 19 Dec
 2022 08:41:32 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 19 Dec 2022 22:11:21 +0530
Message-ID: <CA+G9fYua0HB+KCjXh-5J6ZJUMS-aaXjHxSsK=ux-sY_ye+tupw@mail.gmail.com>
Subject: linux-stable-rc: queue_4.19: 4.14: arm: clang-nightly-tinyconfig failed
To:     linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linux stable-rc queue-4.19 arm: clang nightly tinyconfig build failed.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=0
ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=clang CC=clang
arch/arm/mm/nommu.c:163:12: error: incompatible integer to pointer
conversion assigning to 'void *' from 'phys_addr_t' (aka 'unsigned
int') [-Wint-conversion]
        zero_page = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
                  ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.
make[2]: *** [scripts/Makefile.build:303: arch/arm/mm/nommu.o] Error 1


--
Linaro LKFT
https://lkft.linaro.org

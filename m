Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC5E4FE3A3
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 16:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352411AbiDLOZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 10:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiDLOZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 10:25:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A489A4DF56;
        Tue, 12 Apr 2022 07:23:13 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so3044384pjb.4;
        Tue, 12 Apr 2022 07:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pqBu+E7smYUSARy4+yUB+2pUFzqvHGd4ssU0J/54lGM=;
        b=oeZVA7/ncT728qQkNSolYfMcpssD8EI7eeISbBibEH5RP0Mm7fx2Rh+O9c2wJQKn3d
         nIt/bbXJcu5zrP5mQ01MkPdld0MQipLuecVJ/xO6zApHoryWKlhExZaNAncl3lU3YjYL
         DQqVHxSTR1JlY5StoLSHnKmHkj7Ac1DeZrff4BGHO2YLXEhehsfNIL06POtGhJ1zkYGJ
         wijFki9sNjjLBm6EEhI+AGZHfu4E+f16+0LurlAZEZeHtPZPkkcmXZjWNhpiE7HOdaOj
         CJqgplNqg20vWG0YAtjO2eS++LECJKrwh5JukbFAMV56J5cc2z8eqc15d5e9nuBtxmx0
         HWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=pqBu+E7smYUSARy4+yUB+2pUFzqvHGd4ssU0J/54lGM=;
        b=6eGR0lZtLHkg6K+L9eHTmQPPwTXPLX4aMxrjEnYgtp1WcB3/ywoy34IK7joH/KWEf3
         bD6dbAUNpBU5MMkFZfpCEIfyRZk8Htu22vGk1XN3v2RRryn95CdkxQUWrtyaUFf/i919
         LAYN/9nF2LAm8zcDxtXSkpq1KPF2Fm42ob6QgDno90kelJTcjNcM+PjzYvX3uFaM2SVr
         mbGXNzzcMXjSsO83hTchzPAxHk8x9R2kITDe/zYv1HKO2PUlUaR+lHSiFG+GoGUtTlDZ
         iKghvKqQIhVoW5Nz5F3U8MPSA4tx/NF/a4bRCqazBHZSTh2iqCEwrCMY389JO2IAynjc
         nfgg==
X-Gm-Message-State: AOAM532NAEvHUHF8hjsL7dgp6ylrlXtUaUFKPvqLBoV2en9Plem78K0m
        nYCStVH9zpbI5WwCu2RhTMQ/QKBP0ev5t7fd6K8=
X-Google-Smtp-Source: ABdhPJyLf1h+B8IN6FW6Fe+r5TKWOk2KzyIgdSWrf7gephV7IvI6oZttZqbsoleYmcqEu17gjf1Iwg==
X-Received: by 2002:a17:903:2345:b0:158:87ed:ff87 with SMTP id c5-20020a170903234500b0015887edff87mr3558209plh.5.1649773392535;
        Tue, 12 Apr 2022 07:23:12 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id z5-20020a056a00240500b004e15d39f15fsm39597945pfh.83.2022.04.12.07.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:23:11 -0700 (PDT)
Message-ID: <62558b4f.1c69fb81.98ec7.56fd@mx.google.com>
Date:   Tue, 12 Apr 2022 07:23:11 -0700 (PDT)
X-Google-Original-Date: Tue, 12 Apr 2022 14:23:05 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
Subject: RE: [PATCH 5.16 000/285] 5.16.20-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 Apr 2022 08:27:37 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

5.16.20-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>


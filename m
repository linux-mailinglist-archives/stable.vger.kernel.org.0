Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2295588F7
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiFWTdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiFWTcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:32:51 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDE14F447;
        Thu, 23 Jun 2022 12:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1656011503;
        bh=S61MUOgGmdu8JJvSuihnGYYXe50ppNBdaReTnuk0FMM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=VGMh0d0nNTbwdRVx2SQwJVbsA/XJ4VK3IzdkOZ1YKTlomHkzsZcHuK8Wu9zefT1wt
         SmPi6iMni8CWgc99kRkChj1mCRMV2OAlunMHQOYeN4viTARmTYjLea9fs+wCMrOknB
         Uro2bT88zGuP6blYwPZrmYre2IYjKTy739WylPqA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.176]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N7R1T-1nauI62HaH-017oEZ; Thu, 23
 Jun 2022 21:11:43 +0200
Message-ID: <51440b73-4919-2836-235e-f959641445a0@gmx.de>
Date:   Thu, 23 Jun 2022 21:11:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:HgJZp+hUsaHOPVs0wLnLmpO6PkezFh26LGaJ6g0dCGeczSu0JTM
 Kwi/jhhBbI7ECKdqRVdJ42YDxDfkoPYU5R4NE0v4TJySpzYFNtniPx0c+KEY1qdwdFh50KT
 bntDkCAHBEoNE5zy1JXk7+pgJ4PSjTCGWjGx6IBzlKMCpfkWmSELUzo3POEptypsuQ4cgeF
 sz9vImYgdoPXLPHRbMM7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:G5E84ZIUtZM=:7xtmt65ukL/FvAe4o0CLDi
 GxuPVu8ZNn9WdI8aK537tOkJz56RPA0VJWkXq93gz1g1Zruyrv/d/kGYUFuKD1iUYiPZlEJEF
 kFXHCsOgHU2uA52eBT9Lml7eN93OMH6UpECygUtlV6gFGHp5vOB9HoEb23kgUMj3SwzjK6gVA
 gwnjGJFSh+TUFAadE9+lGbelw73lyH71VQEbXFFD5pLalffqQ2YkM3dT7qfsQQC6rm6aCjKHq
 rav6fbPkTbRhcTBQzH3ciLJEw2DhF1YxyCqHI7IGv/ijCJH5BRWzhx9C+xx454sJ0TtE+CM1F
 erpAuJXmULdyUJHFmG38o+MS6g3ab9HR1oK1j06KsJc9ZKraYH6qA0wHWcgwKgcOUcfS7yG2y
 8BVWxjeACRhMjk0EQ2IcGUSgCNZbIB3QILQgttOM0GK6sELF8CtEcKSXCGPJcIdPpsKcMoaDJ
 IssYZgz4xcefObx8PIuxgu8pTcTW+Yx3fUmvcM/gpDHPlCT2p0XCcChTq12rAkQAb1qAiK2iH
 Pg3/VhWY26hFPfNMkzWFtYXW/Pohwl7bt9GFisSk2o3N0E+7CXqixSYP5u+0V8CxhTBk8ung4
 WEEUeQ4pLi8It8Q6B7hmvVQvZu92IZczkrQnnW+YOHi6s+hTsQtxSh5VkNfyskscE1AGr7+TM
 hbg/MVDFBkPVUiAMeMdsTTZmm2eBFostEnjkFbQUJ9lCOAjWmbRPakPQhyzxzQb96eyCBFeXi
 7WGRyxUhAq2/axXFHhFTnEnkQtIK77fF1n927bYJsgwtC5tD6bN2NHPANmbJm3r3aSlWsVA6S
 219bHnLeyO5lQQRXVBgYc1edNoja6R/PWnyBwiP/tHkjb4MvppWXDhoMKaQ8DAumoYekk508k
 ZW2MbPWnxsDtlEjgmniUrseOIwIp3QrfUjPP1rUOR4elRl7/un5LarxAV0fdxBcjp9HO6aL9k
 XIIXU6IAYvXmMGqlNUU25YRMmwN3i0X1QijdqWgUVkVG/5zobUlAheDRLObMasSPlhymef882
 uerdlHmeGFLQYTzzIytMqgVhWwc/sxDhusoaKcDWRzcIgIOLOZcT8fuLkHb16c1lKFCcpsAg9
 XIBkFA2wMnOf2GGQRsx0EgzDPmM1sOt745dhzZ+BNXBAydGKefVGnvPgA==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

  5.18.7-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Tested-by: Ronald Warsow <rwarsow@gmx.de


Thanks

Ronald


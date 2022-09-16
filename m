Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9EA5BAD87
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 14:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiIPMgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 08:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiIPMg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 08:36:28 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FF2895E4;
        Fri, 16 Sep 2022 05:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1663331785;
        bh=t4xnxRq1ZGQzyp5k8NHFr21kJCmtrb7F9WQ+abAovjM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=f44inrQU1lWV8Vo+J8WTnxf0JTL7eB7vMxtgK46KrznQDj+FN1/++jxJEvDRureuA
         czW5LB+N7jarXEQQFKUREgCZSfoAMB6BDorVuomwXYevIGTXTTPwRy78drkhObJAV6
         GsssiKrrPXaKOXvAwuFE7abuItFt8LcOaZttdnww=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.201]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MTAFh-1ojmLu0dBf-00UZDg; Fri, 16
 Sep 2022 14:36:25 +0200
Message-ID: <a1e7334c-6e53-6af6-24fb-840b06741664@gmx.de>
Date:   Fri, 16 Sep 2022 14:36:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 00/38] 5.19.10-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Ol0kC20tBY7tOi1e2TYdIrBhjePFtA41cSI6+miWs6B787s95EY
 PA8lAYeeS6zcdweuMLeNp5/mWWyC4SsWpYaLfxj0PoamNnSoKdEgyeDk9BujKlOuEWp2x4Y
 JSiYAKYzbb1NFPmsmTCRIktN6qWXe8H5oOYnk7phi2mYeWL7kzBz4R2TX3uQk5t2vxSXtdn
 VWV+1NErVjRJ5jgSbe6UQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:W1s+znv9b1s=:/6Fs+PYNbghAVkbhmSDvtH
 or7n+82MolrivZv+Fd0srRTQ32HmARcBJpKNHpa5Ans9Rk2LHP2ffg65S8cK5l2+KZ06up52k
 daqBe+JsMcCiNkzSnukgf2FEOPTa/XLCoBMesHHUlC0AmjNfKmloKhDy2K4APFOTPa40NWhM+
 lkunzYPj7h2kOqxBSynLygvGByXG9QpwsvK0PvcuTzRcXST9zCM9BWIkaN70yC/6PFZe6b3O5
 IUrW/PuF9NChp8Mm07Qo1LThhlz/UYPAOtyNGI+FW9AlrtCSvPFgmjESJiigBinLp1RZZOK4E
 pCovQBjDzJWsAAyQf1UBqtCvblZfDK+jHWzDwzaB2pmnVwWYu8+SAd9rjbUxzTgm7S+jr5FFI
 teHiyn83Og2wLj4scduLrEdhP/6FnkDJbSgANgPGyIJQ1hYxhPfaNeyVb6SSg81aq0nmc4hP7
 uEILR0XzbABWblFmEm2f6UrDES/B32/aBneyU5fu5JtptkzklyDxud9tmklmvf7MRP47U0mTz
 FJAvSvnQc0lttyCCT33B95jx61fAVPGOxRbX8TO8x0IbywKy9YDFt3Cx2Ae9oxSp6Qu+0EsA6
 TFXE6/PCGAVneDlpfjxWIZpo3ePP0Th082ng8FXZi2D5tfFjZByX4lPs2znP3H+/VvUCte+RL
 TzeFWCCcqU7OEq6ZE0yBPlHf6HiLhGLew6y4CtXEmTCUDENzwJTAafiHlLRS0ICriq+Iy2m63
 1K/kZ80B5Bot3scK7g1Je3gZhB942lXYq8uYGRgHtWVzQMZiiM3MEJDPkMpbx3F8P49ok4AEh
 OaOjGr/wHC54fknCqY6/1uSyMCvFLRpKt61qW7sv0FklbUcA+a9WwGxSVyFsMaSrSdxn2CJX1
 /gfR7l7NzrJYqnAIoqy97Aryz66l5nPqS4YlD9R7EVv4PQB0K+iS90hswkqa8svXadlOp62YN
 jyHyU7BrB9l1hMtXL4YRcCHMdVq0LjP70n3diyCET6C1AqUF7j1+gBWvqfD0hrA+dSfmjHA7S
 X+OTEv0tQlseikmyvqIpLrrysCMSdpevUs5YQWdFRvGCRggmJXP3nq+2FNl2jm/7HR7P6ONQW
 Fsp2l8cye4YUH/1a9WjIo0i4MHfyDGY8A0EfqDDxepB5aCofCkjD9dAentxHgPr/nFKwWGgip
 bC+v0=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.10-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


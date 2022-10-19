Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847316046D5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiJSNVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiJSNVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:21:12 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDF818DAA7;
        Wed, 19 Oct 2022 06:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666184770;
        bh=zFDApoDas0uJkB2pTqthBHi/bLKJFfQsKy3mBsM559Y=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=YIH2twBdOjm2WL9TU5DvIGnatP0k9AjTVZWLz9cVCJ5CZc3165WZl+ZziysaxQG+k
         Uz1cwaZF0on+OfvDSf9KuGXSnnEghzDkbFu4RLzdJRSiF6noTPVS/uDcHmDOTR/4E6
         FViShCK1DLUtF3PVdxfvyUGa8S5KEgRYDXm9zxCQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.106]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McY8T-1pGZT63b4P-00cxv1; Wed, 19
 Oct 2022 12:17:09 +0200
Message-ID: <7b06560d-1271-fa17-fef8-f3b5da6a3f8a@gmx.de>
Date:   Wed, 19 Oct 2022 12:17:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:x/1Yky7vo0jNz9N4s9Sk3unjF8U50f8x1i1VQHUooN8MtrDBLnG
 yxXW9P1fHI4OEUQdlY4Yx0iTAEzqbH3Nj53M/sBZ2dhP6OXemSeExtHlv5XPIqyJG+860fq
 Zl/dC7gPU+51GkKBIOZ+EaS2oRi2yXbYUdbX9yCN3bFKhm8H7zEbh1PLoHwMcTovA78AIgQ
 jKNpEiTuRg5TnObMA25OA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JV77/7SUk6s=:ff8Poi6gMMhNwNxRThCjpZ
 sOA4hmebKLux5DUxjUGk5jNYpz5UWWLjdcukUVAvjgtjjI5DtE09Ac2UHycf/Rx1lExYO4Dv+
 FMR+ukXJRmEUT6JBWEz4UBsXDUD36c0oi9Ko409H9ZPMoJuWCXo3gXOVg8yv47TAvp8j7scbR
 BVBCDi55Tua99bpVM3nHAWh6fNcDadKByMMwvlKrcaekC4Eg3snmA/0wOUEW8jGt2hYkNebH9
 K+aoQi4ELx/akR3mfcCi6qYbYWlULdXV6L/J6Sy3e0C3VuuDZGcmukjFTfaPP1+2hjhpgdlFc
 WE9GBaA4VZhTf0O+jfddvJOYPyqn9N+gpI51gBj5Vhpugvk1Vkmw5OXqMj0KVdNYq+nGVePyI
 JFEV9efgbifOE72xfJ52KMoYPGUDK6vFcDTQjce1B9EOdE9eFSnx4lmoK33p7tVZ0dkO2Kp/D
 uwmgUKwdjvX1xjtj+TSyhlGGS8YayO3m6QTvsvu2DRwoUVfcAHGTrkDmcQ761gG926xWY8oNQ
 +Fiju/TjxINbs/zlMq4gJMM++xidOH39fGknpVhgpIzH/WNgxizeoGUUTsvT9BBVzjvM2TrxK
 oPqd6iH6RxPafPLnxaAALA4NqRcrDzc+Q8/QgUd2MfHC2JvaKo48SQftQ/jSN3jNf9l9bzdmX
 7JjXRNLon9snVslRfGlTafiM/NR7QxxL6HCo/z7D70861H6bB2Hlrz6bkDKY51grcYxLsrJ0H
 BaXEddn2vFQaUHXLPKTaHHpLIq9fowC6E+8Es7CYVvGNd0D1FP7Xg38t+9UpMOX9P6/+tzRGC
 qAKtvgZJ7jb+uWYt0zx29NFYaXX9gk3C9Ra0Ovs5VOHC1DFYXlxlb/jk8DlYIIzmkNmRyccYk
 oJ7cjqeOF7rTGZGSwIuoaO0mhMl6VeOIOtNgkUOv0/8gzASvf14UDmxfO90PuRiPqbAEKWxCW
 NhSrPKrWyecmMNhI7F9o1njeDeSO9w1Lcoc0xi7VPCv8ZrFG/XpkBoBqgqbsONAXikqMS2Xfu
 W9JlAlG4BHqKWllQg/rTATwuscat6cAqFWUgI+hDFr4KNMITfeBy1QS3AGoSXVCscOQu2E0yc
 ec4l9UHQF25guufQi0ywiBXyycd+bthdBjXh9GqvB16DYWRWkTaYqtatYeH0IpQI2L5FTCuqm
 Y6FhQND/56vtCnAlZ04pJWM/c2ZmhGMf/PY5QuFR+e2ZlDcI5OXLxXl9I4FxTLhaMT2qMIIx7
 gIKZirdp+sediTomApcyu510ED4HPUGZ+gHazXhcbIT34NL5N8W3SqZIdYrj+zUf4JW5ZPFPf
 gLPHAoHthYEuTlG4wbFql1qTNT1pNEkwrUDhJ2XrDnldG4/jDyZDk2Joep2gHI+YgWiqnlaUi
 zritnxBYslX+LWEVy0m/Bbcvrl2roraOiGIXL/RGvzs5C0xnC2+g+5M9BKk2f/U7wcH4b6Hxa
 DX4vLeNyZ+6h/MCWkpweBcI/MDEK+106e8L67KyqbIep+TntDsh7WsVgJxyE9Vj0p3Gjw6kN0
 fGtrJ9m5TOaXsrJAhrt9/p8o9jS49f+At1Ow/KJ9YmY+p
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.0.3-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


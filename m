Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DC0551F60
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242302AbiFTOyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242643AbiFTOxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:53:42 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A56544CD;
        Mon, 20 Jun 2022 07:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655734314;
        bh=lrpj5bWSK91JJmPZUyypEEm3vSEYur1O7qLUbe+x124=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=cIMnEM6IhJPcFX2biB/Wl4q+Vdgn04RTW1eJQoQfLLBYOMZD6REMhCEAciB6u1WgM
         ZsxSmcjWC9h4y7cIglygwNg2Sg+hUG5bO/np+ehAiTsoYquu893AyJlXRgtt9TptmJ
         PF4FnKcsGH0g0/BR4/XZHJvDlI6NAM8O4vRfMBzY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.49]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MyKDU-1nkYSc2Td6-00yiTN; Mon, 20
 Jun 2022 16:11:54 +0200
Message-ID: <96b85afe-a6e4-07c8-e1de-079893ac5f67@gmx.de>
Date:   Mon, 20 Jun 2022 16:11:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:OWX0qv4yg+TpG7dOD5rpGozVO56leqUX64ofGcWqZRcL1RbmgjL
 rPrD+AVNnhixi3KfDTntNyIZ7u5RFc14aoWC0phQOc6CXsQgbyxiaLGu0EAy1lVXdafRPDb
 MpZVpVbRksFTOQQpNuOJl9r+NeJj+uX9oNgpoROvPPif0dc2Y63kTVhI87nNOAKx8HScRDg
 GB4S9luGq9QBl61mBoLmQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sQnxqX5WwfA=:bv37lXSERIZLhV3VoFZdUW
 JNiJJjLULWVCM/Q7+1P2punW5HYraYvUaGEyReChKPd3jUxIM2UeYqpOsL5v0Q7f7L9zSNJSL
 mPxXKm+eov02rKKGoGKAhjpLPDcKZkt7ltWeZnxx5lcrwOV3MsTVzZ22D4pPmYlbYw8Dzinwn
 lNLjYw/p6IpndQ3L4xcD+pjIjpo/GuZydSParZ+X65gpuO3ILj09zviNXfK1c8/CtIPermdcG
 osIYx1Hjue02dXkgCoGs7Eq93nhkEwhez4qxQXlDgsPJUDUIYX+FNgvOX4ULlRmzBlHoU/Emq
 xrnb+zgr3rSZimYs8kvCNFB27qUasYo4ljhworSxbl0L4OMG7ICKfPgA7XG/4bBduoDQwkk52
 z7BxWA1il8AYAs7YCvN/40j1HSK82tjrOc0AzmydpDO6kXwMwRR8DZzdRDLYKccIKC3iKl2v+
 e1GEIFvRZ5P/O+rCLdjEXAML7piFq+zFKgqwCqO3gp8KqTtJyClm34Qwh+ky8a2QjXi12h58n
 iKM2QjRkpA0ON04DNRhCC0iHFnusxj7rVmJFaSJEq71W10raSCQd4OIQNBbZQ2QN25oNofhI4
 0XExGfcK/v7bLny3W34yI45CwVf1xOGQTn4Vm61PKcbjgm4D3oWBJbDpqH2i4x98w6DVzLMmY
 vT+bv5hO1RkjlWfPkNiNRTJU065RMSYM98RWlxMQuR5P68OgEiHgp2oua7hzUa93ayPxbNYtN
 o13N2FqH4fmwPvMy8Nm2bheSHXVpPqx1j9uXI0bIEpi9z6azh8RY+AHwkf+HM4R/TFkMO+HEG
 nynj4Sb1uVYThxK39ZdaUc/QNm7PHhACf9nCjYqMGnQY8O78DcP5rCOGd65UlUkgGqtSmyHNg
 1LdsEfn9iKK7rpTtHNaaucF1abi4pWJFnXFtmwzvxWYnm3FIHyLN57EjhSxkkhnsBwLECIYxi
 0LHl2Hg1aLUKTySGstKsryj0/HFh/skYWxNy03ZDkGvCAfyZxw2sUBxI49CHjoxbDl+yJ7cYB
 HTKA4aTosiRl6VNHaO8n4i0mCQRna8hiNKqO/72oYxHnztQd8m1vsfCuUZyKxpr8v17gXenHg
 xYlWlqTqorIUw804+KPDOIAJtxS1iENSWYR
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

5.18.6-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Tested-by: Ronald Warsow <rwarsow@gmx.de


Thanks

Ronald


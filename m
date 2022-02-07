Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647544ACC47
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 23:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiBGWsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 17:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiBGWsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 17:48:41 -0500
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 14:48:38 PST
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D20C061355;
        Mon,  7 Feb 2022 14:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644274117;
        bh=QhZBPtbAWH4+pKc3YMKNO4ZUECQS51u5SUOueTN1NGg=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=Lwl34HF/VMltqaVw0xBpCYB9VcHeyhGakRFm/hWcojk0l88vpnV0YwjJV7vPYywt+
         WeuqSC3XH/5ZyEqE2MyOQgVB0pzyxWelpwVAX9LMoLAHiIBqnUjb+tkwNrcor1MUkT
         JE0yd6wQwmw4PZGevbpv4ZyzSg0b7slAhUFunyf0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.82]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfHEP-1nxAS63xFb-00goFO; Mon, 07
 Feb 2022 23:43:34 +0100
Message-ID: <3251deaa-2b0f-1e04-fdb3-361b84ef4a7a@gmx.de>
Date:   Mon, 7 Feb 2022 23:43:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RZNd/xCD/zmSBdEh/hZVBZ/+M029zV543YVboXn/dcEJt8wJPXu
 fLJhzSU/rzrhToxixgkrDAjbT4y0SVNcIKR5YWEDnkZbNuI++xpqx+g4ggFur4FZixdoW2i
 ITu0T1A4qgSVpKl2xeGHAh4DJCArHZ6kylv86cbmk9lwOv0tHt0Ukm3i4UYk6fRDklKdmT/
 RrMRaK8icvVqGbOB6StaQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3ODOsgAMdFU=:WvP8R29XAfZ72OczrvrIFC
 OAC0aJ3+mV4pewM0QHZfKh0Ef2WMtY8Zw9jYgAOdWp6asUfcXMADovAmArfs/Dnha0yduAQJU
 5GuosIlInFnRRFcFkv2yRpxyuqopSP0JmJTzN4gKlnM6CAQoEwVJyJn4e1Ugdox11TEPSjtd6
 n318fLJ2P2/NQ8wg+8FK2ktJYaoqS5w9UVKbkqphGfJ+fIwusUjBI2yJb+KrhZdeVO42n8GIs
 hzTed7VAFtKqu63A6WurRQdf3oFVaQ+pXNHb3eLKENxIFr4PwwCSTBVzMmy9uPrd7hAvSOAMK
 +wtmpVDb2QvRLyN1eJrK6Da33a1j7aj26r8kHs0sqmJMvFyPy3pp1+3bOUJxWY+QcI8KfrPh1
 Ye7OpaIGiADgk4HYvPV9LzdQl+a31LnwxOxpNjVKTW8e7qIhY/IceTWhoo10vccLhcqdKnPUh
 6CxqTocJealxd6siT9lXfQrO7aCkjiVMfQYspaEBrQvfb7otOQF8wb+AAGvy8b2dmGXAbt/qH
 P+uRlfyQ5xokAZcVlkhPt0EYiBXIWWeH0iIe45AeCSsfMcXAfHP7Hv3wC4fQXqp1reLb0+huu
 Aq5xA6WlSLXqh6p7JOxxEe7ifchHJefg7EqqeuFt0NPsta/2IPCrQudMDbhJMHZbokTmBzUDj
 oAyPkToBjS4J+ChqrbvLqTR9XdGAoItBnN8YBw2Kv71esSFlhUgkLw+A/K6GgTZpKC5P1gFCA
 IoUiSbXuaDvMoXr7YFqaadE+GoE0vwNMqIQ/A5VfFB+NwijSn6kwawpDWh/a0nexWN2lfNv98
 gIG70nEepFp4aTWhmYeO+jkUQraLCnsHYEsKfRwYqxcZKk02cj+9yNehLzHWpNYJAPSYVuyBO
 TWecUg602N4fVcBa7eAZlu5+deb9ez7jz5MsMvMIxzlEBDpV2izOCxZyoPEWKnbF9AOFhk0k0
 n6llywkgEEqMQpfghlZ2CrKo6fjFAx3GMlHt7G7mFK2zL2poe+KkXpA2lzEeE8z0+3MHtDrcN
 EVI2g9F8kv7XZYtQdhAifx+ygToKg9uAOKYnE+LTyvUhnekkw1GDL44xG7VW+E9xxzCfprJ/3
 nvky2jMj/jh2vk=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.8-rc2

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
------------------------------------------------------------------------

regards
Ronald



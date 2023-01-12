Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4826A6686A3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbjALWN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbjALWM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:12:57 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504D93C0D6;
        Thu, 12 Jan 2023 14:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673561214; bh=vmKsO2duT5beaVZSDjMJOmZADWYL3PGTTozlKJCkNjk=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=oYw/dfiTS9zbZvJn9GuUXGTxGK/Q0AdSmlV4eDoTYEetDbjq92Z7QFdFs1U3w/C90
         JmQdI0k5u/5wVJmUQmUrdmSlbtqUJRp3/yOWTGgNrIJh479ctt+SvcMZlheKd9OMB4
         eZIn9JCaHQrY3E2O1qZNpl3OuflwdmJ46ppIe597+KK/g3QgBt46Ffz/OkHTYayOMF
         mLP8guUKl3Wypo1ce4kZXDCwxeGPtFNHwFZjS/2njaNjsZbym8E53yHSFBBwuCP/o7
         2WZEEfju7OH9BlpnrMXyA/cO5Tjg/Lodwv448DNfRVJ0QxusV1qPH+E3GtBu+ApkZ3
         +miAFcRMINsIA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.34.108]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MDhhN-1pQqgT2bm3-00Ans6; Thu, 12
 Jan 2023 23:06:54 +0100
Message-ID: <04df8196-311f-1af3-eb86-b7fee30a62eb@gmx.de>
Date:   Thu, 12 Jan 2023 23:06:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:jjly2qnDqXymmF7rlVT7aE7WtCgzJV9oXRusExnE9LJyV52Epe/
 oYc6X5h/M8X9VgYK+N8+FLwLH/mMtoLxW1zd6ySvrXMiSeXM7WhQz/ymLuKzoUzcRKME/+b
 HjfLy7HYS0fitPJ0iAsEEdZhaOSrPqI6Y+HzVsUidoAuUbvfwt/thOUMemA5FtnYTnYXWqQ
 DCogM79ZdylX7uu/wBxrA==
UI-OutboundReport: notjunk:1;M01:P0:kFGT9KF5kzw=;lKA9v0iySno8qCEkLg6/I+AggaC
 pCFgZyRuDZWGBlScTFqtIHDoyiuRbVB1VALA9j1FurqDuu7jxzSs2MABRM7cjrOYXqJwGlbsk
 K8OQaB8eSZiztfq4aZGXFN63kE3jpkv8X8jQcgvGjYD0F0Sjg3nxyaysjmvl7VU8BpflH76AD
 bnw6VhwuHWtk5gSz9FiYOtPzN5RXnibGOupaYy9qWgy5KHqIWbDCoZftSyJk2ub9hMK45ZXXU
 g6rt5CxnbHTXXC/Hs2Pky4m2iLaGAPcAi8qOHanDX0sL4ipsu5j6u9JnNRKJpkGqzmPeGdp3w
 3C5/ninOCg3JvOndClLM/bCGz9vjIsxWiT2+ElY2FMyKotNDF5oI54F+9KryZdd9EAhRmHss5
 0kT63spvIHE8jnBOqCoLFq4whW4rwjH4/WsZkXnVXGgljDMAZeHGlRdNFqF0cVO2xjFq3Xqbv
 SUfzY7aNy4b5v1C8B2EDWuZ7AX16rPyYhPRJ8bz52O+rmxel//dcJieBt3qhd+Wd2t1uOefpl
 peNuWLl7DccdUgVhkzU4hx+fCaWpCUwF9iJePlyOZh3+ux5PUuUVosME5Ej924HRpgb5I5Er3
 Bvna9sC3hU7gNEtsHoQ1vQiWtZJcn00bACdaea8nUpjnnQEZzgSbY7fZfLDhg9mmNnVnPfpyq
 PDVfLJEZvylrAFSHySE54xhMfKJvvQxo5v0IdcFVHE58CRZz3nZJTMUNqMvS3YWeYQYm4Ag/a
 evbwdtmyB0DLZz4Bjra/RcPXk1NM+DOkgMYHtJMM0bjvhw1ZTP89Y2C68QdmpfVyKuy4ZA3wB
 3PDJ1jR6NZ0Huwnv2tkTqCyq42I+SlhuivQf/muM61Opsvga1ZHEuqAiBDAPYsEKb0AtElqo/
 68DSacUuTWNpBbsG71BJa/EvQDburSFWWRV/ZVHHgiotivD7a0Op7UiVdixtLnJVriO4cEfoP
 2OlxIZ2X2XKcX8cBdbl4aLZy/vI=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.6-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


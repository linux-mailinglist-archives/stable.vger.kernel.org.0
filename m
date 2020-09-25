Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE7279040
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 20:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgIYS0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 14:26:38 -0400
Received: from sonic309-25.consmr.mail.ir2.yahoo.com ([77.238.179.83]:34898
        "EHLO sonic309-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbgIYS0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 14:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601058396; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=dzhYUhF+Hxv7YEFlJk8xGjWe7CX1WxcHNumG6ezP2DlkbPv8d91gleqFahbEXODF1b+FHSrS/g6Z/Q3iEiHMh7/+GWaQ75O46DVUJi+CCiv9XpcHL2d1u4C9RtFW6SYoBbhqiCK6MQSyrn9MwSb643LWzllSNU81dVI1p5205sYh9Da+RVWx0PLq0ljNxOVF8H53a3U5hEvavaGVeSdwFliGE5efYWMiDdndk8wipKCpRtI/EJWVOSEKknVVHGkge6eX2zNkUYWNBOO83At9b1PCHL2dRu0TQzqBTB10b8pnXxeCS9ogLPq8nP6IUKoAHjz3L5G8EHHTcImtlRZIGA==
X-YMail-OSG: XLJ5IwEVM1k6CPksh8Bo.a0xtwSae7pe903fa5yJ9LNvz93vFq_5pqBBNw2AFye
 _nmAl_08Mfh4n4hqNJgHoHud3NCW_ztqQyjjXYjvXffPkL6LT_35GnrtCdzQP5liQ_wLZI8gOupw
 kF6lyKmuDYahW7U1XcZn6jAabyl5mt3xvklyVcd6ziGcUdVgSX_UHF9O5Uh6xrBpGVmtKclkoste
 GNpZis6J_MYjGwVEzbP7cfsKPuuQAOhVLQNhetTx6ao_dQkTwBYEgzNjRfxEIL2Ll8hSEIJplMV3
 b1J6uKoixU9poHTNgpmCNXw96EXOlS2hH_uT0OpsugDc4XLGsG4fs9TsoNey42zq8ph928GiX15P
 SzJ_H0JQayHIzKo8u_AKOwux1KeMR0wapVrM8OKRGJv1pgKsKin6bPSwhBynBXm2rAqkXdTH2jdk
 swiidf3qwPPTMPDS8_sN6avg1Qryq_ILbTvywRHxzJUYHvYE6aLQiCaV94Rmv_9x5owDNN.Wvtbw
 3.sm30mwM7zI0JP61G9MreosJPOyC5QyLh5EWOW13GVeSWsaWZZNHPIu7vjEUyrScSXmXgodDIgt
 oMnQVRV8KSTJJuyQ2_anOzhhhYZQtcvkObsoKGoLG577DzLGKexIfjYHizUbV2V9qpMLhTM1l7S2
 tTXvDENEu0xIgw2SvsE_1sR2a5MEXqJApZ84Tb9V9URdpPYoyAFy3lksLw9PuJLMpUeeagf0qU0m
 5D4wrZsWnBny1RcxNXKRC223Iur9Bm8Vjf7mmZk7CJ_30zgrCahB6LjQGDAStTZytRxr5GXlYwYE
 lmxvldXe66LJfFjjSoRP5AW4M_7LgoE22eTthavgtJZuDafIi0AwzN98Cm8kYrTqA0NQDONKLAm9
 .smhPOKish69L4iYLVHCZYUiMryCxGmCh5ysw9q7zuAi2_8gRmb7BgTqEo4SXb0Y_vns7V7o8wyu
 xyx8dZgltkq8imT3lYMNnkZXhzNNLNvJ8hcffEdUQlBDAs_cU_Sm8XEDS3IS617xPont5X6MkKG2
 nIhGsEda3HZzIjeJwJkbZ7AWm_n4UMVnjp8zahXHvGdbn9P7mVt.PgZIve2M_NBFxNGT576tLgGY
 9sR_BBrr2EQl5ioj665fK667qK2VAOcz2G_aFoPCS6l47_wSrKKjtz.CRX1n3f3NYLxe7tRmUsG1
 k8fLxsJvdtNIqWb20uT8brIp2dJY5CIHMKGvxJWDhasi7phsOJR7ZU_TYPEf2VX5wtB6ZvPuY.Td
 Fukyjj66r78Oycibk4N7n4BxqFv3NbqHa5kNre1fDdqM4RUfCpozARMyie2W08BgIFSqvL.6B83M
 .2cSbsCOoGqe0_Hlkjfrw4Mx.gQsJ9a12y49P4edD4j7s3M7raVahvXR30QFPFsn.M5TZnwPmpoR
 spjcIwU7zSY0EmV9Su9WjlmKfKFbbze3OUnnxKSiyXSn1S_sf
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Fri, 25 Sep 2020 18:26:36 +0000
Date:   Fri, 25 Sep 2020 18:26:32 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh0000@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <128817487.1379831.1601058392872@mail.yahoo.com>
Subject: YOUR HELP FOR THIS TRANSFER.(Ms Lisa hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <128817487.1379831.1601058392872.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.

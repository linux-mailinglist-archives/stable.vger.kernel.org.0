Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D9D6B4DF6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjCJRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 12:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjCJRFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 12:05:51 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABAE118832;
        Fri, 10 Mar 2023 09:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678467852; i=rwarsow@gmx.de;
        bh=LVEe43p1DZGreUdOI7jkyx9NOPhcDp29kL4ynw7ZWUc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=S3uGyhCyJ3F3AWj67f7WNoR2Pbue9WWwuvbikUK1W6f6rQ8ruBcW3Dt8Xca4qH123
         VYCwO0MQHvE5dl5ypvSXA7bmGGf+z6GPae8Fm3gyABSoQoqonBEnVuVIHhfSpg5D4R
         U22/WiriG8za2qa2/pSDZg6qjPTZ5EAgNxUzT5po5OCozs3YEUwUQqX3KB3rRJZyRo
         M1Sb9lvY60SNHLGv02A8NRICNI7gOBYweXqQlFgpod+w6f7tDjQv34P+0mHBkGBaey
         6Zh8o2liMYl5+8nYzeK70D8kyTAl+jFg88LR6yToW057y0bWf9IIvXA1Mavup3R3Mo
         gCq3X5rifeTdA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.170]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MeCtZ-1qAI5z18QZ-00bH53; Fri, 10
 Mar 2023 18:04:12 +0100
Message-ID: <51c4f004-134c-f238-d696-549f2f8bc576@gmx.de>
Date:   Fri, 10 Mar 2023 18:04:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:3kVbuptqkGacsY/s/Hm9EZ4ZAOW3NnhztE1yBVJx667GNSfgvT3
 eSVhxOLRHsYcTePlsYFHnJvS1SqxFrMV9SNaM1xYoTSpUkzD4YcraDlZEYmAU4au5lyfQCu
 WbPmu0XnMsv0TS3bk9duNeC0N1Yhm3LX00tN5JK56yVgy+6arcpjkYFEJK+DUol/yQdIZeX
 XQEZcfNjBm4GaHbKwKuVA==
UI-OutboundReport: notjunk:1;M01:P0:vZ876JNR8o4=;80HgzLfsMQBe9UAx0Td2vcshuI9
 R6R6rgzn0cLytEnurKPvtJB6lE8EUIBnEHFKkzbGTjOZNpbz17clI8mhSde7RDgiMM2f6NtfQ
 YZW0aeLg+5LXn0bRdRK0/1nED71uqydne6tvLZJGadaMXbUyum0qDPzj4Bn1TkEt8Ax3XHEj+
 NjQOxP3xcojIsBm4SXvfupMMxCq34Vn9AI/lO92TNxsklbnGaRa0XdxVMUOwvu1i4uS4ENcIk
 SJsIqZKGm9wHXMuRxlOhFDt7oYe7UrQLNcevEgmKyDx/byOHcpOcgQBGk6TTH3myfIfqepb8K
 GwkxBG460QgvJz2CVdFwTlw6szbBnhtvSqSBCVbsGUjnPLvv/G+Gdx/gBG6zkHG/GaoPVAifs
 UjT8csuzZtuU/PvKfXSwJqLbvDaAOqHJLms+4wLrYFObPrTxwQsqaLjHS+17ZBppYZ2cFjrde
 iYLWpgdzIT5z5doxqEAwGt1WyXQABqcqW/LDJfjrfzuZsgVx6VCEWy7glvnwXXtZh24QTBdUb
 aq77mVrRblEBnOVTmk51yU9tmrZ+efPKDHLYgMhYhWx2AXLz/1gwCvfKMDhlLMiU/WFiL9Vb4
 ACn1Isy1b1yLu5BGy2hhD0W1/t1+nzTwj1czAEs4gOEn2vvOtxF+js/+eVC4sufDG6W9EjYuV
 JAzKCEeXZCcuzOYFEUGCTUDD7iOMHSyQLnk6dotb4VA8x/u8pZhXrb7C2j/YM7hv+X6kEtpxA
 l0t9z5r+F8MTW+SUcQIG8Qk1shaHNTjH5iHSV5ptw2fhrhklwYCLpa8JqEMwSEVJlRyeBt8Vn
 pENw7QeizsQ/9BLBR5ZWSzF6QY41t8wlCG6LOGD+CoOt/O0HLLIBtvXymmW8RFt47kACjnGmM
 L6AajKoh2JwgtXpqVTfKo2ywithRohbSkihheZ4MbVd0GMoQEE43xDqSlWuq9H7+9BqSgU+BD
 zNKKpMhnxP2656VkQNDy8UmECT4=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.4-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


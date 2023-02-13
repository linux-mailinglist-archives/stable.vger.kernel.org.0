Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C7C694D16
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 17:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBMQnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 11:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBMQm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 11:42:59 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB53C7EF9;
        Mon, 13 Feb 2023 08:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676306575; bh=kMuFaY3wQzBvhpxqMdlvLXbloSKJ7H/uly0U7x/xmHg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Vko3gVJeHltQ+9HVqTLY7KnKTl/bZyfyRBHLFdWkRQuXmYGcmikg1451MmFpnF09j
         CKOwRiUVM5Y044v6gcgqBERYs68Nhvx+vVNrtalfAoxjfOvRKFZiAdu9FNRsyUKT8d
         AkOnbl+33Z84cbJ1rcLfMXu14LrlDbK1ukbAPnZ1Weuzg6mMcXXUYCk4xT+ieDIxlj
         o43oZRLHvRu7qEK2RPxKbGNckk2oRha/CMy4rlunF0wyIJ1nZPn00OqdmmajDDXyW5
         uM0mJ49KlnV3XUTNq1YgWMKeVBBVfyTERy8jR40n0Lj25k+BqSM6FBT/BsdC0RBYsr
         3gbcZaeEjB3Kg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.8]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M3lY1-1pRL4827Wt-000waY; Mon, 13
 Feb 2023 17:42:55 +0100
Message-ID: <1dec97a3-b674-500c-bba0-fd158268db27@gmx.de>
Date:   Mon, 13 Feb 2023 17:42:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:BQQlCv/MOUewkIZCKxtTSCqSTN6AWu879hvR//IPqsi2vauHNEn
 FIo0w349FRc5DqirBtzGUXn6CCAve3rGC9uZn3YPC4kfF0jGv6dwlw43nQXNV5629YIdXjC
 npTWx1pkm8Q556njruZiH0gP191a66336qCK87wRTUMOA7fqf2VST90o+6SP6XQP2Li+RHG
 mGbmHoRmFAi+21lOYHUqQ==
UI-OutboundReport: notjunk:1;M01:P0:HL3Gt0LWNfA=;fWQpDRCOZlIErWM6spY9tCZAt8G
 MQwyGolTyrgsL6/ZzVLJihT45sqeBHbD/9FSWNLHoJmNlCUMD4U6PiUHexy4gHP4XvRDx/Y97
 +ge+smXJun11Y3DSU/goOIMer/tljO7mOuVN8KGQBhWMWAQOKe/+592ysuMD/K1zALWqID9jZ
 tDObv2eveGN2/X9auKm4kR172P9fYM10L4uA+sCe/eYJP6Ety6P993SbOKtGzSjlzbGMn+y2k
 I62YZcVZ5krtRdqke2PudyEVHDFdLfu+1cR0f6WvaYiT8jSBjHfLSM8vcwVu2TUHv+AbZqm79
 Z/BPFoD3EPkwVWgPkCoA5xg0TuDmyLEEHLkpkhYCyVsiusOGV9omcz/6JDpGD8a7lRbbDfAJO
 +rg2dqgjaFMjJSLOKvYoojlfw4zkxRCOqL/K2UJVjfBGODoTXbN01Uu8WjYjB95o7ZvgMvMs4
 qEsEoRMheiUi4ZXxOnC9A8e91oA+/3Flqg8NCX6qGY9f7FamFWdIdLEWa4wHQo/5JhlsbSTqH
 ONci3X92iTFXYTY+V5CTe/4ciBAU4knHUbm4BFgV5zJ0FqCEcwjePtSvD2xX6/3QQkeFK+aFY
 u0AqdcKQnuteV6yvj5x4b2t00ReQWFDfLSb5pmvlDZfwRxn2ang036VTkFAtdOkjY2HWRDZHG
 CpWJhf1ohwmpxZZzn4i5S1aiWYtwkH+oJ5cC/aMkiWZsKyTiJ9f8rH569l8ph2Ie67vmvzljO
 SMuVnMKvC+jwjQJkbgdyXiGsQILDCjHa4hj+3GNPKfKLTESu/mWFMQ1fThR2M6UiMFHDJpu0d
 kSowjpTGoY9tjSTSaWfLXGMJZOBYif/0sF+pmweNGoz/DpluIJgSINtSI9/FMZLnB8sX2VELp
 39ldAfy5Awv52eNcquUXUvYjdjhU+1PP9dbLlx1J++AmbhbFrf7DfZylLuA2K4H5SBjCW46FI
 8r03fg==
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

6.1.12-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


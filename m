Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E756E4F5A0E
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 11:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbiDFJcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 05:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583813AbiDFJWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 05:22:41 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7719F23DE98;
        Tue,  5 Apr 2022 21:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649218449;
        bh=lQZC9KF3fkpp3qkV+BLTCo7NkUkmtr0bB09V3SZnVCY=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=WxAkk5vVbIYeVLSfcSDDriM6nT8jvg61gMDeXcY/Rqoq1/Gj9+wFh4Pxl2I2cc7zm
         vm4ssRPryKFKRsqFQTPpDuCBTvqZLmP3ax3Pjac+1Q0+UzdWBHkWrX6DX6M1AXKyDv
         FGn+cy4x/URLABgo00V1xCzTCWHHPqXMKTM+Jg4I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.239]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Msq6M-1nrZ6G3VpA-00tCzq; Wed, 06
 Apr 2022 06:14:08 +0200
Message-ID: <f215f26a-2320-f15e-0532-cf79cc80dc62@gmx.de>
Date:   Wed, 6 Apr 2022 06:14:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:HmIw9au0YIQSfrke29iZ3EK/Oiky1EykBzKTqjFQU9eYuxep+8P
 oWzCk5zC0vWb1C9MJEx3vwYFgMoZIUOCvM8AYynfzH9pyLx4ZbWMexvQD9nm+dLQ0NiOH0u
 OhdmBgD9Ij+lpLN/13RRyRy3bmcZJ3uu/ExmqMe03JoNRsvTg4/DJu2ruB+RGabugLMUuL2
 w2Z0sAvornoyeEY224EpA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:k9G7SOtBuvQ=:nM5c1KX6HmDiq01tJjLQ36
 BzoLHUS9iaBz1iIipl7F6ddHN/nLu+QgSttXpIAhK4Sx6mMpkoOPZmHOz6gj8eQvMb6jOpzYH
 XwTC2DCswwMHlj/5qXfRYCgd5ePeIOosIVQPJjzWB9LrkP3rVe0T1r7gvjD7f0rBUHV+m5c3Y
 +Phz0XAXmxLvXnUp46l3G5owTdpZQ/oKemjzHEeNnYkw8MbfNKkswDzMoObYFvizfEC+CJKII
 5hy46YqkAVmrGt/Qk71uXNW5r4ZYVY/C480pmeCCdVuP5WMVJbrAVBa8gLsusArLWg0iZEIlV
 lTSdd2cTHmyK24zLxXQocqPvU1KaSRnGjgxlctZ75+RnbYAESiqtEwYzm6WCpphHgWC30mHuu
 UThrvLaI9X3be0KPsH03TyGjDIfrq2NVcK12J+YjigJeloMoGkNz79v3zr4yCfyYw1dDDFL6v
 2vdt0eWuR0rAX1+emtS0o0St4KnRisnR+7n6jQPFfWRUlb7Dx8ddZy73PKbVHYnbHaT5uyPCS
 oGcvCBBlm/cApbPCpSmbU1knBgxnLJAJX4X5dY/U+xDxcDvmxQ9VNmJGrO/Cq/yhq+uBcQKJu
 wuq4fy7S+Ogg6Jw0/6IkNQ26Xw8AWGxRquF6eS6ZpjUqMmFkdR73y4RbMo+yvD2fMvIcGAv0Q
 N7VkszAF5IgSYrJi14wDkNOmsOXPxdBEQVKmd2JOP1hXQLU6doHUNQbD3AiGjzZuAc+O0BuhA
 7tStwhb1ao3S8sbSylKnzqgsaLBKPB+MHtyXi4sDD/zPpg27Pc7FlKBPI8iXtuXpZjG3pieAf
 pL/+ZG7yb3aFBA4YLE8fCmsykXwM/C98xBcfpFkmLmGKWtaRF/zK/XzXUFbcqYGAai4YRP4FX
 xwyemtnp54Uzl4thG5qOjEQqAEW8YEvSljivWiLAwxqJveS2IEOAJHmEJ8WlLFg0q1530cchY
 8ebbX/mfniV3BH4uYPcVd7RGqV6IG3sVAz4wBkoth/KgZRNM2MEPQ8LUWxSnw56i8O9SFtFVy
 r5Ix5CbCEWBPvYtQU93UbVmuZ3/TQL1TFw2ewnJZA9iySR55SbLj6mVlSAOgp0qPNeyN4V/qU
 9XRzN2jWKTdauc=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.17.2-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 36 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


Ronald



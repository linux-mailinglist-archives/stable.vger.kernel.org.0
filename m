Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DCE677213
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 20:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjAVTi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 14:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVTi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 14:38:56 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403641CF6B;
        Sun, 22 Jan 2023 11:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1674416332; bh=za8/0tPTK5SSTT9sp8f7200uK/lMJGXH1D/bKjSwN38=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=F2jd7OvSLqS0Upr1bC85L9EIwBTtYDScMbIhX079w0mmt+Y+iGBKLabvlcbODlZha
         M6ulyHSIHMaY2zxlpMydbhbMNgD8ktcZj7i5DEeULPu71VV/hMFo0BCAMpFwOH1agq
         E0XaXk14hBretee+Pw+hMBVu0zBmqYBwJ1N+9nkrxIqxsmFoiNdCrTLEvlJnCgl47c
         ljHDeKF65pMkusDUOB8guSEL8oeXnooOq3mYMJz8jw+UqhGL03U8z+a7eNxj4/7WEb
         DfO+91KHiA3knLogpedJ+NQX2r1DE9iqoYh8qK7YeyS7GFkML0pWOsP2EIXiIxbDFV
         2f0L3xm0zMO/g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.242]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MOzOw-1p3FDs2GTc-00PLf9; Sun, 22
 Jan 2023 20:38:52 +0100
Message-ID: <f642ffc6-002a-c415-4d7d-bb3d359117c2@gmx.de>
Date:   Sun, 22 Jan 2023 20:38:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:g/dPXODScNZLyqhK96/YpBhq9NvUa9zYqXl69FoLA2jaCGQ/CkD
 AQLzX9ST9NmoefQoJq/gPqoGB1kqnVeGU3lkaNddJLrCdfTMZkbaFcsf02FaSCH24Z80JUA
 oDaFMlRj9nvfcNyRXP1H9KW3z++yvojYolHmABH7YsXK884bF2dMXBkRqoP1fmfkmD4ZXVL
 QCV8ejYcLV+wqt8SKnsRA==
UI-OutboundReport: notjunk:1;M01:P0:tFH0FcAE8Lw=;eBwk/d+ZV3RIDS+NWB+g0iwpwu2
 mnXLU6cSSo35BufthMDOWVripaSWUcmGPxI6A1qrlxZ2v/8myG7OoOi01pUmzYWFQybgEFXCM
 UL77ID0jref4aMCWSwvhmpGia8RfKbrq8qUZuwTAs1OGl9O8Ne7EszQYkJzcNZImN6d4DRfDg
 lx14+eZyhmYBT+N5TExsTR4JZLF3ohVKDj4BY1c4j13/cDO5gEqHwVITwBxzqiwN67ih3K67j
 r2iqjxapH7cWGp93vxrMqjsC1p+sxk5CpgbC/ad3vHl36Owr0kK5lTSK0qReor9TgsKDaozQA
 HDwUVNQIIfQbWVgMbcCEss7eRt6tRQEqzhJUKj/fUfjtWs8mdsHSrUTsaONJ/dR1J3QXiT/fp
 mVupfXdTEJTfSgMzpVDXIdyuMrFJQGnMLaHezfwhLhNy/R5cnw6kHRleTHohWCIN5OxMrTWlq
 2oRtZEqPh2vMcyKVocwQcOoN7jpgoa3jPeA8u1kBGYBJsfMybbdLveSYIInsA3kapzUx2EKNg
 OMfLCb0t8R7jSP48qbs2j5YSvHpiDtV/2lJV2BVQHOl02MZ1MEo+UyosbpsBC62TGCsbvGjgK
 0LLpPFQmHCrGek19NN57dXJ+tl70R6rb2CFc7libM/Jf+P7yWP/6CWmO1mSiuWxOHOCvAgbsj
 yCBnQfFpGw+FDujQ2Sh18EXISz1CieQyDqsyIRPJW6OAd0mC7s9h38gDosGPWW6EqaVvQsfVY
 7XqPjvHRkOB1xyU2bZcEKzhBhco3TqzmiYhFBcQlJ13HLuxJowIt8l32tiuUJzmYgipZlgMHZ
 kVxFgohsN5grmgLU5cc3UdZDtB5Kf2m+2n/sR+G98aVshjG3s8HuOzdnzsPcOGOPwP6y9KRAa
 KXvsGbsXTElP7Ku+0GqoYLiq6fWiFmlWYdT/88mE8rMItLuWXJPsFy1L+gtG3Cx+pryy9054N
 qht/cXBxTFZ61oN/En+286yxl0Y=
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

6.1.8-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


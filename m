Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260166AED18
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjCGSBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCGSAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:00:52 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72FF97B63;
        Tue,  7 Mar 2023 09:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1678211687; i=rwarsow@gmx.de;
        bh=90HTZV+RtwF9fQHVah21a+vc8glIy8xmQXfZiTteEg0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=XoRw6Qv2GvOb8C98XTCbezN+W/HdfaL7FKWZwYwwjzVSpj7UC0m/TT8fQtapLm+wn
         LmxWrSf0ojY1SBZ4cIzI9H6uvODoiLLlWYSYTm1lF8+D9oZD06zj/u1gV7gRRPpBxn
         b5Uq/ov0wXQTsGG58Ul7eULghENm5wzljJTecOA1rVXuc/lAyZf7ez0mgczHHkJByl
         ObI5SpNm6aGBCVQxp//MNZ4AZ8knl6q2R0UZ8ZiDwWIear+H2Ez2Puxj925JfMpv9c
         JwKeWuENBjRai4UxU+i0F/sPp+bV/RSDJy3qGJX6GZJaOSujd1mnV1e0WSuO3IKi43
         ArJWVnCtIVh6g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.9]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MPog5-1pugse0mN1-00Mw57; Tue, 07
 Mar 2023 18:54:47 +0100
Message-ID: <3a188a43-690b-04a9-3687-6e35217f0a32@gmx.de>
Date:   Tue, 7 Mar 2023 18:54:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:5eBCHcEFADI3qghgv9MZhDGVG7IP4mlSksLfrqywiFJx7ohp0xC
 xR/b2YFFp/ptYuqHrg2C+aq+9bQ+51J15ENNFCjNYknENs88Ye0puTHOHL+2hLzkeTo4Xh3
 HSZ80yaIR5KGMwYFOnUu4TVmkzxibvWnTOAS09zetxqbp3pZGDgpcccCmaCKUhQfZLpqdXe
 lrdhrWhLr8U0PYPpto00w==
UI-OutboundReport: notjunk:1;M01:P0:fLyYuzUeDcA=;LKVc33uedYCJTAlNvyArkiqpsBe
 GIGO3Xwvu3Q8eaT/WTwnAm142QW/6htWt/1QvexOGzQQgqMXWB0fs90k2KESgyNy092W7pafD
 CPH7/RJSFQ9MtoqqGkAQHH3RkmA5ffZHw5l4OyEtm7oD+38vwU5FEsu1t0PEnTBOq14nX47yi
 rOzoLxj5kZEygIBq8jvglvgIw2Vuli+s+BZHXJHyoP4KFubQrfNzH1j3wZaSzzvelsFJEuVaE
 G6iVe1XRqQebhLSlhcs5QXHPsBa36vIsIPJ5Z6lrDqz9VDRdPaIBWuUxwOfUaOaSyBbDlRRY0
 RRs8bMOP6T+rZgypEmsrYg2dNMkHtaOQdil4TILifnKIO/UvMdFdptZoZO1lBk0Ic85VyjkKV
 DEVG737qzpaqwljWs+5BJiony1t2CprozCRuwCo8hi3QkDNRq6i0giM18dmcKFr+PTkpnv8Eb
 DyAy6WhOUv7m8xfid9omtakVTc7/AikU6jIUXZb2zXi5ERPa1fLBLs3jwM95rZ2vDrIlqNWRz
 jIYm2byXPQ3hxGfgdQgJJD+sMKCRSmv1EGjoMY3GgJgqcdfHZKkdLsUhEFE9+r50s3m4KFCo1
 V89o992xNiWZHGS5R6tD33AfX0p+MLrV1kEWUbI7dfGujsuBOTpIfz4MRdXDvYjvrwN6XdaYU
 ClD1qeJXj2FTNnEDGMGg7UKPeecV99FS2Ty3uxY6yfRoI5A7fqMBbM29PZk6u+V2M6v2wXYuA
 ljrNu+KqI/grLvT+G57sjpWDD73mtXAoODW/T2eKTeP946zTxuF+5bL3GbTf64u+eg4roaqYu
 LiwEA04To1IQ6TyQdOTeMJyEcWVVV0xLCyLdBHfsc3Br+603gJZAhNZduCMapbKOa8sNHD5NZ
 tkrvyA+2iYVboIPEqMOcOThXxoEUwXlx6ORJ4Hj52dyjRDAuEagEkEfyMJXwujDA63ZmI2JoJ
 eX5/tw==
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

6.2.3-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


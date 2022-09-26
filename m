Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D145EAA04
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbiIZPPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiIZPOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:14:37 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812F37F08A;
        Mon, 26 Sep 2022 06:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1664200667;
        bh=FeJEQ8M21dZTC6tb/GsHblyAKx8Yn1HBNJ19Hkdy7ug=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=c1uJqiCP5rUOBeKc+HK+09l+hrcYiSIVBRCyXq7sSGOk3QXQhSuvYbnGlXThUTRsX
         cQ7onGD3Rf22/JCCjF+NMdb7p5/r9de4WFUWnbS2w07EqMfoUQreOcjWX/oUO3GseQ
         jrk2ypiqiMwzjrT/xrKEDBMbLrYxohCvluCLS1TA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.73]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MMGN2-1ow7sz09LC-00JFYJ; Mon, 26
 Sep 2022 15:57:47 +0200
Message-ID: <c4bd4fe7-411d-95f6-ad2a-6510dfd4e590@gmx.de>
Date:   Mon, 26 Sep 2022 15:57:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:k/N755+SsMhy2tbf59A67GZvvH6jlJXFc13DRlW32I72RdQsTJn
 wPNo7hRwteSgf5PKHEYKveivILmxZvWFkUuLaEDXaI+Amn6FxEJBSTqZcKFmZ6ApFvLIVjL
 fCz9iJy4FyfV1x4q+7O67KP0KhCl0OndpRGqGcd/Q5P4VaH5xccNJCs9XBahypM1zJC+5vU
 6zhQEL25agaNvFS3WrcRQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z5ABO6xp8ak=:Gtmz03qMs2bcjirt0I6//N
 sHAvSBj2m8A7DjXYs0IbwaaHd8KWK+HeK567MCUr+nzPX2htcIjDcORJfzXDgf0mDQyaJkq2H
 KFlAi76e6lq/SriY+F/i73w2zVCqyI/V4RPHRgBdC2JPeW7RAi9aT9OIGjt1wmwAxNamL2PQH
 kJJur/XznXD45DLv9us3UqulPmde2PzflRXQYaY5cIQtzn/TrmCjLxk858CskmI9yAR4awJqO
 Woxurm/181XRohaBNoAmQTUx/eaehvAk5ZIPa96aiQ3nqeOYzcZkjNiLEehoQ6sRcxLF+Eklm
 HcnRFlsCroNzweKEz2SN2czza+mZxz+OHzyT/o+6CAd8waqDf5r/9qscILobHkt6NkId7HkRA
 2euiqh2FA6n92K+020lsAGGAec7smt51emh86iwIWpU+RYW666oMCYRTAllV0IdUw1whAxjlP
 0ezv+CilJq5SZYGdPB8J/8Mnrn0lTU5ooHVP7NBr44bQZSYhCaAZ7NsFJqVZADbNEuPV08z+U
 JkzjsKLatVKz8s2XsOGmD/TzP4kI7kktpQ18WrLkbwT2LP0uOPK0OKmQyCuyPtOPy9hGwmh9J
 Um10mZFLQzNZTYs3+nTelMq/r4XrxO1eSZYP7kjoO72xoP5gmBZJstWKWQd2rBhwkRGXbGIh3
 VQjJfNMmT547i16oVnpywvuw3RBcXyqYqbXRqYtAE9ZcKEH1fqChTX9RRoxbyHbPffX8dBvz+
 y5/yVgSp581Wgo6VWx4fmLOIfieJFzUxYZ9a+5z8mKABzL+egLCWIJFLBLLUPzF7fuvpaWgP/
 56K9tWwQpHr0llcpx7y9tPJ3ffcwgH/hF3BB2RMhXHf032EMW3i9QOCwJfP8fyOrXzx0gzQyb
 oGJb8uu3TmTKfNYjb8oeA6QcRyUYoMr7R77AVkD23sIPUp/pW57Sf6ByMpescoqsTpgwQrPEY
 Px5Yrb7q/o4Xv9hm2YSUE87HCZjTv1NdqgLBa227BOPYr7P3FWq3RQOVNm687vobk8ALHmzXC
 YUxKOYWPahW0c53CAYY2TYeWgF7vUAHKfFqBX//DmBiytnAd9Js97kqe5kAR/3IHhOfnwu0v7
 O9BTBVDR6KWttjce/GGIOJyvgi5q3/3NKrCT/haqayM7/pHtRL08/LeXjNJmYtRlej55LHygl
 B8BFY=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.12-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


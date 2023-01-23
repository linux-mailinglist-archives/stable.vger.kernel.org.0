Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C509677A4D
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjAWLoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAWLoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:44:19 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9870C17F;
        Mon, 23 Jan 2023 03:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1674474256; bh=j4L9ULLMNnqvPLcO552fj/kXNJkSI9aSIugiVcv482U=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Zd0gHnvS5mmG0oP4UriGZhgbQWA60FiGGeyNunU+gomDYT26wZn+VuwkF43rn4O1f
         gOsK+YfwC3aOKfXoluiWz31qywKOBefmmKFTg9+NcMVNivba5E0AR3w/fr2TMb0cUN
         8FmUc1Ay8qJtNIIe1MqdcKWto2n4bjSAXRcLO2+BxxmFa+dZJLe81cHE6n9A3e8czJ
         IGCdXLWwGB4dWPTEFdcV4EVXuWa6Nb6tsoj4HESYdpur8Ap9XyatIoL9TWwBEXbKzn
         n9KOmKBIPxN0ul3QSU+OtwYe0Jr7Rnz+rMBEoQquON1OSUIjx0CmBy5IHdbfp0ff5b
         kdin73dlKrTwg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.242]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8QWG-1pOIxU0Eee-004PCp; Mon, 23
 Jan 2023 12:44:16 +0100
Message-ID: <9ae47448-3620-f06f-1b14-d498ec8754ab@gmx.de>
Date:   Mon, 23 Jan 2023 12:44:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RHmgxPGqq8TfMFIlpfGPvPuoR5H47aY2CaGA7numJipvKjejEyb
 vnlof7BE6CkKDAVEdL/0DVG39vluMLBpxrIfnya/KMcq+AOUls+kRzBD7eJtAEEuqS/1jQi
 Yf8JiQGmvkyXz6QUW7PKpsfHraIcG+cjqcW3otDvyvVMaugRVQ+bbqn45KmT5X+cNeoZDgU
 oDsqeGxsamJDElSF/yP8w==
UI-OutboundReport: notjunk:1;M01:P0:Ghrxz0rK1OE=;pvYxpZJ3xAebendcEzv+DvU6urI
 bn8EXl3PZ9cFKIB34wuqZldyJZOYOwTWzY9+1BOiClJama4xgKUOuGmkEEDvB26W9BbANJBSv
 EaaT1Mu55iSzeNzlf1auQOU66MtvI7o5d7Qk3Rxg7+zRySZIA9LMB4sFSTQDgzR/3Oo/IJkNB
 H7foB83Xwt390z865m1u6ZRQepffNEMi9ZhPKTuN49pcmfV2mxLNzlgg2GC9QNF9pf0ICIVeV
 g9Q9eATRTQ2ojMAYL5XdCU6K3flmjbCyHA0F2M1+6yWOMfqB9+R1Vf8xHqj7ZKVOCjo+x1u4O
 GLSd3nNbXvoBBpmzyJrZFM8Q/JzKVcLDJNLZDAD1TKblcQI7FVX6jyh+l39tVavLusolUpf8B
 w50AZ+vdZP48Yh7FGTlqys47gQV1l+hZ3su+XjmbjJkcQQKAk2fBgfHTthwEXp9CJDpdipqoU
 c9v/uhF3lOij5+P1EOom7L1cATrtQxioyKhD1k/bqCKktrE/LFPBS9WN+leC7eN/G9Yu/vXxt
 Rmc5bMmDftHiApY7tDjM+xm77O14Znv56Q/jf+EDIN6HIVFYlcpYJuraNfr1i9/EmZJmF/HSI
 pH5v64z+J2qogQ4kwiIv1RFvV1sB6vZQhU2XVi5VXNHhvLoxKzA9AYt732EgKCcgPG7q0g8Vp
 lYWPclXxhw4pWu2sEcDCceyhB5zjVLuJx5jKcm2pQX8GX4KpV1wOfZZik2cnzEAFg9+QqbKFX
 asr3QtaqXChB6VKUctatnMX4bnFyyjsRzUXL5VtRI109MFlu2UP8e1jbMuFgmhwWZj1wjwt6G
 hef7bSMMe56WOiM/+6V0uoVq5Ao46n6b+PjVBIO6uHJPpWh20s4dxAEBdjw1X6IE23PCqvIG3
 B83QBJAs9pRC143P9ld+RqsfQDt0Or2uQwaAJpX5U874c2AFY9KWcj5hh09L9ACyDHXvGIaV7
 sa/E8F3P9Jj2z3IND0nUVAM0E4A=
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

6.1.8-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


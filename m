Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7795B63E0A1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiK3TVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiK3TVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:21:17 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52775837C0;
        Wed, 30 Nov 2022 11:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1669836074; bh=e1SzejAshlwmjIJTPtgfJldWkml6WCbTZ/fi+IT8JiQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ha8J8zvp5EzUrEBvjCO1JLCkl6kNoPZE+zSPrjZtlMbG0cEtsYk/XrVw7elSWHZgk
         WipyhPZWlLQlJtJ5olNcDzeM1kj9mGEfQuMYGFIB/VkznquovIHcSs64e3y6AxdS5z
         cBqhd1ukKsmasnyoy7EaRRx7NrnFUUXsWIi2RcTriW91bWYjiQAIfK6vYbFDKtoEM2
         6eAhipHfRK7ue+IF9bWFPoCu83XO1TR+A3gXxwLgBgdtRDePa9iK0AroHC2poksse0
         2r4MQgJppevm24rosx63k9nQtvsOoGSIl89ULlBLzXq6XdTXweRIb5KVKtrOtWxhEn
         ImOPhjOU/T5Iw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.165]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N33Ib-1osN0R2Y1t-013Jsn; Wed, 30
 Nov 2022 20:21:14 +0100
Message-ID: <e286ff2b-9072-a009-209a-4008f47bab94@gmx.de>
Date:   Wed, 30 Nov 2022 20:21:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:uujxpXT/r1Ufq3N8wp6bXOTl5r58zuIDWBpWxPWr92iDX5SYIBD
 XUA+0f9EGCc3reHcYiZ5rrKGSDygmAkNBTT8XHlIegDOBD5peX65m5M7xRGZwKNh/NfjTuQ
 CFCazrX2pQGztvBJRpYeplNLpyv6+/oggVfrF+BryeCdpV7TIwzLz1KITR/JysRNKc6EgZu
 84oxAQX//zWPY0EEKB4uQ==
UI-OutboundReport: notjunk:1;M01:P0:aAUpxFf6uGY=;08R5yohcpZlw5Am8n2GLKeTubVt
 uWWB4eXH++8FQqPjFziYYrWCW/md8MM+/PBwxUXtOQ9qpPGGt5APQRN4v2gpnFNjlxAffo3Ua
 b/xWMGQZbfdXHz18A4NIG3vfjfRQNqmM09b5N6i4sVSIfaVl4QkmLQ7cV3A/0sDQ/L5Z4Y4c2
 mK9CZ8HmdzvxNtLdONdiR7FQWkbgeiUXty5/Y+xy5QXLwQbsz0YbCOiQY40f9nvU5x3ujIAKj
 fSSQ9uwNZiOHd8pEfWEFpvVMCDBaQhZl3STybrM30+o4H1p/sqT9HhnASc3FA/dk7HKvDSFUY
 qZXE/O6EtEc+zTlhvnO8eo2zf4aGwdbDoNMXhk/4o/sK/ehOqiSGwBBN2bpE2MTu4aFAPGQtf
 5+kVEC7hjs5uRqCs7dkte+d4O5dM7LR5rmYqSY3p9mWmzom0sXqOYFTYpbQjhYcAvwFTb6h+4
 MZdNKT/Mt4Wjn+LXqONzJlOVwfPbRaVLrEh3zqG7JPdvHZ4aSQgI+Jh2DREaw9+oNm1Q0v1YJ
 COW0gwhpKwpBjJDm9i2Vk//d4JQ+Si+CHQ84znm1eLixxFf0726k7iEJPx98XUP3V4wPuSgtJ
 9qLSnK1cfxDhV2QhzVKjyAScNIljJ2+vw+nxcoDAAEITpyvKxdmFcj6IVaPp8jpxRVKH4IadQ
 h074eWhMRUKN6Et90zxZmnZyH0pvJSEctCgoD0koBpxBXKct9Q2UQ6Mv/b0nAERHWwA1q5h9T
 42cdSKeN/DBZAzf2TsnO/xZ/5tN2gyVwhw6LsRb97TgcWrITIvCS9mTR/F+nT2cT1lpvNwdqP
 2Y/5kunXF0nYcStl5ownFrL5vDAUhK+RPSTCYpO+B8RvlW7qwcUSTXYYEg+2BRsY5IFLPVmzf
 Pz0VaqxyBnSvk6s7r6R3uIaDYlhahS1pGmGGYX0kygVsmj8hrWqWsWm8cASAz4gRZ6fMl7GLN
 wA95kiu1Q1aLMg2fY9B81IDwVh0=
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

6.0.11-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


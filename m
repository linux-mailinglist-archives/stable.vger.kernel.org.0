Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BFD68D9A9
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjBGNu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjBGNuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:50:24 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1FB6193;
        Tue,  7 Feb 2023 05:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1675777816; bh=jlBHC3QyqIXwkEA9wCkUNUW2S5vOVyEt3NXTW9XKYms=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=YYDjoAh1uTogiP68LejSPUPD3G4suAUD6cj247wXqsNBD9dWGKrXTYCA1XrAdRIZp
         mPv4bBa7PjAIygdpaeCIG7Cw6B1iSDVq6+gk6r3wM9l1n5Jw/jT5ji2RXcqJyBOYpo
         UqR0beEPMEfJ8laABih9dGvh7h4S1aJVa4+n1fNvXpyfBe0d/besWLnURc1inHdSL4
         z79G8ghXUOAd6mNud3MnjS+oi3QkxO4XDfy4coWWLMfsV8uI8YCNlnCQAHOU1257Ty
         MyxsH6D39eDCsOyf1Spyz0pdpmSoDWxwJzVKjb7Gr1RqZVvS09NAaKB1vlN/y1q/x8
         JSsXxq+rraRgA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.231]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWzfl-1p5pB31WGX-00XNWI; Tue, 07
 Feb 2023 14:50:16 +0100
Message-ID: <9802c963-1533-690a-220b-261d31f8e7f8@gmx.de>
Date:   Tue, 7 Feb 2023 14:50:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-GB
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:C2rlY5Ph86J3sEp5l/Yzj5UKMivzCrrIUSchviJajyzkb0Mv46z
 djwzNSnu/ZQgXfxdP0RHV69WasZhmYkWn9YQZoKoQtymEC/+DW1FstdhzsXLzq/19/QXyRR
 72MBQ3jzN7CPIp50Xk60tkgynI2iDnzPZ2+9oAi3/oyhZTeisOWnCyvAdfP3i37Hs1UZRqp
 94A/7Nkeu3rNgoM/948Pw==
UI-OutboundReport: notjunk:1;M01:P0:9ofhJka+Z0w=;BFrlA9cXVtzKSgaPlUXaCgl4dEh
 wmNHPA0z5iBBL1q+hB6ih2fsrR3qGM3d+DyvQZ7SZqI695wKZG1XWlpjO8k2wwfbswOIaLIsM
 6SLFv1R/tu+i7Eo4Si2w8drAE9F+pakXsAreTfXUsngGUD0regzWATdbQTwSn8LKpHCSt/aSF
 Qx98lpS4rHomE/QuqzaATFP+oEszgfp9pTDeeu+P3X3/zS0IZhuRJlcmjjlYmlSo8bxdFUDGL
 ic+IQCZSZD8jrbsffRHM+qWXH0DgEhiSkcaYmxb9NViep3e6UZ7kqw7/b97XKFvskynwIj+LK
 zrjI5R8WdqjDyW4ptP2X0w6KR7BO5qyBSx7mRx/urkhWkIc7tIIRr2bSUQFX7bvt8LGY9SlfL
 87SGNcis93HlwlZ2p4Nqh5nZtbSIrjBQJ2JMjn4ckKetn5tZxjHj0gRelDtz/VP8Aypebh7Tv
 8I+Z5WYGD6csW0pDIw91zX9WbdbIKU3pRtI+5nfNNkc2i8TKkF2eNkSWjbBLuZQ+DXT3ZYjIA
 4dqBfQpqVFTeeTJ10nLNS7wzcrRoe51q+YhgcR1EwEjfw1lonkZqmT6DEb7z6jyGu9No6FBEM
 Yyh7/uSyFfD80/erZaWJ9dKy+hY7Eb0Hw2OtFB23fUDZTL3kGG3k9LodFCasfEEYdRGmQy1/j
 nwIdX1GWPLQS74uq5gSk9JRuiVmZWo7jJ59nbBCM/wU8GhCAdyBYRV8TaC9MUdgtHIzkDF13x
 fkr3CD97IWKYGcPO8d0FqcyLdUhtBqu0BcD92IvvjdKFAU3AgxEGh8kokYQLxKl4lzCg9Dirx
 iTC6uerVP3Bz0SKHc9lJuncvUTqb8Bol6WpNVDp3vCEuHCQYNONeUw5qb5wuXzYHkLtYoVqeT
 Q0cgKDxBEwiZ6gAfT5XluRLfRYzqCDbIfWE7nxNhWe1IobnoCws4unjXeoXG/YTARJP8p73j+
 woCUpXHt519eWSwDQym72r5wasg=
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

6.1.11-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


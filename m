Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B7B4E80CA
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 13:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiCZM1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 08:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiCZM1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 08:27:02 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3099292BB2;
        Sat, 26 Mar 2022 05:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1648297521;
        bh=VCWWrzyL8XtS2aaYrOKS+Lz6dsRdhW+SIbacYpRBbAw=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=iWHOlgzNAumeAregQScYvHjQ+6/qUz61+1ceEQpfoXobIBvUIStxR/zHnMlAHkJPn
         liArEorNtc40IFKTkLqucFlBwEOlBW1lCoXpi0AXhq+k2XzZMu3WrW0wy7W+GNDFO3
         C6hoTomQ2qfsYHI2j4mY8O1cP4zqYHg8wA1u6wKo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.223]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N0oFz-1oJKXk08NZ-00wpB2; Sat, 26
 Mar 2022 13:25:21 +0100
Message-ID: <9610390a-c6ce-e231-a8d9-cbf97a4bfecd@gmx.de>
Date:   Sat, 26 Mar 2022 13:25:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 00/39] 5.17.1-rc1 review
Content-Language: de-DE
To:     Rudi Heitbaum <rudi@heitbaum.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <67e05375-077f-ebc7-c691-b0a0a31b3479@gmx.de>
 <20220326032027.GA7@ba72772bdc1f>
From:   Ronald Warsow <rwarsow@gmx.de>
In-Reply-To: <20220326032027.GA7@ba72772bdc1f>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Zpf6VghU7a8AeiRB5swC6uAafLBrWyVBgwlWGV3ZNEBGgwaVqIs
 SEOmSY6Oe1VLr5eV0jLi6MYJJ7dIWxBIP8ZzJK/z5jB8qciPC6enFHS9JWuQdlzZur6UdGu
 JU7mQMl7rOnOV5mJgDLSIfD3MTcSvb0MViMqosSEf+ZoYoMhiIdNWaouh5R2vkoxZTdng4z
 QfQdz5RMtqdXuxL1ETLSw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yPiWFK3IZos=:yYSf/wEObSb+j4jH3RZpvE
 uE/3pG06YY3CihUfm1szfVQ28QMCuCT9wikBlqqZLrDH9gZHGqMBDXpPE6k7Lf/xfEv18PXv7
 dwZD30di2gDj/YNayAKS8apVMIhZb+/AWp995sg1G/nzEstMqGJ5Cz41LaTac6fEBXr8ixCoO
 /jAC4vJ8N2Ybvw+LIO/846RTjPStZR4Ou83RD+dKaRXIBOQeiRMr4VLlwFE7gzv9GWPnteBNi
 9B/7YvhWzZGGIDJZEXUlPy2ZKtvcJYfZirW8ZQmXE7DdhGOQf8EJUaPQFrBuwn/r0HJaiaP3d
 wSv35/Y5YXHeKr11rcK2H1Cn6mgqYrdp23AR2Kmf8lhBO1peoiCq21PfDb5U6pJCUrfmFdHim
 wZWyp+yKl6h0ZlkrnmEPKTQrZzx8rAPGv7lkSZk3IO8a0rxWiB1xQ5wuWnnKVc5w5wcbDcPAC
 gkC14emeQD4hRBKZTGIlqY5CgcCTtsS2wZzlc3rR+J5U2yvh4BoapJl/o0PytaOBDxJy2zSEw
 ZEivusO9ozWla/nUo8tVjroJNKiwHA0HyLFPdfsa/G6m7S5WFKaDFFJos8xbsQdE0HW7f2qaL
 gQp+BkI6eiLVYQa7Eu28k8RgIX7iO454XnV7fAdz+Qg8oMkYOYMQ1r8kxDEZsg1RPDszU33ch
 N9tLnFcJ3oF/5B7CKdjMWNSgkRJU/t6YUiZaeeflnpGfqn3YS1ReDF9U69BItyTTgXgg607ad
 4wEgnk1NlNssAyLai/AGzzaOeKo6tgYp9GhmnLgK3jDFwrXZJrN5Akkpln3tiQTOiBwR/RQTP
 EJcv67Oj7MyXi2QYKwhdeHEZAhQu32dIZOLElxFkwIr6a+0QAaXYY7BSxISt2l1LgjvATEiaA
 6p/PF1g1Uunz2KjzVkD8oIm5QCLuTviqtG6qu1ecnXzWG4wKv5/TXARto3d4MX/fmLeqgfj49
 QoUX1Pj7Qc59kDxOeMkNPAgAMeXxYKge6fsLoOxpOVG8v2vGSy2BTtTFv7ZePTivN7N8w+sYN
 A8hSmU1BZ7cXODcTFUaJQ8EcwvY91rrrD5RGRM+F0wN2TBOEsAPaUQJIRE/3g/sRAElEcfHkw
 GW5mrXGsj7LEj4=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 26.03.22 04:20, Rudi Heitbaum wrote:
> On Fri, Mar 25, 2022 at 05:45:45PM +0100, Ronald Warsow wrote:
>> hallo Greg
>>
>> 5.17.1-rc1
>>
>> compiles, boots and runs on my x86_64
>> (Intel i5-11400, Fedora 35)
>>
>> btw I get:
>>
>> iwlwifi 0000:00:14.3: Direct firmware load for
>> iwlwifi-QuZ-a0-hr-b0-69.ucode failed with error -2
>>
>> (not a regression in the 5.17-series, but compared to 5.16.x !)
>
> Hi Ronald,
>
> 68 is the current correct firmware for the iwlwifi wireless cards
> The 69 version (whilst supported by the kernel) is not
> yet available. See the git below.
>


Thanks for the info.
my wifi is running without it.
my intention was just to share what I see here

Ronald


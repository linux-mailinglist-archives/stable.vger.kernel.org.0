Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FAA58E09B
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242736AbiHIUGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346286AbiHIUGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:06:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7B41EAE0;
        Tue,  9 Aug 2022 13:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1660075579;
        bh=Hw+oevpt/5/O6BYZ65NQeNW7ruk2Ikj+QVY9naIi78M=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=hVA7pWixlzpmK54GV6xJ/i/d3H97fJ+v5nFbTO+/w0qVGwmoSHheg1HtkEdnfnaju
         UnYvqpaRz7BKXRagEls5/DTlH9C8oxZvR6qjsVYieStawNeIaSX/4wl+fCEBuOkiff
         CKRZNL0vu7piPmAZNu3hyCg40suCrqAZMkwOTDu0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.168]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbAcs-1noMb50nNo-00bfIf; Tue, 09
 Aug 2022 22:06:19 +0200
Message-ID: <e2ebc9db-1bb8-12f2-d7eb-2c76919313f5@gmx.de>
Date:   Tue, 9 Aug 2022 22:06:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:SoDCc9N5HFqeJqd9u+Y6O70UercqawTGT4YmB9viMOSD8wKDTja
 udlEhIMhE+3xp1x9P/v5NA2WrNznfOkPHw1WFrx4K8SpRPVEPpiamsVx5ZVGKMwEDOkLtg7
 G/R46FwEd1J9Sg36Rtvgm09YxhAHrn76ZbxBf3wF9AQSrisrcK9b4ehyBwPI1qiAX8JT/cU
 iAfDsrx0JtY81p0aoH5dA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7RajlJnMnj8=:H+1uiFhavH4BFViduUfRQV
 IydsiN4GdzrjcSxgsm6EC5AJ6L/P8pMzRbW5AHPqxBHwTt6CC/GQM74B/IpCPTqYx5Pt2xviR
 vmiwvtFFqL0aZgqhGOpnxHHL8L4hrKv0Jfq2Gr/Muiu83n8lDPABxJEgiR9+i7AwTXHP6hu1p
 f+/KKE2sqlNK3/mfE2U00igSzF/RwOLMQb+Q4mCnpjHxrtC2ldTiNGFsyJhS+InAZbQd3Bu0D
 wt+H0H8IweX2TMjeB3IGUJHoBZDmwFOVYkgR1bSKkHJZ9w87+jbXCa/vaR/aw9G+0j3duT7Ad
 Fnc4jouc6nsLM/9Doxx840borOZ5icfapHK//0HYPujz7XufGd9g8rPFyn8nIk5mb8Q5x0MuY
 fiHQ46XuZ0N/T1erqsX+HQY30We4MjMszuMAFO8a1Mu7xFcTEdQZm90TLEYxxZxEfDyteuIor
 fNiPpcNtKHBLExwFLPhq77yiXtLiGkHdFsKsCFRPGW13L1wSU7lisVhymEn4gaDpILdGR8zwj
 DIKy7HcIqY93IhF4L7qbBobKCvaMQt7P9gmNETN8Vw8lviD6CC85Od6U60x/IjxqimWvor/AD
 li7qjPinZKYDExORJZktzUzirPpsodloH4Q2WxhTq3EtLj0VvGaiMkB28MOPt0tyNQldk0jN/
 EuVZ49+4hZ800B98tL6F7bqzjlkOMI+b4QKDC/+tfiWKdrQLcKb5NJdM8msP05CqvTYd5nHGg
 Z6ZkOXPRNjumPueg8lATwS8aGM+60WGZZ1i6CpzrDjWWpHBmGxF80YLq0FCCruwaDs1Hf8GVa
 X4eCzQxkYkIvcHbJe0aUf2G1hcGKzq5IPdoshUhJFgMfxYrfbSP6iHDoGM0eGPDKwX2wjQwD1
 CuvPjCgwAe8uTLAfZ4vJgYkKzo5Il/ryfwPZTfEQ7Jhf+dqlKftqJJS7kMeamHovmX2fkKJ+d
 cH2buOuc5vvlSMkdUQ+erYwJkRu1esKg70KEXNRFETrYbXMIH32FMvuhkLoH61NWmvvFiDoGV
 AHrVIbgOGi3/k6t7pllZZM0qcwSf6oEY54SZX7F3prQeNFy35/P/nU68W36mivssYCmFsM31e
 NxwTBZCx0VUzfIRug1v1RX/rQVHw1tWuzSg8rguosZWYKFAjCtfvbKkBQ==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.1-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32BD60E77B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiJZSdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 14:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiJZScw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 14:32:52 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5503E6144
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 11:32:16 -0700 (PDT)
Received: from [192.168.0.139] ([5.147.48.148]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUXtY-1oerFO3Qno-00QVX6; Wed, 26
 Oct 2022 20:32:14 +0200
Message-ID: <a92bc96d-fdd0-08cf-6d29-4366efeb54a5@gmx.com>
Date:   Wed, 26 Oct 2022 20:32:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] backport: r8152: PID for the Lenovo OneLink+ Dock
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20221024214207.49365-1-jflf_kernel@gmx.com>
 <Y1ll54KuNR/GUlIO@kroah.com>
From:   jflf_kernel@gmx.com
In-Reply-To: <Y1ll54KuNR/GUlIO@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RWUdtYGrtC8Dcv8EB4z4JWp7lKBlX7rit8LG6MWrIcADFvVjkRC
 wFE6sFjwsExZnJwpNHOOO1R+qflA/A6jFSevv6jU+bU+1CX6s0HE1/JTrL8pJkWlZ65L6zl
 WwZygGel/RXPldxXFAliycNwUKqpEo7SG20WdCrN+d6q07Qv3noveFg89vtMxUh3c2A4jrM
 WKUny12zTx2z2IChYAXeA==
UI-OutboundReport: notjunk:1;M01:P0:hnnBHn7luys=;D8tVP1X6yuQoId5T1Ra5paFzkAA
 OUxyxjIVEL+RmGPQk0o6zGZKkw0wnEY6WjskwONmlcqFC5j4RhOHXCY3Nd0mrnSmAXfKNII1C
 kMgmZHYgbtV3J0iB5qvfuy/aYUXggBTE3MeHvEFLuYKLLCzi7hhK/EqAs28Myt+7lAuQ5oWqj
 Hn3Ajs+nQLzcRi05KmGLNBq8u39ILorUkipu5oTdaem70QqDmM+p00EY407gKdKCoXzZjWqIj
 7fwPn98Uia+Z0hVO9Bg8Q7u1RpGSCj/7bSDuiThxIzLP++sBZsZwCj/Fw2GSXh1Nl4C++YIiU
 6jz0if4ok604RxNF94b/aaAWkdaHq4SzP5VOwlo/D8R58v7wGaCiZcHBsgfR/Px/bkACmev+X
 pqwA4u1bjJhHt5ET7aPz6AUw4KYsiReiZ+Aa/2XgfribUxEmRbs3vBT2NE6zp06Vx7AIlc/Ze
 uQqr7IRGZQnqdGNwVAcVQScUJLa5xjTabSZq21TISaJhR5ID102lA7MdVmKKmJhkgx0sOGLVT
 c4tYSeI2CbgSehysyzbEqRWIGYJ+f5222tEnGSKC4GEZyuNZr+2IxCwzAkwiSI0vAokvC9umI
 2RZo6xTgycCrzX+hW5DOkS4LnU4i2qbfx2XD1xnxRjlkvLQulMsC2fvDED5Md0s8JUE7GgmaO
 MMZRt/u6tT+aw6rI2SV7p6z4DUG/dfmwcPP87bdvzqJQ2qyzIR0mFSp09UuFf+bZvdAusZNdN
 Ys93HmCF/VD0ySqtTrPKDaSeZNOVwRQE5I9ooF0LkgXQUoJnuoHez/TOHvL/K6z6o0fYQ1mBP
 b11/iP8M/PXmCVsJp903jvYW1kP7lVlzZxYkO2GGoaZldRaWjZ8u4z1L3XpiDtI7TzJunq27a
 A7Vf7JfgRoI5BVgMgUqotNLC37lbgRoGGi2fTd4CZJvyja+rck7jjxvMbbGIIvE4V8mFyFAkA
 HnEhDg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/10/2022 18.52, Greg KH wrote:
> On Mon, Oct 24, 2022 at 11:42:07PM +0200, Jean-Francois Le Fillatre wrote:
>> [ Upstream commit 1bd3a383075c64d638e65d263c9267b08ee7733c ]
>>
>> The Lenovo OneLink+ Dock contains an RTL8153 controller that behaves as
>> a broken CDC device by default. Add the custom Lenovo PID to the r8152
>> driver to support it properly.
>>
>> This backport removes the PID declaration for MAC address passthrough,
>> for kernels that don't support the feature.
>>
>> Applies to v4.14, v4.19, v5.4, v5.10
>>
>> Signed-off-by: Jean-Francois Le Fillatre <jflf_kernel@gmx.com>
> 
> All now queued up, thanks.
> 
> greg k-h

Thank you very much, much appreciated. It's been a learning curve.

JF

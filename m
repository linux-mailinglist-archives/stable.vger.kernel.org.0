Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34989572947
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 00:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiGLW0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 18:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiGLW0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 18:26:52 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410E6AA83D;
        Tue, 12 Jul 2022 15:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1657664809;
        bh=6vgHIYo307C+wMr3Dqy/LXRmGc5jwOOtlylqnpb0aPk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=gR7Rwvo+QeoUYj6i0k4VV1PvVRj6XRQEuRdNRUewU3CpNnvVDaAaEfRbSqCED8tmQ
         oVU+mjPePszaeyKxBuH3kS4HXMxTK1AJpYynT4PUcOuHEeRlGc5pECBe0Wa5ftGhkY
         hsnRZWC3pK+26QvQlFId/kCCxq0vB6jy97C9V7Cc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.68]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N5VHG-1nVtjP2KNe-016sv4; Wed, 13
 Jul 2022 00:26:49 +0200
Message-ID: <6094fba0-5089-914a-f8b2-14bb9d68a4eb@gmx.de>
Date:   Wed, 13 Jul 2022 00:26:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:LdFRrNaXODKuu0Z8A/dOku3q8qzRA2ciDxpQHr/0UqXn3n+PCxP
 tamROs4PvCFqLOQM7YP0Ku0fU/UK0DjQA3W1IwD36zzcsdcDyNJ9OeSnr616X0+WMUpNbkp
 nMti9m+EdShYtZf3rb0dIR0VhV8mEL7mN2T1NRaiR7OkRIOJVEeTior1FYsGySINJ3nHRXl
 U5xyzYE4R9Inn19mPJZNw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tiB0EXPRBR8=:KcnIoaEysKi1Iy21AgVNNG
 PVrwuYaQhpcCmb/oYA7Lu7yZn+Mng56BskhZKDWI/Bh5tzrwK9GWTOq1K5FGgJ9gip/cQ234d
 7v2eysEp12EuUZsiDeGrnanUU80EKkHoJE+QZUIwZWifTqyEkp2KG0GlkMlsxz915vqt6jpFF
 Tx2qH5Cj50j7uQmjss9DTgkS5OHLtKKBmx2BCl7SZYAe3QpQIJFhoiSOJErcRebk8NRWxjv+I
 6CVU2Jd88ZEEYRCa5sgdfNHI/V68vJwf56SBrdcVjfFN6B322gmJQz3UZXHnmmwqndnE1bk3S
 ubqBXJTsFzsn/bOBj96lZ/B2UctpBjc5YTA9AlShRf3zFP/6LwbOOAwiKJTwNAQC+qKrglNPE
 C858qzW8i6h0gDZ8jZRcLKAXgyso/1w+WnYjcz/1JE4MeymKnY2fu0CnZFt+l5F91wOwalVgB
 uhS3k88kTZJlGY75ZypIdqEKzNf8P9T5fQsUnGhaSrz5w0XG5mXUu/dpcUQvUBjktMjtHOFqI
 9hEy5kleqep+dNbM1zhZmKtHr28ovuM9u9+yMf9lzmfEgJ4UBpEDQR71fVM/BCA+BSIyBjkSv
 aGPvoSN9n7+DhqugywTsw3qa6sjcfh8YGgQ0jU4SslLtEvfw8w0MezmU7eJyEmtuOKE1SKzrs
 ypxG+tzY9W1zkjI4XeIec5kxMJ49T8C6D8z8EKoX6NTobgpL6ect+4E1/iJ2B9FFtNisI5+wR
 snJcd+UFqpE6b+7/ZSMIDvixl7mi71VfMpFOK/WfD4AoS1Bfx2WklkKfmRLxXmocNOLWPFohf
 Cj6WLs/sVcM+fPAh/5u0ipd0361AWMHy4QuwNiZxsNggKx6tfd0VQY476PxOV5auSFMV8AtKA
 F9A9L5QiBsrCI4sX/RBYfuLCpH2MMb+3oN2wACkyW1+bnz/eFC44nVUxv8iTlLAun8L1LHlqj
 BzLXuclzIMBR9WMnqd/JIqmXbmI2RvM+tTtmF9A49J5gDcFPhab81EsSVaU+waR1uLB1HlsNa
 NKTOdogwiRZv52otyq1JYbFzJurZqA17M7q3y7M0ZTHW2wZzGlvBMxAY5nU8EHezQRkCg6oSA
 6HWRla+b0FpoK+iV2daAbh1n+qdTPU67peh
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

5.18.12-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A616E68D0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjDRQBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjDRQBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:01:02 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D613A9E;
        Tue, 18 Apr 2023 09:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1681833658; i=rwarsow@gmx.de;
        bh=56v+m5XHpIb33sgDfeTmUNsZ8f6Lb3RnUl5YQXhuqIc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=lEy7qzLurlYvYIN2Il3MGKmtA6B94GGeQQEFXttEG7NS0+OWbij6UeRaATWfdBhJ0
         L+tmW0U01n5RBnvRS0RPBRv0UcDuZsMUxJT7RzxGE1BTtPF/He3bR0ov0rrWIJoraS
         xaJ/f1Hx5FIbE94bXj6AfPWK2BiKgsYQdaWJtmXfPn+QsCNBPFTtHiEIXoixeKRLJZ
         21gttgUvEnLVq3N7gel1WuewxoppsEWJHTpfhNDaKVFSACv6jgfhvdizZJuVDOqj7I
         wwuGjAoWOhOxXinjZc5coNnfooubQNM/JovQpcH4WbYW3AeBU9wFLDEIt8dRMgvk+m
         Sie39saanOLZw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.245]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MrQIv-1q9EKb2Zwl-00oXA7; Tue, 18
 Apr 2023 18:00:58 +0200
Message-ID: <ae1742b3-6fe0-792b-4a98-bb6beea7e944@gmx.de>
Date:   Tue, 18 Apr 2023 18:00:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:q60srRT6RuyyTErnhYk3ltzdMAKGtib9tpWBKFaZN9vPjwvHSf2
 /8ZUG2+cJ35kvNrQa3NPJt5RNcP4p7CBpxeWFi4SOuoGvCk+JVMRK2DzidkqD4rpOa+OZhN
 XuVt1WLxvvwUOhMQDsfiw110Ui50aQXao7kIGCzVropmpsBlCUDK1ohUXkBnBoI7I1Crjcm
 YuzK1C5rWQKA6Wz+48hxw==
UI-OutboundReport: notjunk:1;M01:P0:GfE1Ztt1m98=;P1zmPT0XhYVGiRvDt8a36UciTfw
 p/rsTIyA4ASUFNgJ4eGvJqd4lnoaKIiWhbGa31KzELyqyczWjFkNpdMFPjmsC5LchB61vlBmk
 hQdQWLXo24iDFo1WPE09NfMlGtjA/ozazq1iM3aT0IpxaVxf9QEufHcMphb6Mxtn/+u/MHGz1
 q8ZuLbHj6AqJLO1MDCTNdLgF5oPZOdlLFOM9VVKD/G1u9gYtiQDXRt9Zo9AeqN7FF81y5rap6
 PND770Gpmj55pNUHBSH5lWIhFKw9FM00dh6trECMH2L0sA+Bz6Ulw2itFTqLQsh40M8X6SPTc
 J/nL6Napeoz5eQMrclJisjaT+nWJNTrkD377UdeXYcxP7IAfvY3bCI0UW4quQ7ulGo8/UoXeA
 2SNmzheQvKCzPUiDQCkaFHU703gI0tp2fFz7NjIKiax38I7Ly8Gyr+IhJTFJXoa1TM+prAP8a
 0eftc4UC5v+5i04OxLmQTvVTTJTSiBCSisSWI6P0u1M3JGKl9XRUwD/y40I5rsXw5xW6Xn1RQ
 MahfkpzTmVRABKwavzSxhQ7nXt2OagOU/x8c/1GVHGXS+vTAGE4hPcya7dLOXmEnPU3s19wyr
 kb5gyXC42N2h0CzGIB69MPrr0SMfDtEfUflrLEjcxa2BFVESFV1b0Ek3iNjyRovevg9KMvufJ
 NS2mRlVOLiz2Frw8VQeOxjp75Ug+d211gvSM8Tc4NhFHEYz5FUqjMUuNnfxWDEV+1EqvtNC7N
 dxhVme+jWCW7mgKKoHJbsupaWFOpOX68Fg/IQpuAomfPu/bYmWVPAEzu+qDhtU8DRYwK9c+Kt
 9Td0ngHE6ncpYylSCCyEHM6Q1AJ12JuSBwlo9eXf8A1sy99W95j/f8xJunLtPQXE1LMnX87qf
 d0YYatEzjBLemOXPzEYxcDdJPV+H+MIuCk+hrBLIzr97YHQBdxcRD74/xwfUafKCIVEtzcyoD
 e6kdO0BpL10FY/krhkxnHMOu6k0=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.12-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 38)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


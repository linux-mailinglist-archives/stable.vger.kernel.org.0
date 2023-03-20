Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4DA6C1ED5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 19:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCTSBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjCTSAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 14:00:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5A1EF91;
        Mon, 20 Mar 2023 10:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1679334851; i=rwarsow@gmx.de;
        bh=sfCu9Wz9VZysLvg/cNkSkKRkK6ShD22D9x2KooqXwTc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ASp0mfSQXso8qlbwPDz4rDaYSHbOihOzFK73JGacByycEauGc6fBL8/CxtTzSr+uX
         ngMQvtOvVouokt8jPViHSTv+IDEnd3ENhj7aYfLaF5xwkS3O6Ln7zkeXDR0w+LlN4a
         lBvW/qlrBJKKy4FR6lt4gfBYdxbywrUcu46lcPfGgHC/eqCVqyu9YlRJqrSMQYi0fS
         VIkC9Iu3LD7rMlAhBULQAPKUtV4HLX9/gsDCm7ATLrHiSxSZ+T35prLYf/smc6rFdd
         yVePN8WoCqkdTaZ3crLTAVkPxPi0AIoLsCEebbD4IhWVSCJuuUVOF9pmaTwEVT1rl5
         ZSX3f/sqoxOlQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.75]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mf0BG-1q7IsL0HDm-00gaGc; Mon, 20
 Mar 2023 18:54:11 +0100
Message-ID: <a25a2a4b-2c13-3da4-4060-e555adf3a7cd@gmx.de>
Date:   Mon, 20 Mar 2023 18:54:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: RE: [PATCH 6.2 000/211] 6.2.8-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:C7kKgU6cSsm68nm+sKlQNFszjawZjaowT6y85eFEdCa56YuaHer
 0EQZe5c0TPMPkCv70fbXmB9YV1LgPl82lhs+AFa2B08cbRI1CeGShet+WXK7GbPlx1Mow14
 yKUdnLLZcWY6qPoQrZq8O5ovHi++d/4DiGcBLDUv5ZVBrZ8kl5zAWT79oq4lWdp+K0Yw5Hq
 5h3FvE6dmYiGE5kKT59YA==
UI-OutboundReport: notjunk:1;M01:P0:K/y6ODxATkw=;Yd4rtrHZ4+0gKxA+dbVkzKcNMM5
 F13Y9U6mVipnWr+D+PK4aKqYmPVKsaLiwdXx4mBzhd0OOmRGqE9Bp+lEURJ+ZFDe0HnkDKv4L
 Rj+1nEZIBKTFqhc52fyppdvAZlnIOXZwRA2TqI09nbh0zhS/xbAx/YLHBshns9MllFZRqPw8s
 SMo1yJpPZUm0RBZL4uN6YBG9g3U7leu34Wo95hkAjlb/V/p14nrvzEwNyuMc+aGc3H4nRleSi
 Qy5ftMn+t4SEa/ArtStQFOY3E9LYSr0uvZtGWMY/R7xjO7LE0iar6lm1ZTEy2RZtWPXRjV4eT
 h/A2eQDd+8bhnWKm8Z8++pfMYVrhYQHZ1j32Fl4t5Eh7/sdFnU7iiGpeNpUXvvyFf7lZ/hFzc
 7SPzz6reDyvObQaKltD0I1ooH9KGamLO8Y6YG+3pVrRiog9MKP41P1IpGTDghQVbwuWgtBs7/
 ftFmJvya5yAzKssGy8yyd8BF8UTWd7R5DqujHfnzvYoknJjDHErKpSGkf03JqthqwUr5xGfAh
 9BS3lpE/F57tjKKy5NSYeGScBiFMyjTdI7YdEYfNjYmCght30ldv2Ujn1DJ3MAHH2+uLwmFcA
 AG/W07kk46L1oJPvnRnKkU/lEEn707bXFVHNkJvRjKtwQy3S6TSpg6QApLW8niAP5AhTqjQgV
 GNj+zbTpact+RwHKR1lFqolihYGz13+Siph70seKNDSku/4H7k2h57mZ0lhSBgSezO14L6r48
 vIGeHRr+GtL08vzur9N7/rkstDdwIdl8xrH1QCt7duqmYgaZgMvY6uAiDvXw3s1lRd6Wj1mb9
 SINUJzIG6WGI95QCENVT+2xH3iy4mfrAcprkPpyTsjRQvSVl68hWYsvF40J5qH537QAkJ194k
 64HL7nWOzF9t+kGqdS2cZB66e8CACPCD90JWZTLyxmblHj+8Nqziea4T3cUCp0vv0zSxi4t2L
 6FFWk/kVDwWEyuPdMfGr5t/XUgA=
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

6.2.8-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 38 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


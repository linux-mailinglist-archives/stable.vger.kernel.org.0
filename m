Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272A44F6E18
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 00:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiDFWyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 18:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiDFWyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 18:54:17 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A139AC6EC1;
        Wed,  6 Apr 2022 15:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649285536;
        bh=TtLwKAcrHVgXjNMYc4F1qJ3uS3sjFBx9JkXE/llyLCs=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=YUJwc28mHKOocLAG5ZJ3K+xL6X0cK72P/b4i5eTrlrY9rKs6P5+EV+zvaWE33ItUn
         zB4PKHdLSqzCU2rYtMpJwtWzd6ZqzAE+fsSxoAMwKLGitCR0FVugHlu9lGqiYrCsS7
         ooHoqvHqHuXTbF0qLqyo8EboFpI0OGLJVzL9obeg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.32.10]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M26rD-1naIZN34TB-002Tsx; Thu, 07
 Apr 2022 00:52:16 +0200
Message-ID: <4e52dc01-175a-eff8-89bd-2782d61d523f@gmx.de>
Date:   Thu, 7 Apr 2022 00:52:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:NMj8tLIfVDjsisGDkERt7Qo+doEEs0euFAEE2DUf1bwzh8jSeAP
 2DeU0YKeNc6xvusjxMRlUqw/C4kU5stEDhu51sawPuV5gIRE/XMPLFu53tjYErnURRbT+p5
 yR2oSDDxyzhO8122CzwmoXkc1d4Xb4XpzcdaJCXVyG/MsnUXhzjU3x2M9J2ReZaQZGE/ik4
 Vj70YmbKD7XcCklogE+DA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hCLxCtGuEa0=:2foKtnaR7VhoP0V9DTkd8M
 5xpl1i7ySVQ2YRPDTY7Y3eiBepoDaKeTDqwNb4tR1Ib1VEQOi5Y7+/i5GuWFJlZpstAgNPvgF
 TEZvlEcFiRwyAD9VUi848v7LBjjt3zi0BS14yqcITqQsIWu7Y6A7DuS0xjWZtQR+d8xTqoS7h
 J5x2mH/rSc7HGnmn5BBtPL+27Hi2V3Yoz0UbaDg8zYH5RcrNClmyekzUok8R582ujWm3/KLmZ
 sAWbJdugeEr/XHX6JmxNxcoIVcO0VciMPuWjIwHDte/275vi22MqzAb7AxhhKuwjsXewpjOAu
 GLueDxVOaSOQ7SZ4XQxXOeHc6eE+6yHg7HrOb0uP88Xprub9ExKYHgxq0G2yrQ6+o4LjPbGN2
 OkpQ4/+6HgpLmm5g/ZMAbpldrWzWUI9jVP61RJp/0l6SiTq70v07WNXBrswMXJKK+BqMvqcJB
 EvaQ34tnRq1k0ShW0YFPvYaoIDu21IrCC1+wHRMPoFhu7Vhs+a3TH/qPd5cZUkeCk1eGZwtX2
 pqb3V+Zk/HjjQe7QNSNsfix/S30LnaB/1eIkBaZVQDHIjj0mtv3RCp0p2Ixp9/9FLeZKQAjCg
 McflYusuMl4ZVLN9Mf7VogiebBAPk7bQKsF57U5LBYuHSdWeJfa6ajMGCfBd3i5lrMAfv1Cmu
 YvPxUlTItakhqc6h/JtBQu5Bl7iMrk1X4V9xR9xe6nlvXjO0K6vNxK5EsjgNL1Snh6NO7OkAY
 kZq414mgPfkzuu1ggnkh64mnY1NGxvFcUz3TUVpMqBjUUi93za8dAYhmhmT84KLIPya7ZLKMP
 i9G3NBRL34GW+G/tn7PGHundBp5P7Ls0wRBbpmdVDuRwivZ+ULW/Xnf3cRXtF9oG/NM9U5kH+
 BwRrpmueVhjFhjXkpzJcttn3W0jVZQgklSvytiUUAcy/9zxN2X20K8TF92VJNSqx32lk3sxVo
 EPmdnEYv1aQj483rtjX0olLYEaC29PpdNJExv2Bmp66fAFxa1YZ6h03pyS75zVc02nATNblTT
 S/2tbY2qRjDBCSTR8vzAGk/X0p1fHL2SpuaG4Prob7d3T42D6EKGOo05WhoCcXFY4nckYBQlV
 Rotfx5Xhx3yw0Y=
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.17.2-rc2

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 36 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

Ronald


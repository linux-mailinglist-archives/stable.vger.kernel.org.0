Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59331E2DBD
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404528AbgEZTXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:23:54 -0400
Received: from mout.gmx.net ([212.227.15.18]:36483 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404527AbgEZTXx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1590521031;
        bh=Lci+jQawl8c8OvJkMVS3BSHSPIYtCtie4ClFMQvOiFc=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=NAsyf310YJ3pl4J9JtjFPE6e3bTxh9cs0I3bBA5h2XwrnMsO3KT31s0AgvpzjIRys
         3YaPIT+BR0B61agsTopcc0T8yRujRSEv+6K2kued0XPTHrB/gSswan1LQNwcr8JVUd
         iVCiofiCRGBpY6gPF45Py8BiPxM0y810RYcwC+l0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.6.196]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWih0-1jWy8l2RGy-00X7Ro; Tue, 26
 May 2020 21:23:51 +0200
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.6 000/126] 5.6.15-rc1 review
Message-ID: <db05fccd-0221-2227-babe-64b1e16b4656@gmx.de>
Date:   Tue, 26 May 2020 21:23:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nd/r8N99KsO1y2QW5Sy2d53cc6FZx3PgiGxAw1X3hEkcRdB58Wh
 UCOaCtMXWB4+GsWlEc5/UUnWoPYRaXa8e/7N6rzqzKbg0M4n6nVIkZu5pNOPoDj0LvbNJ76
 LVjjKJm5Pc4QEdSB97b8nAf9nd1lTTxiYMOy7Y49+MRXQwmzYKkLHV4jGHAcvVIfBlN/EM6
 e/S9cPi4/9Vdc2QMYjwbw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:k4nX9Q9sCx4=:Due9qigGzlBS4yn0mAgAhm
 duSkQEBgc4DsEQuD/JarvAUoUMmAHwUOMDAxjlkmZjohn1JYB4rdczSw+MdZFd0YqhYFRDWUk
 VqPPDHdvWVwupABLGzVSEoPbCGths6xMrY9VHXwMQ/IwLHYZy0ecwmKdQTARMALMYX1SXT+v7
 i2WZcD8saTKafopSWruNRoxgeVW3nvMyXYt4KklpI7m/bYrDYgewV2IVHqOdytuUJNdeSSfBv
 Q7giuP3fPsD3jzym4r29vT/E0rGhwe3zn5hOcgKfKUH4GCpqHNEmptYBBtdujJyX21QDbSfA2
 cINqql2E3FXfsvr2b/ltOMj6Q9vUNZmsrE2G0drnvWSfG9rp/CdWhMJPwMGyq9otZ5eSpc+KQ
 yTPVoSDN3Rh2fIasX69Ms6mO2Su7VST5+K10YYIFb/4vY3h+PGHEaRKfpLGUsnj5JruA3lZhG
 SMt88ZEwDurwgZHCfrgr6Q96g7ujjFWGURZfExgciteIU80wrdmNEZTxfRNlckVcuy+hMXxPg
 hU8r6GTmvbuF1/bxngnYNxf7TBaJnBpnWs6cNKGUKhniW65eZG/rR1xZwEldbvvZ0U9TUahxa
 pqM2HaR72gXxt+NsLbQWExxbeX7FmRfyO9xXNVrs7IpuHvLePAFuYfXSSRSOfh8gKkpFwPcC3
 8vOON7hdcLD4nkcs0DcPFL2qFZvNBT+PDlDM/ysAPIGcHGNal3HOwYDZAv4OhYvKl7NPiJoPF
 sTApteQ4hTcyBIkM2pT9tNP6mIO1Sf+y0+Vf+/3NONk/FORJ7yr4wdYHJUlaptLikNItYPpw+
 Vdmun6j4qBFJbhw2iki2vNmSM1aqCtH2G/CQpi0kaJOLcDYluju5FHN6FXi5AIHUmUeDDo54s
 +/vn6dltN+wgsdbx58KN9cuKyCHEqqnr2fXCD2ES6MFYmkWC9Dj2Z8F8VO5lK7Atxd+DsBbxi
 pBma1ZCujdLmMhF0vyxaTY4Qbt18KGkUP08s7FL+XVcLU7YeCKgIu6UwbBbhiKk9QxsrkM5Qt
 5vcosdRDq5orxdR9l/5iLnB4D61Yx39v6PkHT7rovSXpwfi8iX6ZAM6aNYdPNWzqy6GvOsyas
 r0O1INCmul/n4cNY1E6EVDim1FIP6lzlf2+HJR4J0o9NZ4gFGXmDBtl5dlFC5n3QxYK3o5T+J
 PUhA2uy+9tiP9PoMLPABbfulZqxNa1jruscK6QTg8GlhWADVfLJIQXfMTWhuoZSlP9AqtdkfS
 pIaA6wTM2FPr3w1r1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo

5.6.15-rc1 compiles, boots and works without errors here on an
Intel-i7-6700-box

Thanks !

=2D-
regards

Ronald

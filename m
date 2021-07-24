Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB83D45D5
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 09:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhGXGtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 02:49:32 -0400
Received: from mout.gmx.net ([212.227.15.15]:43123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234287AbhGXGtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Jul 2021 02:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627111802;
        bh=9Ng847uXLDIObzWv5Yi0qwMF67Zqe0s18408az0TfjQ=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=UmgrV1ApX/l6PY5LDRkR1ULPidqMQIfmJO29cjBNDa0G17whcegPZQhlOrX3NZZxu
         8ZtaikbqBu5ZET/I87oZGuA51KsNch+XIOMbpcnaYhojwBaQ0z+L2rhgXCecZ8T7eN
         jm6L7+m6xdO5s2WekQML8+kPy8wbiE4+MKYdAAdE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([217.61.144.209]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MIMfW-1lv9PJ3rQi-00ELOM; Sat, 24
 Jul 2021 09:30:02 +0200
Date:   Sat, 24 Jul 2021 09:29:58 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <3122A872-7168-4D60-8F65-DDAA9E1AB3D1@public-files.de>
References: <3122A872-7168-4D60-8F65-DDAA9E1AB3D1@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Mtk Spi fix for stable
Reply-to: frank-w@public-files.de
To:     stable@vger.kernel.org
CC:     linux-kernel@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <BFD312E8-7AAE-4A86-A599-9A81904F56A6@public-files.de>
X-Provags-ID: V03:K1:z3ybpe3roEOHBFAE0RrvfSRe4NYVRg4++KZNKr+2xtSltzU9/wj
 dIa4VgOXvda9db0W1VFxNfifQQd3C6ELf2S3S7TBmsQD4BA/a8Os70LDSJQIwt+H3Q2576b
 9aT1eyHFw0xZQyE+NPl2vOxAPubwLdPDBRBVKtkAnllqjjSODFDHl3d1PP+uTTHz4g0cZgs
 zB83WC88wYsH7xyhx3tzA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:r21jBk5x72I=:rjCGmX76LH4m8bO5miXODA
 o6dZypwZzWKHpk3M/0dKvtTpE1rn8QxlxwL5hXrV1VcbmlSkwS6cTorenjHc8+vs9PGE6pezv
 vJtJZ+R6+Uh/WCs3C5LaKD4TUwMCoFCf7LNfuzLNMCAHKRYyn1Ot5nt6WKYB4j+Nkvqr8+2L3
 Acd7XhjhbUVl4mTRqa05eQZZu1vDIa+K/2YJRkYJ4e/jDVOvaOyjjmPnuhfdlAh+8r+tMROjb
 NwmI5ci6G0BWWGKgdiXTYDZiqUVa53bgcza1Nxd8ApE4NFk0tamyF+A1yhHhd8YTFs38/PNyc
 Q9SpGJWu3DExHzLDEvlD5D3Hj+75lov5b0gXUQJBNCE6K5ZY4SP1WbOw+r4FB0fFOuo9ezvcV
 4eUbcUILwdFJyRYrOTss0e1/Em0HI1LbgZzARfE3KoJcG/Oz6+5Kqo5WNlChNWZsJM2livETQ
 W86/OF5e5ELVDjULYujWpXCUPJPUA0gAnRV3ahF6IH/Nm22HF7OsunTESu3ozEeCzYJRULgov
 DM/dLyjNDKLbsOEcZOloCh8sgYmubbl77rLmrSZk0VoOD7CG16gTF8/11RnEvnUbVcxpDRJ1L
 S/BZ2PK3PxN7F4x3hlnQ0jhPWB9h4wwKt3BEzBSbGTHP46SgQUC57yNsparVcL2s5P8bnwYH3
 lzw3H3TwGaUhQsR3+ZqrMsK2uoh9xsWC7AaDhs+YGDCS231NIDEf6ZaaVaqfecUEq2vqU+XoK
 fMLT5ovgBUej0mfz1v+Yh9AJloHn/tqZkiodbY8+MT/Bai8NQ6o7+YcPW+0kC0IWaGGzACRJm
 1LoQp/r8SbzNBTdRsDj1wVkQIsge0APOEtUcerdtx6UExgVBs7tn6wxaBqi9wTvmjgnsngsAc
 ZOGZti5FmlVgMCD7kvZ3sZh6l6mtU7FEs1blQDhVhGzOt+LWCpBPpNnQE59+eLrP5NP4L/8wm
 DTCzcFo3i0oI4+vTHmaXvFZhgbIPqTxjkDTzxu538WvuJakBakalG2DU3vnuxbEdwGjPNLnmQ
 bPsNZz3GyZcSfxjjiEAZAX+/0sXpBV7zTpsOkyMRh8W+niMp5N2S/aoqJVXHZb1yj7n62feoV
 5MeKtuaG3VDU6nn1amz3Ky126sQuIW3JLNBOgkUCTy0Lr+uBUfcWZ1XZw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I noticed i've missed stable tag :(

Can you please pick this up for at least 5=2E4/5=2E10?

https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/torvalds/linux=2Egit/c=
ommit/?id=3D3a70dd2d050331ee4cf5ad9d5c0a32d83ead9a43

regards Frank

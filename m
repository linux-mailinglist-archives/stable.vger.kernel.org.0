Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7F438B8FA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 23:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhETVbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 17:31:44 -0400
Received: from mout.gmx.net ([212.227.15.15]:44895 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230146AbhETVbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 17:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621546218;
        bh=d+i76mWshG7XaZzz/88l5YYOGpS5I6jiK8W0BSP798c=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=YPR23ZQnmT7tOVQMeXlmR6Pj40vE7IClsYQ2DZV67n1NFjHQgXxMT7fT0t82KCe/T
         /zx+oc/lgN52yopY6olCajt3qTShW3e8zbbbv8tdxlPsCDNSympg5gZzmsxoC7rzt6
         EdGtOVKESKtc6qJd9yHau9uxTND2RjEPQINTUuUE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.8.56]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N95iH-1lMHFO3JJf-016623; Thu, 20
 May 2021 23:30:17 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.12 00/43] 5.12.6-rc2 review
Message-ID: <27b7c058-dc68-b2e9-3151-d362dd5fbfae@gmx.de>
Date:   Thu, 20 May 2021 23:30:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DkpKj8jwyu5uKSsacj/q1NKe3Tczf2bfpycEsMS11Q3xygdFMvO
 BpFqvIPPRV6r79qkHe+DyiFQn2SwQ+yeFm6ltvaUw/uR0sWUXdI2vsy5E1CDYi225JuJlMJ
 98pJstaDPEkC41lwgWixpyZEPXfaAX4SAyuycGD5p7ruNyiCNgO66SV70KaabEbuXNHckYE
 t/16Sf/lBIk5lCZt8RrOg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:t3NH5XIErNs=:mC9rJ3m4HdEgJOv7D7FXXd
 YZWgDM0aL4AnA5U5pAFEVnA3WXr4j9vK5ja72yT+RDFxEz/2bPQ/X6nU+OzqDPxMGVVEQiIBO
 R4ocOfv7r/6Ys5GQcMyQle40R+sz8TgYGAjC6113FYYCe/FESe3nxotpl/aGmPeDBSdMt6tJT
 /p85wHnEGIfpsHX3UKbXeO8Q2AztoD+2WQVKK4g+Mqkse9QBYyDAzOrJF3pvtdQnMimy9Lyot
 /ws0WVbE3V2tvTojZpK8p/DTr/mHYdc3rOLGcU5wwYt7g/XX5Aghz/LdaJAoZ1V4Nq0jPBdw5
 VopR7UC2mObX29bQnEbv1VujLmZ0JCQ7okuqKYfqawruaqwLQIRPQOVrOyVwZ0QN1ygcthvNC
 5vpO00pSxpPfZHJnCkGG6B0PpmnKwtXwCRtr9X5TLdc+bkI2rVMI/4OPEv8iqdxtU9Jhdz+Df
 KW2+u4RFx3q+o0PNoeIfnzi/fiShPxR2re997obQIt74/qYCj/867mY+7OrMZJZNHEV+i1qCQ
 yrZWPAVey1BiiyLhsygI74cOY/oMPGE/rtlkY8mAwXO79zJwPH0WAP0qrv8hBdEljbxtfUHoO
 G/PDjrgUUWupha846BPKcqL45cC26e0osMNd/vh8PF6gokyr527XWSzvRD4GAJcjJ6c2Sh5jU
 KnAbobRSlSHmPLlKMTTqjcUEcUdDmergiCu0sPn3LnDG9wIx879P08Lo7v24XhsvMWLh9kjcM
 qa5RqlsdO+9nsICCThjKGdW3mybmlEovkohUioRyd0cexA0UPV838VIhmmds9X14zygU0STdl
 YuKe8SZJ95I85hHrXP7pWucwHLXhevMveuGPi3ONuRiCRggiJevBr5mkfYn2ZU+gpReHgbLjn
 FxOoh+gdO4oieIbqCKoirM7KOZC+1K375DEcoIKavFMWM4MWCGJcntggvbjyyW6xTDPdF9ZXC
 D2CfGOLV/FWjkzHfSBnFXm6ocOpXNNHIZI8yBnMh8XRLYFCkpdritFZ+OCYMlkNpkIEXMXUnI
 KG9tcaUfmvVrm/D3VlsLTSXcLVqJYTN7Q50jf1zxcbZ4v87teAGguGCicTfxSKspmu2GwA/iv
 r+hNVY5nuW4lACj7G8MYvoY3K0g/7YjNYYGUuBPxfqxiCEtFix4p9Mmgtrat6Yy0c304rZkyg
 wobsIh39SIjr9aP3vuV+pLdDqeVkbGsxizO8oaZE0AP049kScKIgfS0PzKwyf09Z1jL5U=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello

apart from one warning all seems fine here with 5.12.6-rc2

thanks


...
                  from arch/x86/kernel/tboot.c:9:
In function =E2=80=98memcmp=E2=80=99,
     inlined from =E2=80=98tboot_probe=E2=80=99 at arch/x86/kernel/tboot.c=
:70:6:
./include/linux/fortify-string.h:19:33: warning: =E2=80=98__builtin_memcmp=
_eq=E2=80=99
specified bound 16 exceeds source size 0 [-Wstringop-overread]
    19 | #define __underlying_memcmp     __builtin_memcmp
       |                                 ^
./include/linux/fortify-string.h:235:16: note: in expansion of macro
=E2=80=98__underlying_memcmp=E2=80=99
   235 |         return __underlying_memcmp(p, q, size);
       |                ^~~~~~~~~~~~~~~~~~~
   CC      kernel/module.o
..


=2D-
regards

Ronald

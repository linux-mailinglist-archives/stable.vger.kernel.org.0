Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C8649C96C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbiAZMRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:17:32 -0500
Received: from mout.gmx.net ([212.227.17.21]:35585 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbiAZMRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jan 2022 07:17:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643199450;
        bh=RnSLHB5xlGrMBIAWVMEGMCnPlmxzMJdE2b6Dr7mh98Q=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=VZzh8qGHL3myD8TprE5XP0A1DLhKYnOu+Q1CC3TyLoXVx+Z/Wkl4Zr71tjg5qWezM
         DPZhOb5Alc/VHBjnN45EuhqyPlkhDBL9ETi+n0riZnWLl3rRk1wm6YDFvllr6ZCZzq
         xzpyCPw7sMcNeh3uOjybst2JHK+rs+fFDfabjph4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.46]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEFvp-1n4gtr2q9t-00AF2n; Wed, 26
 Jan 2022 13:17:30 +0100
Message-ID: <51531567-00b7-a2e7-1d2b-78b5aea3830f@gmx.de>
Date:   Wed, 26 Jan 2022 13:17:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6cEJfyVD8IWZc/RkflkxulSsLvkGrnpj78keQhV7Pbk+q6OcyeQ
 DBQR++/a+HypJfz5FoxOQxr7jpkzUQ1Xe1IvUjRgSnAKe+mHYXrdB1V6AQdUFzEh3/I1jf2
 ZASmxVIrFlPMfk3ogS1NeaODL682gW2GknBll2kFnvh0i1fKDaTt4tU5Zqg8ZtSW2E999Ik
 p7tahkFFIP8D/Xx52g1xg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kb0/+3GizoY=:Oig05xm/kGEXhVjH9NnJRI
 KR9PWkbaTzbiyJrZYByxMlZGNSV+sHmjMdtoA+CqgcUQiQsU/5gW1az77xG4G+Vu7YYvTmeHy
 TAQUzKhSBK70kS6d9u+9tr1UK1tLRI9dQneHgfDbU+s5raBHOYEs+GIknEUBgVrVxFjgB+1UK
 pyB713n9B1Bi5zZMybM8vPwCb46Qq8f803bOnkgs072lgI+XiJcxnAvjP84PTLGK9OJzzL8KD
 7Xky5GYNpAXuq+oSbm9p/pfsHCC5Y8SJ9mivOg9YplwcXw7Pc2Sf99rDP1bWVLPpjfoJFE1Ha
 erttucex/h+yv+HcmmoocNgBFRF5zKFo0hIE602OpGC+CO3mlF3+rEkw4jUAILiOgZGhPKDXc
 g72QZ3of9+S/VKPvkYMv6RXZpL0LKydkF5iK2s0nptRMhnvKFIPk9gry8/5c9mDXT4GIGb18j
 O0j2eiwFxPeDe7hhjq0ARU4x2EEYDuTP/zA08bJJ5RwQC3sc79f8/VVoXD6evUBQbBzPbaFkb
 TyBaCN+yUm7c8wv5zrEbeuWe94XInv4FQDDq6K6RBHialLU/LUBJZWdrnh6l/2xVjROdi+aHS
 eprog3ZWNx/llUiqEQWdbHpU3lp0zSjbvkkj1TpNVwB27FEmoe3/uaIFcOZYlKV+Bzxitx5aQ
 otPP36//SqU5x/sHYGruqka437zAdGTAO1IOVfXYfdOvbMN7rm+ogTvcppFtT00NkrppaVvnW
 s5bYD5cNtI0ayBGhz97mWvD4z94oDYR88lja6KN1DtNxpx3cw3Xd5JTAiQ4FH44H+/jzKjT14
 BdX7R2P4/XsjBJ1ud0cR52aiV8wHZI4WjmegRkU4GZQheMONja4HnoZX7nkoR/70L/tZ266Vy
 MtfP2/GmBG8AWs8Kdq2Q2h7ijgsPNjNeCPC+chhNvc6j974Z9rSuFgteZbt4vnxZ3PW7caaHd
 aj5dorIXUFrmylKMNPWyFtn9kuDIwLREqJMSSVA4TcBb0KTiFZikt/wmIkr3wflllh6Ye/MxE
 wHG1TwV5O83P3I6jjl7uzuZBJcnBgW0r+jF9l7gqQwU5PTgp2Ad8Gk3BLL9NT0aBS8IZb6yt+
 duHhrEp2Z8t7go=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.3-rc2

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

=2D-
regards
Ronald


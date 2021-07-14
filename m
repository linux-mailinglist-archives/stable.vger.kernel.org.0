Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF323C8440
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 14:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhGNMJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 08:09:40 -0400
Received: from mout.gmx.net ([212.227.17.21]:37231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhGNMJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 08:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626264406;
        bh=lxpFcYvSv+ZN5kjSF8j1xFhmw+hDTGIGlO0mGRo2Hso=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=kg8Gvkmah6oC5hZtqHGw8EkJ+vTXjhVAgdl8r+/ZXk7aX3/brNfa3mxahGoMcoboG
         pdzoqoom8OhENs6Mo6tjFswF3QUIurJerCFI3dk9EiUbstTl0YRs0X5TtMrwxSMH4Y
         +g0iv9mCB6j4OttXDhkDuUxa2ojUMBkaZW92eNds=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.1.123]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MSKy8-1lb0yE2jRw-00SjUT; Wed, 14
 Jul 2021 14:06:46 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <fdce0566-617d-cc0c-368a-761f8015c79a@gmx.de>
Date:   Wed, 14 Jul 2021 14:06:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:t65iRbTh5+mBCuPXyIrHQ6N4GkHmWuW7BcOyvJMCd2KB53nP99E
 jYi1d2NTwDBGbHY8kbOnqRfYisXYpKDOMrZNR5vJiMK+TNG0RhbAx75eOZwJKZl2YKSi4iQ
 fLhFjr9xe+8HrOww3QWge37k6butv8XdxnugFx/YPQWVgi2JS5qw9ELc2moEl4/FRFfZ0tV
 mR+4Z7hgIcsd3k99sJzhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9knAF4K6514=:dpJYqfor1fBCaAUqLQR7qX
 8rc0Ko+5exakDZVq+CyZWJUNFA02fHxnW8vYZnI2i0Yy5O3GEzo8p+D6IvbIMUC3VAxzu/+F/
 CR+zoIyfH3wGCBSML2vKqewMIaAZfm8QCHOoZjLzn0IBsKj7aJwkiSlA6qQINDB5f6U4+QO63
 NAyuHNLMCnaUt+faAqMnCG5SrhnVJ+9mHGajyYi0QRGuHpD1YWwvwiSmonawbrndV2o7dEXZT
 gP55TiAQR/rOo3UucZCIY54c+b1C+kr8TtrnRBkvEWRb2gFC1UQsvwEfszALQePuA9ZZzGoHU
 mW0Eu0u90xZTvfTkzOYQRqynRRhhRBq71yNX9TuidJhPezUHsalqcHuPhw4b6fKsCCdKl08G3
 WVoiTvUetQweSENkust4dXbx8+LRLpdOi4Nn7YAfT6ZjINmOw/3fufOg+FBMLPCHh2firLALY
 xXTReMbTT4XaKCIQ7X2XL1uyh2SSdBJouwsgt6FLMOW6PG8FH1NESI6IvWBodzE1V+IVhYS33
 mvxBcttaQhDZAas2euM/7SERuUbQ5ccfxhQQX8NrxmsuUTmk2DOR5pPjYN2n5CtDoQzcVq7aE
 sdES38Gbgb+DBwm1Ht2NuSW9wPNgyfthGBcLpHrBvaw1umVbCubvPYNc3N0bO/4zYx9Oh7Ufd
 skv80OwDCnVXpB9lRdf7LWi+p88aVNCzRgs91wiryR1rokNrJl8CzKegw0RGtYGEO54rre7AM
 ye11bYk7vsy65C+MSw5mLjKSbQGyLj3kf9tp/LTKNwJiY9kPfrev7bwVo7yOtSWyF5RI0LqxL
 niEBsNmuVN6H8GGC4GaghCNlF9P8eUY21a34K+cFcINWZHrVWpSPK/mGa6kZQAeEq89SNaPX4
 NpdNy1kd+bnrwVEHN1hCfF8obQH63OsF2eO6i4gUwCL0UfdHFcfB1rr4CS0ag8pyiblTnklR8
 +qb89lqk+774Fn71iFj907VKVhWS9PE+iLpriCh5B5QK8iCbLCcAtU3CCrV/S1gktttOtCkS6
 uO4yE4w8n7Ho0NPJdUn/T/4LxTjNXCb6iIE7t/kWYShhE4rFI0Js5wVPxxGwN68EzPIAEo5LI
 EwqdABW5POtCEPMPc0FcPwYAWxVmCh9mEMQ
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo

all fine here on an Intel i7-6700 box.

thanks


+++ UPDATE +++
##############

Regarding the above I need to be more accurate:
The kernel compiles, boots and runs without errors -so far -.

BUT: it seems under load it could lead to an dead box.


what I did:

running in one terminal: dmesg -w

and in an second terminal:

make clean && ccache -Czs && time make all -j $(nproc)


leads within a minutes to an complete dead box after make has started !


- no output regarding crashes, etc. in the first terminal running dmesg
- no mouse, no keyboard, no switch via CRTL+ALT+F3 to a console
- the box is dead
- only the power button helps


with kernel 5.13.1 all the above is fine


anyone (too) ?

=2D-
regards

Ronald

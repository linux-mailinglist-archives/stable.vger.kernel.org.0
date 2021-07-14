Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D9C3C7AC4
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 03:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbhGNBFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 21:05:31 -0400
Received: from mout.gmx.net ([212.227.15.15]:41089 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237180AbhGNBFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 21:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626224559;
        bh=lxpFcYvSv+ZN5kjSF8j1xFhmw+hDTGIGlO0mGRo2Hso=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=VbbsZpQ6M2bkJ1FSQyyIS/AUOgnavfTqPFK5/6/w0sS+w89SDP5uTk5Ud2KKlX1E+
         c5DOcZs2W710K4WSOC9KKe80AgiZ8KGAUPBFiCwmjts4aFckFPAA13ddndvehR2gvh
         VhJTamdmjESIOV0fwtJ4kt4Tzg83CnPkqS1gjA28=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.4.8]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MysVs-1lGiAH26BW-00w1CZ; Wed, 14
 Jul 2021 03:02:39 +0200
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review +++ UPDATE +++
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-ID: <de177981-f530-69ab-6fb2-e9f9e142647a@gmx.de>
Date:   Wed, 14 Jul 2021 03:02:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tJ09X9k66KrOKlGLC5QbYL0AnCtX65voOwmk2G573F8CYaNhspu
 uKPE0lfC4HdhwZLZ27QNfyYc6w2w9jgCkrAIEYbbIm5SHI/1WTl3uM1R+ZKI9lSR+jvOw6C
 3gN9QRPcj/dn0e31ZKCoMvV+2Bt/8hXKcVp8XDpqcT9o4YzT9VXx7SRsnRYXy8FqeFKf90B
 H7cVaKWlEgOXwBzRaWeTQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UJ8AQgHu45Y=:yPLVLATp4Tg03LHgdTiQZO
 aEkEy/+D4ZO24Bz/64D2cIhtRgYv9J/vtMt4jfOc2SL3TTiv2JxCgQ5nRJJr8cRK7+ynTUV12
 KWoVsEzxOWInjSH5S4UbF8+S4xexHbEC54tpIe36Ext2zs7cWazTvLea6kmA83lSg7a0Vhmqf
 DLyMaN2NoUEvlFCfQ67ig9PAZFJCoiq1LOQh0JVZpIzo7jP4lc6iV4thvSrXipB9JVy/xjx83
 +PtUFNneZx4W90SkSCcpaVD0sUVfsMPq6mQIPITxKaVnimcaWMWlqSBS/CsAGagbmcUBxMczA
 uQwo2pIfIpRgYY4D1Tx7mBqLqxmF7WdJAiEt4uQFaEdL82ZgNzJXRnKXaunShbjz/0hPwJTfp
 mMPJsix//35z78N+/Vgbr3IuhvbFHa3mcKoXGVZdobx6Hcw79CiWonzCSSrbsLfnqKYHWwpb8
 myhwa2zihT3+uSCWqcNw/TCZAZ5Q9ej1Iliy6s0oo7PsoqqCpeW68FOAFoTIDzkkP1IGGuCjS
 asklBo9rTtKlovK761gd8at3L98viXxr2bx8hC/nUTixhtsEuTyNX/nXlbyILhht6hxHVfCLe
 Ixt3VtHEclEO3lFhZdUiWxFf4195PmtOp+zHij59KKCbufnPTKfa5IX7gEJKf1E/E//rNTpiv
 IJ8bt8cp2x5AIbsOLR6vro6dlhBoFgAua1ME68YdRXFLufAroxE0TpB8b8YYQR1Wk71unwYOi
 x1EhMonUU+wTtgo7vOAqYMjjd+Q4t5rwRNdSFNFwzmxgxV1gCyrluVI0HoOCXvkpU7lCcRgrM
 VaOaYtQwd08s0/xcBCkMMj5HbZLMbM/ZnQfmU8OPK0oEFQM8hoDW9ysBNPbMD9nEcIkDNMh5p
 pRoHRKUlPeSSrRhnXLxTBxVMxVK2ZX3NWkNeI3ZcXfYegLwoXTEDwzW3GjuchxpRl5ooLE6wx
 ugcBtS2Cz1IGDotUhtH05mJkOVO9PjK9mgH8nsAm/yPQonthdEyosyWTxFoDgf7to3JCmhI2R
 /j2zQ2wJblct5J1QCidjG1uEfX0OO0vnIgvobD3AtI+LTtskBgbnlGL2UcguPtm5HOi7LIEEu
 UFaEG41y2VUw3rRzELxM9ClLWXYPSKKRzMV
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

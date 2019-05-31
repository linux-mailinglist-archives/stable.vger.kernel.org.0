Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CBE31766
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 01:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfEaXDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 19:03:51 -0400
Received: from mout.web.de ([212.227.15.3]:44625 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726450AbfEaXDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 19:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1559343822;
        bh=rW5cSCO/48qpJ0EI9RXtwgzx0kIenC43po9wrzrIpX0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fWgZF8CW35w9kGU3SlNHEk8Zr/bGJWlifVkZDRNcTff4w1cPqJq3R/az0mOFpkoaa
         YJoHwsnXyzw3jTBOdDR9ZrG1H0JGbCcPYjrvB2Orjap+VLAwFxR+vh4TclUbRkm8l4
         2IQ9pUWoQLpASFFAYcCFWPU/6+V57S0tlndzljCU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.15.238.249]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LjJaZ-1h166k40Zr-00dTHz; Sat, 01
 Jun 2019 01:03:42 +0200
Subject: Re: [PATCH] Revert "usb: core: remove local_irq_save() around
 ->complete() handler"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190531215340.24539-1-smoch@web.de>
 <20190531220535.GA16603@kroah.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <6c03445c-3607-9f33-afee-94613f8d6978@web.de>
Date:   Sat, 1 Jun 2019 01:02:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531220535.GA16603@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:Ic3+BDCPO+aCwP4xgWm/m1rofgV+DLFjQnm+DtiI7ck6/unR63b
 T8R+2OxuPIUTGr1rp06Qv5f8+59HAHjknKRMVT1QG+Gqi15uHt3g6mVBO+TQilJClGwRdIg
 qFPIuTqfdK09xkaQEhNpzROrzl/FoAotj1pS63Zf+qOkRxPYJsW7GZPf+JWqJe3/urAavw6
 gEdiY5wPrc9FX8cJ4TlOg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oEz2LEv2h6U=:gWNWOuxyuL4SYyrdke7Hyu
 ctdKJLK/kYoRXK1BhWOnasJyRXGRh8slxtpr+Hnx3Ej1/aDRVSbRQkENAGozScEw3Xm9y/FK+
 JvFE0j/aYYPgwx82yl+dQkfOVTwwY7GjOu5qySu6NeWjhlafFzsFPSiuX6yJwXaQI6r+wRGr+
 mzlOeBJPOsZmtsCBUpaYmuSWDHYQ9bdw8P8r4TKT1rrajhEYz0ksPUtyokYhGTSbpeWvGQnTI
 k+Fq/Kc36T6zkgtRMiXNI5SU5c2A9DBlIbb/7lJ9T2TtokC4AJDH+780GSprJhKgzVLLW82Vj
 Iik4cdBtW3w0D74/Nv1QJ//KQd2XGjh/4O6hIDBPIfT3rVSgTHl6IZYi7aBZTulbnNopprJ4T
 GQYyqLpiOuH5+7tZDSm7CirOGd7q3z3U153KT3IahNdt2QAWaw3CRZV+ZKvu08Oyr627SHY3r
 P4NG7xorbLYPN4Ukd2qGzgqcTJX3wYHbQiQazfm3i2hpp5Q5EGgGMk47jCuqM4ksL0qLDC9Zg
 DllXyNjC7CtDLptWn/BS9imiP0aaukB66jVvx0E4GbeTwWuosPCcSo1TLwiKqwaE2coyJL6jJ
 9Hb3O1XkbXZ2TCXWtp/dElxcq/hg9tUleUpQUXEWCOiyppB2FMprgvjtmHuCNQf/dfTbydRw9
 RCeUvCts8RxATPA7f1iNLekMEfeyIbLVK8Q8DfMjQT22xFSk67FrovJqqEcSI8gtHKu4lapZc
 59S5LSOgz1GTJdbRxBJWgOqqWlcfLg7nKKyq5lNeRIIRFrk2mGcr7mThP+TbfQ4GYWQLzJIi7
 d+VddnRyAxFVvVr7QUrQOD6PQs2NnP2odTAnn7rQuasIlwW4QMuK25GcJqyQjTRgVBKCnSoje
 qBPal3LlBpcScsOI4st5WuwAoTcsYcaYw6zkxN443Y1uP32FbGREGX+JYjGBRs5tUdbpkbgG2
 No7i9kGz+qSRY0KDNa9CkLIHZU9ltyQc=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01.06.19 00:05, Greg Kroah-Hartman wrote:
> On Fri, May 31, 2019 at 11:53:40PM +0200, Soeren Moch wrote:
>> This reverts commit ed194d1367698a0872a2b75bbe06b3932ce9df3a.
>>
>> In contrast to the original patch description, apparently not all handl=
ers
>> were audited properly. E.g. my RT5370 based USB WIFI adapter (driver in
>> drivers/net/wireless/ralink/rt2x00) hangs after a while under heavy loa=
d.
>> This revert fixes this.
> Why not just fix that driver?  Wouldn't that be easier?
>
I suspect there are more drivers to fix. I only tested WIFI sticks so
far, RTL8188 drivers also seem to suffer from this. I'm not sure how to
fix all this properly, maybe Sebastian as original patch author can help
here.
This patch is mostly for -stable, to get an acceptable solution quickly.
It was really annoying to get such unstable WIFI connection over the
last three kernel releases to my development board.=C2=A0 Since my interne=
t
service provider forcefully updated my router box 3 weeks ago, I
unfortunately see the same symptoms on my primary internet access.
That's even worse, I need to reset this router box every few days. I'm
not sure, however, that this is caused by the same problem, but it feels
like this.
So can we please fix this regression quickly and workout a proper fix
later? In the original patch there is no reason given, why this patch is
necessary. With this revert I at least see a stable connection.

Thanks,
Soeren


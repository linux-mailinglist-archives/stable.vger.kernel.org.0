Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB253D5646
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 11:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhGZIew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:34:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:54151 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232799AbhGZIer (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1627290913;
        bh=Q0HbiNkIqxRokCWrNCzTztUj3bwzixZqW8zb0edjAs0=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=BDgyKZRI9Ef64DvVqwgX9+kq1QrfPs253MJ6wJEGuSj8qXjvmnKH0tfMckyP70C7H
         MvYOcEfk0XPF5n0xBBWGqBvgJC1oYcW9rNOh785xQZ1bAxcKZAJxKymckMn6afJjck
         GJKFnAkGD1fvQFXNCqZ/GAnDSd7/Dgnh6f2eJr7E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([217.61.151.117]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M2f5T-1m4ML02tLj-0049dB; Mon, 26
 Jul 2021 11:15:13 +0200
Date:   Mon, 26 Jul 2021 11:15:09 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <YP56uH0IjiK4KS2x@kroah.com>
References: <3122A872-7168-4D60-8F65-DDAA9E1AB3D1@public-files.de> <BFD312E8-7AAE-4A86-A599-9A81904F56A6@public-files.de> <YP56uH0IjiK4KS2x@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Mtk Spi fix for stable
Reply-to: frank-w@public-files.de
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <8243515A-7F61-4F4C-B698-4C13679BADB3@public-files.de>
X-Provags-ID: V03:K1:Ah421xxDg1VBciWGzx6C4iU19X4IUDM7Nnv/pyYLy/1OH/DwBBw
 pphhRXgts3KeZ9ulwwDef0rA+Av/X24BWZS5Wn/JRBxLjE8HSMWtUEHHwnB0hdRVrLCkb02
 yiokOVZkXJelOp951+17fJ83CbV4zFRg/La+Xv0Rx9xeE93SUVl7MCdOAEv3JhjkLL2Mocn
 friLXYEHbMBqO3drbviRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8vsaDvHzXRw=:aafKxNF2g/OkLMQaREGPXm
 Y1YZ11DVLWCBw2OoJvKhvEG1gMGgYNvUBx1YmbylCNhMAx6S69x956i6Ww/igzhbmYh0n/6ko
 aesR5L9RB9f3uiIdNHPRwoQx/0fzQKC+Peciu63XWniZS8D7qhCPLKOa36uATqNkydbHtpNoK
 Z3hqiPNftQGnTbdtPrsaypKQQDW3gIaB60yII2ayOD5umCFf6huD4vKvo6amKKEDalx9OcO6X
 GgrKUmr8n/pIAUf9TbqYSO0tYLjAH882XMPDgpVeijyaOyPboBBjeTrLz+NcxhhauJvEf9A6m
 GxuGanKOEXTqY8mM9317cWx5nT7p0n+DOEg25egfVEKE9xarLJhRYWeClBdkEZpgUVn5kYZoN
 257Ua8nZUYnLMG22eIvJnWRcdy9IwasnjhjWgtM5OA+kAsNHZQD7vEOjH6Mgi2ddmlh8F3PKZ
 O7qlfKXNGdTaNBZJydum6JTHhZRJLUHV+TkCxrHLZFdKhZGZ8BVrYMJXFyxS9qj93VmG8Affh
 phHYRqS3WiTJEF6PWv46Uos2pzufg2O+4+EJ4GJlk7d3b59UnYlDiFRFsFVrBAxQFvUhxNHPN
 nqh15GkgLYSEVa6Vx83TusWBPD2n0MoP8OIcUub5bwE/emOSgrZXPME1JKQd6jfr8v1kNpLLN
 X2P6AwZSH28+JzAuX8Dw92tzd4EO4KzrS0Qb2RuItPpUhqABmmEQeQykSU8WSt2Ca5jKwGZ+G
 2Q+OutyqjSN0EATuuSnMOg3FGzX0Swobg9iZVRIp1gOVXE9/tlgMK+LJxxZqVArjceG9vYXgp
 MbF93wR9QdiBZG7GAjw9+Bn+aVsN7mzPA4rbGl4DY5K9Sbk9Mg8vSlCqRn1VH3GeLIZTMBeSr
 4GydWECWksws3S4fMlYQyXyjIRJTBgXOg5oo1Z7xOEfJ0cHnd4AT79EOxS77qW6AEKk2Us8Xm
 e5fi8NKviyp//Cl8TVkFrnOJp1Z6C8TQwm551DrgOcGB5e4RL6gMc8Dvh2bB2qtPrZC3M/ZHO
 X+hFSJX40qJ56V2vQulNaZdOq+jN/bE6lcMc4fDii3xUMDd5nqlD5ZxrZVUnysJX9PGm/3M9M
 iFZigC02RNy8iCZmj88TVZs8mhDosKz5dTCRdToeBncwZJm8RZVWmQzog==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 26=2E Juli 2021 11:04:56 MESZ schrieb Greg KH <gregkh@linuxfoundation=2E=
org>:
>Now queued up, but needs a working backport for the 4=2E4=2Ey queue if yo=
u
>want it there too=2E

Thank you

Imho 4=2E4 is not needed,as mtk works with own versions of 4=2E4 and most =
boards do not work with mainline 4=2E4=2E

For me 4=2E14+ is enough :)

regards Frank

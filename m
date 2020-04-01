Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779A619A74E
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgDAI3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:29:07 -0400
Received: from mout.gmx.net ([212.227.17.20]:58715 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDAI3H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 04:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1585729730;
        bh=7ENC0WB0xNiXzg5pVa0oc4PrPawTdH18bOEIRwUdtlg=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=LwDmCBYH/MuT5vX7OAp7DHKPiHTqZxlG96u/lxfpLPKqBo3jCfhv/V0pLx7a3mKTJ
         11ztkbL9UJGnxAjs8QfrKyWDvxwo65RGG7JDkNSbmZgb4/XGwWOP55At15mZAy/Hph
         2r9CAtDVOYU8FoMIT+89+fnr1jXeZ/jskTC+ARSQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.54.0.101] ([87.167.90.34]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MY68T-1jph8B19gr-00YUHC; Wed, 01
 Apr 2020 10:28:50 +0200
To:     stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
From:   =?UTF-8?Q?Georg_M=c3=bcller?= <georgmueller@gmx.net>
Subject: Stable request: platform/x86: pmc_atom: Add Lex 2I385SW to
 critclk_systems DMI table
Autocrypt: addr=georgmueller@gmx.net; prefer-encrypt=mutual; keydata=
 mQGiBD1O6uYRBADzyVXlOCHhmtVG0ttc5ryyNkmTL1xkhuFxygpnAnGA3T1Me0xZ1792b5/l
 1SkeB8VREGtxkpyjikmjPMlKVwDUAHAyNmVdUPUprNzxF/5YwFGyBADPlPoA0jjR7FJ8cSI+
 1zPbRGRvXVcGeRkcabv30EjzL1IVrZaTBk4KBWDeewCg5SPnVc81nzfneYTvyCrIS0MCuNMD
 /1/FEQZa/O4YiPVGUGcumi3A26Albp9nTp4k4OcmRZSL9g6PT/YPKWOxj0ugJeSpVQ7opIct
 LcnHRXeakh0x6T7nrG03CBdK/M+EIKXdolX2dtyW380QT8fwzLjBVO0RefwygSu5Ha6XXRhg
 /K4rXvDCciI5T/cQnK5HQe0dVKGRBADd57A59PzxALhOyF7AgC4wq5m/9KbVgci2Yo4MeMFE
 uuESLYjPSSvHY/zBG6onevyYxuriSdbEgfXD10Gwvr8Exho8cX0Kg/AEDIj1zLBk3JxuTHQa
 7Rxp565Ck6cHEwIAYoWek0LzEZdMtS8BStHABFMJtlCyWMVKGXqG7VlkdbQtR2VvcmcgTfxs
 bGVyIChHTVgtS2V5KSA8Z2VvcmdtdWVsbGVyQGdteC5uZXQ+iFwEExECABwCGwMECwcDAgMV
 AgMDFgIBAh4BAheABQJVNO78AAoJEIeZ9sDo/JvLn3kAn39yAfifTqrJNQ0d0qDs92oYptW3
 AJ0d2yfN4y0oG5HnoBRsGWLUO/1TibQuR2VvcmcgTcO8bGxlciAoR01YLUtleSkgPGdlb3Jn
 bXVlbGxlckBnbXgubmV0PohaBBMRAgAaBQsHCgMEAxUDAgMWAgECF4AFAlU07wACGQEACgkQ
 h5n2wOj8m8tXgACbB0On074qXrS3eWfhutFlH+6KmYIAoMgeY4C4cDk1/GbMBUlP2qo50EUp
 uQENBD1O6ucQBAD1Jah6AjT25zOL2HdzIx0f2Uyi9f+5rI2FmIq4v2GCuWzpapRMEGtvr23R
 XjV7HJsQs7jBVFi2Xda+WmZDlviPD/T/se0Htyq09qUDCI+/lTnSOruyIvSlR4hKML16m7Mv
 KwKOdU2NOkk/iCbTEoOQXM8sNKSkA14EpL7EhUCVnwADBQQAtDPJPZ6prjwEtbmFaz8Me3tP
 fpQItg7wveW+WLtqdsvIo0qmp0hWp47t1YEVXpQVmTnxkBgh+8RAhlHcB7cU2MnqLDmvTh0O
 In4DdusWIOfAxzv442hbFBrAA1r4xlnV2zq59E8w4hhBA8Tur4rfL69LfwEasPqugoI9v28E
 RvaIRgQYEQIABgUCPU7q5wAKCRCHmfbA6Pyby3sEAJ9HM3QGgjcPSRh8c7j8SN0auYvNmgCg
 3TiiOylY6CaDzF8iI0M6ejP5dPc=
Message-ID: <8bdec034-3be9-1b5f-ab09-dfdbe153acba@gmx.net>
Date:   Wed, 1 Apr 2020 10:28:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:7moJ0YdZuBqrSQP0X6nc/YBU/ddE728vKZb9OoffVHBoFfLWz48
 eRSm9mcA6PNbhZ6ACFjvii2I82yFJYrZFvTUEQ+wve5/wRoPslhcjlZO2KiTyYyRqz3iPqD
 kr8elBZYaILCdGj0SFN/KPRzWJq2VhUuBzTFSHtLsMUcn2I5poggSNOkbiTh/gSOLbdjrXL
 Oh82yf9MXipI7PgKHvRKQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PRiyFFz++Wo=:EuCzTvKCq+sZb2PuW9MVGT
 FqCkOMcRDEmUQPV7SJPX6UYzqU17bz5oIebqdOHYVhnPa7dUZAZfXpE4fK75WmsQlQGUcZiWw
 s8vrY3Ps1TW4RMhqNcNCIJJKJkLdgI8O/6GIiCi8SE/vUT/uDtKaayxuxmoy/G03CowhZ6ZgK
 fNLhUX4Rl7iCSukmrHR/nWofGeylZ6Zs+KAqruKb903v36dNHAOQpWY7l8bq6Qr2gRzv4+HpW
 mKjz2UP1FMsoP9t1ouBtVmMaidQpb5DIxJ0ydAJVBezDV51Ja3j2tU7vGAxBGq5QNBfIgtDo2
 JMSJki3HNDBbWd6g02bupinrAjxwo1vlkqVEbcOa2xNr8WZ6uhmKCxZgqTZkea64ZonRVI9bH
 XPNorfONkikk3OvUNjEmab8Dusei85tWIMpI4zRTbBa20r2xDhbQ7YAMe7z8AVrs692WFF4Nm
 nbxSyv7B1ryQVgQTVQFCLQcRtefYwihtF3VwKylytxvYbc8ikc0nnmFXbe8bFnRrZwY2LxR1S
 4djNUBNBnmACsmrZx/5q5XIA7A1jmL2Gf9RO8PoCpJCRn4XVU7HAvr4e1hfjFEp5F/cmubi+o
 Qn5+k/3DeYW5Xfn1KnSq7fYD/41dyI1h2ncANEVRgRtnBlYOs2Zs0D2qCFGcYM91oXjE0pioS
 Wjj9Q04lrEnVmq21aIE62RG0/ZG6cSgwIyBsZg1aFbbsqVSWYV2ypgXSBl51U9nVHnTxVLMxW
 keJWFCvBsO5aFhdwx6L69hTmzZHcWfumTkL9S18oD6Ne5vKqSIW+BlQDqvHmD8nXuzwtIxwtV
 H6T5mWnoFSxeQc5jRh/Z0vr0L5Xjoaj1Og/TMWdU6gvf5skWDmzK26JJIsnLKH6WMihKQRIFE
 WsIg22I0HQh6JQ0pKS4sJ1LY/ePpmg9kFhAYQwH9AXPTz01gFGRZ+NBThQV0G4jy/bhDLwzxU
 og4ySajmRjaUykV04I1s0pjJpCajfuF1BUjPj5XO8AnHQWBaVJAbAk/pWhuTUKGpbotXgfTsk
 r0kn9fmGZQ+L4FvQORY7eZ26zSoIcqFcmXONFWjTaAHifmM9y6FfGlh62aLxRvql9S4DysfB+
 HIam9Y95ttgbENYob2PMcxKeX65Wij/8eRilm+n6K32UxYJlAfhWJaMDwPSY09tAf0Bo9n94T
 F22sjWpJJYISK8Jwmntij14yFRcCA/q3SG7UyKrSXFHKBkjLgm3y3dZeqnr5LfU4Yru4d05Ts
 pVKXX8IrXyaXu7Jm/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 95b31e35239e5e1689e3d965d692a313c71bd8ab upstream

This is a regression since linux v4.19, introduced with commit 648e921888ad96ea3dc922739e96716ad3225d7f.

Without this patch, one ethernet port of this board is not usable.

From the currently maintained stable kernels, the patch 648e921888ad96ea3dc922739e96716ad3225d7f was also
backported to linux-4.14.y, so I suggest to backport the patch to v4.14 and v4.19+.

Best regards,
Georg

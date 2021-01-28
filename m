Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C063074A1
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 12:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhA1LXV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 28 Jan 2021 06:23:21 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:37524 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhA1LXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 06:23:20 -0500
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id EA0A16083244;
        Thu, 28 Jan 2021 12:22:37 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id mkb795HYT3tx; Thu, 28 Jan 2021 12:22:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5A5FE6083270;
        Thu, 28 Jan 2021 12:22:36 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9rn1BgoA46tL; Thu, 28 Jan 2021 12:22:36 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 363536083244;
        Thu, 28 Jan 2021 12:22:36 +0100 (CET)
Date:   Thu, 28 Jan 2021 12:22:36 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     menglong8 dong <menglong8.dong@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        yang yang29 <yang.yang29@zte.com.cn>,
        stable <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Message-ID: <95961161.337242.1611832956034.JavaMail.zimbra@nod.at>
In-Reply-To: <b7d9d9db42d639aa143f6e6b98ca7b9f4dcfd46e.camel@infinera.com>
References: <20210128105535.49479-1-yang.yang29@zte.com.cn> <b7d9d9db42d639aa143f6e6b98ca7b9f4dcfd46e.camel@infinera.com>
Subject: Re: [PATCH] jffs2: check the validity of dstlen in
 jffs2_zlib_compress()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: jffs2: check the validity of dstlen in jffs2_zlib_compress()
Thread-Index: AQHW9WSdcQjTUgG4ZEOlNPQW4whXrao844+AZaZjKmc=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Joakim Tjernlund" <Joakim.Tjernlund@infinera.com>
> An: "menglong8 dong" <menglong8.dong@gmail.com>, "David Woodhouse" <dwmw2@infradead.org>
> CC: "yang yang29" <yang.yang29@zte.com.cn>, "stable" <stable@vger.kernel.org>, "linux-kernel"
> <linux-kernel@vger.kernel.org>, "richard" <richard@nod.at>, "linux-mtd" <linux-mtd@lists.infradead.org>
> Gesendet: Donnerstag, 28. Januar 2021 12:17:34
> Betreff: Re: [PATCH] jffs2: check the validity of dstlen in jffs2_zlib_compress()

> On Thu, 2021-01-28 at 02:55 -0800, menglong8.dong@gmail.com wrote:
>> From: Yang Yang <yang.yang29@zte.com.cn>
>> 
>> KASAN reports a BUG when download file in jffs2 filesystem.It is
>> because when dstlen == 1, cpage_out will write array out of bounds.
>> Actually, data will not be compressed in jffs2_zlib_compress() if
>> data's length less than 4.
> 
> Ouch, data corruption will ensue. Good find!
> I think this needs to go to stable as well.

Indeed! Do you know whether this is a regression?
Seems to be like that since ever.

Thanks,
//richard

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE74244687
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 10:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgHNIkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 04:40:11 -0400
Received: from m15112.mail.126.com ([220.181.15.112]:47876 "EHLO
        m15112.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgHNIkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Aug 2020 04:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Mime-Version:Subject:Date:Message-Id; bh=5Qcgf
        s5MKxLBirkY8dPQN9RvXYRgyU8pzvTY4uiAN8A=; b=i7wrzNLFEDs8SuURZipJr
        ZvXGEkTLhBoj9M2woipK+m1lC8C1LpsLr7D6kCirZZdswuvXdo5ZGsOolYiI8afS
        xy3fA/XSbu7wNXqdDXmXFrm4Ak4TjPdLH0SlT7jiiSlys31G0xdqZ4gFSje2KYWb
        5NPITQkfEuf7+CeGhxJ4DQ=
Received: from [10.167.40.167] (unknown [106.121.67.41])
        by smtp2 (Coremail) with SMTP id DMmowACXnOB4TTZfbJ5mGQ--.38305S2;
        Fri, 14 Aug 2020 16:38:18 +0800 (CST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?B?5aec6L+O?= <jiangying8582@126.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v4] ext4: fix direct I/O read error
Date:   Fri, 14 Aug 2020 16:38:16 +0800
Message-Id: <7C2EEB3C-3007-469A-B3E6-B810AFB6E983@126.com>
References: <20200814080404.GA14135@infradead.org>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, wanglong19@meituan.com,
        heguanjun@meituan.com, jack@suse.cz
In-Reply-To: <20200814080404.GA14135@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
X-Mailer: iPhone Mail (17G68)
X-CM-TRANSID: DMmowACXnOB4TTZfbJ5mGQ--.38305S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU0zV1UUUUU
X-Originating-IP: [106.121.67.41]
X-CM-SenderInfo: xmld0wp1lqwmqvysqiyswou0bp/1tbipBqAAFpEBSeynAAAss
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ok=EF=BC=8CI will make time to do it.

=E5=8F=91=E8=87=AA=E6=88=91=E7=9A=84iPhone

> =E5=9C=A8 2020=E5=B9=B48=E6=9C=8814=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=884:0=
4=EF=BC=8CChristoph Hellwig <hch@infradead.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> =EF=BB=BFOn Wed, Aug 05, 2020 at 03:40:34PM +0800, Jiang Ying wrote:
>> This patch is used to fix ext4 direct I/O read error when
>> the read size is not aligned with block size.
>>=20
>> Then, I will use a test to explain the error.
>>=20
>> (1) Make a file that is not aligned with block size:
>>    $dd if=3D/dev/zero of=3D./test.jar bs=3D1000 count=3D3
>>=20
>> (2) I wrote a source file named "direct_io_read_file.c" as following:
>=20
> Can you please add your reproducer to xfstests?
>=20
> Thanks!


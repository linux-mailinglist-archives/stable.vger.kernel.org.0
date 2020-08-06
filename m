Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93C23D566
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 04:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHFCYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 22:24:40 -0400
Received: from m15113.mail.126.com ([220.181.15.113]:45862 "EHLO
        m15113.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHFCYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 22:24:39 -0400
X-Greylist: delayed 1882 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2020 22:24:37 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Mime-Version:Subject:Date:Message-Id; bh=ywqa8
        L2ixKMexJpGMIYm6JOP6w+bNibGRHdnxfimh+E=; b=BmYQrex5MroCjEM6mhEvH
        txqvu9Re9qvUYzReWsIdXK4O/4RaejKzgydOnPRJ72EqK/OMg/uNUww0RVwC+jVs
        s85Vud2ivMdfa2VuKmsQkpKjHzbxwv+BjsjioG/Ux+rYlPD8rpox/oER/6Anuqz8
        CNxqVZdqq52HMbt0if1AKU=
Received: from [100.34.13.32] (unknown [106.121.162.12])
        by smtp3 (Coremail) with SMTP id DcmowABHnfFqYitfRqCkIQ--.14539S2;
        Thu, 06 Aug 2020 09:52:44 +0800 (CST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?B?5aec6L+O?= <jiangying8582@126.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v4] ext4: fix direct I/O read error
Date:   Thu, 6 Aug 2020 09:52:42 +0800
Message-Id: <4E76AAD5-D69F-455F-8B70-A46E50E7D60B@126.com>
References: <20200806011909.GD2975990@sasha-vm>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanglong19@meituan.com,
        heguanjun@meituan.com
In-Reply-To: <20200806011909.GD2975990@sasha-vm>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: iPhone Mail (17F80)
X-CM-TRANSID: DcmowABHnfFqYitfRqCkIQ--.14539S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKry7Gw13tF1DWF4kZr1UZFb_yoWfuwc_CF
        WkG3ykGFWUCFW3JF4Uta9xAry7CFWagryDX3yqgrsFg34DArZ8Wa15Aa1Fyr1fCwn3GF1D
        KryYyw1DWr13ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUj4CJJUUUUU==
X-Originating-IP: [106.121.162.12]
X-CM-SenderInfo: xmld0wp1lqwmqvysqiyswou0bp/1tbi7wx4AFpD+obtvgAAst
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry=EF=BC=8CI will fix this error on 4.4 and 4.9=EF=BC=8Cand then send a p=
atch for 4.4 and 4.9=EF=BC=8Cthanks=EF=BC=81

=E5=8F=91=E8=87=AA=E6=88=91=E7=9A=84iPhone

> =E5=9C=A8 2020=E5=B9=B48=E6=9C=886=E6=97=A5=EF=BC=8C=E4=B8=8A=E5=8D=889:19=
=EF=BC=8CSasha Levin <sashal@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> =EF=BB=BFOn Wed, Aug 05, 2020 at 10:51:07AM +0200, Jan Kara wrote:
>> Note to stable tree maintainers (summary from the rather long changelog):=

>> This is a non-upstream patch. It will not go upstream because the problem=

>> there has been fixed by converting ext4 to use iomap infrastructure.
>> However that change is out of scope for stable kernels and this is a
>> minimal fix for the problem that has hit real-world applications so I thi=
nk
>> it would be worth it to include the fix in stable trees. Thanks.
>=20
> How far back should it go? It breaks the build on 4.9 and 4.4 but the
> fix for the breakage is trivial.
>=20
> It does however suggest that this fix wasn't tested on 4.9 or 4.4, so
> I'd like to clarify it here before fixing it up (or dropping it).
>=20
> --=20
> Thanks,
> Sasha


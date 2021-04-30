Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01023703B8
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 00:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhD3WvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 18:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhD3WvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 18:51:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BDAC06174A;
        Fri, 30 Apr 2021 15:50:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b21so8885221plz.0;
        Fri, 30 Apr 2021 15:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=16/dtgglXPhTLhotwiWNpu5uwDUYzC2lKFh3DLa1Hx4=;
        b=PQh2dt8gfZQLbTOx+5X49nw58W9XQe0SF5XUL0UdMy2a2yUgrs3eR3D59/5TixELZ9
         3ynAu1Iu99ssHH6ryOu+RXkgNjaTuf9FEwmMU7XmylKrjtQYeRRO3aNW6gLKGNDeW6Oc
         XfZ0EScSEqfscXh7odVRPWJZ4XOVMSYdSpBU/135Y5g0CVP3+7V/dzmQZnMTb18w9ZCL
         E1v0Q1tqonZ0nmAVlhdx1l/CZXFLEYxfK5s3mw3Dwva+nlvydY4ygXq38rybbM0bPwVz
         Q+iJUyepcWX/ApREea50n06UwT8RTbDzkxAph162hhaLiM5Ct47fHpYa1xIVE1HF4v6X
         w+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=16/dtgglXPhTLhotwiWNpu5uwDUYzC2lKFh3DLa1Hx4=;
        b=nFsrjxDo6S+6xKRc5Ayie1F5T78gUVma62jQ58RbzeDGBDnfOuv1qusjcHZ1YNIPDQ
         Cc0vNEYVNS5cJDDeJQEPeM3Qe0Pb148J4Ev6X0u27uqUjw6tcBzcMR18gq27GG8Jkd9m
         s7ZQNAsBLf2NOH5pPUMOTRkBENH/QUIUnSenFukjAeRtqG2jYOqoBsYpqIBuTubE6q74
         XTiwaRVgj+1gndxynkRDjCbPqSHFvTLm4n/v86IQadyR8qOguV4olx+189E14hCzv5Pp
         GC/qPrQUghr7sGeZ1viUguo6ViueUAa3ZmcU75dfHnX7iOoTpUsZY1nQlGKgE9qDvJLn
         ssgw==
X-Gm-Message-State: AOAM533BQbp9yhjxaSvb/NYGei9gBli6IjD6J5B2RNLzIDKMCTVUkTHo
        94xkvp9DqFNoPptUJ1/+8CQ=
X-Google-Smtp-Source: ABdhPJwu8fcqqjV2X7H3OGTmr1JB4BCD/RIOt6MROYUT4+1TMGnf5Fmu6bskgXZtpR8x6aVq0f++RQ==
X-Received: by 2002:a17:902:b18f:b029:ec:7ac0:fd1a with SMTP id s15-20020a170902b18fb02900ec7ac0fd1amr7627001plr.84.1619823018324;
        Fri, 30 Apr 2021 15:50:18 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id a13sm3884882pgm.43.2021.04.30.15.50.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 15:50:17 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Message-Id: <3D6CEB0B-101D-4C40-9BFB-68ABC85B084D@gmail.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_5772B81F-3D79-4A46-BB6E-A83FEA1C4D1A";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH v2] iommu/vt-d: Force to flush iotlb before creating
 superpage
Date:   Fri, 30 Apr 2021 15:50:14 -0700
In-Reply-To: <YHhJ/0b5i55zGib7@8bytes.org>
Cc:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Gonglei <arei.gonglei@huawei.com>, stable@vger.kernel.org
To:     Joerg Roedel <joro@8bytes.org>
References: <20210415004628.1779-1-longpeng2@huawei.com>
 <YHhJ/0b5i55zGib7@8bytes.org>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_5772B81F-3D79-4A46-BB6E-A83FEA1C4D1A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Apr 15, 2021, at 7:13 AM, Joerg Roedel <joro@8bytes.org> wrote:
>=20
> On Thu, Apr 15, 2021 at 08:46:28AM +0800, Longpeng(Mike) wrote:
>> Fixes: 6491d4d02893 ("intel-iommu: Free old page tables before =
creating superpage")
>> Cc: <stable@vger.kernel.org> # v3.0+
>> Link: =
https://lore.kernel.org/linux-iommu/670baaf8-4ff8-4e84-4be3-030b95ab5a5e@h=
uawei.com/
>> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
>> ---
>> v1 -> v2:
>>  - add Joerg
>>  - reconstruct the solution base on the Baolu's suggestion
>> ---
>> drivers/iommu/intel/iommu.c | 52 =
+++++++++++++++++++++++++++++++++------------
>> 1 file changed, 38 insertions(+), 14 deletions(-)
>=20
> Applied, thanks.
>=20

Err.. There is a bug in my patch, and some other problem. I will
investigate and get back to you.


--Apple-Mail=_5772B81F-3D79-4A46-BB6E-A83FEA1C4D1A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmCMiaYACgkQHaAqSaba
D1oZ4Q/+Jj4yXux596UIVxLwjOM4+uRS3ogEzW8mp/ULCCWdPlcpGflYqzuNIQdl
txomPflOeOJdCfNR07pjaWktYzMSJo5AqcljhiBXRn3As8Folmq5OaAzvN1OOfnh
RIuUMnUUWok+3gzKM3c8KanBdIaoIryLcBW1uZn7f74JytPjIO7y/sOf9f1LGzkT
cw/VAHuF8pMYtW1flj+N15aqMhI0BRrvEZgarT3qU/eTZd/1W1I1WrAxPeNFPTkz
7Svx8uvznKmzqNaG/z9ujYELhtHutNzA2R1ky3eAQ7JdVn0HwPF0jqlgkeKe6LF4
uFR2OCqLu52RgOCME/w6jqTYnbJti9u7npbCbWxZremUj/ghf9QUoe8VNFlkmgI4
Het2C5n53PrzqYKahXIMpsdlYxzmNqfTmve9BPhWVR2s0/4UqKIwLaBB6RmUqMYV
MpM1Eh1RoBMRuTroQJ6Wztg7er9pHkb/SUB25WdK+Zxpkd1fd4p+zs86OM/6YRY2
KBlqLFfco3OzGlxvvKOFJC4idYaFN3YsyIs8DMhpqmDKTHLlEocgRrFMoPCXl4XS
R7LWf0rEfvYeoOTm1+uM+F5uj8oI7ZR61mNibegQE4IyxtTMxavp4lI/5+yYfU0Y
WhjOyMmqQ+TqOWHNV70cdUOb/s0wjKXw4mCk+axasUCY0iy69xc=
=lcNo
-----END PGP SIGNATURE-----

--Apple-Mail=_5772B81F-3D79-4A46-BB6E-A83FEA1C4D1A--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C82E2A75
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 08:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408553AbfJXGcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 02:32:17 -0400
Received: from forward101j.mail.yandex.net ([5.45.198.241]:44064 "EHLO
        forward101j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404377AbfJXGcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 02:32:17 -0400
Received: from mxback27o.mail.yandex.net (mxback27o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::78])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id 411611BE0125;
        Thu, 24 Oct 2019 09:32:14 +0300 (MSK)
Received: from iva3-3f75f35f86d4.qloud-c.yandex.net (iva3-3f75f35f86d4.qloud-c.yandex.net [2a02:6b8:c0c:498f:0:640:3f75:f35f])
        by mxback27o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id KoqmSK881M-WDqGriqt;
        Thu, 24 Oct 2019 09:32:14 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1571898734;
        bh=ZEMULDmi68Ln7bpVQGgkzmUAobTz0pq0naePIbMZshw=;
        h=From:To:Subject:CC:References:Date:In-Reply-To:Message-ID;
        b=Jkj5bEawIxahuU705QS8Z8hrrCUw2eVLeO7jBWuH2jEv2UO1Xr0DuOlmyxionWD69
         4v1+pTmSfrbCqi6xZlcy+Wrmk9Z+poul0fahxqmaDuQ3P6Orwe6G7pVDxdT0fWmD9k
         ueRYrxN0iNAkypt62u/4/DwrlVyZ/dPhd7N8Qhnw=
Authentication-Results: mxback27o.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by iva3-3f75f35f86d4.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id ioVuZtsd54-WC0CN0fH;
        Thu, 24 Oct 2019 09:32:12 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Date:   Thu, 24 Oct 2019 14:32:05 +0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20191024040624.eezpuusvhujfffud@lantea.localdomain>
References: <20191023152551.10535-1-jiaxun.yang@flygoat.com> <20191024040624.eezpuusvhujfffud@lantea.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] MIPS: elf_hwcap: Export microMIPS and vz
To:     Paul Burton <paulburton@kernel.org>
CC:     linux-mips@vger.kernel.org, paul.burton@mips.com,
        stable@vger.kernel.org
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <B1A8B4BF-FF80-4E6D-9B4F-8E45B0EF5FE5@flygoat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



=E4=BA=8E 2019=E5=B9=B410=E6=9C=8824=E6=97=A5 GMT+08:00 =E4=B8=8B=E5=8D=88=
12:06:24, Paul Burton <paulburton@kernel=2Eorg> =E5=86=99=E5=88=B0:
>Hi Jiaxun,
>
>On Wed, Oct 23, 2019 at 11:25:51PM +0800, Jiaxun Yang wrote:
>> After further discussion with userland library develpoer,
>> we addressed another two ASEs that can be used runtimely in programs=2E
>>=20
>> Export them in hwcap as well to benefit userspace programs=2E
>>=20
>> Signed-off-by: Jiaxun Yang <jiaxun=2Eyang@flygoat=2Ecom>
>> Cc: <stable@vger=2Ekernel=2Eorg> # 4=2E4+
>> ---
>>  arch/mips/include/uapi/asm/hwcap=2Eh | 2 ++
>>  arch/mips/kernel/cpu-probe=2Ec       | 7 ++++++-
>>  2 files changed, 8 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/mips/include/uapi/asm/hwcap=2Eh
>b/arch/mips/include/uapi/asm/hwcap=2Eh
>> index 1ade1daa4921=2E=2Ee1a9bac62149 100644
>> --- a/arch/mips/include/uapi/asm/hwcap=2Eh
>> +++ b/arch/mips/include/uapi/asm/hwcap=2Eh
>> @@ -17,5 +17,7 @@
>>  #define HWCAP_LOONGSON_MMI  (1 << 11)
>>  #define HWCAP_LOONGSON_EXT  (1 << 12)
>>  #define HWCAP_LOONGSON_EXT2 (1 << 13)
>> +#define HWCAP_MIPS_MICROMIPS (1 << 14)
>> +#define HWCAP_MIPS_VZ       (1 << 15)
>
>What's the motivation for exposing VZ? Userland can't actually use it
>without something like KVM, which already exposes a means of detecting
>whether VZ is supported (try the creating a VM of type KVM_VM_MIPS_VZ &
>see if it works)=2E I'm not sure what userland would be able to do with
>this information in AT_HWCAP

Hi Paul,

Well, that was preposed by a kvm developer from Loongson=2E They want to u=
se it to implement CPU_AUTOPROBE and load required modules automatically=2E

As they said they will submit KVM support to mainline later, I'm just occu=
pied a place for them=2E

Out of tree commit:

http://cgit=2Eloongnix=2Eorg/cgit/linux-3=2E10/commit/?id=3D4db9301cca3b49=
358d46fd0da67c01ab2ae4a3e3

--=20
Jiaxun Yang

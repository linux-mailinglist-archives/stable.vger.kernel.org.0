Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935821F5ED5
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgFJXqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 19:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgFJXqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 19:46:25 -0400
Received: from mx2.freebsd.org (mx2.freebsd.org [IPv6:2610:1c1:1:606c::19:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85B7C03E96B;
        Wed, 10 Jun 2020 16:46:24 -0700 (PDT)
Received: from mx1.freebsd.org (mx1.freebsd.org [IPv6:2610:1c1:1:606c::19:1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mx1.freebsd.org", Issuer "Let's Encrypt Authority X3" (verified OK))
        by mx2.freebsd.org (Postfix) with ESMTPS id CD83870E2B;
        Wed, 10 Jun 2020 23:46:23 +0000 (UTC)
        (envelope-from jkim@FreeBSD.org)
Received: from smtp.freebsd.org (smtp.freebsd.org [IPv6:2610:1c1:1:606c::24b:4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "smtp.freebsd.org", Issuer "Let's Encrypt Authority X3" (verified OK))
        by mx1.freebsd.org (Postfix) with ESMTPS id 49j3Xv4DQSz3T7F;
        Wed, 10 Jun 2020 23:46:23 +0000 (UTC)
        (envelope-from jkim@FreeBSD.org)
Received: from freefall.freebsd.org (static-71-168-218-4.cmdnnj.fios.verizon.net [71.168.218.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: jkim/mail)
        by smtp.freebsd.org (Postfix) with ESMTPSA id 64F1716470;
        Wed, 10 Jun 2020 23:46:23 +0000 (UTC)
        (envelope-from jkim@FreeBSD.org)
Subject: Re: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "Kaneda, Erik" <erik.kaneda@intel.com>
Cc:     "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "glider@google.com" <glider@google.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pcc@google.com" <pcc@google.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "will@kernel.org" <will@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
References: <CAMj1kXErFuvOoG=DB6sz5HBvDuHDiKwWD8uOyLuxaX-u8-+dbA@mail.gmail.com>
 <20200601231805.207441-1-ndesaulniers@google.com>
 <BYAPR11MB3096A0EA2D03BCB76C91F80AF0830@BYAPR11MB3096.namprd11.prod.outlook.com>
 <CAKwvOdnh6Zh+P9SM_qFiy-9u7Y21fn=byTJtG4fTTRJqqU9bcQ@mail.gmail.com>
From:   Jung-uk Kim <jkim@FreeBSD.org>
Autocrypt: addr=jkim@FreeBSD.org; keydata=
 mQENBFJBztUBCAChqNyGqmFuNo0U7MBzsD+q/G6Cv0l7LGVrOAsgh34M8wIWhD+tztDWMVfn
 AhxNDd0ceCj2bYOe67sTQxAScEcbt2FfvPOLp9MEXb9qohZj172Gwkk7dnhOhZZKhVGVZKM4
 NcsuBDUzgf4f3Vdzj4wg6WlqplnTZo8lPE4hZWvZHoFIyunPTJWenybeV1xnxK7JkUdSvQR0
 fA59RfTTECMwTrSEfYGUnxIDBraxJ7Ecs/0hGQ7sljIj8WBvlRDU5fU1xfF35aw56T8POQRq
 F4E6RVJW3YGuTpSwgtGZOTfygcLRhAiq3dFC3JNLaTVTpM8PjOinJyt9AU6RoITGOKwDABEB
 AAG0Hkp1bmctdWsgS2ltIDxqa2ltQEZyZWVCU0Qub3JnPokBPQQTAQoAJwUCUkHO1QIbAwUJ
 E0/POwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRB8n5Ym/NvxRqyzB/wL7QtsIpeGfGIA
 ZPMtgXMucM3NWzomyQMln2j2efUkDKthzh9jBxgF53TjOr7imwIt0PT2k1bqctPrq5IRqnu9
 mGroqaCLE3LG2/E3jEaao4k9PO6efwlioyivUo5NrqIQOQ4k3EAXw7d2y0Dk1VpTgdMrnUAB
 hj7lGlLqS4ydcrf24DdbCRGdEQwqd9DBeBgbWynxAJMgbZBhYVEyIHuQKkJ8qY0ibIPXXuF0
 KYDeH0qUHtWV2K3srNyPtymUkBQD84Pl1GWRYx05XdUHDmnX0JV3lg0BfYJZgZv0ehPQrMfY
 Fd9abTkf9FHQYz1JtsC8wUuRgqElRd6+YAGf8Tt9uQENBFJBztUBCADLtSrP44El2VoJmH14
 OFrlOgxzZnbn+Y/Gf1k12mJBiR+A+pBeRLD50p7AiTrjHRxO3cHcl9Dh0uf1VSbXgp8Or0ye
 iP/86fZPd4k5HXNmDTLL0HecPE08SCqGZ0W8vllQrokB1QxxRUB+fFMPJyMCjDAZ7P9fFTOS
 dTw1bJSTtOD8Sx8MpZUa9ti06bXFlVYDlaqSdgk181SSx+ZbSKkQR8CIMARlHwiLsa3Z9q9O
 EJr20HPyxe0AlTvwvFndH61hg7ds63eRvglwRnNON28VXO/lvKXq7Br/CiiyhFdKfINIx2Z5
 htYq22tgGTW7mBURbIKoECFBTX9Lv6BXz6w9ABEBAAGJASUEGAEKAA8FAlJBztUCGwwFCRNP
 zzsACgkQfJ+WJvzb8UZcJQf+IsTCxUEqY7W/pT84sMg5/QD3s6ufTRncvq14fEOxCNq1Rf4Q
 9P+tOFa8GZfKDGB2BFGIrW7uT5mlmKdK1vO6ZIA930y5kUsnCmBUEBJkE2ciSQk01aB/1o62
 Q3Gk/F6BwtNY9OXiqF7AcAo+K/BMIaqb26QKeh+IIgK1NN9dQiq3ByTbl4zpGZa6MmsnnRTu
 mzGKt2nkz7vBzH6+hZp1OzGZikgjjhYWVFoJo1dvf/rv4obs0ZJEqFPQs/1Qa1dbkKBv6odB
 XJpPH0ssOluTY24d1XxTiKTwmWvHeQkOKRAIfD7VTtF4TesoZYkf7hsh3e3VwXhptSLFnEOi
 WwYofg==
Organization: FreeBSD.org
Message-ID: <9f4322a5-eea6-fb65-449c-90f3d85f753e@FreeBSD.org>
Date:   Wed, 10 Jun 2020 19:46:19 -0400
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnh6Zh+P9SM_qFiy-9u7Y21fn=byTJtG4fTTRJqqU9bcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 6. 10., Nick Desaulniers wrote:
> On Wed, Jun 10, 2020 at 4:07 PM Kaneda, Erik <erik.kaneda@intel.com> wrote:
>>
>> +JKim (for FreeBSD's perspective)
>>
>>> -----Original Message-----
>>> From: Nick Desaulniers <ndesaulniers@google.com>
>>> Sent: Monday, June 1, 2020 4:18 PM
>>> To: Moore, Robert <robert.moore@intel.com>; Kaneda, Erik
>>> <erik.kaneda@intel.com>; Wysocki, Rafael J <rafael.j.wysocki@intel.com>;
>>> Len Brown <lenb@kernel.org>
>>> Cc: Ard Biesheuvel <ardb@kernel.org>; dvyukov@google.com;
>>> glider@google.com; guohanjun@huawei.com; linux-arm-
>>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
>>> lorenzo.pieralisi@arm.com; mark.rutland@arm.com;
>>> ndesaulniers@google.com; pcc@google.com; rjw@rjwysocki.net;
>>> will@kernel.org; stable@vger.kernel.org; linux-acpi@vger.kernel.org;
>>> devel@acpica.org
>>> Subject: [PATCH] ACPICA: fix UBSAN warning using __builtin_offsetof
>>>
>>> Will reported UBSAN warnings:
>>> UBSAN: null-ptr-deref in drivers/acpi/acpica/tbfadt.c:459:37
>>> UBSAN: null-ptr-deref in arch/arm64/kernel/smp.c:596:6
>>>
>> Hi,
>>
>>> Looks like the emulated offsetof macro ACPI_OFFSET is causing these. We
>>> can avoid this by using the compiler builtin, __builtin_offsetof.
>>>
>> This doesn't really fly because __builtin_offsetof is a compiler extension.
>>
>> It looks like a lot of stddef.h files do this:
>>
>> #define offsetof(a,b) __builtin_offset(a,b)
>>
>> So does anyone have objections to ACPI_OFFSET being defined to offsetof()?
>>
>> This will allow a host OS project project to use their own definitions of offsetof in place of ACPICA's.
>> If they don't have a definition for offsetof, we can supply the old one as a fallback.
>>
>> Here's a patch:
>>
>> --- a/include/acpi/actypes.h
>> +++ b/include/acpi/actypes.h
>> @@ -504,11 +504,17 @@ typedef u64 acpi_integer;
>>  #define ACPI_SUB_PTR(t, a, b)           ACPI_CAST_PTR (t, (ACPI_CAST_PTR (u8, (a)) - (acpi_size)(b)))
>>  #define ACPI_PTR_DIFF(a, b)             ((acpi_size) (ACPI_CAST_PTR (u8, (a)) - ACPI_CAST_PTR (u8, (b))))
>>
>> +/* Use an existing definiton for offsetof */
> 
> s/definiton/definition/
> 
>> +
>> +#ifndef offsetof
>> +#define offsetof(d,f)                   ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
>> +#endif
> 
> If this header doesn't explicitly include <stddef.h> or
> <linux/stddef.h>, won't translation units that include
> <acpi/actypes.h> get different definitions of ACPI_OFFSET based on
> whether they explicitly or transitively included <stddef.h> before
> including <acpi/actypes.h>?  Theoretically, a translation unit in the
> kernel could include actypes.h, have no includes of linux/stddef.h,
> then get UBSAN errors again from using this definition?
> 
> I don't mind using offsetof in place of the builtin (since it
> typically will be implemented in terms of the builtin, or is at least
> for the case specific to the Linux kernel). But if it's used, we
> should include the header that defines it properly, and we should not
> use the host's <stddef.h> IMO.  Is there a platform specific way to
> include the platform's stddef.h here?
> 
> Maybe linux/stddef.h should be included in
> include/acpi/platform/aclinux.h, then include/acpi/platform/acenv.h
> included in include/acpi/actypes.h, such that ACPI_OFFSET is defined
> in terms of offsetof defined from that transitive dependency of
> headers? (or do we get a circular inclusion trying to do that?)

Actually, I think we should let platform-specific acfoo.h decide what to
do here, i.e.,

#ifndef ACPI_OFFSET
#define ACPI_OFFSET(d, f) ...
#endif

Jung-uk Kim

>> +
>>  /* Pointer/Integer type conversions */
>>
>>  #define ACPI_TO_POINTER(i)              ACPI_CAST_PTR (void, (acpi_size) (i))
>>  #define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) 0)
>> -#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *) 0)
>> +#define ACPI_OFFSET(d, f)               offsetof (d,f)
>>  #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
>>  #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
>>
>> Thanks,
>> Erik
>>
>>> The non-kernel runtime of UBSAN would print:
>>> runtime error: member access within null pointer of type for this macro.
>>>
>>> Link: https://lore.kernel.org/lkml/20200521100952.GA5360@willie-the-truck/
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Will Deacon <will@kernel.org>
>>> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
>>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>>> ---
>>>  include/acpi/actypes.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h index
>>> 4defed58ea33..04359c70b198 100644
>>> --- a/include/acpi/actypes.h
>>> +++ b/include/acpi/actypes.h
>>> @@ -508,7 +508,7 @@ typedef u64 acpi_integer;
>>>
>>>  #define ACPI_TO_POINTER(i)              ACPI_CAST_PTR (void, (acpi_size) (i))
>>>  #define ACPI_TO_INTEGER(p)              ACPI_PTR_DIFF (p, (void *) 0)
>>> -#define ACPI_OFFSET(d, f)               ACPI_PTR_DIFF (&(((d *) 0)->f), (void *)
>>> 0)
>>> +#define ACPI_OFFSET(d, f)               __builtin_offsetof(d, f)
>>>  #define ACPI_PHYSADDR_TO_PTR(i)         ACPI_TO_POINTER(i)
>>>  #define ACPI_PTR_TO_PHYSADDR(i)         ACPI_TO_INTEGER(i)
>>>
>>> --
>>> 2.27.0.rc2.251.g90737beb825-goog



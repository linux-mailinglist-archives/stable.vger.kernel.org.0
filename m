Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98AFEB2C
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 21:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfD2Tux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 15:50:53 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28148 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbfD2Tux (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 15:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1556567453; x=1588103453;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=QU8C5FHUHbs8SsOZ9YN/PcURVaJONHThVrfdV6R+ucY=;
  b=iRNrAo91ytQqKF7yQ8ft993Urobxua89vdgODFH9U9GgrJNL4YVSOKNM
   bycJABG9uU5w45OSEExOHeGtqacvUj+yvpGEj+WGBCHxHom8vvqFb/Fuu
   Eyj3+3NNO3POY51xqNkaBMAQtQYAYrRGLGIX0vn2tOIXVYq9k6r3wo8yY
   BNc0ejzS2Rqs+oJoCNxh90MUZB91/KHKyAK8HyE2w/jmvRng5X/lxQfbK
   LbaQ0da/tRmj7zVI2aVX6kVvzbTgaai4fNTqwRTIBf6Rt3pF0YqxTbMDu
   vhjvqs4hJe74EcbKP5Qy2m4CmaH1C1SqeYkMdmx+FHQ1M+rRbfPgp8u16
   w==;
X-IronPort-AV: E=Sophos;i="5.60,410,1549900800"; 
   d="scan'208";a="108822848"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2019 03:50:43 +0800
IronPort-SDR: NGLG1B5OCi0LAuATKVQKPs/+WHeVV59zyWXXhFJhAC9PWrYYvbB6EVafULP+MO3EuHFXIRkWL4
 a2yrxbjDltJKfbAYkC2KoUseDYTbCC7htISR0X1M02YfoRXBKcw9RYzG+BErow7FQ5BJUEKjWG
 cu2r5YHW4EXGgzV3B51rqnl1VGdW2bGV59jIGqedMJsfG3Z+O9rJacfPo9aHJ0v6RIn2gYkHzz
 mTuBYw7ZLTORUjpoWlR0PHi8E41OT8Xl4OSZ0/J3iPgCmgbxJYxGhQ8hH6OwCnGVQfYJiCKddj
 CTjNvjBczZlH/M8+5u785tqp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 29 Apr 2019 12:27:05 -0700
IronPort-SDR: WIxNxlwXkZwhe2QTYR5CqZl7GDzPmRfIWXE/ne+n3USGxuqMC4yTQEqYiI1wvhGqWpdqTmR9lF
 qxn1e/QdsndD3NjWgiOsdQxPXP24JtrPASI6r2FmbjtNXbnr9Z0mDXhf/sFyhob6m5JQCYeuSU
 oC8jQaHB44mncrYX1GQR53OqA5a+1KBlckRNBZmAbUNz7yEJpBRjHzsSkX90DuI3G/x3dFpGyo
 qqGL9vHo9eIEVcYtHrERbEOXZJtTqbPd6QxV7TUkdXqS0PSLc42vIWgMHO/ldHk84FqWFXFKg3
 WI4=
Received: from c02v91rdhtd5.sdcorp.global.sandisk.com (HELO [10.111.66.167]) ([10.111.66.167])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Apr 2019 12:50:43 -0700
Subject: Re: [PATCH] tty: Don't force RISCV SBI console as preferred console
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190425133435.56065-1-anup.patel@wdc.com>
 <9a8be7ef-e62e-2a93-9170-e3dc70dfb25f@wdc.com>
 <CAAhSdy3z1aDdVZ3dM1bec0z_pNtmfdJ0XukX_0YWwy7Q90G9AA@mail.gmail.com>
From:   Atish Patra <atish.patra@wdc.com>
Message-ID: <a886a50b-c9dd-2e10-37c4-98a591b6c89f@wdc.com>
Date:   Mon, 29 Apr 2019 12:50:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAAhSdy3z1aDdVZ3dM1bec0z_pNtmfdJ0XukX_0YWwy7Q90G9AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/25/19 11:21 PM, Anup Patel wrote:
> On Fri, Apr 26, 2019 at 10:11 AM Atish Patra <atish.patra@wdc.com> wrote:
>>
>> On 4/25/19 6:35 AM, Anup Patel wrote:
>>> The Linux kernel will auto-disables all boot consoles whenever it
>>> gets a preferred real console.
>>>
>>> Currently on RISC-V systems, if we have a real console which is not
>>> RISCV SBI console then boot consoles (such as earlycon=sbi) are not
>>> auto-disabled when a real console (ttyS0 or ttySIF0) is available.
>>> This results in duplicate prints at boot-time after kernel starts
>>> using real console (i.e. ttyS0 or ttySIF0) if "earlycon=" kernel
>>> parameter was passed by bootloader.
>>>
>>> The reason for above issue is that RISCV SBI console always adds
>>> itself as preferred console which is causing other real consoles
>>> to be not used as preferred console.
>>>
>>
>> Do we even need HVC_SBI console to be enabled by default? Disabling
>> CONFIG_HVC_RISCV_SBI seems to be fine while running in QEMU.
> 
> Actually, HVC_SBI console is useful on boards (such as SiFive Unleashed)
> lacking upstream serial driver. It allows us to boot upstream kernel to prompt
> on such boards with just timer driver (and probably irqchip driver).
> 
> Also, we should be able to use same kernel image on QEMU and SiFive
> Unleashed board so disabling CONFIG_HVC_RISCV_SBI for QEMU is
> a temporary solution.
> 
>>
>> If we don't need it, I suggest we should remove the config option from
>> defconfig in addition to this patch.
> 
> Like mentioned above, HVC_SBI is useful for newer SOCs and boards
> where serial driver is not yet up-streamed.
> 

Ok. Lets keep it then.

> Regards,
> Anup
> 
>>
>> Regards,
>> Atish
>>> Ideally "console=" kernel parameter passed by bootloaders should
>>> be the one selecting a preferred real console.
>>>
>>> This patch fixes above issue by not forcing RISCV SBI console as
>>> preferred console.
>>>
>>> Fixes: afa6b1ccfad5 ("tty: New RISC-V SBI console driver")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
>>> ---
>>>    drivers/tty/hvc/hvc_riscv_sbi.c | 1 -
>>>    1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/tty/hvc/hvc_riscv_sbi.c b/drivers/tty/hvc/hvc_riscv_sbi.c
>>> index 75155bde2b88..31f53fa77e4a 100644
>>> --- a/drivers/tty/hvc/hvc_riscv_sbi.c
>>> +++ b/drivers/tty/hvc/hvc_riscv_sbi.c
>>> @@ -53,7 +53,6 @@ device_initcall(hvc_sbi_init);
>>>    static int __init hvc_sbi_console_init(void)
>>>    {
>>>        hvc_instantiate(0, 0, &hvc_sbi_ops);
>>> -     add_preferred_console("hvc", 0, NULL);
>>>
>>>        return 0;
>>>    }
>>>
>>
> 

Reviewed-by: Atish Patra <atish.patra@wdc.com>

Regards,
Atish

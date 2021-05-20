Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2355238A039
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 10:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhETIwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 04:52:47 -0400
Received: from ms-10.1blu.de ([178.254.4.101]:39890 "EHLO ms-10.1blu.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhETIwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 04:52:46 -0400
X-Greylist: delayed 3824 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 04:52:46 EDT
Received: from [87.102.202.253] (helo=[192.168.1.92])
        by ms-10.1blu.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <joerg.sigle@jsigle.com>)
        id 1ljdPA-0000yH-RY
        for stable@vger.kernel.org; Thu, 20 May 2021 09:47:40 +0200
From:   "Joerg M. Sigle" <joerg.sigle@jsigle.com>
Subject: [PATCH] iommu/vt-d: Fix kernel panic caused by 416fa531c816: Preset
 Access/Dirty bits for IOVA over FL
To:     stable@vger.kernel.org
References: <095f9639-2708-48bf-bf56-57ab0866dcee@jsigle.com>
Openpgp: preference=signencrypt
Autocrypt: addr=joerg.sigle@jsigle.com; prefer-encrypt=mutual; keydata=
 xsDiBEQYHMMRBADRvakjCgWbUtuZFxoKohCVAFgjhJ5RtxG3x7NfZj4k/Bm18GXLea1qIwKf
 aO55x4KCj+/ecbdAaFHFirPAZi45DzvFshgEBKY0w89A4qo7UvX3mqfg/G9RZFT55YDqPMJh
 VO3X0r+Qz6ID7BgOVZnmbpnyMiAPx5OpRly+aA4ZQQCg/6ll3zyL6q6AAHhjT0OSgdKXcfkD
 /3ZQUfDD4+ZbV6IG4fdeXzc8qHyLrqWEf+aQWQjtjxe3+vQIL6VDaACz3eeERETMrnyVLG+p
 wrIiccShYYkLUt+PeMNiEFMZNi8FzsLv8GiEvxPVaRuHgteX5LgdHsDceqou3UJb4hPQtO1n
 8YatK5MfMB3vXFox74rpj0Hh9+yyBACzc6O8F7SYNVvy3oDU9AJR1kkHiXf9Y8Z0SOB13zDW
 GDPKAewIxGXk6PKaArRugPzd7caUBd8Cha/COUwoWfxdCe1RGZTdSVCoe1TvqqdGtwrw+fis
 6XddsfTfLsuPXR3yW1ESPB00utIE/rVG6XbFQ0s5kZQep4ZfftyHBFKUVs0oSm9lcmctTWlj
 aGFlbCBTaWdsZSA8am9lcmcuc2lnbGVAd2ViLmRlPsJLBBARAgALBQJEGBziBAsDAQIACgkQ
 CJ3K818VBio/PwCg1wv3nkMEOCc8Oh+UPDCAID2ZmZcAn1vcO7SDQrp2FGmPqr+g6NH7Qr8N
 zsNNBEQYHMQQEAD5GKB+WgZhekOQldwFbIeG7GHszUUfDtjgo3nGydx6C6zkP+NGlLYwSlPX
 fAIWSIC1FeUpmamfB3TT/+OhxZYgTphluNgN7hBdq7YXHFHYUMoiV0MpvpXoVis4eFwL2/hM
 TdXjqkbM+84X6CqdFGHjhKlP0YOEqHm274+nQ0YIxswdd1ckOErixPDojhNnl06SE2H22+sl
 Dhf99pj3yHx5sHIdOHX79sFzxIMRJitDYMPj6NYK/aEoJguuqa6zZQ+iAFMBoHzWq6MSHvoP
 Ks4fdIRPyvMX86RA6dfSd7ZCLQI2wSbLaF6dfJgJCo1+Le3kXXn11JJPmxiO/CqnS3wy9kJX
 twh/CBdyorrWqULzBej5UxE5T7bxbrlLOCDaAadWoxTpj0BV89AHxstDqZSt90xkhkn4DIO9
 ZekX1KHTUPj1WV/cdlJPPT2N286Z4VeSWc39uK50T8X8dryDxUcwYc58yWb/Ffm7/ZFexwGq
 01uejaClcjrUGvC/RgBYK+X0iP1YTknbzSC0neSRBzZrM2w4DUUdD3yIsxx8Wy2O9vPJI8BD
 8KVbGI2Ou1WMuF040zT9fBdXQ6MdGGzeMyEstSr/POGxKUAYEY18hKcKctaGxAMZyAcpesqV
 DNmWn6vQClCbAkbTCD1mpF1Bn5x8vYlLIhkmuquiXsNV6z3WFwACAg//XFEPM51xtB19Vzdp
 V65oFdf9LCNoR9+N2yPyEx/Y4+bmymhhJpJGWLeSiicBx2VONvKpDBlPd0jX3GImm2FjQzbg
 o38IaAqc1VzjAJ8p7AV0eOttmh5rNUqe8NKPmuXIzNIiHMBjZ6Vsg44aFnOkDVyMTxC08QxJ
 t6WAKCb3KersKv6AxcTvAuKKIggIzLhrcfbyD61NlxLJRSvNxwmVMhblb5ngZ2ri1SigOC2u
 eW527nX6m4vJFvqZ2kGg0KiM9Zam34m4/QCQcUCFAcaoWtQYT0lwwXGuCKhKUBSQO86shLqF
 yO4jYGYhLJskvVkHbiGtjqqEBjQIag67N9uk1EQFy32e0Vv7nfVmyzCUqHv9EixAN+DtBENz
 R70xrCFmwBiPNb1HixrGRa8VzeNI66pJPsyCb4+yc/Pc17J2e/Pltyfee/5scr+6Tln2VQb2
 Ru89XVni2UI7xj6CR6wfP6hiBKF9DI4nIxEv8r3aLKBLCCKDvS+YAPRtBpSVnk0Cwiri1KHo
 l38mzjiLqW5LBZ4NkcV3PAMYsAmv/80zY+eGb8YRPnOv/rHCLSesw9Wo8MtH7MXc+PqrZnio
 50U8+WpViaE1A5GDCP1KNPTs5ghAM2cHQCPyFxf0GLIeyCdQyAr5JbM4UyJblqNT4+bdgaxy
 foletFZEk/WkMXPpFX/CPwMFGEQYHMQIncrzXxUGKhECA0wAoPP81KOLYdkMjQYN7sbcyA3k
 8PuOAKC9roFUBE+MA3ttuTAdqMIxhIo1cw==
Message-ID: <7827b043-7abe-de56-2a46-19d689f34120@jsigle.com>
Date:   Thu, 20 May 2021 09:47:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <095f9639-2708-48bf-bf56-57ab0866dcee@jsigle.com>
Content-Type: multipart/mixed;
 boundary="------------3F1517983449C001715574EE"
Content-Language: de-DE-1901
X-Con-Id: 102464
X-Con-U: 0-joergsigle
X-Originating-IP: 87.102.202.253
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------3F1517983449C001715574EE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Dear colleaguse

I've submitted a patch for 5.10.37 that wasn't included in 5.10.38,
which would have corrected a patch that has been reverted instead.

More info:
https://bugzilla.kernel.org/show_bug.cgi?id=213077

Now sending to the other kernel list, according to autoresponse
from Greg Kroah-Hartman.

Thanks for any feedback & Kind regards, Joerg Sigle

-------- Weitergeleitete Nachricht --------
From: 15 2021 <>
X-Mozilla-Status: 0001
X-Mozilla-Status2: 00800000
X-Mozilla-Keys: Subject: [PATCH] iommu/vt-d: Fix kernel panic caused by 416fa531c816: Preset Access/Dirty bits for IOVA over FL
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>, joro@8bytes.org, sashal@kernel.org, linux-kernel@vger.kernel.org
References: <bug-213077-5531-kGNQn2oCe1@https.bugzilla.kernel.org/> <8f485610-7560-239f-207b-cda3234869f2@jsigle.com> <041d48f5-0c3c-a435-1980-33492c377e8b@linux.intel.com>
From: Joerg M. Sigle <joerg.sigle@jsigle.com>
Openpgp: preference=signencrypt
Autocrypt: addr=joerg.sigle@jsigle.com; prefer-encrypt=mutual; keydata= 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 8PuOAKC9roFUBE+MA3ttuTAdqMIxhIo1cw==
To: bp@alien8.de
Message-ID: <095f9639-2708-48bf-bf56-57ab0866dcee@jsigle.com>
Date: Mon, 17 May 2021 08:49:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <041d48f5-0c3c-a435-1980-33492c377e8b@linux.intel.com>
Content-Type: multipart/mixed; boundary="------------B30AAE90B5865B3ACE0C512C"
Content-Language: de-DE-1901

From: Joerg M. Sigle <joerg.sigle@jsigle.com>

Patch 416fa531c816 commit 416fa531c8160151090206a51b829b9218b804d9 caused
an immediate kernel panic on boot at RIP: 0010:__domain_mapping+0xa7/0x3a0
with longterm kernel 5.10.37 configured w/ CONFIG_INTEL_IOMMU_DEFAULT_ON=y
due to removal of a check. Putting the check back in place fixes this.
The kernel panic was observed on various Intel Core i7 i5 i3 CPUs from
Sandy Bridge, Haswell, Broadwell and Kaby Lake generations (at least).
It may NOT be reproducible on some older CPU generations.
Suppressing the panic with boot parameter intel_iommu=off is diagnostic.
See: https://bugzilla.kernel.org/show_bug.cgi?id=213077
https://bugzilla.kernel.org/show_bug.cgi?id=213087
https://bugzilla.kernel.org/show_bug.cgi?id=213095

Signed-off-by: Joerg M. Sigle <joerg.sigle@jsigle.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>

---

Dear colleagues,

Please find the suggested patch in the attachment, now reformatted to include the affected C function.
It fixes a problem in LT kernel 5.10.37; I'm asking for inclusion into LT kernel 5.10.38.

I'm submitting this now, after receiving Lu Baolu's positive response attached below.
Baolu, I hope that the line "Acked-by: Lu Baolu ..." is ok given your comment.

I hope I'm providing this in a useful way, following
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html

I'm still unsure whether this line should be added above:
Cc: stable@vger.kernel.org
Please add this if needed, also considering Baolu's comment re. upstream/backported.

Thanks and kind regards to all! Joerg


Am 17.05.2021 um 04:51 schrieb Lu Baolu:
> Hi Joerg,
> 
> On 5/16/21 7:57 AM, Joerg M. Sigle wrote:
>> Dear colleagues at Intel
>>
>> could you please check the enclosed bug report
>> and confirm whether the suggested patch is valid.
>>
>> Thank you very much & kind regards - Joerg
>>
>>
>> -------- Weitergeleitete Nachricht --------
>> From: bugzilla-daemon@bugzilla.kernel.org
>> To: joerg.sigle@jsigle.com
>> Subject: [Bug 213077] Kernel 5.10.37 immediately panics at boot w/ Intel Core i7-4910MQ Haswell or Core i3-5010U Broadwell w/ custom .config CONFIG_INTEL_IOMMU_DEFAULT_ON=y, same config worked with 5.10.36, due to commit 416fa531c816 =
>> a8ce9ebbecdfda3322bbcece6b3b25888217f8e3
>> Date: Sat, 15 May 2021 23:47:39 +0000
>> X-Envelope-To: joerg.sigle@jsigle.com
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=213077
>>
>> --- Comment #7 from Joerg M. Sigle (joerg.sigle@jsigle.com) ---
>> This patch:
>>
>> 416fa531c816 iommu/vt-d: Preset Access/Dirty bits for IOVA over FL
>> commit 416fa531c8160151090206a51b829b9218b804d9
>> Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3
>>
>> https://github.com/arter97/x86-kernel/commit/416fa531c8160151090206a51b829b9218b804d9
>>
>> while doing other things, changed the conditional:
>>
>> if (!sg) { ...
>>          sg_res = nr_pages;
>>          pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
>> }
>>
>> to an unconditional:
>>
>> pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
>>
>> Reinserting the check for !sg fixed the immediate panic on boot for me.
>> Reverting the remainder of the same patch had not helped before.
>>
>> Here's a possible patch for 5.10.37:
>>
>> -------------------------------------------------------------------------
>> --- a/drivers/iommu/intel/iommu.c       2021-05-14 09:50:46.000000000 +0200
>> +++ b/drivers/iommu/intel/iommu.c       2021-05-16 01:02:17.816810690 +0200
>> @@ -2373,7 +2373,10 @@
>>                  }
>>          }
>>
>> -       pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
>> +        if (!sg) {
>> +                sg_res = nr_pages;
>> +                pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) | attr;
>> +       }
>>
>>          while (nr_pages > 0) {
>>                  uint64_t tmp;
>> -------------------------------------------------------------------------
>>
>> Could you please check this patch submission and pass it to upstream?
> 
> 
> Above fix looks good to me.
> 
> This issue is caused by the back-ported patch for stable v5.10.37.
> There's no need for upstream.
> 
> Best regards,
> baolu
> 
>>
>> I have, however, NOT tried to understand what the code really does.
>> So please ask the suppliers of patch 416fa531c816 whether their
>> removal of the condition was intentional or a mere lapsus. Thanks!
>>
>> Thanks and kind regards, Joerg
>>
> 

-- 
-------------------------------------------------------------------
Dr. med. Jörg M. Sigle                             +41 76 276 86 94
http://www.ql-recorder.com                         +41 32 510 23 46
http://www.jsigle.com                           +49 176 96 43 54 13




--------------3F1517983449C001715574EE
Content-Type: text/plain; charset=UTF-8;
 name="patch-to-LinuxKernelLT5.10.37-iommuvtd-FixKernelPanicBy416fa531c816-202105160112js.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="patch-to-LinuxKernelLT5.10.37-iommuvtd-FixKernelPanicBy416fa";
 filename*1="531c816-202105160112js.txt"

LS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jCTIwMjEtMDUtMTQgMDk6NTA6NDYu
MDAwMDAwMDAwICswMjAwCisrKyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYwkyMDIx
LTA1LTE2IDAxOjAyOjE3LjgxNjgxMDY5MCArMDIwMApAQCAtMjM3Myw3ICsyMzczLDEwIEBA
IHN0YXRpYyBpbnQgX19kb21haW5fbWFwcGluZyhzdHJ1Y3QgZG1hcl8KIAkJfQogCX0KIAot
CXB0ZXZhbCA9ICgocGh5c19hZGRyX3QpcGh5c19wZm4gPDwgVlREX1BBR0VfU0hJRlQpIHwg
YXR0cjsKKwlpZiAoIXNnKSB7CisgICAgICAgICAgICAgICAgc2dfcmVzID0gbnJfcGFnZXM7
CisgICAgICAgICAgICAgICAgcHRldmFsID0gKChwaHlzX2FkZHJfdClwaHlzX3BmbiA8PCBW
VERfUEFHRV9TSElGVCkgfCBhdHRyOworCX0KIAogCXdoaWxlIChucl9wYWdlcyA+IDApIHsK
IAkJdWludDY0X3QgdG1wOwo=
--------------3F1517983449C001715574EE--

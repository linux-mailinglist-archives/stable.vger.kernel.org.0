Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83CB4A7079
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 13:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbiBBMHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 07:07:23 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:12182 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiBBMHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 07:07:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643803642; x=1675339642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=cuSCVfW005fsSBEPH88lKXaq75n7sp1cMS4Op/VVQoc=;
  b=iAPulhsRU9mgIB2VBZAQ2faKvHdz5vgyAgpkeUz8/PfkdPU3o+qb2c9b
   xwRrdiK50eUUZo7+sSXGzepMhdOOj/gVe+/JqhTXSkb+bTnjzaMHs+4Bf
   s8N85XOD0etz6GjEBVLgB+qiKdcmebZnW3aYyxaCl3m+XhDe9kCIu9r8F
   ko5Z5Lbd2qXFYZPG4CjeWaKyCf7sS2tC6Vm++bd9boE0juM5uFUhCF6IO
   D3x8fVk9DwCfEoExqsYBRwuRuBdTMg4U6y3dNOBKQydByrjWfm0mgAsTY
   W80LbQwqKl65pw9k5FoD5RBMrhXmGagI9ep4M0ftfEhhppRkkEoUKOFM1
   A==;
X-IronPort-AV: E=Sophos;i="5.88,336,1635177600"; 
   d="scan'208,223";a="303870796"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2022 20:07:22 +0800
IronPort-SDR: yKcP1dU8G65dxlZd3ldj3U3Ca0/5Zjk8+u9pVpc/9uQZdpfCgLF3vbxEtiZ6kKdh9Z4JkxTn7n
 4ok/igVvh0Y90oKzsBRMWACJSQhKTInB+MX2CtlnCeUpzqGr1NzQWeCUfTXQ8/0xDVo6hyXqQs
 u0xDGczNdtx5edGObSNyKTcRP1gd870JARgQX3xzupO88HXabzW8V7ZsOxyknrf1rNl4m/BXck
 EmFB0oQ+ysloBZpTtcletdPlB97N6hM4vncvCU6rAY/YwoUY2ZW6sTUFHvkTwMpYKszXtytix2
 Uw4cGWC8l1KJ8yWvOigYfqma
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 03:39:18 -0800
IronPort-SDR: dGotRU3rr9dRfAJ1e2BTrxBJXAA9lgr/eR1w/JcjVTg5hqDR1dGXWsg3VEYpLyGNXIth6GUNbO
 c+0soisLoiEwMAw0cr4RkbCCN5t/l5CN2GyA5T/IoBMNx5rAAbE7WOVjuhD4RsBnJuP1K6Fekh
 gvPd7a6dsbBXubvX/GkkVBBPA8Z2+fE+RnAvrT4rxMBTeeCVOiwUdpnfbzNOauOx9C5a7Lvdj+
 K3I+/5XXVRHFvgdRByLFk9w0m3HYQnTCjRmW2zpsIv6KriBeLNEsW2dUnudNwWfkS54Dy2aJRi
 5e8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 04:07:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JpgXT53zFz1Rwrw
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 04:07:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=in-reply-to:organization:from:references
        :to:content-language:subject:user-agent:mime-version:date
        :message-id:content-type; s=dkim; t=1643803641; x=1646395642;
         bh=cuSCVfW005fsSBEPH88lKXaq75n7sp1cMS4Op/VVQoc=; b=NLqtPRsmCnPU
        dm+Y3aO4OSeQZagX+alEV2bVTRPTWSsJaQs1BbNl9sLgFZLV2a1mWH5F+lRCiNtI
        CRcx37FLkuQoi17W/7ea640IlDjaVfF+o39EBVZn+hiTqY8CgJUKKRobME3Ve7oQ
        Eww3jcbCs6IBEEWrHtpdWR3PBdCMQzsQI0Iezdvuocl5p2GyLXvGyhizU5GmxedQ
        MxqggJjCsGaZcsk/2g63XY4s6oMZC9WWwKvR+sWzjbj8ieptVBGkJWtX5d75ke99
        ovH2jAsVFuWIyoZNSgJAwr0pXyca2k4vcOygulcqlH9cOT4ywSmxSlC/Yip88rw7
        wBfdMxF4nA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SEHpjTTtnO7B for <stable@vger.kernel.org>;
        Wed,  2 Feb 2022 04:07:21 -0800 (PST)
Received: from [10.225.163.62] (unknown [10.225.163.62])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JpgXS5VG2z1RvlN;
        Wed,  2 Feb 2022 04:07:20 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------gzEvRNWjyoiv70euu27C7jRA"
Message-ID: <68992064-ee43-db10-fdd4-f40a09734ffe@opensource.wdc.com>
Date:   Wed, 2 Feb 2022 21:07:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] libata: Don't issue ATA_LOG_DIRECTORY to SATADOM-ML 3ME
Content-Language: en-US
To:     Anton Lundin <glance@acc.umu.se>, linux-ide@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220202100536.1909665-1-glance@acc.umu.se>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220202100536.1909665-1-glance@acc.umu.se>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------gzEvRNWjyoiv70euu27C7jRA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/22 19:05, Anton Lundin wrote:
> Back in 06f6c4c6c3e8 ("ata: libata: add missing ata_identify_page_supported() calls")
> a read of ATA_LOG_DIRECTORY page was added. This caused the
> SATADOM-ML 3ME to lock up.
> 
> In 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
> a flag was added to cache if a device supports this or not.
> 
> This adds a blacklist entry which flags that these devices doesn't
> support that call and shouldn't be issued that call.
> 
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Anton Lundin <glance@acc.umu.se>
> Depends-on: 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
> ---
>  drivers/ata/libata-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 87d36b29ca5f..e024af9f33d0 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4070,6 +4070,13 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "WDC WD3000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
>  	{ "WDC WD3200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
>  
> +	/*
> +	 * This sata dom goes on a walkabout when it sees the
> +	 * ATA_LOG_DIRECTORY read request so ensure we don't issue such a
> +	 * request to these devices.
> +	 */
> +	{ "SATADOM-ML 3ME",		NULL,	ATA_HORKAGE_NO_ID_DEV_LOG },
> +
>  	/* End Marker */
>  	{ }
>  };

Can you try the attached patch ?

I think it is important to confirm if the lockup on your drive happens
due to reads of the log directory log page or due to reads of the
identify device log page. The attached patch prevents the former, your
patch prevents the latter. If your patch is all that is needed, then it
is good, modulo some rephrasing of the commit message and comments.

-- 
Damien Le Moal
Western Digital Research
--------------gzEvRNWjyoiv70euu27C7jRA
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-ata-libata-core-Introduce-ATA_HORKAGE_NO_LOG_DIR-hor.patch"
Content-Disposition: attachment;
 filename*0="0001-ata-libata-core-Introduce-ATA_HORKAGE_NO_LOG_DIR-hor.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA1NGU1NjZkNDIzM2Q5ZTYyNzM1ZmQ4OTgzN2RiMGY1ZjRkZWE5OWUyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbnRvbiBMdW5kaW4gPGdsYW5jZUBhY2MudW11LnNl
PgpEYXRlOiBXZWQsIDIgRmViIDIwMjIgMjA6NDc6NDAgKzA5MDAKU3ViamVjdDogW1BBVENI
XSBhdGE6IGxpYmF0YS1jb3JlOiBJbnRyb2R1Y2UgQVRBX0hPUktBR0VfTk9fTE9HX0RJUiBo
b3JrYWdlCgowNmY2YzRjNmMzZTggKCJhdGE6IGxpYmF0YTogYWRkIG1pc3NpbmcgYXRhX2lk
ZW50aWZ5X3BhZ2Vfc3VwcG9ydGVkKCkgY2FsbHMiKQppbnRyb2R1Y2VkIGFkZGl0aW9uYWwg
Y2FsbHMgdG8gYXRhX2lkZW50aWZ5X3BhZ2Vfc3VwcG9ydGVkKCksIHRodXMgYWxzbwphZGRp
bmcgaW5kaXJlY3RseSBhY2Nlc3NlcyB0byB0aGUgZGV2aWNlIGxvZyBkaXJlY3RvcnkgbG9n
IHBhZ2UgdGhyb3VnaAphdGFfbG9nX3N1cHBvcnRlZCgpLiBSZWFkaW5nIHRoaXMgbG9nIHBh
Z2UgY2F1c2VzIFNBVEFET00tTUwgM01FIGRldmljZXMKdG8gbG9jayB1cC4KCkludHJvZHVj
ZSB0aGUgaG9ya2FnZSBmbGFnIEFUQV9IT1JLQUdFX05PX0xPR19ESVIgdG8gcHJldmVudCBh
Y2Nlc3NlcyB0bwp0aGUgbG9nIGRpcmVjdG9yeSBpbiBhdGFfbG9nX3N1cHBvcnRlZCgpIGFu
ZCBhZGQgYSBibGFja2xpc3QgZW50cnkKd2l0aCB0aGlzIGZsYWcgZm9yICJTQVRBRE9NLU1M
IDNNRSIgZGV2aWNlcy4KCkZpeGVzOiA2MzZmNmUyYWY0ZmIgKCJsaWJhdGE6IGFkZCBob3Jr
YWdlIGZvciBtaXNzaW5nIElkZW50aWZ5IERldmljZSBsb2ciKQpDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZyAjIHY1LjEwKwpTaWduZWQtb2ZmLWJ5OiBBbnRvbiBMdW5kaW4gPGdsYW5j
ZUBhY2MudW11LnNlPgpTaWduZWQtb2ZmLWJ5OiBEYW1pZW4gTGUgTW9hbCA8ZGFtaWVuLmxl
bW9hbEBvcGVuc291cmNlLndkYy5jb20+Ci0tLQogZHJpdmVycy9hdGEvbGliYXRhLWNvcmUu
YyB8IDEwICsrKysrKysrKysKIGluY2x1ZGUvbGludXgvbGliYXRhLmggICAgfCAgMSArCiAy
IGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2F0YS9saWJhdGEtY29yZS5jIGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYwppbmRleCA2
N2Y4ODAyNzY4MGEuLmUxYjFkZDIxNTI2NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9hdGEvbGli
YXRhLWNvcmUuYworKysgYi9kcml2ZXJzL2F0YS9saWJhdGEtY29yZS5jCkBAIC0yMDA3LDYg
KzIwMDcsOSBAQCBzdGF0aWMgYm9vbCBhdGFfbG9nX3N1cHBvcnRlZChzdHJ1Y3QgYXRhX2Rl
dmljZSAqZGV2LCB1OCBsb2cpCiB7CiAJc3RydWN0IGF0YV9wb3J0ICphcCA9IGRldi0+bGlu
ay0+YXA7CiAKKwlpZiAoZGV2LT5ob3JrYWdlICYgQVRBX0hPUktBR0VfTk9fTE9HX0RJUikK
KwkJcmV0dXJuIGZhbHNlOworCiAJaWYgKGF0YV9yZWFkX2xvZ19wYWdlKGRldiwgQVRBX0xP
R19ESVJFQ1RPUlksIDAsIGFwLT5zZWN0b3JfYnVmLCAxKSkKIAkJcmV0dXJuIGZhbHNlOwog
CXJldHVybiBnZXRfdW5hbGlnbmVkX2xlMTYoJmFwLT5zZWN0b3JfYnVmW2xvZyAqIDJdKSA/
IHRydWUgOiBmYWxzZTsKQEAgLTQwNzMsNiArNDA3NiwxMyBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGF0YV9ibGFja2xpc3RfZW50cnkgYXRhX2RldmljZV9ibGFja2xpc3QgW10gPSB7CiAJ
eyAiV0RDIFdEMzAwMEpELSoiLAkJTlVMTCwJQVRBX0hPUktBR0VfV0RfQlJPS0VOX0xQTSB9
LAogCXsgIldEQyBXRDMyMDBKRC0qIiwJCU5VTEwsCUFUQV9IT1JLQUdFX1dEX0JST0tFTl9M
UE0gfSwKIAorCS8qCisJICogVGhpcyBzYXRhIGRvbSBkZXZpY2UgZ29lcyBvbiBhIHdhbGth
Ym91dCB3aGVuIHRoZSBBVEFfTE9HX0RJUkVDVE9SWQorCSAqIGxvZyBwYWdlIGlzIGFjY2Vz
c2VkLiBFbnN1cmUgd2UgbmV2ZXIgYXNrIGZvciB0aGlzIGxvZyBwYWdlIHdpdGgKKwkgKiB0
aGVzZSBkZXZpY2VzLgorCSAqLworCXsgIlNBVEFET00tTUwgM01FIiwJCU5VTEwsCUFUQV9I
T1JLQUdFX05PX0xPR19ESVIgfSwKKwogCS8qIEVuZCBNYXJrZXIgKi8KIAl7IH0KIH07CmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2xpYmF0YS5oIGIvaW5jbHVkZS9saW51eC9saWJh
dGEuaAppbmRleCA2MDU3NTZmNjQ1YmUuLjdmOTliNGQ3ODgyMiAxMDA2NDQKLS0tIGEvaW5j
bHVkZS9saW51eC9saWJhdGEuaAorKysgYi9pbmNsdWRlL2xpbnV4L2xpYmF0YS5oCkBAIC0z
ODAsNiArMzgwLDcgQEAgZW51bSB7CiAJQVRBX0hPUktBR0VfTUFYX1RSSU1fMTI4TSA9ICgx
IDw8IDI2KSwJLyogTGltaXQgbWF4IHRyaW0gc2l6ZSB0byAxMjhNICovCiAJQVRBX0hPUktB
R0VfTk9fTkNRX09OX0FUSSA9ICgxIDw8IDI3KSwJLyogRGlzYWJsZSBOQ1Egb24gQVRJIGNo
aXBzZXQgKi8KIAlBVEFfSE9SS0FHRV9OT19JRF9ERVZfTE9HID0gKDEgPDwgMjgpLAkvKiBJ
ZGVudGlmeSBkZXZpY2UgbG9nIG1pc3NpbmcgKi8KKwlBVEFfSE9SS0FHRV9OT19MT0dfRElS
CT0gKDEgPDwgMjkpLAkvKiBEbyBub3QgcmVhZCBsb2cgZGlyZWN0b3J5ICovCiAKIAkgLyog
RE1BIG1hc2sgZm9yIHVzZXIgRE1BIGNvbnRyb2w6IFVzZXIgdmlzaWJsZSB2YWx1ZXM7IERP
IE5PVAogCSAgICByZW51bWJlciAqLwotLSAKMi4zNC4xCgo=

--------------gzEvRNWjyoiv70euu27C7jRA--

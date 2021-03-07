Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC923304DA
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 22:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhCGV1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 16:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbhCGV1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 16:27:25 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F664C06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 13:27:25 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso2622269wmi.3
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 13:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=UNME1cmshD1kui4AaKz6vKOyi8LbK0oP3Nsoy/JNHBc=;
        b=ks15rluHGcmgoUcHCyCXmqfP0ARBqvX7uS9YnLAnHrDXGJO/1JqNzbJVKSpUJlyjb3
         NMTrZsLG5Y067fbfu5LFfYDTcyfYAHMPEP96gFwUvgynvZckFC6xpVKJyAKALMYvQC8c
         Frbg9Zio+i7xjaNpYBBd0EhojzKtOsnJQP95UEY8cHviwfT485sv0mROUvX41dPZub+c
         DMJJj1KVWUPtmvzzGE9OcRTGfow+BFQ4dr9dzVrtKy75vZ5sJQELnQjK2wk7gK2SINm5
         tG3QuNmHjPk5WKmHZdlF3ZXvxTuTrdBNsfNmKen/FYb/BWSjTzz+xy6VBs2MOoLgaTdJ
         Xxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=UNME1cmshD1kui4AaKz6vKOyi8LbK0oP3Nsoy/JNHBc=;
        b=XirXz8m69uTNZm/AL7133fmf+LIPH5zJs3Non7wB5jRLRcKZ8CsY+0dymqDtO6HjbJ
         qfLJITKuHhAiizdu3dG2DrZaH83XEqNBByP26quc9D4AOaPOejMa0dKA4v49tb2Jiah2
         3PV7N4vdkGrVq28rbRpt6jafutjhmO6dpHAk7PO3GrBoUtQsyU1bBAQjarUmZnjUU0Q7
         8F0dLh+JihswvD3WsqtOdkPcoTz7e5J5OJXlZXW7GURc7FY2dV526b8cmOfNzXTOLCR+
         GGwD7kd2nuDFoViW2o8G8vxx7dsAKfSXWn/3nKI4wkArOlYYrNonzuPQSKwp5XUbbj6u
         Ye7Q==
X-Gm-Message-State: AOAM533ev8Ru9SN4Q06yF7GCAybW4+Qg/a6J6dTUnO385uPgHbbT9Mcs
        wbTIcLlgW+YF152461rAb71j8ba47ds=
X-Google-Smtp-Source: ABdhPJz93d7C/Yn8IrHsrI5gOeI8Z7nuWJ281pJ8F/HQu0B1u+bgTOeJ3ekCyXQLbv4hRsJWiO9mZg==
X-Received: by 2002:a7b:c755:: with SMTP id w21mr19695528wmk.89.1615152443663;
        Sun, 07 Mar 2021 13:27:23 -0800 (PST)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id q4sm7231260wma.20.2021.03.07.13.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 13:27:22 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] dm verity: fix FEC for RS roots unaligned
 to block size" failed to apply to 4.19-stable tree
To:     gregkh@linuxfoundation.org, cJ-ko@zougloub.eu,
        samitolvanen@google.com, snitzer@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     stable@vger.kernel.org
References: <161512534156239@kroah.com>
From:   Milan Broz <gmazyland@gmail.com>
Message-ID: <82970d00-c11d-e2fb-5999-d953f46901fa@gmail.com>
Date:   Sun, 7 Mar 2021 22:27:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <161512534156239@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------C02B9C677A2F9FC6936FF60C"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------C02B9C677A2F9FC6936FF60C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 07/03/2021 14:55, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hello,

I think the patch should be backported to 4.19, only trivial diff context change needed.
Backported patch based on top of 4.19.179 is in attachment.

For older longterm (4.9, 4.14) it cannot be easily backported without additional
changes to dm-bufio (mainly support for non-power-of-two block sizes).

Thanks,
Milan

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From df7b59ba9245c4a3115ebaa905e3e5719a3810da Mon Sep 17 00:00:00 2001
> From: Milan Broz <gmazyland@gmail.com>
> Date: Tue, 23 Feb 2021 21:21:21 +0100
> Subject: [PATCH] dm verity: fix FEC for RS roots unaligned to block size
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Optional Forward Error Correction (FEC) code in dm-verity uses
> Reed-Solomon code and should support roots from 2 to 24.
> 
> The error correction parity bytes (of roots lengths per RS block) are
> stored on a separate device in sequence without any padding.
> 
> Currently, to access FEC device, the dm-verity-fec code uses dm-bufio
> client with block size set to verity data block (usually 4096 or 512
> bytes).
> 
> Because this block size is not divisible by some (most!) of the roots
> supported lengths, data repair cannot work for partially stored parity
> bytes.
> 
> This fix changes FEC device dm-bufio block size to "roots << SECTOR_SHIFT"
> where we can be sure that the full parity data is always available.
> (There cannot be partial FEC blocks because parity must cover whole
> sectors.)
> 
> Because the optional FEC starting offset could be unaligned to this
> new block size, we have to use dm_bufio_set_sector_offset() to
> configure it.
> 
> The problem is easily reproduced using veritysetup, e.g. for roots=13:
> 
>   # create verity device with RS FEC
>   dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
>   veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=13 | awk '/^Root hash/{ print $3 }' >roothash
> 
>   # create an erasure that should be always repairable with this roots setting
>   dd if=/dev/zero of=data.img conv=notrunc bs=1 count=8 seek=4088 status=none
> 
>   # try to read it through dm-verity
>   veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=13 $(cat roothash)
>   dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer
>   # wait for possible recursive recovery in kernel
>   udevadm settle
>   veritysetup close test
> 
> With this fix, errors are properly repaired.
>   device-mapper: verity-fec: 7:1: FEC 0: corrected 8 errors
>   ...
> 
> Without it, FEC code usually ends on unrecoverable failure in RS decoder:
>   device-mapper: verity-fec: 7:1: FEC 0: failed to correct: -74
>   ...
> 
> This problem is present in all kernels since the FEC code's
> introduction (kernel 4.5).
> 
> It is thought that this problem is not visible in Android ecosystem
> because it always uses a default RS roots=2.
> 
> Depends-on: a14e5ec66a7a ("dm bufio: subtract the number of initial sectors in dm_bufio_get_device_size")
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> Tested-by: Jérôme Carretero <cJ-ko@zougloub.eu>
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> Cc: stable@vger.kernel.org # 4.5+
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index fb41b4f23c48..66f4c6398f67 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -61,19 +61,18 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
>  static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
>  			   unsigned *offset, struct dm_buffer **buf)
>  {
> -	u64 position, block;
> +	u64 position, block, rem;
>  	u8 *res;
>  
>  	position = (index + rsb) * v->fec->roots;
> -	block = position >> v->data_dev_block_bits;
> -	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
> +	block = div64_u64_rem(position, v->fec->roots << SECTOR_SHIFT, &rem);
> +	*offset = (unsigned)rem;
>  
> -	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
> +	res = dm_bufio_read(v->fec->bufio, block, buf);
>  	if (IS_ERR(res)) {
>  		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
>  		      v->data_dev->name, (unsigned long long)rsb,
> -		      (unsigned long long)(v->fec->start + block),
> -		      PTR_ERR(res));
> +		      (unsigned long long)block, PTR_ERR(res));
>  		*buf = NULL;
>  	}
>  
> @@ -155,7 +154,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
>  
>  		/* read the next block when we run out of parity bytes */
>  		offset += v->fec->roots;
> -		if (offset >= 1 << v->data_dev_block_bits) {
> +		if (offset >= v->fec->roots << SECTOR_SHIFT) {
>  			dm_bufio_release(buf);
>  
>  			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
> @@ -674,7 +673,7 @@ int verity_fec_ctr(struct dm_verity *v)
>  {
>  	struct dm_verity_fec *f = v->fec;
>  	struct dm_target *ti = v->ti;
> -	u64 hash_blocks;
> +	u64 hash_blocks, fec_blocks;
>  	int ret;
>  
>  	if (!verity_fec_is_enabled(v)) {
> @@ -744,15 +743,17 @@ int verity_fec_ctr(struct dm_verity *v)
>  	}
>  
>  	f->bufio = dm_bufio_client_create(f->dev->bdev,
> -					  1 << v->data_dev_block_bits,
> +					  f->roots << SECTOR_SHIFT,
>  					  1, 0, NULL, NULL);
>  	if (IS_ERR(f->bufio)) {
>  		ti->error = "Cannot initialize FEC bufio client";
>  		return PTR_ERR(f->bufio);
>  	}
>  
> -	if (dm_bufio_get_device_size(f->bufio) <
> -	    ((f->start + f->rounds * f->roots) >> v->data_dev_block_bits)) {
> +	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
> +
> +	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
> +	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
>  		ti->error = "FEC device is too small";
>  		return -E2BIG;
>  	}
> 

--------------C02B9C677A2F9FC6936FF60C
Content-Type: text/x-patch;
 name="0002-dm-verity-fix-FEC-for-RS-roots-unaligned-to-block-si.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0002-dm-verity-fix-FEC-for-RS-roots-unaligned-to-block-si.pa";
 filename*1="tch"

RnJvbSBkZjdiNTliYTkyNDVjNGEzMTE1ZWJhYTkwNWUzZTU3MTlhMzgxMGRhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29t
PgpEYXRlOiBUdWUsIDIzIEZlYiAyMDIxIDIxOjIxOjIxICswMTAwClN1YmplY3Q6IFtQQVRD
SCAyLzJdIGRtIHZlcml0eTogZml4IEZFQyBmb3IgUlMgcm9vdHMgdW5hbGlnbmVkIHRvIGJs
b2NrIHNpemUKTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBj
aGFyc2V0PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCk9wdGlvbmFs
IEZvcndhcmQgRXJyb3IgQ29ycmVjdGlvbiAoRkVDKSBjb2RlIGluIGRtLXZlcml0eSB1c2Vz
ClJlZWQtU29sb21vbiBjb2RlIGFuZCBzaG91bGQgc3VwcG9ydCByb290cyBmcm9tIDIgdG8g
MjQuCgpUaGUgZXJyb3IgY29ycmVjdGlvbiBwYXJpdHkgYnl0ZXMgKG9mIHJvb3RzIGxlbmd0
aHMgcGVyIFJTIGJsb2NrKSBhcmUKc3RvcmVkIG9uIGEgc2VwYXJhdGUgZGV2aWNlIGluIHNl
cXVlbmNlIHdpdGhvdXQgYW55IHBhZGRpbmcuCgpDdXJyZW50bHksIHRvIGFjY2VzcyBGRUMg
ZGV2aWNlLCB0aGUgZG0tdmVyaXR5LWZlYyBjb2RlIHVzZXMgZG0tYnVmaW8KY2xpZW50IHdp
dGggYmxvY2sgc2l6ZSBzZXQgdG8gdmVyaXR5IGRhdGEgYmxvY2sgKHVzdWFsbHkgNDA5NiBv
ciA1MTIKYnl0ZXMpLgoKQmVjYXVzZSB0aGlzIGJsb2NrIHNpemUgaXMgbm90IGRpdmlzaWJs
ZSBieSBzb21lIChtb3N0ISkgb2YgdGhlIHJvb3RzCnN1cHBvcnRlZCBsZW5ndGhzLCBkYXRh
IHJlcGFpciBjYW5ub3Qgd29yayBmb3IgcGFydGlhbGx5IHN0b3JlZCBwYXJpdHkKYnl0ZXMu
CgpUaGlzIGZpeCBjaGFuZ2VzIEZFQyBkZXZpY2UgZG0tYnVmaW8gYmxvY2sgc2l6ZSB0byAi
cm9vdHMgPDwgU0VDVE9SX1NISUZUIgp3aGVyZSB3ZSBjYW4gYmUgc3VyZSB0aGF0IHRoZSBm
dWxsIHBhcml0eSBkYXRhIGlzIGFsd2F5cyBhdmFpbGFibGUuCihUaGVyZSBjYW5ub3QgYmUg
cGFydGlhbCBGRUMgYmxvY2tzIGJlY2F1c2UgcGFyaXR5IG11c3QgY292ZXIgd2hvbGUKc2Vj
dG9ycy4pCgpCZWNhdXNlIHRoZSBvcHRpb25hbCBGRUMgc3RhcnRpbmcgb2Zmc2V0IGNvdWxk
IGJlIHVuYWxpZ25lZCB0byB0aGlzCm5ldyBibG9jayBzaXplLCB3ZSBoYXZlIHRvIHVzZSBk
bV9idWZpb19zZXRfc2VjdG9yX29mZnNldCgpIHRvCmNvbmZpZ3VyZSBpdC4KClRoZSBwcm9i
bGVtIGlzIGVhc2lseSByZXByb2R1Y2VkIHVzaW5nIHZlcml0eXNldHVwLCBlLmcuIGZvciBy
b290cz0xMzoKCiAgIyBjcmVhdGUgdmVyaXR5IGRldmljZSB3aXRoIFJTIEZFQwogIGRkIGlm
PS9kZXYvdXJhbmRvbSBvZj1kYXRhLmltZyBicz00MDk2IGNvdW50PTggc3RhdHVzPW5vbmUK
ICB2ZXJpdHlzZXR1cCBmb3JtYXQgZGF0YS5pbWcgaGFzaC5pbWcgLS1mZWMtZGV2aWNlPWZl
Yy5pbWcgLS1mZWMtcm9vdHM9MTMgfCBhd2sgJy9eUm9vdCBoYXNoL3sgcHJpbnQgJDMgfScg
PnJvb3RoYXNoCgogICMgY3JlYXRlIGFuIGVyYXN1cmUgdGhhdCBzaG91bGQgYmUgYWx3YXlz
IHJlcGFpcmFibGUgd2l0aCB0aGlzIHJvb3RzIHNldHRpbmcKICBkZCBpZj0vZGV2L3plcm8g
b2Y9ZGF0YS5pbWcgY29udj1ub3RydW5jIGJzPTEgY291bnQ9OCBzZWVrPTQwODggc3RhdHVz
PW5vbmUKCiAgIyB0cnkgdG8gcmVhZCBpdCB0aHJvdWdoIGRtLXZlcml0eQogIHZlcml0eXNl
dHVwIG9wZW4gZGF0YS5pbWcgdGVzdCBoYXNoLmltZyAtLWZlYy1kZXZpY2U9ZmVjLmltZyAt
LWZlYy1yb290cz0xMyAkKGNhdCByb290aGFzaCkKICBkZCBpZj0vZGV2L21hcHBlci90ZXN0
IG9mPS9kZXYvbnVsbCBicz00MDk2IHN0YXR1cz1ub3hmZXIKICAjIHdhaXQgZm9yIHBvc3Np
YmxlIHJlY3Vyc2l2ZSByZWNvdmVyeSBpbiBrZXJuZWwKICB1ZGV2YWRtIHNldHRsZQogIHZl
cml0eXNldHVwIGNsb3NlIHRlc3QKCldpdGggdGhpcyBmaXgsIGVycm9ycyBhcmUgcHJvcGVy
bHkgcmVwYWlyZWQuCiAgZGV2aWNlLW1hcHBlcjogdmVyaXR5LWZlYzogNzoxOiBGRUMgMDog
Y29ycmVjdGVkIDggZXJyb3JzCiAgLi4uCgpXaXRob3V0IGl0LCBGRUMgY29kZSB1c3VhbGx5
IGVuZHMgb24gdW5yZWNvdmVyYWJsZSBmYWlsdXJlIGluIFJTIGRlY29kZXI6CiAgZGV2aWNl
LW1hcHBlcjogdmVyaXR5LWZlYzogNzoxOiBGRUMgMDogZmFpbGVkIHRvIGNvcnJlY3Q6IC03
NAogIC4uLgoKVGhpcyBwcm9ibGVtIGlzIHByZXNlbnQgaW4gYWxsIGtlcm5lbHMgc2luY2Ug
dGhlIEZFQyBjb2RlJ3MKaW50cm9kdWN0aW9uIChrZXJuZWwgNC41KS4KCkl0IGlzIHRob3Vn
aHQgdGhhdCB0aGlzIHByb2JsZW0gaXMgbm90IHZpc2libGUgaW4gQW5kcm9pZCBlY29zeXN0
ZW0KYmVjYXVzZSBpdCBhbHdheXMgdXNlcyBhIGRlZmF1bHQgUlMgcm9vdHM9Mi4KCkRlcGVu
ZHMtb246IGExNGU1ZWM2NmE3YSAoImRtIGJ1ZmlvOiBzdWJ0cmFjdCB0aGUgbnVtYmVyIG9m
IGluaXRpYWwgc2VjdG9ycyBpbiBkbV9idWZpb19nZXRfZGV2aWNlX3NpemUiKQpTaWduZWQt
b2ZmLWJ5OiBNaWxhbiBCcm96IDxnbWF6eWxhbmRAZ21haWwuY29tPgpUZXN0ZWQtYnk6IErD
qXLDtG1lIENhcnJldGVybyA8Y0ota29Aem91Z2xvdWIuZXU+ClJldmlld2VkLWJ5OiBTYW1p
IFRvbHZhbmVuIDxzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcgIyA0LjUrClNpZ25lZC1vZmYtYnk6IE1pa2UgU25pdHplciA8c25pdHplckBy
ZWRoYXQuY29tPgotLS0KIGRyaXZlcnMvbWQvZG0tdmVyaXR5LWZlYy5jIHwgICAyMyArKysr
KysrKysrKystLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyks
IDExIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTQuMTkvZHJpdmVycy9tZC9kbS12ZXJp
dHktZmVjLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtNC4xOS5vcmlnL2RyaXZlcnMvbWQv
ZG0tdmVyaXR5LWZlYy5jCTIwMjEtMDMtMDcgMjI6MDc6MjcuMzIxMzkxNDYyICswMTAwCisr
KyBsaW51eC00LjE5L2RyaXZlcnMvbWQvZG0tdmVyaXR5LWZlYy5jCTIwMjEtMDMtMDcgMjI6
MDc6MjcuMzE3MzkxNDgxICswMTAwCkBAIC02NSwxOSArNjUsMTggQEAgc3RhdGljIGludCBm
ZWNfZGVjb2RlX3JzOChzdHJ1Y3QgZG1fdmVyaQogc3RhdGljIHU4ICpmZWNfcmVhZF9wYXJp
dHkoc3RydWN0IGRtX3Zlcml0eSAqdiwgdTY0IHJzYiwgaW50IGluZGV4LAogCQkJICAgdW5z
aWduZWQgKm9mZnNldCwgc3RydWN0IGRtX2J1ZmZlciAqKmJ1ZikKIHsKLQl1NjQgcG9zaXRp
b24sIGJsb2NrOworCXU2NCBwb3NpdGlvbiwgYmxvY2ssIHJlbTsKIAl1OCAqcmVzOwogCiAJ
cG9zaXRpb24gPSAoaW5kZXggKyByc2IpICogdi0+ZmVjLT5yb290czsKLQlibG9jayA9IHBv
c2l0aW9uID4+IHYtPmRhdGFfZGV2X2Jsb2NrX2JpdHM7Ci0JKm9mZnNldCA9ICh1bnNpZ25l
ZCkocG9zaXRpb24gLSAoYmxvY2sgPDwgdi0+ZGF0YV9kZXZfYmxvY2tfYml0cykpOworCWJs
b2NrID0gZGl2NjRfdTY0X3JlbShwb3NpdGlvbiwgdi0+ZmVjLT5yb290cyA8PCBTRUNUT1Jf
U0hJRlQsICZyZW0pOworCSpvZmZzZXQgPSAodW5zaWduZWQpcmVtOwogCi0JcmVzID0gZG1f
YnVmaW9fcmVhZCh2LT5mZWMtPmJ1ZmlvLCB2LT5mZWMtPnN0YXJ0ICsgYmxvY2ssIGJ1Zik7
CisJcmVzID0gZG1fYnVmaW9fcmVhZCh2LT5mZWMtPmJ1ZmlvLCBibG9jaywgYnVmKTsKIAlp
ZiAodW5saWtlbHkoSVNfRVJSKHJlcykpKSB7CiAJCURNRVJSKCIlczogRkVDICVsbHU6IHBh
cml0eSByZWFkIGZhaWxlZCAoYmxvY2sgJWxsdSk6ICVsZCIsCiAJCSAgICAgIHYtPmRhdGFf
ZGV2LT5uYW1lLCAodW5zaWduZWQgbG9uZyBsb25nKXJzYiwKLQkJICAgICAgKHVuc2lnbmVk
IGxvbmcgbG9uZykodi0+ZmVjLT5zdGFydCArIGJsb2NrKSwKLQkJICAgICAgUFRSX0VSUihy
ZXMpKTsKKwkJICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylibG9jaywgUFRSX0VSUihyZXMp
KTsKIAkJKmJ1ZiA9IE5VTEw7CiAJfQogCkBAIC0xNTksNyArMTU4LDcgQEAgc3RhdGljIGlu
dCBmZWNfZGVjb2RlX2J1ZnMoc3RydWN0IGRtX3ZlcgogCiAJCS8qIHJlYWQgdGhlIG5leHQg
YmxvY2sgd2hlbiB3ZSBydW4gb3V0IG9mIHBhcml0eSBieXRlcyAqLwogCQlvZmZzZXQgKz0g
di0+ZmVjLT5yb290czsKLQkJaWYgKG9mZnNldCA+PSAxIDw8IHYtPmRhdGFfZGV2X2Jsb2Nr
X2JpdHMpIHsKKwkJaWYgKG9mZnNldCA+PSB2LT5mZWMtPnJvb3RzIDw8IFNFQ1RPUl9TSElG
VCkgewogCQkJZG1fYnVmaW9fcmVsZWFzZShidWYpOwogCiAJCQlwYXIgPSBmZWNfcmVhZF9w
YXJpdHkodiwgcnNiLCBibG9ja19vZmZzZXQsICZvZmZzZXQsICZidWYpOwpAQCAtNjc1LDcg
KzY3NCw3IEBAIGludCB2ZXJpdHlfZmVjX2N0cihzdHJ1Y3QgZG1fdmVyaXR5ICp2KQogewog
CXN0cnVjdCBkbV92ZXJpdHlfZmVjICpmID0gdi0+ZmVjOwogCXN0cnVjdCBkbV90YXJnZXQg
KnRpID0gdi0+dGk7Ci0JdTY0IGhhc2hfYmxvY2tzOworCXU2NCBoYXNoX2Jsb2NrcywgZmVj
X2Jsb2NrczsKIAlpbnQgcmV0OwogCiAJaWYgKCF2ZXJpdHlfZmVjX2lzX2VuYWJsZWQodikp
IHsKQEAgLTc0NSwxNSArNzQ0LDE3IEBAIGludCB2ZXJpdHlfZmVjX2N0cihzdHJ1Y3QgZG1f
dmVyaXR5ICp2KQogCX0KIAogCWYtPmJ1ZmlvID0gZG1fYnVmaW9fY2xpZW50X2NyZWF0ZShm
LT5kZXYtPmJkZXYsCi0JCQkJCSAgMSA8PCB2LT5kYXRhX2Rldl9ibG9ja19iaXRzLAorCQkJ
CQkgIGYtPnJvb3RzIDw8IFNFQ1RPUl9TSElGVCwKIAkJCQkJICAxLCAwLCBOVUxMLCBOVUxM
KTsKIAlpZiAoSVNfRVJSKGYtPmJ1ZmlvKSkgewogCQl0aS0+ZXJyb3IgPSAiQ2Fubm90IGlu
aXRpYWxpemUgRkVDIGJ1ZmlvIGNsaWVudCI7CiAJCXJldHVybiBQVFJfRVJSKGYtPmJ1Zmlv
KTsKIAl9CiAKLQlpZiAoZG1fYnVmaW9fZ2V0X2RldmljZV9zaXplKGYtPmJ1ZmlvKSA8Ci0J
ICAgICgoZi0+c3RhcnQgKyBmLT5yb3VuZHMgKiBmLT5yb290cykgPj4gdi0+ZGF0YV9kZXZf
YmxvY2tfYml0cykpIHsKKwlkbV9idWZpb19zZXRfc2VjdG9yX29mZnNldChmLT5idWZpbywg
Zi0+c3RhcnQgPDwgKHYtPmRhdGFfZGV2X2Jsb2NrX2JpdHMgLSBTRUNUT1JfU0hJRlQpKTsK
KworCWZlY19ibG9ja3MgPSBkaXY2NF91NjQoZi0+cm91bmRzICogZi0+cm9vdHMsIHYtPmZl
Yy0+cm9vdHMgPDwgU0VDVE9SX1NISUZUKTsKKwlpZiAoZG1fYnVmaW9fZ2V0X2RldmljZV9z
aXplKGYtPmJ1ZmlvKSA8IGZlY19ibG9ja3MpIHsKIAkJdGktPmVycm9yID0gIkZFQyBkZXZp
Y2UgaXMgdG9vIHNtYWxsIjsKIAkJcmV0dXJuIC1FMkJJRzsKIAl9Cg==
--------------C02B9C677A2F9FC6936FF60C--

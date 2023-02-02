Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD1C6884D4
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 17:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjBBQwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 11:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbjBBQwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 11:52:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025B56DFFE
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 08:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675356685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JTzAWBEi5HSO9Co7j9eqLuzQVPsmDG7KdLe0XlcpLzA=;
        b=FZoAtLQlSkbZFuc1znEA8swY1JHzKm2msc/ELekFhcRqucDklMyTMhUhMLjIPDNeU4tmTp
        9xPyx0oe/mhA0wpc8vkauCxsIdHJKLwf8yjDZKC+1okpg+r4oQAuekKimzeA50XbLG70uR
        9zWe/eFh+scNdGwpRBSgGgtAlZ9ov6Y=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620--4NqKZscN8moVVC20qt4Qg-1; Thu, 02 Feb 2023 11:51:16 -0500
X-MC-Unique: -4NqKZscN8moVVC20qt4Qg-1
Received: by mail-qk1-f199.google.com with SMTP id u10-20020a05620a0c4a00b00705e77d6207so1634648qki.5
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 08:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JTzAWBEi5HSO9Co7j9eqLuzQVPsmDG7KdLe0XlcpLzA=;
        b=i3nokl7RCcdckyDGfTkafmuJ8RobWB7Rh6SxKVBAN1rKMs1tLg83YSfdJ324Ldo7ze
         V7yTCFodXVxm90Qf/SUXjB5KmF3SI+qqs5V+hiaxwxBaAIgKuyGnNQhdp7SLcshX0GlI
         BXJrfirTzMIRJ+WODdTBG3cCkLOMr5Fm25rlGfQAEp447KHnxFZaC7+BAlKv2jMbeUmd
         F1OV4fdfGlePXwPmWjfeCnmkzM39GG9f4ai0hgZ/3gF+Qi3xgGF9Z9JsqQHJSSoPQy2F
         hL23k7acauE4Fv0efaq6fCOWMR5BpGSa1Q6k2kErYO1IzM3V34EBWFFjSDb97ATAAQk9
         Z0TA==
X-Gm-Message-State: AO0yUKWvLvpaB7LXfDTSJkji4gTkuJpbCC1tuhsCY4Ez9QqXt09vCRAt
        cTSEAw0VH1jVCbpZD2RT/9Vfh/UFuyys9z19+aWy1xAKp7AWOZt3lLYdfvggujWTpJocN05ks7u
        KWeaxbkotAbKRFj3BzTlX7Hbf1o59+tvy
X-Received: by 2002:ac8:5bcb:0:b0:3b8:4aed:5e35 with SMTP id b11-20020ac85bcb000000b003b84aed5e35mr755703qtb.377.1675356675868;
        Thu, 02 Feb 2023 08:51:15 -0800 (PST)
X-Google-Smtp-Source: AK7set9CdlG5MCbspTLzaIYSjOuDOOu9+Li9sUJHoDTil1GB7T0FTEtXJ34q3qGH8hAtfqWNRKuEkLMS14ckMfg0JSQ=
X-Received: by 2002:ac8:5bcb:0:b0:3b8:4aed:5e35 with SMTP id
 b11-20020ac85bcb000000b003b84aed5e35mr755698qtb.377.1675356675572; Thu, 02
 Feb 2023 08:51:15 -0800 (PST)
MIME-Version: 1.0
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
In-Reply-To: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Thu, 2 Feb 2023 17:51:04 +0100
Message-ID: <CAMusb+TdiP=RJ_gQ0K8Wx1_6MoNBfb=7QUrvEeJcF3G45Yo-aA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Fiona Trahe <fiona.trahe@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 Hi, Giovanni, all,

On Wed, Feb 1, 2023 at 4:59 PM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> When preparing an AER-CTR request, the driver copies the key provided by
> the user into a data structure that is accessible by the firmware.
> If the target device is QAT GEN4, the key size is rounded up by 16 since
> a rounded up size is expected by the device.
> If the key size is rounded up before the copy, the size used for copying
> the key might be bigger than the size of the region containing the key,
> causing an out-of-bounds read.
>
> Fix by doing the copy first and then update the keylen.
>
> This is to fix the following warning reported by KASAN:
>
>         [  138.150574] BUG: KASAN: global-out-of-bounds in qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
>         [  138.150641] Read of size 32 at addr ffffffff88c402c0 by task cryptomgr_test/2340
>
>         [  138.150651] CPU: 15 PID: 2340 Comm: cryptomgr_test Not tainted 6.2.0-rc1+ #45
>         [  138.150659] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0087.D13.2208261706 08/26/2022
>         [  138.150663] Call Trace:
>         [  138.150668]  <TASK>
>         [  138.150922]  kasan_check_range+0x13a/0x1c0
>         [  138.150931]  memcpy+0x1f/0x60
>         [  138.150940]  qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
>         [  138.151006]  qat_alg_skcipher_init_sessions+0xc1/0x240 [intel_qat]
>         [  138.151073]  crypto_skcipher_setkey+0x82/0x160
>         [  138.151085]  ? prepare_keybuf+0xa2/0xd0
>         [  138.151095]  test_skcipher_vec_cfg+0x2b8/0x800
>
> Fixes: 67916c951689 ("crypto: qat - add AES-CTR support for QAT GEN4 devices")
> Cc: <stable@vger.kernel.org>
> Reported-by: Vladis Dronov <vdronov@redhat.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
> index b4b9f0aa59b9..b61ada559158 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -435,8 +435,8 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
>         } else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
>                 ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
>                                              ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
> -               keylen = round_up(keylen, 16);
>                 memcpy(cd->ucs_aes.key, key, keylen);
> +               keylen = round_up(keylen, 16);
>         } else {
>                 memcpy(cd->aes.key, key, keylen);
>         }
> --
> 2.39.1
>

Thanks, the fix seems to be working. It was tested on "Intel(R) Xeon(R)
Platinum 8468H / Sapphire Rapids 4 skt (SPR) XCC-SP, Qual E-3
stepping" machine with 8086:4940 (rev 40) QAT device:

Without the fix:

# dmesg | grep KASAN
[  142.612847] BUG: KASAN: global-out-of-bounds in
qat_alg_skcipher_init_com.isra.0+0x2fe/0x440 [intel_qat]

With the fix:

# dmesg | grep KASAN
<no output>

So,

Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Tested-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer


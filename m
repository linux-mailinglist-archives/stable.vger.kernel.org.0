Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC75BE734
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 15:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiITNf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 09:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiITNfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 09:35:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632835AA14
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 06:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663680940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9x8e5qkUjMznghkBDdwOcBCIS07P7DOG6g3UpXG3akw=;
        b=FovKiBKRrZqadHVPBg5bToCjtKpt1vWKXoHexe5/qwyaCyZL2M5WygPcz8rZ8biwqZEDp+
        YxUo1o0DVT3fvBu+7CLk/HYVKFupKyhGZSOq3nrPUB3gm//dZT1GPhCtszYm6aDhHkuN85
        pIdZ4o+jMqURa5W/gu1JtiDKjtErL3U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-FHIuKzQrN3um1tDoIQ_c3A-1; Tue, 20 Sep 2022 09:35:39 -0400
X-MC-Unique: FHIuKzQrN3um1tDoIQ_c3A-1
Received: by mail-pj1-f72.google.com with SMTP id il18-20020a17090b165200b002038e81ee7dso3862101pjb.4
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 06:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9x8e5qkUjMznghkBDdwOcBCIS07P7DOG6g3UpXG3akw=;
        b=jV7cjmDnCt+MjEuO4y9UYxInFcHaB6SSrbclMkCyz6wxQ92GBcwt3PXI4mRMxr4+o8
         0I3dLomwCuzRdGgMhisxzd68+rxH18LfXK9T2yGl4hljPW6WrShmN5f7tqly0lort9fi
         f8LjZDylWjbWI8NdnSNFPn7JsYqm0eN7WkVUfmAGNKJpaUvqfxLFa9/cR+m6odWNA3Qu
         jzzxZ1b0GJ56Zq426DrUGmdudVlj4Q6gvGPoqYHFgJ8TScPGrzW9IKNU4/Cd1xZVYgc+
         vDgnY6WHXLIJV71H5qDGiRAWltvHhgzYQBCfUGTkSlHCrvhrT1VOLSOqhSyv+b1pmUuI
         Br/A==
X-Gm-Message-State: ACrzQf20yPf6nm+JHIoWFaxlpu8OvMDqGox1mZcwzl6eLNkdn4RvybZU
        bBlBkY4KumN9ersYpGE4/sQadoi21XsYjaydyvZ7ApaUXHBFFz7c+0RXk5ojBF3r/wACNsy4F2e
        vj+lvxkZo8MY3SEHxExC2mGgMNVzCwuge
X-Received: by 2002:a17:90a:f28b:b0:203:627c:7ba1 with SMTP id fs11-20020a17090af28b00b00203627c7ba1mr4026011pjb.191.1663680937964;
        Tue, 20 Sep 2022 06:35:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4zTvy/bDvHyBrE+JUUsKur2adqFplid6MucMFNyIBVKKvLas2J1c7TNrnt2m4PiaCFrmunxu8S0yD35UFJ7tc=
X-Received: by 2002:a17:90a:f28b:b0:203:627c:7ba1 with SMTP id
 fs11-20020a17090af28b00b00203627c7ba1mr4025983pjb.191.1663680937706; Tue, 20
 Sep 2022 06:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220907150159.2285460-1-andri@yngvason.is>
In-Reply-To: <20220907150159.2285460-1-andri@yngvason.is>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 20 Sep 2022 15:35:26 +0200
Message-ID: <CAO-hwJLAxcBB9sDHeQMZKDdbHpkz6L3vZX9f0pmg_moeRuvX6A@mail.gmail.com>
Subject: Re: [PATCH v3 RESEND] HID: multitouch: Add memory barriers
To:     Andri Yngvason <andri@yngvason.is>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 7, 2022 at 5:02 PM Andri Yngvason <andri@yngvason.is> wrote:
>
> This fixes broken atomic checks which cause a race between the
> release-timer and processing of hid input.
>
> I noticed that contacts were sometimes sticking, even with the "sticky
> fingers" quirk enabled. This fixes that problem.
>
> Cc: stable@vger.kernel.org
> Fixes: 9609827458c3 ("HID: multitouch: optimize the sticky fingers timer")
> Signed-off-by: Andri Yngvason <andri@yngvason.is>
> ---

Applied to for-6.1/multitouch in hid.git

Sorry for the delay

Cheers,
Benjamin

>  V1 -> V2: Clarified where the race is and added Fixes tag as suggested
>            by Greg KH
>  V2 -> V3: Fix formatting of "Fixes" tag
>
>  drivers/hid/hid-multitouch.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 2e72922e36f5..91a4d3fc30e0 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -1186,7 +1186,7 @@ static void mt_touch_report(struct hid_device *hid,
>         int contact_count = -1;
>
>         /* sticky fingers release in progress, abort */
> -       if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
> +       if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
>                 return;
>
>         scantime = *app->scantime;
> @@ -1267,7 +1267,7 @@ static void mt_touch_report(struct hid_device *hid,
>                         del_timer(&td->release_timer);
>         }
>
> -       clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
> +       clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
>  }
>
>  static int mt_touch_input_configured(struct hid_device *hdev,
> @@ -1699,11 +1699,11 @@ static void mt_expired_timeout(struct timer_list *t)
>          * An input report came in just before we release the sticky fingers,
>          * it will take care of the sticky fingers.
>          */
> -       if (test_and_set_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
> +       if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))
>                 return;
>         if (test_bit(MT_IO_FLAGS_PENDING_SLOTS, &td->mt_io_flags))
>                 mt_release_contacts(hdev);
> -       clear_bit(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
> +       clear_bit_unlock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags);
>  }
>
>  static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
> --
> 2.37.2
>


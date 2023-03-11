Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305A76B5CDD
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjCKOc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjCKOc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:32:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F869AA33
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 06:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678545097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=INJDANEQXKU0xsqosQ//yXFvq7T3jrX3e/2hzObW3f0=;
        b=UkVipt7PZRH462cG6spyww3FgGx6rXpo6Vt0990nFxH51oIOthDS1sAAWSzoywK9A9mHT+
        sYcwNen/T3AVyCxvFc1ZVoADnRwMXJCQddONJAYQbvSuAigjH6aU8RNLGQTP/DXZ7QAtim
        eOW58E9AcYjUWkZFKz+LCr5t0Mkis6k=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-v2SXwpuIOq2IJi8GxcH77w-1; Sat, 11 Mar 2023 09:31:33 -0500
X-MC-Unique: v2SXwpuIOq2IJi8GxcH77w-1
Received: by mail-ua1-f70.google.com with SMTP id p17-20020ab06251000000b006915fe92421so3720605uao.11
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 06:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678545093;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INJDANEQXKU0xsqosQ//yXFvq7T3jrX3e/2hzObW3f0=;
        b=W7AeNha1iv4J5aRgbKO2V/6Mgb15cgP9RQuXRyM+RT31SEMZ8bbmcfyWkjRnpWCZ3J
         e6kvZya56OJTkWcjLtuQm5dmYw/QfrCOvTd/bE3H5K2fcbXbHw/yZOciG/jfbMyG6TQx
         cxGExyZMQzD/kXsNvpHdegQCCVk3IfYrijMCL7cIlDteE/uqaDHTxpR8dCE33uSjTZ2e
         bh+c5inYs0FYCu1/GsP5iUBW1finh4PqKW4WRdDmB8rxeu9lwh4/rszZ/k5FnxqAIHAH
         9VsXwEBOOab9ipikkWijbr7I8wtN6sHDiVEyohNCyMM9wPLA3gqPuykT34xy52TUOssl
         Pwww==
X-Gm-Message-State: AO0yUKUB4gtqH1gcAIeKxAWc9tPs03fiXFe9sdeg7zcTjgaDNvmNn1V0
        uTsXeT14v99wGWzdSrSyZxXgIA8YLKdJV3OsbMS/PzognFOiA6Bb6zPQIq1BgVqy8kEeoZ7WyJ3
        ortQpyuPbuRfl/gRmdNLwKrM1FLrPezNQ
X-Received: by 2002:a1f:4358:0:b0:429:73a8:6dba with SMTP id q85-20020a1f4358000000b0042973a86dbamr12974015vka.0.1678545093455;
        Sat, 11 Mar 2023 06:31:33 -0800 (PST)
X-Google-Smtp-Source: AK7set8zoROtzVyy3knl/9H3DfJsJJvBDGmhfiN880HUo8QG4OZ5lUIyateA8pR1NXbwisLQVNcIStUvBVgL1TdBOy0=
X-Received: by 2002:a1f:4358:0:b0:429:73a8:6dba with SMTP id
 q85-20020a1f4358000000b0042973a86dbamr12974004vka.0.1678545093176; Sat, 11
 Mar 2023 06:31:33 -0800 (PST)
MIME-Version: 1.0
References: <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st> <20230311141914.24444-1-marcan@marcan.st>
In-Reply-To: <20230311141914.24444-1-marcan@marcan.st>
From:   Eric Curtin <ecurtin@redhat.com>
Date:   Sat, 11 Mar 2023 14:31:17 +0000
Message-ID: <CAOgh=Fw7ULhH0PrANYHwqz504SMfNfooUBBjaU03e8L2uhuzPg@mail.gmail.com>
Subject: Re: [PATCH] wifi: cfg80211: Partial revert "wifi: cfg80211: Fix use
 after free for wext"
To:     Hector Martin <marcan@marcan.st>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        Ilya <me@0upti.me>, Janne Grunau <j@jannau.net>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, asahi@lists.linux.dev
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

On Sat, 11 Mar 2023 at 14:28, Hector Martin <marcan@marcan.st> wrote:
>
> This reverts part of commit 015b8cc5e7c4 ("wifi: cfg80211: Fix use after
> free for wext")
>
> This commit broke WPA offload by unconditionally clearing the crypto
> modes for non-WEP connections. Drop that part of the patch.
>
> Fixes: 015b8cc5e7c4 ("wifi: cfg80211: Fix use after free for wext")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-wireless/ZAx0TWRBlGfv7pNl@kroah.com/T/#m11e6e0915ab8fa19ce8bc9695ab288c0fe018edf
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Eric Curtin <ecurtin@redhat.com>

Is mise le meas/Regards,

Eric Curtin

> ---
>  net/wireless/sme.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 28ce13840a88..7bdeb8eea92d 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -1500,8 +1500,6 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
>                 connect->key = NULL;
>                 connect->key_len = 0;
>                 connect->key_idx = 0;
> -               connect->crypto.cipher_group = 0;
> -               connect->crypto.n_ciphers_pairwise = 0;
>         }
>
>         wdev->connect_keys = connkeys;
> --
> 2.35.1
>
>


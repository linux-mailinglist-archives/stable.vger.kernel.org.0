Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525994ECE9F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 23:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347216AbiC3VRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 17:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344344AbiC3VRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 17:17:40 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7487D58834
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:15:54 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y10so25926540edv.7
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 14:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s9G70I/zaybCNjMBuuh48NsQh+RQ1aOHxWfcOdS61NU=;
        b=dAD9ZiAYhN9sRAbOvEwtAfZoYaVGY7JhtrvE1XXU/1EyI5/2eySDpZRBKVDJ9S5FxM
         CbQ8rNM9kUCWaEn9N8sKxrwV/66j8r2ScFXW5BkCLsP30CXHUb42V/guKom3xLbpEhLq
         AeRl2Fa8CYE/ezROk0HeypXg3hBPAtou9TU8tZl3vPrQtgoIytTNAxYpWyiCKua94TZO
         Qa1AbJJsIcu2VLWb/QlVY5YuNQpUOod32dACG8pVCk4qDpQw3SBQoaORHMNhSfRNWIKp
         MSX1OM3Q2S2WKjSmDu1/Nm1tI1CHvhUmp0Zg/gu8wx5cdzrVQUVrBZnQU8qGZV4C6z5d
         8CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s9G70I/zaybCNjMBuuh48NsQh+RQ1aOHxWfcOdS61NU=;
        b=oYzj92HPb1za3YNctLbHIJEj2+vcmUCDFDkbknlz3z6WjQoO936CGJiTxe4a9jl4ak
         eGJaepmO1TwjHY5LbaaqjjfubceFRofRbQJweNMX3tZkk/Q6fNUdtw1WRulttKkgdtNE
         yjDHmUXfCqXTwACe2a6Jd7tiAonimySJA/G0Zldp30Xa0i9Lmz6jm2CP3jz9mVJfxu9k
         J/NBzCs2EVGHn33LW6Z39B4BcvF5BtuhWWunjj7M/y8JN+x1JEG/X8pF13YtRtUqV2i6
         S2Vs364Ag6j/RrdKbdEnI5fzv+6jRMaTrMiPfZ58MpYF2P6Uxz2sid0azUkZ9YkekDKp
         KmDA==
X-Gm-Message-State: AOAM532dGdBiwQ6Ew7wQl7HTifMZ9mETkPT4cZ+OM7Z0ghhwHGogqyyS
        ZziTDuHliPM90CJNwJ6PvnJlH00HZP60AaT0IUB1PVpiRVFIjKLn
X-Google-Smtp-Source: ABdhPJzotdy5WD9IEM0NjSzWI43oD8oq2eMhwpCm8Fr7a989ll6T5wNNpw0hbIvE1GUdnz+4pkLezlhNZkZbTTt4tkM=
X-Received: by 2002:a05:6402:254e:b0:418:e716:f987 with SMTP id
 l14-20020a056402254e00b00418e716f987mr13079947edb.74.1648674952841; Wed, 30
 Mar 2022 14:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220330205543.2064615-1-wonchung@google.com>
In-Reply-To: <20220330205543.2064615-1-wonchung@google.com>
From:   Won Chung <wonchung@google.com>
Date:   Wed, 30 Mar 2022 14:15:40 -0700
Message-ID: <CAOvb9yivq8mEQCqKf0VynuEcAPo3-ZZ6YHyrH+vbwoJ0osY+JQ@mail.gmail.com>
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback function
To:     Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@google.com>,
        Prashant Malani <pmalani@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 1:55 PM Won Chung <wonchung@google.com> wrote:
>
> Component match callback function needs to check if expected data is
> passed to it. Without this check, it can cause a NULL pointer
> dereference when another driver registers a component before i915
> drivers have their component master fully bind.
>
> Fixes: 7b882fe3e3e8b ("ALSA: hda - handle multiple i915 device instances")
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Won Chung <wonchung@google.com>
> ---
> - Add "Fixes" tag
> - Send to stable@vger.kernel.org
>
>  sound/hda/hdac_i915.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/sound/hda/hdac_i915.c b/sound/hda/hdac_i915.c
> index efe810af28c5..958b0975fa40 100644
> --- a/sound/hda/hdac_i915.c
> +++ b/sound/hda/hdac_i915.c
> @@ -102,13 +102,13 @@ static int i915_component_master_match(struct device *dev, int subcomponent,
>         struct pci_dev *hdac_pci, *i915_pci;
>         struct hdac_bus *bus = data;
>
> -       if (!dev_is_pci(dev))
> +       if (!dev_is_pci(dev) || !bus)
>                 return 0;
>
>         hdac_pci = to_pci_dev(bus->dev);
>         i915_pci = to_pci_dev(dev);
>
> -       if (!strcmp(dev->driver->name, "i915") &&
> +       if (dev->driver && !strcmp(dev->driver->name, "i915") &&
>             subcomponent == I915_COMPONENT_AUDIO &&
>             connectivity_check(i915_pci, hdac_pci))
>                 return 1;
> --
> 2.35.1.1021.g381101b075-goog
>

Hi,

I am resending this patch to correct email accounts.
Sorry for confusion.

Thanks,
Won

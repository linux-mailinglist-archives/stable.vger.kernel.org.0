Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A656A5677
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 11:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjB1KQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 05:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjB1KQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 05:16:17 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37A9211C0
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:16:15 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5384ff97993so257763857b3.2
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t0sXz6BDCiLwEh1KNvjDfulCrcyBO1PDElpdqHBu3EE=;
        b=Vbd8nzOB1jWXhXCvUpZz82Ixn8nHCHrxEjzhuZp9ZOXcDhoi1fahpRBt8i+MPria0m
         Pcne771BCZCK7gLanf22ojjMBfkyfUe71SCbecg35MYIYMdqv5a8ngPNzTAwB+8XV2rG
         flb7Dtnf7QIXZPCFTsso9vjc76rEwA9EogpMVKhpma++SvCW2qIF3Os3XG3LI98RfOQU
         aMJEpRESgFKCGgk/rHnJa04zATzuDspYG49ycS7PsEOXvzaJGDraIkthzBgWcEdqT+k7
         xZAkWh+UTWVpkx97qKc9s0xBfgcrNjJLq7vpeQF9f1E5uIhg0xyzbNDEIndvD9Ec4Wj2
         pbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t0sXz6BDCiLwEh1KNvjDfulCrcyBO1PDElpdqHBu3EE=;
        b=kW5uMsYeu8OECFOKpHeVXUaLFPM+kRFrseWh1LRUlV046dtrP1dTFB5Wqmv7QsCybS
         go7XBaGUMrVMu4ONvW4f7Ss44WtCEDfQ7K2bsNwFH0eS/BMWKijr1RT3abZyri8vLZ2A
         G5KOQDoK1NoycUyxG+/7bV28n6D5WB91vgLrQvv8ctip2XBRuxaezndLqNsmOH1tAml9
         BKEYY9OuH8EzbkXQAruJHLR5ET6kcb2vsG9dZnvBsesVpWhaDbp8ZxD+tsXWpL65dYBb
         7ASiuwHJFKG6jIERQ3Can8OWCqEuBNQMdwEfUXW4ASe0yC2CdzAdpfH/5CZGDJuXFQzu
         ot3g==
X-Gm-Message-State: AO0yUKXje6IW7cFuaE/BSpy4bkbwF9fUpncwULsX2BjVpFmZJwOZqdD2
        NlhY/AFmbFWGr8E9GKdLBgtADgosDpLr7EdySAfmXLsGC9A=
X-Google-Smtp-Source: AK7set9M/7GFtkfNMqU6LCmrYJ83fpM/YH7yUF1e6LQ4tVN1TdJqH1dzAneZald4aqZ8X2JtzCk68vix9zHXauCaqtc=
X-Received: by 2002:a5b:a0f:0:b0:a0d:8150:bed5 with SMTP id
 k15-20020a5b0a0f000000b00a0d8150bed5mr1089698ybq.3.1677579374871; Tue, 28 Feb
 2023 02:16:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:a309:b0:480:bd65:1f87 with HTTP; Tue, 28 Feb 2023
 02:16:14 -0800 (PST)
In-Reply-To: <Y/27PBzfeRNEhWnA@kroah.com>
References: <CAPge7ycxEpms_wQoDoCncz743N2BfzVCZPLmbHCVTs6ZKSp=nA@mail.gmail.com>
 <Y/27PBzfeRNEhWnA@kroah.com>
From:   =?UTF-8?B?546L5piK54S2?= <msl0000023508@gmail.com>
Date:   Tue, 28 Feb 2023 18:16:14 +0800
Message-ID: <CAPge7yekNA633CiWbCftS5GRHTzYAMeraOmKKSMZL=5GdWzqfw@mail.gmail.com>
Subject: Re: Symbol cpu_feature_keys should be exported to all modules on powerpc
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2023-02-28 16:28 GMT+08:00, Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Feb 28, 2023 at 04:18:12PM +0800, =E7=8E=8B=E6=98=8A=E7=84=B6 wro=
te:
>> Just like symbol 'mmu_feature_keys'[1], 'cpu_feature_keys' was reference=
d
>> indirectly by many inline functions; any GPL-incompatible modules using
>> such
>> a function will be potentially broken due to 'cpu_feature_keys' being
>> exported as GPL-only.
>>
>> For example it still breaks ZFS, see
>> https://github.com/openzfs/zfs/issues/14545
>>
>> [1]:
>> https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220329085709.4=
132729-1-haokexin@gmail.com/
>
> External modules are always on their own, sorry.  Especially ones that
> are not released under the GPL.
>
> good luck!
>
> greg k-h
>

Some inline functions are just powerpc implementation of some generic KPIs,
such as flush_dcache_page, which indirectly references 'cpu_feature_keys' i=
n
powerpc-specific code; this essentially makes 'flush_dcache_page' GPL-only =
in
Linux powerpc, but not in other architectures.

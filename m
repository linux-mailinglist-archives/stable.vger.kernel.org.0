Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CC86A566E
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 11:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjB1KO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 05:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjB1KOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 05:14:48 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708F012F3A
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:14:41 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536c02eea4dso257370537b3.4
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 02:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdiVHeLJmPipKwbnev6rYifxgPcAVJ5LNE0F+64LtHw=;
        b=ArgXO9B6HItihOgNqDyRQpCC8X9gj9Z+ZO0vplqQFaazKwzfswF/FhWK98axHmflcJ
         DX8mg3lmmcQRVCuFdgObr2NSRURNARLnjvutXgxB2JFw/P0+ffGotzkmHKZk0fLarcHY
         WpbxliiQyd4lVzQbtFOgeP4IVDEinvOOqABSueFkj/jE8G1sPNWf2yuHAr769npycnAl
         GMYvg2POaFTUPzGIN2kHH/4xrk8ZxqaYEYbufFfxmvNeAI4/YaePFTQHsEDAzdKTi0Wv
         nd1oMhbPnCb140JU1ixBTsGDDXhlwcOZSHQrpa95IX6mYBWRYcxnu0C0lPp8IThY08v3
         rZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdiVHeLJmPipKwbnev6rYifxgPcAVJ5LNE0F+64LtHw=;
        b=rRdQZh6UHAKIAg7nBwUg7PgDO0ZPCPnerJDPYakjU5Rk1OInP/NKffx6tiCE4ZjDeZ
         l+GJOWpUD176Gro1jYIgmK0ep+nym/SIWc1FZ+SaWuoz1J1xaFOzhjMUbpTnhCgi0bsA
         DN38ZvMPzcW3IUdmUZ9cgGpfsCL2LbpSIsBsl72ly5BBAlJWDTuoiv2OF64MyQkL9xps
         MZfADuzX3wv0m+VxBZ0VByjNfv8xyoEcBJ3DSmJxU1cuxqRfz95qE/EcFeCSR4t4g6S1
         8lWlpzaUEGyekg7995hZsK9ODiU0rJfBi1Ops/PWz1FTCGf8g4/K46gkjTftdRyY0hYi
         oAlg==
X-Gm-Message-State: AO0yUKVUrf0U5JJzgtBrh3l3FV9daSV06czbfGnBBL2YSQlIile20n/a
        Sx1GwlX0vj7Sm/zi6UIfqyBrrEMpjjLDODs5UlyKylptLFY=
X-Google-Smtp-Source: AK7set9z2GcQY+PK0yKuxiPsbmNsQhUOUpcH2qDIbOvH1rSN0k2FUQJrJzOKypjtf29bN3CAQm4bKzT5gW2HsLjHmug=
X-Received: by 2002:a05:690c:f0d:b0:52e:e8b1:d51e with SMTP id
 dc13-20020a05690c0f0d00b0052ee8b1d51emr2606204ywb.1.1677579280631; Tue, 28
 Feb 2023 02:14:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7000:a309:b0:480:bd65:1f87 with HTTP; Tue, 28 Feb 2023
 02:14:39 -0800 (PST)
In-Reply-To: <Y/27PBzfeRNEhWnA@kroah.com>
References: <CAPge7ycxEpms_wQoDoCncz743N2BfzVCZPLmbHCVTs6ZKSp=nA@mail.gmail.com>
 <Y/27PBzfeRNEhWnA@kroah.com>
From:   =?UTF-8?B?546L5piK54S2?= <msl0000023508@gmail.com>
Date:   Tue, 28 Feb 2023 18:14:39 +0800
Message-ID: <CAPge7yd8-A1+7TF6s_Oo_AOi0ZJoUGs7D6y_zT0P4F_CwWbFhg@mail.gmail.com>
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
Linux powerpc.
Some inline functions are just powerpc implementati

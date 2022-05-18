Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A855852B1FB
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 07:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiERFzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 01:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiERFzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 01:55:15 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1EE44A2E
        for <stable@vger.kernel.org>; Tue, 17 May 2022 22:55:14 -0700 (PDT)
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 43E1F3F207
        for <stable@vger.kernel.org>; Wed, 18 May 2022 05:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1652853312;
        bh=7QzVvRPT9zcHwwbvlE1BZS1PhfbxonREGh377KbSmmo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=s/vOlIlCeC0dPlfn60Z1ajYuJhNf7Ds32AbnbUwDTrvxPnVuOb6BVIb+jKOgWvwTt
         8jsN15XAFst0ZrVU6XMd9w1rn6WqfOKHkC16lXcGljN7vnKe0kX0p/c50RFofAvO1p
         ZoI7bbWxlhWYFul7fTONu8mdYI0gk/yoTlMMT5qMmnMAoqLUf61f+uKoELuK4T+Seh
         RMqEFm0SzOTCbHlT3bfPaQavj0VrqYORju8+eXTntCoBfl3jOChxWAFi/QdYgC+esX
         UN9E/5nHLnKodXa9+VDRqPA7TYSWrmm0niAGjD+fDZdDU/EWamxu+HGiTt36uuxH2F
         aNOk0HgTcHFQA==
Received: by mail-oo1-f71.google.com with SMTP id k2-20020a4aa5c2000000b0035e9926bc1bso665917oom.1
        for <stable@vger.kernel.org>; Tue, 17 May 2022 22:55:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7QzVvRPT9zcHwwbvlE1BZS1PhfbxonREGh377KbSmmo=;
        b=QdD+zUvX7pCbfbUrmPHQimNECbPe39ckWbaE/legZvSjGDkVBQtIjxQYiyIN9HtcTR
         /QF1MLgJDzvsKb2LC3sAOSBFNwzXMrVI3D9Hq7T39SARYB9wACVkCHo7AsNpUkCi8QfV
         GbRGdXdILsEPhNpMLv9TYlLd85MhJfl4Mnm/VzNGQlhkBZKxBY3+8SH7lx9geBI9x13P
         FPB3y1z/xhS2nugwvAaFBmxQSmbSkHx3QxIn/zyA7BZp0UY2TdnZprx97pucAbt7x2f6
         QJqnTihQ4XUMVg62p6b1wll2dNGSqpFPE+W/N9K4WM6onFQ5ML1oiGdR2aZwHhrjTFZ+
         heAg==
X-Gm-Message-State: AOAM5335KocEm/mg3Hz0prwEiiKCuhNGq4RqjE2I8yFQg6J0nER9gkw9
        uhPBgBxFx5y+bbjqOZ4lDmt0ro6xRSy+lZBcrBQfuBwycsFD368q/yya2atAquoVDYhsakPMXPD
        1/Mgc9hw6t/7q7GKrweWf9YP1/JWPzno2VSh59SISfCNyLR80jw==
X-Received: by 2002:a05:6808:1441:b0:328:af9e:5540 with SMTP id x1-20020a056808144100b00328af9e5540mr12372831oiv.42.1652853311164;
        Tue, 17 May 2022 22:55:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVpJ1/BBEpcSQaygPxyD32x52i7qeqG7wwqzTjFQkpxGvWl5Z9noxcBBU53YMpGpzjNmG6aPHbXHWHVRb7gUo=
X-Received: by 2002:a05:6808:1441:b0:328:af9e:5540 with SMTP id
 x1-20020a056808144100b00328af9e5540mr12372824oiv.42.1652853310886; Tue, 17
 May 2022 22:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <4c8afdd6-3573-619d-d46c-e13a4fdd9ac7@leemhuis.info>
In-Reply-To: <4c8afdd6-3573-619d-d46c-e13a4fdd9ac7@leemhuis.info>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 18 May 2022 13:54:59 +0800
Message-ID: <CAAd53p4ddFYE+O6Je8z9XDy54nTiODJsQEn7PncZ95K_PXPtPQ@mail.gmail.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     casteyde.christian@free.fr, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
>
> > I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0da
> > ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"), and
> > the problem disappears so it's really this commit that breaks.
>
> In that case I'll update the regzbot status to make sure it's visible as
> regression introduced in the 5.18 cycle:
>
> #regzbot introduced: 887f75cfd0da
>
> BTW: obviously would be nice to get this fixed before 5.18 is released
> (which might already happen on Sunday), especially as the culprit
> apparently was already backported to stable, but I guess that won't be
> easy...
>
> Which made me wondering: is reverting the culprit temporarily in
> mainline (and reapplying it later with a fix) a option here?

It's too soon to call it's the culprit. The suspend on the system
doesn't work properly at the first place.

Kai-Heng

>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.

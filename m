Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C224E1ED8AE
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 00:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgFCWek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 18:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgFCWej (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 18:34:39 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05053C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 15:34:38 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s1so4850669ljo.0
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 15:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gh37isHiEa0VDwLfX8KuGahT8mC736+W9oMftFOpgb8=;
        b=NI9BNZsZdQDK5mmCBfvcf4CZuksZNkq/F+BU0OYIGjn/GXd8AdBMnwywGKwiM14KiN
         GWVeyJoC99OT1ioTuXeoMUNgTP79Fxp2VHsXm7dQjmmSbo+4nLiuCnHHp1TQP/yZuzdq
         NFblHC6HRzkHEyA/LHmf9UxTwF9isjRLAry8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gh37isHiEa0VDwLfX8KuGahT8mC736+W9oMftFOpgb8=;
        b=lUmiBIY/Ckc7qmG+xZSUiBVVNlb0sDwshr7z8imf38Y7HAVbTYp9pUzIz+AcBCc3/i
         zewe8UUL+mMrjsVWGdBO8F9uOIoMuqGTSZogAPYEYXKpSv9lnKlKZv2GhiKBUqdgFuEB
         Zh8WAh3vf3791yfjVQkaB6rtPych9Ky2kzBHlf2MlJQJ9zuIbKuNs2OduHIvc3ZYJoZl
         a80/S9NXYyZ69VlT+JVWynshWwnluqCkikmtO5M/h7b1Bvh76M6byZoh28+efpphv1fW
         LqGL2DHgwj6GjdjcdqMiUKClDS93U3HXEaxIZSH8d0CUyya4Yq70J81n7dHIM25Ip41+
         MhqQ==
X-Gm-Message-State: AOAM531qrnuJWDu9//wYT9UbdMVJ3FC8P8slNcPt8ZbwQJj+sN5JHDRE
        h7CSuG/jDJEs+Cq/4WXUbzJs62WJejo=
X-Google-Smtp-Source: ABdhPJyxAK69DTAaM6SkX80mGCt5IVhnTDUEar4YuBk7umqxGdqyD5GBe416umkTJWOzOTg6lu9CMQ==
X-Received: by 2002:a2e:8944:: with SMTP id b4mr615388ljk.247.1591223674435;
        Wed, 03 Jun 2020 15:34:34 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id w24sm812068ljd.14.2020.06.03.15.34.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 15:34:33 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id c21so2349540lfb.3
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 15:34:32 -0700 (PDT)
X-Received: by 2002:a19:103:: with SMTP id 3mr827227lfb.196.1591223672262;
 Wed, 03 Jun 2020 15:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200602163257.26978-1-sibis@codeaurora.org> <CAE=gft7sbh_S_GiRohtMmdMN9JzQhG0m3bUerwrmzhjmXucGKw@mail.gmail.com>
 <6392c800b0be1cbabb8a241cf518ab4b@codeaurora.org>
In-Reply-To: <6392c800b0be1cbabb8a241cf518ab4b@codeaurora.org>
From:   Evan Green <evgreen@chromium.org>
Date:   Wed, 3 Jun 2020 15:33:55 -0700
X-Gmail-Original-Message-ID: <CAE=gft4v1iHAPJS13fLBXgjt8ZRhD7q894zF_7JvK9QbiTbwhA@mail.gmail.com>
Message-ID: <CAE=gft4v1iHAPJS13fLBXgjt8ZRhD7q894zF_7JvK9QbiTbwhA@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: qcom: q6v5: Update running state before
 requesting stop
To:     Sibi Sankar <sibis@codeaurora.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ohad Ben Cohen <ohad@wizery.com>, rohitkr@codeaurora.org,
        stable@vger.kernel.org, linux-kernel-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 2, 2020 at 10:29 PM Sibi Sankar <sibis@codeaurora.org> wrote:
>
> Evan,
> Thanks for taking time to review
> the series.
>
> On 2020-06-02 23:14, Evan Green wrote:
> > On Tue, Jun 2, 2020 at 9:33 AM Sibi Sankar <sibis@codeaurora.org>
> > wrote:
> >>
> >> Sometimes the stop triggers a watchdog rather than a stop-ack. Update
> >> the running state to false on requesting stop to skip the watchdog
> >> instead.
> >>
> >> Error Logs:
> >> $ echo stop > /sys/class/remoteproc/remoteproc0/state
> >> ipa 1e40000.ipa: received modem stopping event
> >> remoteproc-modem: watchdog received: sys_m_smsm_mpss.c:291:APPS force
> >> stop
> >> qcom-q6v5-mss 4080000.remoteproc-modem: port failed halt
> >> ipa 1e40000.ipa: received modem offline event
> >> remoteproc0: stopped remote processor 4080000.remoteproc-modem
> >>
> >> Fixes: 3b415c8fb263 ("remoteproc: q6v5: Extract common resource
> >> handling")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> >> ---
> >
> > Are you sure you want to tolerate this behavior from MSS? This is a
> > graceful shutdown, modem shouldn't have a problem completing the
> > proper handshake. If they do, isn't that a bug on the modem side?
>
> The graceful shutdown is achieved
> though sysmon (enabled using
> CONFIG_QCOM_SYSMON). When sysmon is
> enabled we get a shutdown-ack when we
> try to stop the modem, post which
> request stop is a basically a nop.
> Request stop is done to force stop
> the modem during failure cases (like
> rmtfs is not running and so on) and
> we do want to mask the wdog that we get
> during this scenario ( The locking
> already prevents the servicing of the
> wdog during shutdown, the check just
> prevents the scheduling of crash handler
> and err messages associated with it).
> Also this check was always present and
> was missed during common q6v5 resource
> helper migration, hence the unused
> running state in mss driver.

So you're saying that the intention of the ->running check already in
q6v5_wdog_interrupt() was to allow either the stop-ack or wdog
interrupt to complete the stop. This patch just fixes a regression
introduced during the refactor.
This patch seems ok to me then. It still sort of seems like a bug that
the modem responds arbitrarily in one of two ways, even to a "harsh"
shutdown request.

I wasn't aware of QCOM_SYSMON. Reading it now, It seems like kind of a
lot... do I really need all this? Can I get by with just remoteproc
stops?
Anyway, for this patch:

Reviewed-by: Evan Green <evgreen@chromium.org>

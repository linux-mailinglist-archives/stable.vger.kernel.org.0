Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF6F2920C2
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 02:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgJSAzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 20:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgJSAzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 20:55:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC22C061755;
        Sun, 18 Oct 2020 17:55:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t4so1511942plq.13;
        Sun, 18 Oct 2020 17:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+Rt56BOJl/bRW3wLKniwJW7cXJ9hWnw6gYa/kUVuwSc=;
        b=kD5/mWhkowA2pgqZNgdK7l9xxePyAZyXwGV1X+zM9Ioz+N7wLSW4TPdxvJJ21i6HsT
         oqq5siaFUuyhaYJZcCrnvsvMjAqSjosXD4HKxICovb20aO0RTDcv6mGLozRujN5d8eBH
         qNpDAF2hqdEXaIlnUoudG3c/F7DgjCshsonws0f5TkV3659dUETU544ww9FFfIfrOG87
         Ep7hCGxCIS0gRsUK1VN3tMdRyz6jHpEYq7jm+0hReNmpdkanoNxPlxixLbl+iExHF5M6
         nbTWRhV1QxVP/F1YYtSIWYltBJNkXvgKrbTr6+982+mAUp0aUomiI/+xyKnBT3ZlD/vt
         klBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+Rt56BOJl/bRW3wLKniwJW7cXJ9hWnw6gYa/kUVuwSc=;
        b=aa39mkVZYKkcoOo/D4ikBDp+fjEtPA/2948MCAhORGfVG9hilySQuI7fHtOxp7o0T+
         f+9mtrC5Ckm/nMf8jdlf/9CNvk8xsg0us918K4bt7sEMvT5t/N1w0LmGsIcTM62IHvjw
         t8178Y6LxFetvjBDU0/4Ei7WnlCZC7aBraZUmNNYHrGeqkJhAwOfSpzjdpQBTei0cx6B
         HW0bv5yvHOoSTW0Wi/3RSF9ATdsL1udl2s9Qpcpa11d0ZYirAytXyN34T0cAikdskYOz
         o4Bpyv8BRgDD77t5NqMkgPTvK7MgKTL+QTWsEmsiajh49KsndAy7WynFsos0zkarq+qz
         LXkQ==
X-Gm-Message-State: AOAM531M+L5lEoRBn89HQGXYYYJivNB9gWxK4pWdgF5pGUoUE4SobjvC
        2JfYGqNXakEAwNaQF+y3Lb0=
X-Google-Smtp-Source: ABdhPJwtBh0pw3ZFUZm8ksceFnJOezgtN1JWySkFktYidxEioc0v1efLNTaDMS9uD7RnzQg2Rgu9Jg==
X-Received: by 2002:a17:90a:400e:: with SMTP id u14mr15103805pjc.118.1603068915729;
        Sun, 18 Oct 2020 17:55:15 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id l199sm9906039pfd.73.2020.10.18.17.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 17:55:15 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 19 Oct 2020 08:54:52 +0800
To:     =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected
 GPIO chip's pin status
Message-ID: <20201019005452.uqqwq7xrusvsptmz@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com>
 <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com>
 <20201017004556.kuoxzmbvef4yr3kg@Rk>
 <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com>
 <20201017140541.fggujaz2klpv3cd5@Rk>
 <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com>
 <BXoa8IFE81mt8sW2luHnqgFoZUBIDxRGg8SzTxqCuBMm0PPopB98-w7u1ckq77Gtj2bJCVSFFA83zOPVdP_kynQ8Zkys3B96lFTV6fUCJHM=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BXoa8IFE81mt8sW2luHnqgFoZUBIDxRGg8SzTxqCuBMm0PPopB98-w7u1ckq77Gtj2bJCVSFFA83zOPVdP_kynQ8Zkys3B96lFTV6fUCJHM=@protonmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 18, 2020 at 12:23:14PM +0000, Barnabás Pőcze wrote:
>> [...]
>> > > > > > +static int i2c_hid_polling_thread(void *i2c_hid)
>> > > > > > +{
>> > > > > >
>> > > > > > -   struct i2c_hid *ihid = i2c_hid;
>> > > > > > -   struct i2c_client *client = ihid->client;
>> > > > > > -   unsigned int polling_interval_idle;
>> > > > > > -
>> > > > > > -   while (1) {
>> > > > > > -       /*
>> > > > > >
>> > > > > >
>> > > > > > -        * re-calculate polling_interval_idle
>> > > > > >
>> > > > > >
>> > > > > > -        * so the module parameters polling_interval_idle_ms can be
>> > > > > >
>> > > > > >
>> > > > > > -        * changed dynamically through sysfs as polling_interval_active_us
>> > > > > >
>> > > > > >
>> > > > > > -        */
>> > > > > >
>> > > > > >
>> > > > > > -       polling_interval_idle = polling_interval_idle_ms * 1000;
>> > > > > >
>> > > > > >
>> > > > > > -       if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
>> > > > > >
>> > > > > >
>> > > > > > -       	usleep_range(50000, 100000);
>> > > > > >
>> > > > > >
>> > > > > > -
>> > > > > > -       if (kthread_should_stop())
>> > > > > >
>> > > > > >
>> > > > > > -       	break;
>> > > > > >
>> > > > > >
>> > > > > > -
>> > > > > > -       while (interrupt_line_active(client)) {
>> > > > > >
>> > > > > >
>> > > > >
>> > > > > I realize it's quite unlikely, but can't this be a endless loop if data is coming
>> > > > > in at a high enough rate? Maybe the maximum number of iterations could be limited here?
>> > > >
>> > > > If we find HID reports are constantly read and send to front-end
>> > > > application like libinput, won't it help expose the problem of the I2C
>> > > > HiD device?
>> > > >
>> > > > >
>> > >
>> > > I'm not sure I completely understand your point. The reason why I wrote what I wrote
>> > > is that this kthread could potentially could go on forever (since `kthread_should_stop()`
>> > > is not checked in the inner while loop) if the data is supplied at a high enough rate.
>> > > That's why I said, to avoid this problem, only allow a certain number of iterations
>> > > for the inner loop, to guarantee that the kthread can stop in any case.
>> >
>> > I mean if "data is supplied at a high enough rate" does happen, this is
>> > an abnormal case and indicates a bug. So we shouldn't cover it up. We
>> > expect the user to report it to us.
>> >
>> > >
>>
>> I agree in principle, but if this abnormal case ever occurs, that'll prevent
>> this module from being unloaded since `kthread_stop()` will hang because the
>> thread is "stuck" in the inner loop, never checking `kthread_should_stop()`.
>> That's why I think it makes sense to only allow a certain number of operations
>> for the inner loop, and maybe show a warning if that's exceeded:
>>
>> for (i = 0; i < max_iter && interrupt_line_active(...); i++) {
>> ....
>> }
>>
>> WARN_ON[CE](i == max_iter[, "data is coming in at an unreasonably high rate"]);
>>
>
>I now realize that WARN_ON[CE] is probably not the best fit here, `hid_warn()` is possibly better.
>
Thank you for the suggestion!
>
>> or something like this, where `max_iter` could possibly be some value dependent on
>> `polling_interval_active_us`, or even just a constant.
>> [...]
>
>
>Regards,
>Barnabás Pőcze

--
Best regards,
Coiby

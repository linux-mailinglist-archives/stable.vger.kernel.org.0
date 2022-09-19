Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FD65BD39E
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 19:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiISRZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 13:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiISRZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 13:25:12 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D38183B3
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 10:25:04 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-12c8312131fso404799fac.4
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 10:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=vctj5HCSzGwdLm3ihJHxXlvukok6qduDHO/C6dYfeBk=;
        b=vznTHUMSyxTCsdjO2JXlrufcZeNc+w8lNaKjidvChQ3HXhbZepYOHhytvKeBkM1iA5
         hKEq0oVjGmC8RGZ4cclAiyV/NG298ZlVqioNuUm7F1hJJwwDDNvvLhaLiYiGYv9IUFxv
         Q1RWg1cetwNWf9D7VAa5fB6Rq/JriMq50KD2rvNVbxIR3HTEMVV9bkJJwLrhtRx/nliM
         mgoxinJcLrW1/RctounS3IXs9VAwWOzByvY5eK0vnBLSmXvehL9eSyu7N5AqwPvmJOkj
         3sKfMG2SbdXFvulCqvyD7JyPOilT2Q4whtWpW/fA3BBTqYouEgRNp9+XiUwtWDtGFrwC
         LgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vctj5HCSzGwdLm3ihJHxXlvukok6qduDHO/C6dYfeBk=;
        b=II2DMeYHIU2xIZTyoYPKA/EDOxXIoneC3nR0HUYmlFAKi5WdRcwNeR8ZyovvuD71ds
         opiL763y/SFlIucZGw6u7ICslA6w2kD87W/ZO485aWiEm27FmeNNcVHrhU3i0GhR9Pr7
         7gZ7z4PtNc+oQ6ZxhE7bS4/sskAWmYKV8YLLdUnEkQSf6rsu/RUyiI2GwwHGnyRtqJ7n
         abucDGWCq4J5EcTcmmVs12qia7Si0Auf9tKkovhK6f98tBiwnEaDBsgd92bfPVhdYT3w
         R5R6hrSJe5/caN2YTvxnzvhlFXxETQQGUqVDGrVlpeeNqxnTnI/f6PpwAaY18VwwvrRL
         z90A==
X-Gm-Message-State: ACgBeo2iqLFsyY+B2HZd7ziS4kuFHExaePLWvKei7lmQQk/ApYJzea9l
        sr0KsgWekdtV+3bZQf4ASnHQR7jQ8krnl/HVTHWdNA==
X-Google-Smtp-Source: AA6agR6PIExzbO7BZyGMk5OG1ePbcXS7CYu022otcLvbs4mq2DgJebDFBZx/pL35hUMVSBccEr1PZrv8YzqjfYboeAI=
X-Received: by 2002:a05:6870:b511:b0:12b:5871:2129 with SMTP id
 v17-20020a056870b51100b0012b58712129mr17182964oap.80.1663608303236; Mon, 19
 Sep 2022 10:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
 <YmPadTu8CfEARfWs@xps> <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
 <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com>
 <CAG2Q2vXFcSVwF4CbU5o3VP1MWwrdqrZjTHgfBj_Q0t3nNipJRw@mail.gmail.com> <CA+ASDXNx30A3=BA9b-tiAQzYHP=nV_eLw1QFpJij=F=JgWZ5sg@mail.gmail.com>
In-Reply-To: <CA+ASDXNx30A3=BA9b-tiAQzYHP=nV_eLw1QFpJij=F=JgWZ5sg@mail.gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 19 Sep 2022 10:24:51 -0700
Message-ID: <CAJ+vNU38WyC=FFZVgqyKunEnjXid6vXqkorv8a8+ywjJBk_0NA@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     Brian Norris <briannorris@chromium.org>
Cc:     Cale Collins <ccollins@gateworks.com>, kvalo@kernel.org,
        Patrick Steinhardt <ps@pks.im>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Stephen McCarthy <stephen.mccarthy@pctel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 2:57 PM Brian Norris <briannorris@chromium.org> wrote:
>
> Hi Cale,
>
> I meant to respond a while back, but didn't get around to it, sorry.
> In case it's still helpful:
>
> On Wed, May 11, 2022 at 3:52 PM Cale Collins <ccollins@gateworks.com> wrote:
> > On Mon, May 9, 2022 at 11:16 AM Cale Collins <ccollins@gateworks.com> wrote:
> > > I'm experiencing an issue very similar to this.  The regulatory domain
> > > settings wouldn't allow me to create an AP on 5ghz bands on kernels
> > > newer than 5.10 when using a WLE900VX (QCA9984) radio.  I bisected the
> > > kernel and ultimately landed on the regression that Brian patched.
>
> If the revert broke you, then you were also broken before v5.6. This
> patch only landed in v5.6-rc1:
>
> 2dc016599cfa ath: add support for special 0x0 regulatory domain
>
> I'm not really an expert on the wide variety of ath-related hardware
> production, but given the many people complaining about the existence
> of the non-reverted patch, it seemed like a revert was the best way
> forward -- don't break those that weren't already broken pre-5.6.
>
> > > root@focal-ventana:~# iw reg get
> > > global
> > > country 00: DFS-UNSET
> > >     (2402 - 2472 @ 40), (N/A, 20), (N/A)
> > >     (2457 - 2482 @ 20), (N/A, 20), (N/A), AUTO-BW, NO-IR
> > >     (2474 - 2494 @ 20), (N/A, 20), (N/A), NO-OFDM, NO-IR
> > >     (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW, NO-IR
> > >     (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW, NO-IR
> > >     (5490 - 5730 @ 160), (N/A, 20), (0 ms), DFS, NO-IR
> > >     (5735 - 5835 @ 80), (N/A, 20), (N/A), NO-IR
> > >     (57240 - 63720 @ 2160), (N/A, 0), (N/A)
> > >
> > > phy#0
> > > country 99: DFS-UNSET
> > >     (2402 - 2472 @ 40), (N/A, 20), (N/A)
> > >     (5140 - 5360 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN
> > >     (5715 - 5860 @ 80), (N/A, 30), (N/A), PASSIVE-SCAN
>
> Unless there's some other bug hidden in here in how we're reading
> EEPROM settings, it sounds like you have a badly-provisioned PCI
> module, with no EEPROM country code. Thus, the driver has to
> conservatively treat you as a very-limited "world roaming" regulatory
> class, which mostly disables 5GHz, or at least doesn't let you
> initiate much radiation on your own (which basically eliminates AP
> mode).
>
> The "fix" there would be to get a different, correctly-provisioned
> (for your regulatory domain) module.
>
> Also, I didn't notice until today: technically, you also could be
> retrieving your incorrect country code info from ACPI; but if you're
> using a typical ARM board like claimed, it's unlikely you're using
> ACPI.
>
> Somewhat of a sidetrack: The existence of ACPI override support does
> suggest that perhaps there's some room for a Device Tree property, so
> one can set their regulatory domain on a per-board basis. I've
> definitely known some downstream product makers use that sort of
> approach -- and that very "solution" is potentially why some devices
> don't get a valid EEPROM (if the manufacturer could hack the drivers,
> why bother getting the EEPROM right?), and therefore don't work
> correctly with upstream kernels... Unfortunately, that kind of
> solution is hard to deploy 100% correctly for upstream Linux, because
> the Device Tree would need to change depending on which country the
> affected system is shipped to. It's easier to get those things right
> in a pre-flashed firmware or an EEPROM; it's harder to get those in a
> software DTS file shipped to everyone in the mainline kernel sources.
>
> > > #dmesg |grep ath output
>
> In the slim chance there's something else going on in the driver, you
> might try to capture logs with ATH10K_DBG_BOOT and
> ATH10K_DBG_REGULATORY logging enabled. That could look something like:
>
> echo 0x820 > /sys/module/ath10k_core/parameters/debug_mask
> rmmod ath10k_pci
> modprobe ath10k_pci
> dmesg | grep ath
>

Brian,

Thanks for the follow-up. Indeed the situation Cale had here was with
Compex WLE900VX which apparently does have what we now understand to
be an unprogrammed EEPROM. I suspect this was some choice from Compex
that somehow must have benefited them at the time and I'm not clear if
there are many other cards that have this same issue. Maybe something
should be added to the ath drivers wiki pages
(https://wireless.wiki.kernel.org/en/users/drivers/ath9k)

Reverting commit 2dc016599cfa ("ath: add support for special 0x0
regulatory domain") does indeed resolve the issue on the older kernels
but somehow the issue creeps back in with later kernels (definitely
appears in 5.15) perhaps due to other changes. Perhaps you can confirm
my findings if you have a card like this.

For 5.15 and newer I've elected to add a hack from OpenWrt for the
kernel's used to support my companies boards which adds a kernel
config to not enforce EEPROM reg restrictions for the kernels that our
users use:
https://github.com/Gateworks/linux-venice/commit/39ef369cbca269fa32e8f85d31ae813b97d84aec

Best Regards,

Tim

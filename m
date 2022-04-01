Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B0D4EE723
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 06:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbiDAEZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 00:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244830AbiDAEZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 00:25:32 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CF624BF9;
        Thu, 31 Mar 2022 21:23:42 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o8so1455633pgf.9;
        Thu, 31 Mar 2022 21:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eESKxdpMfFxPyM1uk0oYjHMKWrtVKAqnO3g4CjGdKIo=;
        b=FajAfzjeSZaOxtrhPeu42XMPxmxcLGoaRJ6bmtBt0aNk3IUhyscb033PkciY2KliMI
         8KP2Fx7PcFMQP5r1Mp4J+Lxz3u5DpCJ+4n+MbkwCBR/nWdEv7qeqyAxMHeWrgAlWdU9K
         KECmALwyFfq0OPM/pm3VOXudsJtwcahtimuhgQq64SOFX2DpSiKjbyoyrvO2YwIGRgy0
         WNJATageYgvFdakP5ZttzfgJnpJOzEeZ9qikfaxS16PPYFhdv08f9OZYgSdnkhE543p6
         D98vxpiYGpF+vWZQUTmjPJNL9wOwploQaeCNx8OT+OYPeJV013V2lIYNELJD/ZaQPvle
         jfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eESKxdpMfFxPyM1uk0oYjHMKWrtVKAqnO3g4CjGdKIo=;
        b=twgV7Uxz6d/nHknKf5HD3jzhRk4V1KkxsYmKCwtNKTixeV9qetQc51DMjqN0proUsN
         PAG4beAVzDtw9T60AFPGhKd8kiV1UESWmRonwQZuEPE7vFWkhexs8Y62hD4npnrhcnSz
         s84wXDWfqX1AfONlWnO3M6KhIA1dxBK3Qu4TYosdbFmZJ7KvpTi4sxw38arbziASP0/0
         yYlvyqqfgmgWgiIZ71e8OZBZQfdaPZvAQQQlqf8fW8izOlUtK+nKgdhDYqqWrEjB1w1+
         zLeCDShmcB8rZG0G9DKlnL0aVOTKf3Ocg4TXhd/35F6IoHtTSnZDpEYiQe6cecd4jCW4
         aQgg==
X-Gm-Message-State: AOAM530lqYWPk7APC04agpx391LeuLvKSLhrR9+iJkU0l/KWCxnoESyG
        X6UufFltCbItUQgHY5x9WcaNHOtFGQo=
X-Google-Smtp-Source: ABdhPJzAS50LZ2W0yPHY18Ri8Dl4LtyAOMCiz6o8AqAIH0n0AfMaWj+xWDAe4gcOwOcxyz0KTW6W1A==
X-Received: by 2002:a05:6a00:2304:b0:4fa:dff2:88f5 with SMTP id h4-20020a056a00230400b004fadff288f5mr42934884pfh.11.1648787021589;
        Thu, 31 Mar 2022 21:23:41 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:861c:fce2:7032:ab10])
        by smtp.gmail.com with ESMTPSA id w8-20020a63a748000000b0038117e18f02sm861164pgo.29.2022.03.31.21.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 21:23:40 -0700 (PDT)
Date:   Thu, 31 Mar 2022 21:23:38 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Peter Hutterer <peter.hutterer@who-t.net>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Message-ID: <YkZ+Sie9ANR0r12B@google.com>
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
 <44abc738-1532-63fa-9cd1-2b3870a963bc@leemhuis.info>
 <CAO-hwJJweSuSBE_18ZbvqS12eX9GcS+aJoe7SRFJdASOrN3bqw@mail.gmail.com>
 <YkUqajiNZmi+lAPC@google.com>
 <YkUwRIa4ZI3TLAs0@quokka>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkUwRIa4ZI3TLAs0@quokka>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 02:38:28PM +1000, Peter Hutterer wrote:
> On Wed, Mar 30, 2022 at 09:13:30PM -0700, Dmitry Torokhov wrote:
> > On Wed, Mar 30, 2022 at 02:30:37PM +0200, Benjamin Tissoires wrote:
> > > On Wed, Mar 30, 2022 at 2:27 PM Thorsten Leemhuis
> > > <regressions@leemhuis.info> wrote:
> > > >
> > > > Hi, this is your Linux kernel regression tracker.
> > > >
> > > > On 21.03.22 19:44, José Expósito wrote:
> > > > > This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
> > > > >
> > > > > The touchpad present in the Dell Precision 7550 and 7750 laptops
> > > > > reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> > > > > the device is not a clickpad, it is a touchpad with physical buttons.
> > > > >
> > > > > In order to fix this issue, a quirk for the device was introduced in
> > > > > libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> > > > >
> > > > >       [Precision 7x50 Touchpad]
> > > > >       MatchBus=i2c
> > > > >       MatchUdevType=touchpad
> > > > >       MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> > > > >       AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> > > > >
> > > > > However, because of the change introduced in 37ef4c19b4 ("Input: clear
> > > > > BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> > > > > anymore breaking the device right click button and making impossible to
> > > > > workaround it in user space.
> > > > >
> > > > > In order to avoid breakage on other present or future devices, revert
> > > > > the patch causing the issue.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
> > > > > Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
> > > > > Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> > > > > [...]
> > > >
> > > > Jiri, Benjamin, what the status here? Sure, this is not a crucial
> > > > regression and we are in the middle of the merge window, but it looks
> > > > like nothing has happened for a week now. Or was progress made somewhere
> > > > and I just missed it?
> > > 
> > > No, I think it just wasn't picked up by the input maintainer yet
> > > (Dmitry, now in CC).
> > > 
> > > FWIW:
> > > Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > 
> > > José, please do not forget to add the input maintainer when you target
> > > the input tree, not the HID one :)
> > 
> > I see that there were several ACKs, but how many devices misuse the
> > HID_DG_BUTTONTYPE? Would it be better to quirk against either affected
> > Dell models, or particular touchpads (by HID IDs) instead of reverting
> > wholesale?
> 
> fwiw, a quick git grep in libinput shows 12 entries for disabling BTN_RIGHT
> and 9 entries for enabling/disabling INPUT_PROP_BUTTONPAD. That's not the
> number of devices affected by this bug, merely devices we know advertise the
> wrong combination.
> 
> Note that the cause for the revert is loss of functionality. Previously, a
> device was just advertising buttons incorrectly but still worked fine. This
> was mostly a cosmetic issue (and could be worked around in userspace). With
> the patch in place some devices right button no longer works because it's
> filtered by the kernel. That's why the revert is needed.
> 
> The device could/should still be quirked to drop INPUT_PROP_BUTTONPAD but that
> is only required to work around the cosmetic issues then.

OK, fair enough, applied.

Thank you.

-- 
Dmitry

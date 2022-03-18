Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B84DDBA6
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 15:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbiCRO3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 10:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbiCRO3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 10:29:51 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3411D186CD;
        Fri, 18 Mar 2022 07:28:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q8so623457wrc.0;
        Fri, 18 Mar 2022 07:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QMp0QqN5Rc7yHWj1ge61Fcg0NrJkJCfWYiT8StepBHo=;
        b=fHAvxLIqcCsasXYO5/xFApFasN5U22rI+6ED4ZM+sYXuGCeS5K+trKxI+h2NnFmVQB
         FQbWqICMr1CyhRowbVlGIX4TPaZvx8RUgDzFc4z2MCcJQjGLLeX8MLGfL4KORMXrxMk5
         lo72vQVYwB4HrKlZhQPASSVSk9+1KdLRL5cQs3jTOaddKWh0BtoLYlDMFxheelJygrjI
         7XFrbwjod/uLWuJumOqKFJCANjvWt4LHNeMAbZPz13kIDNOOQIv+u+bkP+HCKqtozgBk
         pzxlPeTHC5h65mxllCACRwjxW3JmlcK5vsVBMb5qLuXPuE61nq6kpmKxcGtyTdW63VSN
         ntoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QMp0QqN5Rc7yHWj1ge61Fcg0NrJkJCfWYiT8StepBHo=;
        b=aWk5uiyqzGCSLrgdZe+q8S9Ze79Cqz48JWZH65mRztfWz5HP62GuTlXHN/Q75LblGD
         fX8hL3bjtMEu+b8hmfOdul1DRwFBkDNNpN8qSkTjwPpokOSupIDGGgX6xATFPZmmtW/l
         UlbEwUCQ3KWslEu1ud+KNEhIqBziaUeCKnFsakJz/0gf6pmgF6brdakGE7hoqDCxThxO
         lV6Rq+bVakbNyJ0Kr6SJj5aN5ZR1TTXPnq58lhGOR9NpiBeitroja9JNvvB0FEJDPJhZ
         v+QSsXVsZRfaa7QswGd7d78lLbU1/l3hBHB7BCHZnRtzDIIULSSthioCiqvZURqAUrrE
         Qz+g==
X-Gm-Message-State: AOAM532f8NTlVXxdu7NOkauTljIho3ASXOhhByF85LNh4KWtjg9jVPVO
        z6Ywdb4yV68w1FB3Ks8CTqt3kgGygwOPaA==
X-Google-Smtp-Source: ABdhPJxePbWH34FcXfBL0WTi8+NF9q6Kjyl2jV78U90F/g95zgtCmQhzIckknx6bRKSiMeDBVLa7Mg==
X-Received: by 2002:adf:dfc2:0:b0:1f0:262a:d831 with SMTP id q2-20020adfdfc2000000b001f0262ad831mr7850277wrn.589.1647613710524;
        Fri, 18 Mar 2022 07:28:30 -0700 (PDT)
Received: from elementary ([94.73.33.246])
        by smtp.gmail.com with ESMTPSA id b3-20020adfd1c3000000b00203f94379a4sm1267780wrd.67.2022.03.18.07.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 07:28:30 -0700 (PDT)
Date:   Fri, 18 Mar 2022 15:28:24 +0100
From:   =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Right touchpad button disabled on Dell 7750
Message-ID: <20220318142824.GA6009@elementary>
References: <s5htubv32s8.wl-tiwai@suse.de>
 <20220318130740.GA33535@elementary>
 <s5hlex72yno.wl-tiwai@suse.de>
 <CAO-hwJK8QMjYhQAC8tp7hLWZjSB3JMBJXgpKmFZRSEqPUn3_iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO-hwJK8QMjYhQAC8tp7hLWZjSB3JMBJXgpKmFZRSEqPUn3_iw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 03:06:55PM +0100, Benjamin Tissoires wrote:
> On Fri, Mar 18, 2022 at 2:11 PM Takashi Iwai <tiwai@suse.de> wrote:
> > > > Hi,
> > > >
> > > > we received a bug report about the regression of the touchpad on Dell
> > > > 7750 laptop, the right touchpad button is disabled on recent kernels:
> > > >   https://bugzilla.suse.com/show_bug.cgi?id=1197243
> > > >
> > > > Note that it's a physical button, not a virtual clickpad button.
> > > >
> > > > The regression seems introduced by the upstream commit
> > > > 37ef4c19b4c659926ce65a7ac709ceaefb211c40 ("Input: clear
> > > > BTN_RIGHT/MIDDLE on buttonpads") that was backported to stable 5.16.x
> > > > kernel.
> > > >
> > > > The device is managed by hid-multitouch driver, and the further
> > > > investigation revealed that it's rather an incorrectly recognized
> > > > buttonpad property; namely, ID_DG_BUTTONTYPE reports it being 0 =
> > > > clickable touchpad although it's not.  I built a test kernel to ignore
> > > > this check and it was confirmed to make the right button working again
> > > > by the reporter.
> 
> Yep, I came to the same conclusion this morning with the reporter of
> the libinput bug José was mentioning.
> 
> > > >
> > > > Is this check really correct in general?  Or do we need some
> > > > device-specific quirk?
> 
> The device firmware is clearly wrong here. It's the first time I see
> this failing like that and I hope this is just an isolated case.
> The device advertises itself as a buttonpad, when it's not.
> 
> However, the fact that it passed MS certification (even if I doubt
> Microsoft ever got that touchpad in their own hands) leads me to
> believe that the certification doesn't enforce that setting too much,
> and that we might see more devices coming in with that same bug.
> 
> To sum up, I am not happy that this commit introduced a regression
> that we can not work around in userspace: given that BTN_RIGHT gets
> removed from the device, all of the values are filtered out and
> userspace can not resolve that situation by itself.
> 
> I wish I had a better way of fixing this than having to quirk the device.
> 
> > >
> > > A couple of days ago another user with the same laptop (Dell Precision
> > > 7550 or 7750) emailed me to report the issue and I sent him a patch for
> > > testing.
> > >
> > > I he confirms that the patch works, I'll send it to the mailing list.
> > >
> > > I believe that your analysis of the regression is correct and I think
> > > that we'd need to add a quirk for the device.
> > >
> > > In case you want to have a look to the patch, I added it to this
> > > libinput [1] report.
> >
> > Great, I'll try to build and ask the reporter to test with the patch.
> >
> 
> As noticed on the libinput bug, I think the patch is wrong (not by a lot).
> We should base the class on MT_CLS_WIN8, not MT_CLS_DEFAULT.

Thanks for providing the right class Benjamin, I updated the patch:
https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/726#note_1303724
 
Jose

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DA94ED314
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiCaEk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCaEk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:40:27 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AC05370F;
        Wed, 30 Mar 2022 21:38:40 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 4ACA83201F94;
        Thu, 31 Mar 2022 00:38:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 31 Mar 2022 00:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=who-t.net; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; bh=220FvBfvs98k1i
        EJqsZ+bl0CZjmlZ3jc/CXvJx3fxGs=; b=RLMQq0lrMr2v0PWc4EJtO7H7pUDfT7
        ZQ0a9TP8mentwV2H54yDA8k0sp/kUiNNZ92krGTF9ZXYE/r++Vf5sHXYxa/BtHiD
        b3Kxp1cykXI/FXIJhkBcpIpkNpHYhM1HTD2bRBgJx6+CPSn3tiupa5iMOP6RvBoV
        9/Iflj0E3pirSCqWLxAkqEEdacIYOPIsqA3Q8USU3eduMeC/IL3J0+ec4Rw89Ve8
        ln55npPmY2teiTKh7xVx9M6V1AIt+8Vcm9ALl9cr4AlsmLNq9/UJqOpO7atd1RFX
        bMjvsBKm+poxrS3VOc5wlBDBgkHMQfQA+aHdFCD4OpGJHrvNj4LTG0kA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=220FvBfvs98k1iEJqsZ+bl0CZjmlZ3jc/CXvJx3fx
        Gs=; b=oluUQ17m7MAC9vzPWeqgJ6avk9ohDHnMVbQD+I12ByS95TD8cUXcXl6p4
        JlRBWqn0g8LbVwptRKoOWM/kyveSovgI6pVS1Lh2TTleOMbc/sM5cVi4+VYaHOZp
        ZOUObEuFywn6p/dXHNBhFLwpL16fuiYvo5PVdnu/DZnA824igC+k1wiHoAkshReX
        L0YMggj3GLdJGAZdS9e0C+EehFlewx7NVQFP66+wJE9sVWa/+2kbAVXU2+qzo0pf
        RqCmcI7NIfwEZnWAtVFRHbsRiCHbpZAjmB+6d/6FrDP96AIskfm0IBsvadGG1s/M
        oZXTBG6uPdHLMYAymzfRBAUNiNsTQ==
X-ME-Sender: <xms:TDBFYgj_xKbPdmeiLPniqBYx4PLXFU1N5CCZIIFZfMSiLYUi7SuFaw>
    <xme:TDBFYpDiV1KwBSR-xRy_gQla5HMzPVvgmtoJzlyKsZY4AN769dR-eda2dx8bmyZLB
    mw3gvfbiDFiFoG3szY>
X-ME-Received: <xmr:TDBFYoEvGbnJCAANaZdTYlXQKrMJl5NPOA2CYgvG2UlBb_zqg_IBOyIK499PDjjfYhaoG91sJAghCpXscLPdhYEFzaCZg5L47g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeifedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomheprfgvthgv
    rhcujfhuthhtvghrvghruceophgvthgvrhdrhhhuthhtvghrvghrseifhhhoqdhtrdhnvg
    htqeenucggtffrrghtthgvrhhnpeevfeejhedvffeuhfelfefghfdtvddvfffhleejffeu
    gfekvdefhfeffffgueefleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrgh
    dprhgvughhrghtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepphgvthgvrhdrhhhuthhtvghrvghrseifhhhoqdhtrdhnvght
X-ME-Proxy: <xmx:TDBFYhSMNl4Bu6DHMPfcV_YzkyIbHs7mi5RQiaXJJsszDqO5sYztqA>
    <xmx:TDBFYtxgx9WrY6NT_KgbH49cOdjw3gnd943x5AKGzC8wYHJEc1-wwA>
    <xmx:TDBFYv6BoLo7iKO5yRYE-iC1eR2C7RH3_gZQM5hHXsRTEdC_CnHplA>
    <xmx:TDBFYkn65k_eP794kQX1E9SzRUOU_lvmY-rnvUh3SIbPkrNz-5St5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 31 Mar 2022 00:38:33 -0400 (EDT)
Date:   Thu, 31 Mar 2022 14:38:28 +1000
From:   Peter Hutterer <peter.hutterer@who-t.net>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>, regressions@lists.linux.dev,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "Input: clear BTN_RIGHT/MIDDLE on buttonpads"
Message-ID: <YkUwRIa4ZI3TLAs0@quokka>
References: <20220321184404.20025-1-jose.exposito89@gmail.com>
 <44abc738-1532-63fa-9cd1-2b3870a963bc@leemhuis.info>
 <CAO-hwJJweSuSBE_18ZbvqS12eX9GcS+aJoe7SRFJdASOrN3bqw@mail.gmail.com>
 <YkUqajiNZmi+lAPC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkUqajiNZmi+lAPC@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 09:13:30PM -0700, Dmitry Torokhov wrote:
> On Wed, Mar 30, 2022 at 02:30:37PM +0200, Benjamin Tissoires wrote:
> > On Wed, Mar 30, 2022 at 2:27 PM Thorsten Leemhuis
> > <regressions@leemhuis.info> wrote:
> > >
> > > Hi, this is your Linux kernel regression tracker.
> > >
> > > On 21.03.22 19:44, José Expósito wrote:
> > > > This reverts commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40.
> > > >
> > > > The touchpad present in the Dell Precision 7550 and 7750 laptops
> > > > reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
> > > > the device is not a clickpad, it is a touchpad with physical buttons.
> > > >
> > > > In order to fix this issue, a quirk for the device was introduced in
> > > > libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:
> > > >
> > > >       [Precision 7x50 Touchpad]
> > > >       MatchBus=i2c
> > > >       MatchUdevType=touchpad
> > > >       MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
> > > >       AttrInputPropDisable=INPUT_PROP_BUTTONPAD
> > > >
> > > > However, because of the change introduced in 37ef4c19b4 ("Input: clear
> > > > BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
> > > > anymore breaking the device right click button and making impossible to
> > > > workaround it in user space.
> > > >
> > > > In order to avoid breakage on other present or future devices, revert
> > > > the patch causing the issue.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Link: https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481 [1]
> > > > Link: https://bugzilla.redhat.com/show_bug.cgi?id=1868789  [2]
> > > > Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> > > > [...]
> > >
> > > Jiri, Benjamin, what the status here? Sure, this is not a crucial
> > > regression and we are in the middle of the merge window, but it looks
> > > like nothing has happened for a week now. Or was progress made somewhere
> > > and I just missed it?
> > 
> > No, I think it just wasn't picked up by the input maintainer yet
> > (Dmitry, now in CC).
> > 
> > FWIW:
> > Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > 
> > José, please do not forget to add the input maintainer when you target
> > the input tree, not the HID one :)
> 
> I see that there were several ACKs, but how many devices misuse the
> HID_DG_BUTTONTYPE? Would it be better to quirk against either affected
> Dell models, or particular touchpads (by HID IDs) instead of reverting
> wholesale?

fwiw, a quick git grep in libinput shows 12 entries for disabling BTN_RIGHT
and 9 entries for enabling/disabling INPUT_PROP_BUTTONPAD. That's not the
number of devices affected by this bug, merely devices we know advertise the
wrong combination.

Note that the cause for the revert is loss of functionality. Previously, a
device was just advertising buttons incorrectly but still worked fine. This
was mostly a cosmetic issue (and could be worked around in userspace). With
the patch in place some devices right button no longer works because it's
filtered by the kernel. That's why the revert is needed.

The device could/should still be quirked to drop INPUT_PROP_BUTTONPAD but that
is only required to work around the cosmetic issues then.

Cheers,
  Peter

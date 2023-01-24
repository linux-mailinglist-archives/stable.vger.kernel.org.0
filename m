Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F069867975A
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjAXML5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbjAXML4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:11:56 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB943909
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 04:11:55 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j17so11306913wms.0
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 04:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JTFl8KCFidacHzHAzwVR33OH+oMKyAXW2A3xkAdwji0=;
        b=J4p/cLsrWdEGqs5e2GIKxoafZOqNahTBFk6BgZsLnxL7fmcPX4CIUEyfS0lNksIPOz
         tL99btBZDSCY+Z6OVsL6gDGHPTQfoCIwikGl+Gs/JWbhheLuUT+XL5kSKG5QECnjvI/m
         TdHLPmmcLLlBCWYnUere4za7t2WAum8yvPnHFHL0YpIw3JNYTj+qpfB1kEIhnJ02PN2Z
         tyzBGywas0dmCuPktjapZ80gEwVuFsITMmYp92AqdU8bBKyVl1Y0+5bS7UgjqcZiB+ug
         sA6Vd6nrka1Bv+Ep5rTm2kGdSshGr47NYDnf9bTea3JeZUWtE8bNdlidsr0crCxjUE3P
         6R2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JTFl8KCFidacHzHAzwVR33OH+oMKyAXW2A3xkAdwji0=;
        b=RjMNsyEucnQRbZFCzVQws51cPpeE/OtcUmt0LOjQiSmxqcTekz1U+2na6MFGVU2fw8
         hke6MgwCG2NscM2U4e9b3p1nM5DIz1/h1vdJFJNl5nzX67FYVnD+pfAk8/5cDzplEy7c
         3XLrE0yDpFrWBc3B8ZrZYsOCtk5zEgbKKEnq6Uh/EKuSEQzPXp0FLWRDd1K47VE1zyNs
         8jVS6Rgkxc3j8+gZvtZ2BSMNgehMOT+T+0iUyKgzRoUW5WIfsedRQC58TaFvKpvKH05S
         FI0kcKi+eyoGLIXwifnvOTeTmfv3gHjFbFH1b51rL3siTfJbg11AFJIThPXDiqpS0GyR
         C5gg==
X-Gm-Message-State: AFqh2kr0iZ06iZPDtgqRyE1iykRrwyXWjRGbZPzx2CogPDyHWCbCNARv
        wIVBQWtgsjMOhfYpa1Pj0bmZDrSsghBjNO8c5sdBhQ==
X-Google-Smtp-Source: AMrXdXvetO6fQegu/4E4RSnpJxxq527M9OI7SPO8/UyHMUs6ms1Yv+difJP8RbF+w81HJdiHO+Ng2qi4y9UbEdoc1IA=
X-Received: by 2002:a7b:c7d2:0:b0:3da:facf:a0ac with SMTP id
 z18-20020a7bc7d2000000b003dafacfa0acmr1728900wmk.171.1674562314130; Tue, 24
 Jan 2023 04:11:54 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <Y89n98fRfTpLmPUg@kroah.com> <CAFJ_xbqMx8LsD_Ry70jnqVmmhyGjTFpA-Gv7SpRR21v3Djr1DA@mail.gmail.com>
 <CALFERdxxAt5+Y0nxbEieYSZX8YLTA9aogtGWLLZBEpGdbWxT-g@mail.gmail.com>
In-Reply-To: <CALFERdxxAt5+Y0nxbEieYSZX8YLTA9aogtGWLLZBEpGdbWxT-g@mail.gmail.com>
From:   Lukasz Majczak <lma@semihalf.com>
Date:   Tue, 24 Jan 2023 13:11:43 +0100
Message-ID: <CAFJ_xbrAVZDtXwe0Ku0V7b1xp580N+ao0caCRP1xiHBr11oKyQ@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Sasa Ostrouska <casaxa@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> If you need anything else just let me know.
>
> Thanks
> Sasa

Sasa,

Thank you for sharing logs from the working version - could you also
provide dmesg for the no sound scenario? You can also share them using
e.g. https://gist.github.com/ .

Best regards,
Lukasz

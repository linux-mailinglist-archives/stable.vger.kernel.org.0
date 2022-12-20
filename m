Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5AD65227A
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiLTO0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiLTO0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:26:23 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191BAB4A1
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 06:26:18 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id h26so11906659vsr.5
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 06:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dOTj4EKc4DtuiZEeC7kPyAapzOMSPLY5av1ZgnWFYWs=;
        b=URjdmIRpeR3h3kPCGuMWB46Qb6AeKarBtQuQr0z3itmqEsfYG8YgF1CyXzgprN3zgz
         yskU7RLRo3xI88jMG/JaXIQ4pfv/IbwOdD5AG6t2n4aiYQUzraubORsbiX3blEBYfRdw
         t/CXjlStdRZd6yQwlrM+QhExtut7jnhlndE89Zz7uBMUZGM0eEd7Gp4Xbp/G5BzPkjpw
         GPF4+DSuPuzwQmtIN+NecYTnynJIR1P4aZL2atFRQVKnMIQIjEJ51csAIrK+iGcLa40T
         D6HWDjqfbE8Z+ppQ0kM9wRraiJzPxC6A3CQpApIMUv6ayzDOy77GMLs/tGPWdzfOI4t1
         DUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dOTj4EKc4DtuiZEeC7kPyAapzOMSPLY5av1ZgnWFYWs=;
        b=37GJAPYrn41CdIE0kw7vXIsnYzxXYk4rbkxnIhYZlqwvv+9ZM1Nt+u8jbpfkplprq6
         Arp5RuypmkvHO2ato7hYnO2coVtfoR7Oz087SqmCxc6BUXgDy3I6Z/h9oGZMKHVfBEuE
         jD8zoi2f+kCW1Id2uaZIT2Dgx0tQA0jomgyyD1CeKpDAHd/WPTduJMI1zERTfPut+AZ5
         7WUiXt3lwtT8HDBZRISZSioogWvMqaBBJ/3MVorIOmIf+c0ZuSiLk94DbMUg1TI2YWsk
         09TgLvDDHVIqtjokuS5qQWvEWOGnlaxBFV+LERpUccCj1nBI4RHC1p+kcrOvjJ6b9ygJ
         r8aA==
X-Gm-Message-State: ANoB5pm6bZuJz6EMpL03jlTnJiFgPP1ooLJAuWqSF06pnR1+gr3+tnUX
        Ux21mf/O5dOZtAkrfqsARHI6KREZM9WmaHNlGFpKNA==
X-Google-Smtp-Source: AA0mqf5JjKIjeV+9+aHhQxj19YLPX6LE+tWVIFecY61JnDpk4xJOJkg+52bmreGQ8g5xpC6CGIush1JD5XH4IlUpNWY=
X-Received: by 2002:a67:f04e:0:b0:3b1:1713:ba11 with SMTP id
 q14-20020a67f04e000000b003b11713ba11mr21558567vsm.76.1671546377728; Tue, 20
 Dec 2022 06:26:17 -0800 (PST)
MIME-Version: 1.0
References: <20221219191855.2010466-1-allenwebb@google.com>
 <20221219204619.2205248-1-allenwebb@google.com> <20221219204619.2205248-2-allenwebb@google.com>
 <Y6FZWOC1DSHHZNWy@kroah.com>
In-Reply-To: <Y6FZWOC1DSHHZNWy@kroah.com>
From:   Allen Webb <allenwebb@google.com>
Date:   Tue, 20 Dec 2022 08:26:06 -0600
Message-ID: <CAJzde06et8qZPmu=zF13rJt8=v_etMjgTRhv9y75wdrX7doC0g@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] imx: Fix typo
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 3:23 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Mon, Dec 19, 2022 at 02:46:09PM -0600, Allen Webb wrote:
> > A one character difference in the name supplied to MODULE_DEVICE_TABLE
> > breaks a future patch set, so fix the typo.
>
> What behaviour is broken here for older kernels? What would not work
> that makes this patch worthy of consideration for stable? The commit
> log should be clear on that.
>
> In the future, it may be useful for you to wait at least 1 week or so
> before sending a new series becuase just a couple of days is not enough
> if you are getting feedback.
>
> So before sending a v10, please give it at least a few days or a week.
>
>   Luis

On Tue, Dec 20, 2022 at 12:42 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 19, 2022 at 02:46:09PM -0600, Allen Webb wrote:
> > A one character difference in the name supplied to MODULE_DEVICE_TABLE
> > breaks a future patch set, so fix the typo.
>
> Breaking a future change is not worth a stable backport, right?  Doesn't
> this fix a real issue now?  If so, please explain that.
>
> thanks,
>
> greg k-h

I will update the commit message to say that it breaks compilation
when building imx8mp-blk-ctrl as a module (and so forth for the other
similar patches).

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C852577099
	for <lists+stable@lfdr.de>; Sat, 16 Jul 2022 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGPSLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jul 2022 14:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGPSLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jul 2022 14:11:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BBF1837A
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 11:11:13 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q5so5733886plr.11
        for <stable@vger.kernel.org>; Sat, 16 Jul 2022 11:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qg21JsqTT7dIfuOPcGDzTRF7RP/qngJyPHwB7Xnsbfc=;
        b=Aoy7cggZmSqMk73k4ZpwpKcjvvVU8jcuCKWpYDvjk5QUfgqG8Lau80mC/YDS9YoZKH
         u7DLrp7j1GnxqRejLE7IQmRnw0Hla3PsRnr7yd+Bp+h/AIPLVvIHEDpDa+2q0HNDkjIR
         QpPylNhavRSsSAt1XkXu/OghsnnEFoToKwFrzhbidB662VShVpjyuObKKqUJ69DJFSh1
         0lZOabOfq7oVZGWDrMT7YvWDmQYbMt6XjW20kL31nGluJ1pULGgzmMlH6nVQjFp8rxT/
         Rgz/wnQCbfOk8u/oofnbMs2S2mrQfBxpnfTZtfSpwWQIfwi3SGcGEn9NNwPaofBvnanE
         vfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qg21JsqTT7dIfuOPcGDzTRF7RP/qngJyPHwB7Xnsbfc=;
        b=6sy8VDGarMu/f4STkO4N0tRUkCg3uJwoN2UzQmjhh6QyW22kpEEkmyX40aorW+HfM7
         mM3Qu2Qs+tuABgRqiHAUr5lP6d/XrnHG84XFtyo6rlCZsv5MpBV1NU685meKcDP8SA9b
         THeRQEJWnRMiccS2IF9+lZEVEkx0xUjvPtPDY0wU1boWAmCbuLmOQJSgVAlxLAIdPz6h
         1dlq6UMDnFcnFGpVlBtyvlnUAUPm9ouNhcewJhlWaK4tTVhlUOZVFV8lG493ZO/0ve6j
         rh/dQcsi+tZ3z8wB5DyPgkR6UHB3gkiLK6xwAcYA4OQhPMrMScotZWdhGN6F5LJyIx04
         CclA==
X-Gm-Message-State: AJIora9/lW/hJcd0M19mzVh/Z0QskQn37iqBG/iYLFgOWHdH7WuiW1hh
        uuMHBlEnJmkAAZ1dhgY+TvTkc/gxbpdVIaIhmbfzna7aioI=
X-Google-Smtp-Source: AGRyM1vBUyWrRJN9UI3s7yw6uOVzHl7v3Z2OwrqWJQiS+RC7hw6CoYBZXPPV9E1SqlrSMrQzv2565GZ+tM8A/ULqdqI=
X-Received: by 2002:a17:90b:4f4d:b0:1ef:deb3:eb0c with SMTP id
 pj13-20020a17090b4f4d00b001efdeb3eb0cmr23032813pjb.168.1657995072738; Sat, 16
 Jul 2022 11:11:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220715231542.2169650-1-ovt@google.com> <YtJHOtDQ4swTmxjf@kroah.com>
In-Reply-To: <YtJHOtDQ4swTmxjf@kroah.com>
From:   Oleksandr Tymoshenko <ovt@google.com>
Date:   Sat, 16 Jul 2022 11:11:02 -0700
Message-ID: <CACGj0Ch1wQnVp0k4EBujncGXW8UGGyprFh2ESeRt_5m2OL4FZg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix vm kselftest build
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sidhartha.kumar@oracle.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 10:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Jul 15, 2022 at 11:15:40PM +0000, Oleksandr Tymoshenko wrote:
> > This patchset reverts duplicates of two backported commits that created
> > exact copies of functions added by the original backports.
> >
> > Oleksandr Tymoshenko (2):
> >   Revert "selftest/vm: verify remap destination address in mremap_test"
> >   Revert "selftest/vm: verify mmap addr in mremap_test"
> >
> >  tools/testing/selftests/vm/mremap_test.c | 53 ------------------------
> >  1 file changed, 53 deletions(-)
>
> For what stable tree(s) are you wanting these to be applied to?

5.15, only this branch is affected

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D841733A04F
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 20:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhCMTYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 14:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234071AbhCMTYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 14:24:01 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3003C061762
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 11:24:00 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f16so11498706ljm.1
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 11:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fkMUwflg0okgtiiFHyBwNautlkx4oxTesZnPR+Zbdm0=;
        b=bSs9U8+fE70nTPl25+3Ah15euLoLlf6KJftxZU0Bk7mfBawqk4ClAgFvihRohYSlmf
         Q8cF7V7jozp1ZSnDK19SRHNVt+iv9oUAO1jA+nrFirHrwpiRa8mdMZuuUFq7BPWS87Wd
         gxP/e6JcYnycxahzA1sONPqIC7MV8++JX76Kg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fkMUwflg0okgtiiFHyBwNautlkx4oxTesZnPR+Zbdm0=;
        b=Nm9PmbD9An8WOJQQ3+eSjmHPU4b6FVCARCC7KrgDmz7evtvMBYUXUln1cx2GHdAeYA
         Prosh4F1F1lztd3IjOLgRotV6HmHiSHlMaFboHaro1Dl7TjfgzSkpXNcDllzexPmLQ/y
         g9HcnVdKOC8qZBiPD1zUMSlqItdtosfXdSLPxA7+P0tv+He3KYTuvZhfY7e8W7TfDQiJ
         Hsy0NxXnA/hog4iOwVd38GPcCgCsJpI5i97DEeTCxUerX8m8MEhRGRrur4EDsxtOW2OZ
         VjBZnHQ0g1m9Sysp0P10yqhryGIIPi/0IlNlPKcpn8nRduEO0+Bgf7PQ69zbrtYF66N+
         MosA==
X-Gm-Message-State: AOAM533h/N/gAZ5nlzZlgN3LUa9QcyhsM884WbIIqIDKAvLhbBIaES7/
        7PLhCgxHhdicmB7fTzp+DF/BhQTVQOYptw==
X-Google-Smtp-Source: ABdhPJzIfHHfecajgkNN0gs54xsG8nRSyZml9UXyVl9j36UGk4hmK6nVIPOc5dp8tUk5ihLexbRqUQ==
X-Received: by 2002:a2e:a48b:: with SMTP id h11mr5972725lji.492.1615663438176;
        Sat, 13 Mar 2021 11:23:58 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id k11sm2377113ljg.119.2021.03.13.11.23.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 11:23:57 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id x4so44023064lfu.7
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 11:23:57 -0800 (PST)
X-Received: by 2002:a05:6512:33cc:: with SMTP id d12mr3118409lfg.487.1615663436752;
 Sat, 13 Mar 2021 11:23:56 -0800 (PST)
MIME-Version: 1.0
References: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org> <20210313050820.EoPGLS3gj%akpm@linux-foundation.org>
In-Reply-To: <20210313050820.EoPGLS3gj%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 13 Mar 2021 11:23:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wht_gk_d9k+NZs7eJvBeLOQT4xGcykgaCRHuiQ+LbReRw@mail.gmail.com>
Message-ID: <CAHk-=wht_gk_d9k+NZs7eJvBeLOQT4xGcykgaCRHuiQ+LbReRw@mail.gmail.com>
Subject: Re: [patch 23/29] mm, hwpoison: do not lock page again when
 me_huge_page() successfully recovers
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     aneesh.kumar@linux.vnet.ibm.com, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, Oscar Salvador <osalvador@suse.de>,
        stable <stable@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 9:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> From: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Subject: mm, hwpoison: do not lock page again when me_huge_page() successfully recovers

This patch can not possibly be correct, and is dangerous and very very wrong.

>  out:
> -       unlock_page(head);
> +       if (PageLocked(head))
> +               unlock_page(head);

You absolutely CANNOT do things like this. It is fundamentally insane.

You have two situations:

 (a) you know you locked the page.

     In this case an unconditional "unlock_page()" is the only correct
thing to do.

 (b) you don't know whether you maybe unlocked it again.

     In this case SOMEBODY ELSE might have locked the page, and you
doing "if it's locked, then unlock it" is pure and utter drivel, and
fundamentally and seriously wrong. You're unlocking SOMEBODY ELSES
lock, after having already unlocked your own once.

Now, it is possible that this kind of pattern could be ok if you
absolutely 100% know - and it is obvious from the code - that you are
the only thread that can possibly access the page. But if that is the
case, then the page should never have been locked in the first place,
because that would be an insane and pointless operation, since the
whole - and only - point of locking is to enforce some kind of
exclusivity - and if exclusivity is explicit in the code-path, then
locking the page is pointless.

And yes, in this case I can see a remote theoretical model: "all good
cases keep the page locked, and the only trhing that unlocks the page
also guarantees nothing else can possiblly see it".

But no. I don't actually believe this is fuaranteed to the case here,
and even if it were, I don't think this is a code sequence we can or
should accept.

End result: there is no possible situation that I can think of where the above

       if (PageLocked(head))
               unlock_page(head);

kind of sequence can EVER possibly be correct, and it shows a complete
disregard of everything that locking is all about.

Now, the memory error handling may be so special that this effectively
"works" in practice, but there is no way I can apply such a
fundamentally broken patch.

I see two options:

 - make the result of identify_page_state() *tell* you whether the
page was already unlocked (and then make the unlock conditional on
*that*)

   This is valid, because now you removed that whole "somebody else
might have transferred the lock" issue: you know you already unlocked
the page based on the return value, so you don't unlock it again.
That's perfectly valid.

 - probably better: make identify_page_state() itself always unlock
the page, and turn the two different code sequences that currently do

        res = identify_page_state(pfn, p, page_flags);
  out:
        unlock_page(head);
        return res;

into just doing

        return identify_page_state(pfn, p, page_flags);
  out:
        unlock_page(head);
        return -EBUSY;

instead, and move that now pointless "res" variable into the only
if-statement that actually uses it (for other things entirely! It
should be a "enum mf_result" there!)

And yes, that second (and imho better) rule means that now
{page_action()" itself needs to be the thing that unlocks the page,
and that in turn might be done a few different ways:

 (a) either add a separate "MF_UNLOCKED" state bit to the possible
return codes and make that me_huge_page() that unlocks the page set
that bit (NOTE! It still needs to also return either MF_FAILED or
MF_RECOVERED, so this "MF_UNLOCKED" bit really should be a separate
bitmask entirely from the other MF_xyz bits)

 (b) make the rule be that *all* the ->action() functions need to just
unlock the page.

( suspect (b) is the better model to aim for, because honestly, static
code rules for locking are basically almost always superior to dynamic
"based on this flag" locking rules. You can in theory actually have
static tooling check that the locking nests correctly with the
unlocking that way (and it's just conceptually simpler to have a hard
rule about "this function always unlocks the page").

But that existing patch is *so* fundamentally wrong that I cannot
possibly apply it, and I feel bad about the fact that it has made it
all the way to me with sign-offs and reviewed-by's and everything.

                  Linus

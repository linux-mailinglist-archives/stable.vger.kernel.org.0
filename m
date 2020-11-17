Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEC72B6D41
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 19:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbgKQSYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 13:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730650AbgKQSYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 13:24:21 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD381C0617A6
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 10:24:19 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id u18so31418182lfd.9
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 10:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvUf4J0DFW1w2WtJ3V6+jniQAPhY7yyvFEspsD/tJmg=;
        b=PEkPOajtdsc4vIPnzM9bVRVqYkht1WKu9HytymEE8l1JV5LOIEPq4BZ4U++e/c0KUw
         gwT0H1upKqxmypmrqpI9U3ggwpq1tCugR4BokqmJbZUSWy5UvZT3kY0Gec7Lk89ev35b
         zSUKO3Tk9zzocvLF3Nc/ui5aJ3U1f2I/TBi5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvUf4J0DFW1w2WtJ3V6+jniQAPhY7yyvFEspsD/tJmg=;
        b=Vgg+pLXO+EIny/vWwUs+fSncPIXsCDERaJBglFcnBKuB7D7mQI9w2Sgs4xnboy1iEy
         9Y7m6sgesMBoIWgXjgIv7O38RIu/4P7yYHLE3n+4pa90dE7CTorSlQo9SnAv9d4brMFz
         w/+Jk0+PpVUkj+4ENbNt3zRSUH0KE0TM+sxKbOS6bRKJilEiobsUjs1Z9+mswjooXMtP
         dzhOQ2JZmvwYQXSMJM4rEai0QFO3y14jcmGthAEjJAiwsjgjmMMDvOCO5bEus+q9r/li
         4+BvJEXMTKDnXrOIVBY1o5FHGrJfFfjZ8yspe467KnAal6HxUC+n6nrGhWPjIQGOUpWe
         zPPg==
X-Gm-Message-State: AOAM530OCEbBIbetCvWkC/eVyPcDtfsPWqyzlUDTxq/JIxTdT2cdRMIY
        svbDz5oIMSWSO2tubCAEAPW2CMeV1RyfCQ==
X-Google-Smtp-Source: ABdhPJysc5Ru5lWkC+DC6yHwGMnBPHZ0qhWlf5KYQNM2lRNvmaDxzr1qMe10JO5W6jRLfLsvLHerCw==
X-Received: by 2002:ac2:4a79:: with SMTP id q25mr2016105lfp.495.1605637457722;
        Tue, 17 Nov 2020 10:24:17 -0800 (PST)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id o4sm3238225lfo.229.2020.11.17.10.24.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 10:24:15 -0800 (PST)
Received: by mail-lf1-f43.google.com with SMTP id u19so25229793lfr.7
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 10:24:15 -0800 (PST)
X-Received: by 2002:a19:c301:: with SMTP id t1mr2049940lff.105.1605637454918;
 Tue, 17 Nov 2020 10:24:14 -0800 (PST)
MIME-Version: 1.0
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org> <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org> <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
 <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
 <20201116174127.GA4578@infradead.org> <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
 <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
In-Reply-To: <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 17 Nov 2020 10:23:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
Message-ID: <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in ima_calc_file_hash()
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 10:35 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> We need to differentiate between signed files, which by definition are
> immutable, and those that are mutable.  Appending to a mutable file,
> for example, would result in the file hash not being updated.
> Subsequent reads would fail.

Why would that require any reading of the file at all AT WRITE TIME?

Don't do it. Really.

When opening the file write-only, you just invalidate the hash. It
doesn't matter anyway - you're only writing.

Later on, when reading, only at that point does the hash matter, and
then you can do the verification.

Although honestly, I don't even see the point. You know the hash won't
match, if you wrote to the file.

           Linus

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC446D2C
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 02:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbfFOAY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 20:24:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39783 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfFOAY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 20:24:29 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so4039587ljh.6
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 17:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aK7lUvYVYd4MHzc03gl18he+PgV3Hkk9KuzGz+vIyo4=;
        b=e5ZS2eb2pZskGk1t2DAfftIR2H6ohKVnchU3giQkQVAHGxWxwBW20eLh5ZsUiCGGME
         6sw8frLd89Po3z4XAfZ9MbD/TJit973JCdkHd51Y1T1Uq4vgc81VpJT6f+zyKtfC0mDs
         rLEOUzr6pgcKa2PubqoFxZV/FYtmA1r3D0rKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aK7lUvYVYd4MHzc03gl18he+PgV3Hkk9KuzGz+vIyo4=;
        b=FRIH4EpFH3ytKeMtCEyKWhQQX99n9dkNHJ/0lsr3TjiqLBcuXjjn/VnAqJTDNqD3OZ
         RHDbAOSLxNiWk9Re4WTxgPSI4AXjtl4pYUR/NsKRomJDwQJyVYXvVELYkxQh1s9CjV8p
         no04iABZV7cKwMjV1Ln85jMrIA/HjJDnzDoK7FcBeZUw+kzDAvwvO48aDqyBuHGr4LFs
         YhpHQA71PpZV2JZGq2dfKb0vhXx8XfohWo8SCbpLDJN4uZcUgN8zNWHNZx8hY1AlPPo/
         pxgrCCwQYDliMTeR2jRtT+LWd8rkrHxxRXhMLuYcD+KINbFZaYxgOGSL4kFF6BSa1T/y
         /yig==
X-Gm-Message-State: APjAAAVAQDVQrncMZwXXqIu+sgdSDGbYUVZw6ZR0Nr3MOqJ4L9SqDlB4
        LTb/PG0FSVNxeMqC9y51hjeYEDiMojk=
X-Google-Smtp-Source: APXvYqw6BerSsie359La7PAB5PgPDtvoGbv4Zi996dqorKNcgX0EdQIkeVFeaQI85sYXNqyvyD7ngg==
X-Received: by 2002:a2e:9bc6:: with SMTP id w6mr9217877ljj.156.1560558266924;
        Fri, 14 Jun 2019 17:24:26 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id d5sm667900lfc.96.2019.06.14.17.24.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 17:24:25 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id y13so2827444lfh.9
        for <stable@vger.kernel.org>; Fri, 14 Jun 2019 17:24:25 -0700 (PDT)
X-Received: by 2002:ac2:4565:: with SMTP id k5mr45739644lfm.170.1560558265318;
 Fri, 14 Jun 2019 17:24:25 -0700 (PDT)
MIME-Version: 1.0
References: <155930001303.17253.2447519598157285098.stgit@warthog.procyon.org.uk>
 <17467.1559300202@warthog.procyon.org.uk> <alpine.LRH.2.21.1906040842110.13657@namei.org>
 <6cfd5113-8473-f962-dee7-e490e6f76f9c@schaufler-ca.com> <cb3749a6-e45b-3e07-27f9-841adf6f4640@schaufler-ca.com>
In-Reply-To: <cb3749a6-e45b-3e07-27f9-841adf6f4640@schaufler-ca.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 14 Jun 2019 14:24:09 -1000
X-Gmail-Original-Message-ID: <CAHk-=wj8VCxjwyd_BDgRtDigik5UdizCZP7PU4wUtj4vHsEWNw@mail.gmail.com>
Message-ID: <CAHk-=wj8VCxjwyd_BDgRtDigik5UdizCZP7PU4wUtj4vHsEWNw@mail.gmail.com>
Subject: Re: [PATCH] Smack: Restore the smackfsdef mount option and add
 missing prefixes
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>, Jose Bollo <jose.bollo@iot.bzh>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 1:08 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Al, are you going to take this, or should I find another way
> to get it in for 5.2?

I guess I can take it directly.

I was assuming it would come through either Al (which is how I got the
commit it fixes) or Casey (as smack maintainer), so I ignored the
patch.

                 Linus

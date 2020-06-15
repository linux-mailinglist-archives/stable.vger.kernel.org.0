Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406EA1FA013
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 21:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgFOTTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgFOTTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 15:19:08 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07FDC061A0E
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 12:19:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id s1so20603835ljo.0
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 12:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FMgKYOjVhUBuTcnQ1AyHE4BtQ7tCVAL8UZn7yy+xmgk=;
        b=Ku01HuK0gBj949mUMZFHpP3o+Lo6ocyc8TLpiY6Njw7TCEYhMiApdxFGqwPw3hsp8g
         P1f/1ziVM30i6N2+An+S+RH7rfcxlJmwzRGT5feGKEhsr6BTdgkI1RuXsQ/zi4WagN/5
         Vanz7hYJP1sLHId5EcFKIQ+tPyUxzaqQ6wdFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FMgKYOjVhUBuTcnQ1AyHE4BtQ7tCVAL8UZn7yy+xmgk=;
        b=oUcPDzYMCx5V6/B6GT4dZ91PlxQFxnu6cN4XPGo3z3SrRhJIM/Ry8rOHl8Ia2iqsG4
         kbSaqe8BQLDupPoNrHC4UXKmgYIDVjNpkBbNb1UYshxlHIwldYmZn4yyHlJxSL2AGMaR
         wFdJCGC7NM7u2lKltmepb4GeEuzC49vobeoTRlojRLV4PLJL5rFy0vovElctK3GdOqhV
         m+fJjeWEMW4qNGOmccmhXoa24aNhYta8PgDABIvwwS2q4SJNMPQbPM8ds7WzkNy5j5Pa
         l1oSX7dRMgxKkQqCoLOGPBgH/rlT3TJYuMiPwySBGXFqSUX2UT8z8qzbflBDP2q1OFuT
         QTVQ==
X-Gm-Message-State: AOAM531h7xOHeKbBU6nx5wMbDFDYl67JLGywd+ehXn7H8tEcEPSTMHLp
        dhWqoy2g8qwbrMWaxf39vkbgsnSGXH8=
X-Google-Smtp-Source: ABdhPJw/w3qjc1q9+THCdxygIKPdpXbQr/F8YxEVI3xAVayT74DdqcRY+ard2F1AOmUkDJxsf6h0ZA==
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr14474162ljc.403.1592248745015;
        Mon, 15 Jun 2020 12:19:05 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id 23sm4723077lfb.1.2020.06.15.12.19.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 12:19:04 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id u16so10256668lfl.8
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 12:19:04 -0700 (PDT)
X-Received: by 2002:ac2:521a:: with SMTP id a26mr1384648lfl.192.1592248743827;
 Mon, 15 Jun 2020 12:19:03 -0700 (PDT)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 15 Jun 2020 12:18:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj-RATn3dNoBWgYaCSJGWotz3cRHFqWJwK-6GOLJK8o-w@mail.gmail.com>
Message-ID: <CAHk-=wj-RATn3dNoBWgYaCSJGWotz3cRHFqWJwK-6GOLJK8o-w@mail.gmail.com>
Subject: Please add 17839856fd58 to the stable queue
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 17839856fd58 ("gup: document and work around "COW can break
either way" issue") is a real fix, but wasn't marked for stable
because I wanted it to get more coverage testing in mainline first.
Not because the patch is all that complex or scary, but because I was
worried we'd find some odd case where it would make things slower by
triggering the GUP slowpath much more often due to people doing odd
things.

It turns out my worry seems to have been misplaced. The kernel test
robot did indeed trigger a case where this made a big difference, but
rather than being bad, it improved the odd corner-case test-case
performance by a factor of 20x by breaking the COW and triggering the
fast-case code that way, rather than the other way around.

See

  https://lore.kernel.org/lkml/20200611040453.GK12456@shao2-debian/

for details.

So that commit fixes a bug, isn't expected to really make any
difference on any sane workload, and can apparently help the crazy
cases by a huge amount. Let's just push it to stable..

            Linus

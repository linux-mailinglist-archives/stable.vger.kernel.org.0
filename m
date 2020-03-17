Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B8D188464
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 13:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgCQMiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 08:38:25 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40243 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgCQMiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 08:38:25 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so16987483lfe.7
        for <stable@vger.kernel.org>; Tue, 17 Mar 2020 05:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RxvspXpJnT1wLGWC1yqAwht7wPofjiDL2MZ2V4GJU0s=;
        b=hnj4sEry8e72e+4XxcViMh2kR/clVi9rs+0bXE1Bk+1jnM9tAaTyTvgL4uYk9HGokQ
         CS6JmX/z0c6hGZP4+/nsjdwrRToHL2MnmrEP2s5tbTN6meK7gab1DE86o95g8btZIabJ
         X0Nb39RB/DJ0JWjBmqOkl9uU6GNs9+S6/0dZvKl3+nAxc/hPOac2EFucKTzFdRe8iZbM
         pd2Cz/K1I/XtSdYirkd2zkc5FVQnbLpfFYWuWeR4JcwrggK69xvkfXK7qVwpyd+zrveT
         XkUuyowMJlxJdZtfXDBqIGaPNwQ4N/hPoHdbjT/raGV9/FQs/kLHLi9N8GnTZjdSG/jt
         rWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RxvspXpJnT1wLGWC1yqAwht7wPofjiDL2MZ2V4GJU0s=;
        b=QsPTD0lQ5WN4oMusUot2Yi7F2kDPjU9LZllyDSmWeODOKf+VnEHQaV5sztNWGDRupR
         tp/4G9C5KzvfaeenLyF8zHg/q9RyYfG3dEDqDLF3cyZuUpn2Sk2ZQGn7TaqqZviH9QHJ
         hyQ+BSb5z6o/VgFqDodfQ/d9UxR0A+Taaz/T0GcuzCUnszGS5x9zuxvTmPmYiAs87dbB
         /SGsVWBQOw91BDifpaapD24lDxBGRaXYmpVfESqfB9p5Tk8g+Xdi04L0KQRSCxyESaDL
         HNXPZ8/RtXI3V01JQR+Puz/hkn/S7sIK3ppANP6rBtYN6IOqcQuVaZuknnC1NR6fyBol
         +N1A==
X-Gm-Message-State: ANhLgQ38QFl5/BkVYEs+FGn3oHtHUGqqbLb/ywj5wS85Frvfyt3vk15o
        +Pk3aDJiPHocEVjrpBO0vPWGP793usMGTJLkOnCE6w==
X-Google-Smtp-Source: ADFU+vtpPO/SB7g4ehk7qTFyPKse2g7Gmfi77CZPwCuVUbJVQI6d70Lf5FyUoeDifSP8iaSTW1v77WW+rDocRRRH0SY=
X-Received: by 2002:a19:6502:: with SMTP id z2mr2694078lfb.47.1584448702419;
 Tue, 17 Mar 2020 05:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200317113153.7945-1-linus.walleij@linaro.org> <87lfnzdwrf.fsf@mid.deneb.enyo.de>
In-Reply-To: <87lfnzdwrf.fsf@mid.deneb.enyo.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 17 Mar 2020 13:38:11 +0100
Message-ID: <CACRpkdY8uLVrT5=NMpNmKhgmqu=yT_Bgc-Q9-BR6NgRFjnzjFQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: Give 32bit personalities 32bit hashes
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 12:53 PM Florian Weimer <fw@deneb.enyo.de> wrote:

> Just be sure: Is it possible to move the PER_LINUX32 setting into QEMU?
> (I see why not.)

I set it in the program explicitly, but what actually happens when
I run it is that the binfmt handler invokes qemu-user so certainly
that program can set the flag, any process can.

Yours,
Linus Walleij

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838EC12FCF2
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 20:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgACTYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 14:24:04 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41687 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbgACTYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 14:24:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so44864243ljc.8
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 11:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OFXcXk/rWc+vZDd2lXOSRdfqK7Rx+9AcujMvsOnCZcQ=;
        b=H1MIzm6Oi4jSBscmLV49r9Nd5HT6nc6bvrco9VvwbKlzMSopWLEIAGe6hSQb7cvv9P
         cip/Cxk8S5U7lhfpRoBFf8HeyyrOu6N9/Nrl1mnD3DgILx8h5/RFBbeGmAVeWDKR8rbY
         hm/i7+uHQDHv5J8iclqo1WiLmqKxGLcnr6544=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OFXcXk/rWc+vZDd2lXOSRdfqK7Rx+9AcujMvsOnCZcQ=;
        b=uWULyyR9ZIve1Yf0YuZ4n0uLuryi+69tzy7XJLb8WamIp8Tfo4Ru7J2o4L8pwkIR/8
         j+WvIzm8b2AIQ/JHjX9OCPSuLGcw5PDvZZx77V2PrUTHd0r8fRULP4GhHx6SMLFcdPdA
         FVv1DM3H6PhZCICfoo4gKbanT95ldWdaSmBTzzxF1Em5oij/Vr4TkewPlcbWaGOrnokO
         OgA38abXVGAiLD3nRxsfDiaqfzKJdVl1CXhVbPgvVot5p3fIYHwY6wjFPJKDna7GaX/P
         C8U3M//0IrOvuPHx1nq8j16VBuU94nvj35jvQkxyYbl5YY8QBNS3MXjdmJpBtW9Fq+m9
         XSvQ==
X-Gm-Message-State: APjAAAW1PdUTUeSk3OllvV0nPiV2mn1m+iq0rU8Hop3avIDMJbyKETrk
        6WfWG5ZerxXoTWs1TRjUMinciEQsmhA=
X-Google-Smtp-Source: APXvYqy0tzHF1B9s+WTQkeku1/gqLGYsWh4FeTLN9V+zd1wD4CixGtA5vJ6dQY5THwNe0/zcBHmoDg==
X-Received: by 2002:a2e:7405:: with SMTP id p5mr53837298ljc.34.1578079441960;
        Fri, 03 Jan 2020 11:24:01 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id d1sm23529204ljl.18.2020.01.03.11.24.00
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 11:24:01 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id l18so24342344lfc.1
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 11:24:00 -0800 (PST)
X-Received: by 2002:ac2:465e:: with SMTP id s30mr51941142lfo.134.1578079440587;
 Fri, 03 Jan 2020 11:24:00 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org> <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
 <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
 <CAK8P3a24EkUXTu-K2c-5B3w-LZwY7zNcX0dZixb3gd59vRw_Kw@mail.gmail.com>
 <20200103154518.GB1064304@kroah.com> <CAK8P3a00SpVfSE5oL8_F_8jHdg_8A5fyEKH_DWNyPToxack=zA@mail.gmail.com>
 <a2fc8b36-c512-b6dd-7349-dfb551e348b6@oracle.com> <8283b231-f6e8-876f-7094-d3265096ab9a@oracle.com>
 <CAHk-=wjvWTFn=C3mT5wA=mtOwXw44U+OHLVxk5DCe4v+7nOvKg@mail.gmail.com> <c5c3b8c8-1dfe-2433-630c-06dbfb3d318b@mageia.org>
In-Reply-To: <c5c3b8c8-1dfe-2433-630c-06dbfb3d318b@mageia.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Jan 2020 11:23:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgV_YN9az2XBX=xr_DGQiUEqwjtMXkmj-w12j58NQxneQ@mail.gmail.com>
Message-ID: <CAHk-=wgV_YN9az2XBX=xr_DGQiUEqwjtMXkmj-w12j58NQxneQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 3, 2020 at 11:11 AM Thomas Backlund <tmb@mageia.org> wrote:
>
> Does not seem to exist in public git yet, maybe you forgot to push ?

Not "forgot", but I've pulled a couple of other things, and done my
usual build tests etc. I tend batch up the pulls and pushes a bit,
sorry for not making that clear.

But I've pushed it all out now.

           Linus

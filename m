Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F065ED8A
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 22:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfGCUcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 16:32:10 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:37885 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfGCUcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 16:32:09 -0400
Received: by mail-qt1-f171.google.com with SMTP id y57so3404357qtk.4
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 13:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sWaWgbwKlJOeYyoqsb1vlz9ot5Q1bPSdsRLavMMfewA=;
        b=KozrphQwmyTabOqTKnnWRhUdupsYqdV762kuThSxG3pDlG+HiJc+IpkZflTpVkqMHS
         zgYGfvPoOpxdMlKyN5aoAnzAAzI718kHJ75t8tppseN1Yra55Y0URvle5aUFhOBrqI/J
         f8uNXu5Avc62k0NrQO11GgPOxIe4gpa7Lnxo6WuWaZK5qR3W7RXzL7DiCY9PIvQ8ShuA
         gv3aggw6wwaCeG3x8Sc4PrMTqk6b7fr0xh8Xe0DT8R6yz2mJdxAbHlropUD8THpSuwLY
         /ohGZZPiwSJQh2nvzxQGWVNhgZJdtYBJZAyrJG7JKNhR9bBlkrSF7G7q81q0QIdARs8W
         8Jeg==
X-Gm-Message-State: APjAAAVSg1CpzQRgFlk7lZV5VmAOzGG5x9/EKhzMIRtKg9iCM06z0e1a
        5JocUoYbRO6PYtvmUBTZAJMC8cCEByp3pAz5DXwqw6CBtQo=
X-Google-Smtp-Source: APXvYqwpJGe+bPbLX9AAv1KT3ptpRxgFQoabyLL8qISMkE2rTrX/TkHcMDGIxA+yH1P8shv7UxnRuzs+KWbEp4qtjbg=
X-Received: by 2002:ac8:5311:: with SMTP id t17mr31488022qtn.304.1562185927989;
 Wed, 03 Jul 2019 13:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
In-Reply-To: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 3 Jul 2019 22:31:51 +0200
Message-ID: <CAK8P3a3M7cuxPeoZrNKaQGayg-Q6-UH+JEN4gsMDNxa9SWBpUw@mail.gmail.com>
Subject: [STABLE-4.9] proposed backports
To:     "4.4.y backports" <stable@vger.kernel.org>
Cc:     gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 3, 2019 at 10:17 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> I looked at the kernelci.org output for 4.4.y and found a couple of
> patches that need to be applied here:

Here is a similar list for 4.9, from
https://kernelci.org/build/stable-rc/branch/linux-4.9.y/kernel/v4.9.184-66-g79155cd391a8/

8535f2ba0a9b ("MIPS: math-emu: do not use bools for arithmetic")
02eec6c9fc0c ("MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()")
173a3efd3edb ("bug.h: work around GCC PR82365 in BUG()")
993dc737c099 ("mfd: omap-usb-tll: Fix register offsets")
5464d03d9260 ("ARC: fix allnoconfig build warning")

      Arnd

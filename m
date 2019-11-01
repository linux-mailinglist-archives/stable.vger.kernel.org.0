Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FADEC8D5
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 20:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKATEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 15:04:39 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41472 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfKATEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 15:04:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id o3so14249220qtj.8
        for <stable@vger.kernel.org>; Fri, 01 Nov 2019 12:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhqExbZh5kPvj3K4NZnoOcF081VOsziHuz7IlqtxrcQ=;
        b=pZeGw3P0RHdQki9K0gEObnP8OHglDuZpmvPq+OFKsU6xgeQL13BnAHlulP/AXJaNhH
         ZwTok1P9GNkau5IjixzgvwHoRsMHZDO4mQHl58gONYUVmICu+ICmGAtlNEveE0COrV9y
         /Xa/uFFqFErQaCPkaMjXEPyOF3xZXKviJzxY5RswiEk3RU1cFRsNAAq86vhLr+M4iejN
         DUSzb9XHpmVLLc2pvB9NkEKqyofyX55556V+I2ArroDUo1pUEBLty4g6IEse0WyTjh8w
         PDU5nOG+jTcNTKTvoqF9nxDfT1BF6OsABjs+f7dv3bSZ1ICuWpkn9uNUWSuindYPhE30
         ehAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhqExbZh5kPvj3K4NZnoOcF081VOsziHuz7IlqtxrcQ=;
        b=cJ30TJiuW2GfnS+C+LhW1JWI/s2370mH7PCHW9lgST0iSLkRTkRfRwsOu2h/Arn7bc
         UmTf+4WL/P3rqPBFV50dK/bYyS/tIP/MJSBEVzJwZte3YFV48Kk5cMe6ONSi1XlDbiyn
         IGtSo3TKh/drSof5gb2FAmzjJiuWTxHUDJCrsiuVKxDMZ27hxszLR3Q1zRUU198IrcpU
         ZZ3eOnzaI1hIHsmnQBz9iJeIJ5mRtjxWrqM8dHJdOU5WplFIeX24vKIj7kDtLui71k3g
         XRQZJ5TIAdtQadvKwF6ik8CP7m0Obc6zVLzdGhY/QZC5oIQNBBzRmwuoL/GOlxsKiUSK
         xvcw==
X-Gm-Message-State: APjAAAX3wDQ+3+FjC9Zorai8dRV0iQ8SKD4/L/GL8ZkSASfL2g8eTxeK
        TIkR5MwZWQ3KiGQpK5XTjVQtvPkfabvstWpVG7wE5A==
X-Google-Smtp-Source: APXvYqzaVfaVFf4/E1qtu06OCKxRakja8j6eb7eFWaPT90bJMEaqpKJybo0BQto3pfGWV02Havz8W/MP/51N1VZFBBk=
X-Received: by 2002:a0c:c392:: with SMTP id o18mr11435117qvi.75.1572635077831;
 Fri, 01 Nov 2019 12:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=yYwmQHyp62qKDoiM091iXKs5iP8rNBLs9kc7Wi_PDCgMrbw@mail.gmail.com>
In-Reply-To: <CAG=yYwmQHyp62qKDoiM091iXKs5iP8rNBLs9kc7Wi_PDCgMrbw@mail.gmail.com>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Sat, 2 Nov 2019 00:34:01 +0530
Message-ID: <CAG=yYwmYCLOktQxhsyjarybbR+aF2Z3RuXVj4hfE5wD_6nJjNA@mail.gmail.com>
Subject: Re: PROBLEM: PCIe Bus Error atleast
To:     ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 2, 2019 at 12:15 AM Jeffrin Thalakkottoor
<jeffrin@rajagiritech.edu.in> wrote:

> But i think when i tried again today i could not reprodu....
i do not know why, but now iam able to reproduce the error

more details follows
---------------------x------x------------------------------------------
GNU Make            4.2.1
Binutils            2.33.1
Util-linux          2.33.1
Mount                2.33.1
Linux C Library      2.29
Dynamic linker (ldd) 2.29
Procps              3.3.15
Kbd                  2.0.4
Console-tools        2.0.4
Sh-utils            8.30
Udev                241
------------------------x-----------------x---------------------------

$gcc --version
gcc (Debian 9.2.1-14) 9.2.1 20191025
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

---------------------x----------x----------------------------------

-- 
software engineer
rajagiri school of engineering and technology

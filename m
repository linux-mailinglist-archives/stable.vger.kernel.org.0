Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23CC1557F7
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 13:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgBGMwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 07:52:33 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33090 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGMwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Feb 2020 07:52:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id h4so2084828qkm.0
        for <stable@vger.kernel.org>; Fri, 07 Feb 2020 04:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=aPqo1sMAZbMFiJ7xBkS2/H+/WQt5QI/MJP3L6PssMJU=;
        b=UQGk0AZYMElOejpmqbMzvL6bHPsdlpDPXI0hgkjsB2rSKzHVhBcITs3HbfdQA/IEcc
         U3ncJWfrkMV+9YSvYSSGbb4xq5JfIy8w1vWBGCMkS3w6A9D7YCnxNOEEsp/AIUWwz4A/
         sZ7crdgo3hXVzxu7CrhXjd0c7LMu9aweOAPeB/gJEv9VXnY3jAT2C+FOAoLz1mX++TVh
         8ecX2cHkdb1KPPxJsmiBWqvo1skwxRzKwOPqqMqnCq3NWFyoLhxMAG3lDOrUAGyjKwDv
         NSeJWLS4B5xcjmzTkKvAHE81Bs/a3LIivk+BuWXglayBja12fRVMnpG4Z5bpgRMvqAwp
         wChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=aPqo1sMAZbMFiJ7xBkS2/H+/WQt5QI/MJP3L6PssMJU=;
        b=KvutHi1DyJJN6CIXZ8hszstOrqUFGmFMDUaZ/NK7E2khgj4wppXQjDbYrpZc/r2C5w
         reV1DHMbmTebAgSPWa6Jp/3Ql1fd6QLkqNzInZl5dY6VjJo1TfQZyTE1I5l4bRhtv3sS
         HyfQG8OemQv262RVIjyjiLxIOowvIqRf9GJwuWQ89ZPObnKjEwmMyl3x2g9eq8JxvY9O
         Xg8w1W4dtY69vwBx0D8AhVWCN63QNFJACPjadZdAkZyO6eNvJ+N5Ez/4xrq8ElZGklWb
         G+wvQ8D/PI3S8ehhtpRjJBOAgOnbRS8sbCILT+qkpzhDo5NYU6EcnxOQZdAizLapzn/M
         X/ig==
X-Gm-Message-State: APjAAAUk+6IiuZcbeYXV+DlfsbzYv3Yb4cX8NbH63j2oGo6ckv7Yrjfi
        ztIfkKRoRXN1n9pqDncANZQEFUfDrACgFhBECfXI5b7G
X-Google-Smtp-Source: APXvYqyuNXPh0Rdf+EQodYDJD815szqq6gnsmzxyMjIJlaNEbGQVBcUJPVks1O2l/U/77vlzCL/FE5WvK/iZRHvaCk4=
X-Received: by 2002:a05:620a:1fa:: with SMTP id x26mr7061231qkn.311.1581079952071;
 Fri, 07 Feb 2020 04:52:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:c24c:0:0:0:0:0 with HTTP; Fri, 7 Feb 2020 04:52:31 -0800 (PST)
Reply-To: pbarthelchambers@gmail.com
In-Reply-To: <CAG6Cp80pz89Z01UFiE3LBX-eNFdZf4Zre26kJa6h62ugKe+XAA@mail.gmail.com>
References: <CAG6Cp800gw-bAha8J-PgdHedhN9h6V+H9=3rAkGXdkmDSdzWPA@mail.gmail.com>
 <CAG6Cp82uRt2kBc_MpQBqTT7nw8K3Qu6wAKRXe1bgv=_02tW5Qg@mail.gmail.com>
 <CAG6Cp82zNE5SNUk4_=J=pPGGBKPi8Mzmg0ABtc0YFOdavVJiaQ@mail.gmail.com>
 <CAG6Cp81J4cDsKLoRiNTReqjBU4Lapprs_Dd9ovaG02_oAWjQGw@mail.gmail.com>
 <CAG6Cp80ExqAwwjDbktdTyjJtjuMKzY0mbynuS72ZUExa=mZy+Q@mail.gmail.com>
 <CAG6Cp80muUZYy-i6Jz82QHeFZWY9xLLFq8aHmTXKw6zDHjrqbg@mail.gmail.com>
 <CAG6Cp8230kGzN4cYemmgA_nPrAc5ozfXT12XySeWpQc7eGH+_g@mail.gmail.com>
 <CAG6Cp81bgRonDwHUNi88P2XebCx81N0SC6p2RVadqWXJUMhxYA@mail.gmail.com>
 <CAG6Cp81AfVdzRZLH_TCcZBKRUuf6psbQeNN8dNhdJsA0pcb-VQ@mail.gmail.com>
 <CAG6Cp82k0CzP6ffXOD2T4yEWUDmc4oGg_TTzSPOii_NLozOfiw@mail.gmail.com> <CAG6Cp80pz89Z01UFiE3LBX-eNFdZf4Zre26kJa6h62ugKe+XAA@mail.gmail.com>
From:   Philip Barthel <sgtalvessarment@gmail.com>
Date:   Fri, 7 Feb 2020 13:52:31 +0100
Message-ID: <CAG6Cp83GSFyV357386LpCFSUVe1_6bcC=SYRV-GsSdOTwKAiwg@mail.gmail.com>
Subject: Fwd: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please contact me is an urgent matter that need your attention.

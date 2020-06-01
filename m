Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FE11EA297
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 13:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgFALWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 07:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFALWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 07:22:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AF0C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 04:22:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id d6so111931pjs.3
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 04:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=qtDWGf61BkYn0rf7nuasMYebJPjzmC1Cp1FevqBC1TL0r6GUyYDQ723icQf8IfG1qO
         7z0OGHJJTg/s1eMnNQkQQfulLFFJyPqnwHO97diOnppJXecdxVzFu2skPw9+1rfJmwR5
         zHWuN537ZcLQV1fPrPDJznpUtYrIYOrL1mHrIh1gmI77O8SBLOTYcvvU0TXDJj+r+qCf
         yu3y4egpbbh8DXhLoY/Nh3/lFqPOE+UNoOo9rMT5jWI82A5A5D0gTAC9FDGIP/EhK0l9
         oZiCIXUMFrxgY/x/7NuFUU80H0Uuzo6xpkQguiL5JJiRUiY5hiMzHl2jUT7i+xvSfkmU
         J6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=ueux+cNgPJMPKzLDVj/54SdGO0PK7cylFSNlpmLPxcLmFVzE4VDZOUBlH1yS5f6kvF
         rx8PVSPpyEuNKkQ/9O/2PW3BPo2dXXBhTlCR+QNqUYECyd4yex83g+9cBJ2wsMysQMZ5
         b3fw3TDC7pfJ7a9zjWg0lcF9HMBioF9Gv+LD6yFE/bbAJyYdDINwH+AyjyNH6c/8dtxj
         g3RktNpb/ycRT4EVJU+lbGDXoRgT2fFMl2oGJ68ke+OQt9jEPmeE0ly7whxDfLJHAqUi
         tUyanobZ3s1rlnhX+4u66MP7IJgua4j+F4PGFAiwu46o1yGR4e0/KcSURrkk1MirG0aK
         C87w==
X-Gm-Message-State: AOAM5318NwSulJl51RDEHWqDKiNWv7BFsrcGYpYFllLwc1qT9IN2ae4t
        GvKRLH6RR1K8tZBHOkfQ9NCqvqb15UHMFo/R2M8=
X-Google-Smtp-Source: ABdhPJwDQ9xm/vzcRXrkqENna+ZNC90cfOCupShXbH7w9BKrC14jr3C5onPLwBphvcBfCAYjNyGmls9rg9em0YVoeXg=
X-Received: by 2002:a17:902:b710:: with SMTP id d16mr19926433pls.28.1591010573245;
 Mon, 01 Jun 2020 04:22:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:16c2:0:0:0:0 with HTTP; Mon, 1 Jun 2020 04:22:52
 -0700 (PDT)
Reply-To: robertandersonhappy1@gmail.com
From:   robert <ehfoukoh1023@gmail.com>
Date:   Mon, 1 Jun 2020 04:22:52 -0700
Message-ID: <CADxjG6mrmPKFDjdRVBVeeE5SwpwitKc68DT9XxGMAmO4=XHnnQ@mail.gmail.com>
Subject: =?UTF-8?B?0JTQvtGA0L7Qs9C+0Lkg0LTRgNGD0LMsINCc0LXQvdGPINC30L7QstGD0YIg0JHQsNGA?=
        =?UTF-8?B?0YDQvtCx0LXRgNGCINCQ0L3QtNC10YDRgdC+0L0uINCvINCw0LTQstC+0LrQsNGCINC4INGH0LDRgdGC?=
        =?UTF-8?B?0L3Ri9C5INC80LXQvdC10LTQttC10YAg0L/QviDRgNCw0LHQvtGC0LUg0YEg0LrQu9C40LXQvdGC0LA=?=
        =?UTF-8?B?0LzQuCDQv9C+0LrQvtC50L3QvtC80YMg0LrQu9C40LXQvdGC0YMuINCSIDIwMTUg0LPQvtC00YMg0Lw=?=
        =?UTF-8?B?0L7QuSDQutC70LjQtdC90YIg0L/QviDQuNC80LXQvdC4INCc0LjRgdGC0LXRgCDQmtCw0YDQu9C+0YEs?=
        =?UTF-8?B?INGB0LrQvtC90YfQsNC70YHRjywg0L/RgNC40YfQuNC90LAsINC/0L4g0LrQvtGC0L7RgNC+0Lkg0Y8g?=
        =?UTF-8?B?0YHQstGP0LfQsNC70YHRjyDRgSDQstCw0LzQuCwg0L/QvtGC0L7QvNGDINGH0YLQviDQstGLINC90L4=?=
        =?UTF-8?B?0YHQuNGC0LUg0YLRgyDQttC1INGE0LDQvNC40LvQuNGOINGBINGD0LzQtdGA0YjQuNC8LCDQuCDRjyA=?=
        =?UTF-8?B?0LzQvtCz0YMg0L/RgNC10LTRgdGC0LDQstC40YLRjCDQstCw0YEg0LrQsNC6INCx0LXQvdC10YTQuNGG?=
        =?UTF-8?B?0LjQsNGA0LAg0Lgg0LHQu9C40LbQsNC50YjQuNGFINGA0L7QtNGB0YLQstC10L3QvdC40LrQvtCyINCy?=
        =?UTF-8?B?INC80L7QuCDRgdGA0LXQtNGB0YLQstCwINC/0L7QutC+0LnQvdC+0LPQviDQutC70LjQtdC90YLQsCwg?=
        =?UTF-8?B?0YLQviDQstGLINCx0YPQtNC10YLQtSDRgdGC0L7Rj9GC0Ywg0LrQsNC6INC10LPQviDQsdC70LjQttCw?=
        =?UTF-8?B?0LnRiNC40LUg0YDQvtC00YHRgtCy0LXQvdC90LjQutC4INC4INGC0YDQtdCx0L7QstCw0YLRjCDRgdGA?=
        =?UTF-8?B?0LXQtNGB0YLQstCwLiDQvtGB0YLQsNCy0LjQsiDQtNC10L3RjNCz0Lgg0L3QsNGB0LvQtdC00YHRgtCy?=
        =?UTF-8?B?0L4g0YHQtdC80Lgg0LzQuNC70LvQuNC+0L3QvtCyINC/0Y/RgtC40YHQvtGCINGC0YvRgdGP0Ycg0LQ=?=
        =?UTF-8?B?0L7Qu9C70LDRgNC+0LIg0KHQqNCQINCU0L7Qu9C70LDRgNGLICg3LDUwMCwwMDAsMDAg0LTQvtC70Ls=?=
        =?UTF-8?B?0LDRgNC+0LIg0KHQqNCQKS4g0JzQvtC5INC/0L7QutC+0LnQvdGL0Lkg0LrQu9C40LXQve+/vQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



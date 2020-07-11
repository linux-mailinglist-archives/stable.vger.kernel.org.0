Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6073B21C103
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgGKAF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 20:05:56 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:40458 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgGKAF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 20:05:56 -0400
Received: by mail-ot1-f44.google.com with SMTP id c25so5428069otf.7;
        Fri, 10 Jul 2020 17:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=C35HQbYWf7+Pw/INZ5gJ7RwAxH5seLfPnaJMvyUZa+w=;
        b=TlaEmjH9DNsqFealX/kODXlH38hmJncnCJKbbqL3kY6x7tG7tO9+GY9KR3yWxN1JpD
         RHl8BC1CMZLqOr6aKE3XhAjrnT5EHjQCH4SXNEd72UhpieVpmrymQOZlzG+Tx6mXCsQw
         bOqfxCUnF76BcuO/mNEL7kXv+Y/Cq8/lfFrrEA2vQ6vCneOOyYh0qbui3j5DtqvKceGR
         BPIAm9gJuhn4I28FYE+RQUN+ZnBShy/2aRA9pqAA2pq8x8/of8iIbcfgWt9JABf51Q39
         drG3KusTs69je7pLKsESFirSTbzIEJjvn1jkLud8lt4oH6dFAKCo2CkBJExI9x6oRH+/
         STOA==
X-Gm-Message-State: AOAM531zQeHuts1/3Vw4neqEJTEjHm3rtbSp49OWeAZFRpCyt5Z5EpqC
        grmaG3F5HflXAyTTdId0CCRf6uEqxdc=
X-Google-Smtp-Source: ABdhPJyZDMZl39RaRLwf8s59LZnYJwO3QIyKGpiIlYYYOcQNW0vC03FOPxe0Nqa7W6mDNC3KhrgmRA==
X-Received: by 2002:a05:6830:1d6c:: with SMTP id l12mr34376074oti.275.1594425954869;
        Fri, 10 Jul 2020 17:05:54 -0700 (PDT)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.googlemail.com with ESMTPSA id t21sm1479993oor.20.2020.07.10.17.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 17:05:54 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id 5so5409533oty.11;
        Fri, 10 Jul 2020 17:05:54 -0700 (PDT)
X-Received: by 2002:a05:6830:1b67:: with SMTP id d7mr53684427ote.322.1594425954402;
 Fri, 10 Jul 2020 17:05:54 -0700 (PDT)
MIME-Version: 1.0
From:   Gordan Bobic <gordan@redsleeve.org>
Date:   Sat, 11 Jul 2020 01:05:43 +0100
X-Gmail-Original-Message-ID: <CAMx4oe34RcVeaA+sz6vFN-CyNtwdPxj+oTBQjWiM4C7iAqnLGw@mail.gmail.com>
Message-ID: <CAMx4oe34RcVeaA+sz6vFN-CyNtwdPxj+oTBQjWiM4C7iAqnLGw@mail.gmail.com>
Subject: =?UTF-8?Q?perf=3A_util=2Fsyscalltbl=2Ec=3A43=3A38=3A_error=3A_=E2=80=98SYSCALLTBL=5F?=
        =?UTF-8?Q?ARM64=5FMAX=5FID=E2=80=99_undeclared_here_=28not_in_a_function=29?=
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I hit this FTBFS earlier today while trying to build the LT 4.19.132
kernel from source:

https://lore.kernel.org/patchwork/patch/960281/

The "quick hack" patch mentioned at the bottom of the thread gets it
to compile. Is this the correct solution, or is there a better fix? As
it stands, tools/perf doesn't seem to compile on 4.19.132.

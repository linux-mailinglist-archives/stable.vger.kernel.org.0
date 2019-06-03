Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6AA32EE7
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 13:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFCLqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 07:46:04 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:43326 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCLqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 07:46:04 -0400
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x53BjrOD005594;
        Mon, 3 Jun 2019 20:45:53 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x53BjrOD005594
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559562354;
        bh=xcdVS2lZM1a48jGewJjV7DieZdVaVvo2sv103QVTF4A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vD2ZSXItTjKjdiNBHbKw3ZwxymGkS+mFzGNJdILthjozmnTu79/V5i1V8R22/nnLr
         3Bw8q1gvPjzDonVsJOuFRSuMKPvOQAUdQaZmuCbo0GRiGSBfxaddMQx1ahOH8UJqTx
         YfHiSmxDHnUIL+meK6FxxCOVklZh415UQpOq1Dp0zXb3EiK/jpR2st9Kjvipf0isXu
         A5q5swRbapK7hp912uNtA2dqkyZEP2HMa1B5c0V0HrNiot0WqaCOeKEbm0bkGoddoU
         csou2T6LFFYdEKH87VrsG7p35LArxmFUjTiFl5fSqOU9j7jWNvgLKYgGp4n52MswfN
         ml+ums0o22Y+Q==
X-Nifty-SrcIP: [209.85.221.180]
Received: by mail-vk1-f180.google.com with SMTP id k1so2803503vkb.2;
        Mon, 03 Jun 2019 04:45:53 -0700 (PDT)
X-Gm-Message-State: APjAAAW2o2ixN0XDlOCxvgENyQLU56pos+NFFWK8eeRKkM8sW1+L1gAb
        Dla9sbdsjNZeex+fZGoENQmmtTBpcODboDmwks8=
X-Google-Smtp-Source: APXvYqxzUHPoQIku6KGXaYa9Qp+9KgMH/y/NROsn43MQouSz1p//qa19a5lw5lYTcOIKJq2hnfSJHM9bQSGQoQwpkgs=
X-Received: by 2002:ac5:c215:: with SMTP id m21mr8858804vkk.84.1559562352459;
 Mon, 03 Jun 2019 04:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190603104902.23799-1-yamada.masahiro@socionext.com> <3dcacca3f71c46cc98fa64b13a405b59@AcuMS.aculab.com>
In-Reply-To: <3dcacca3f71c46cc98fa64b13a405b59@AcuMS.aculab.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 3 Jun 2019 20:45:16 +0900
X-Gmail-Original-Message-ID: <CAK7LNATt=P5rHrnK_8PTmjMb+tdtPg2qBgopRUDBFw_fkP2SsQ@mail.gmail.com>
Message-ID: <CAK7LNATt=P5rHrnK_8PTmjMb+tdtPg2qBgopRUDBFw_fkP2SsQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: use more portable 'command -v' for cc-cross-prefix
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 3, 2019 at 8:16 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Masahiro Yamada
> > Sent: 03 June 2019 11:49
> >
> > To print the pathname that will be used by shell in the current
> > environment, 'command -v' is a standardized way. [1]
> >
> > 'which' is also often used in scripting, but it is not portable.
>
> All uses of 'which' should be expunged.
> It is a bourne shell script that is trying to emulate a csh builtin.
> It is doomed to fail in corner cases.
> ISTR it has serious problems with shell functions and aliases.

OK, I do not have time to check it treewide.
I expect somebody will contribute to it.



BTW, I see yet another way to get the command path.

'type -path' is bash-specific.

Maybe, we should do this too:

diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
index 4b1fe09e9042..77829ee4268e 100755
--- a/scripts/mkuboot.sh
+++ b/scripts/mkuboot.sh
@@ -1,14 +1,14 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: GPL-2.0

 #
 # Build U-Boot image when `mkimage' tool is available.
 #

-MKIMAGE=$(type -path "${CROSS_COMPILE}mkimage")
+MKIMAGE=$(command -v "${CROSS_COMPILE}mkimage")

 if [ -z "${MKIMAGE}" ]; then
-       MKIMAGE=$(type -path mkimage)
+       MKIMAGE=$(command -v mkimage)
        if [ -z "${MKIMAGE}" ]; then
                # Doesn't exist
                echo '"mkimage" command not found - U-Boot images will
not be built' >&2


-- 
Best Regards
Masahiro Yamada

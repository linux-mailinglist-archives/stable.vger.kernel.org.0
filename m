Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933486EB7BA
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDVHCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 03:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDVHCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 03:02:22 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED00E77;
        Sat, 22 Apr 2023 00:02:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-506b2a08877so4176369a12.2;
        Sat, 22 Apr 2023 00:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682146939; x=1684738939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QJug3HFwwM76eXtI/ZybFRMLVPjmd4+EsYAZDkR3Svc=;
        b=lmyF6Sny0Ee4vR1YKrh+LsX4kbjs57R0D6Dis5iMQyJRizAgaXBKzng6zok6xJGRQa
         oWhniLhC10eeEXu02sFgOWgHqNlSIdmFi7CVjMGPENWjBeg/NRZDKc7RbTmS0Rqgr98+
         jT06lAomWeU1hd4mQedfvpt2tVjh1cLyQ49uYKZf5bou8EuYoa9a+KGk4631MGo81Q7E
         vcnXi52WeqqnDAZdL+sXyHJUjzL++C/sI1mFjtyR1lKoZ1IPzVtYRDeVzrYJ9ruzOsW9
         jEiFu+97NcTZPsBszU2Xa3osRO3zLXc0xFn1hg7hkMUpLZ9MOuZfsooMzf/hzinLKvA3
         l5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682146939; x=1684738939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJug3HFwwM76eXtI/ZybFRMLVPjmd4+EsYAZDkR3Svc=;
        b=kt3IBCq8Sygf9xj81OXat6LbiJQoUvLb361rQQzJJEFODDSeuQsh7lNEpc1vAIK+h9
         hZ3UciGbhKhR0FuCYyIAcuPKAHdHzEMmeWnFiZBqKTA3DaJfI0G1mroXK3+j5AHfc2Ui
         Zx4TxPW43Hz3Y0lmYfEJFjU6+S2c6c6KYQPHsNDW8sISNN1/OLt2vheZqtzK2q/KbYTU
         5Qs5znnfs01f4ruETUzaJRby0nk5Qosxh1PlF0MvcL0A4Tl4nA0pCRG3Yr7NEPUnmvOT
         D0vYd8q3ml/CB0RCiICWAogvOqrsORv4tESlr/zCLBhtGvZ56puYoVF1ZWjYxQIS0wRT
         7eQg==
X-Gm-Message-State: AAQBX9feEncf2butR4s7rAHpfzru0srz4wfZseMgNvgggQF0HFy+j0Mz
        E7F/tJRRhtDYLdGk4VnrbN4=
X-Google-Smtp-Source: AKy350Y8MzEpCSpS5sm68AXROV3Oy3lqZE1tHP/SiPTaj2HSXCKP5XLd96iOIzInN5hQ8QgIMmey7g==
X-Received: by 2002:aa7:d713:0:b0:506:7385:9653 with SMTP id t19-20020aa7d713000000b0050673859653mr7039392edq.39.1682146938962;
        Sat, 22 Apr 2023 00:02:18 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id e9-20020a50fb89000000b00504ada6d718sm2534634edq.38.2023.04.22.00.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 00:02:17 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 0A8ACBE2DE0; Sat, 22 Apr 2023 09:02:17 +0200 (CEST)
Date:   Sat, 22 Apr 2023 09:02:17 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 stable-5.10.y stable-5.15.y] docs: futex: Fix
 kernel-doc references after code split-up preparation
Message-ID: <ZEOGeVyvOx6/xypo@eldamar.lan>
References: <20230421221741.1827866-1-carnil@debian.org>
 <bc5a2d13-4829-0c5a-837d-8842e16cd997@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc5a2d13-4829-0c5a-837d-8842e16cd997@infradead.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Randy,

On Fri, Apr 21, 2023 at 05:03:15PM -0700, Randy Dunlap wrote:
> Please see https://lore.kernel.org/all/20211012135549.14451-1-andrealmeid@collabora.com/
> 
> Don't know what has happened to it though.  :(

It was applied, as bc67f1c454fb ("docs: futex: Fix kernel-doc
references") in 5.16-rc1. But 5.10.y and 5.15.y picked up from the
refactoring only 77e52ae35463 ("futex: Move to kernel/futex/"). 

So this change is a specific backport of subset of it, to 5.10.y and
5.15.y thus the commit message:

> On 4/21/23 15:17, Salvatore Bonaccorso wrote:
> > In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
> > futex code from kernel/futex.c was moved into kernel/futex/core.c in
> > preparation of the split-up of the implementation in various files.
> > 
> > Point kernel-doc references to the new files as otherwise the
> > documentation shows errors on build:
> > 
> >     [...]
> >     Error: Cannot open file ./kernel/futex.c
> >     Error: Cannot open file ./kernel/futex.c
> >     [...]
> >     WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2
> > 
> > There is no direct upstream commit for this change. It is made in
> > analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
> > references") applied as consequence of the restructuring of the futex
> > code.

Here pointing out explicitly that there is no (direct) upstream commit
for it. 

Hope this helps,

Regards,
Salvatore

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9374469DB37
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 08:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbjBUHad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 02:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBUHac (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 02:30:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558F323852
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 23:30:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B465CE119A
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 07:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5019BC433D2;
        Tue, 21 Feb 2023 07:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676964626;
        bh=UozP5DlxR2ZS/tTokN94KymTNQAvVGDyAFejHvtlSe4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kq1srutuin3tOUyQKGxyyA+pYRiknvLciDvrIgTkDaTbkqhlvYhkx4th6VTVhSnXQ
         bjg3JhSK6+wrcRveEjdfbybM1KeSbzCxsXFwnEp4MC1AM4TtD+RYxC1CKTWIoP6EOn
         5BAPUtqKdftZ3rPtC8QnJ6W4p3MMJ5yP0En7KZJk=
Date:   Tue, 21 Feb 2023 08:30:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     peterz@infradead.org, keescook@chromium.org,
        sethjenkins@google.com, Dave Hansen <dave.hansen@linux.intel.com>,
        bp@suse.de, stable@vger.kernel.org
Subject: Re: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
Message-ID: <Y/RzDvXr/iGpHl+f@kroah.com>
References: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 03:19:05PM +0800, Tong Tiangen wrote:
> Hi peter:
> 
> Do you have any plans to backport this patch[1] to the stable branch of the
> lower version, such as 4.19.y ?

Why?  That is a new feature for 6.2 why would it be needed to fix
anything in really old kernels?

> When I try to backport this patch to 5.10.y, I met some KASAN[2] and
> KASLR[3] related issues. Although they were finally solved, there were still
> some detours in the process.

Send your series of backports to the list for review please if they
match the stable kernel rules.

But why can't you just use the 6.2 kernel instead of something obsolete
like 4.19?

thanks,

greg k-h

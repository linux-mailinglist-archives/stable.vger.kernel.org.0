Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639651FB123
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgFPMu3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 16 Jun 2020 08:50:29 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:60180 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgFPMu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 08:50:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21513227-1500050 
        for multiple; Tue, 16 Jun 2020 13:50:19 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAO_48GFVYOv8Km7fEh8iBPp7d5ziySBV0vB9nu_+oset6hBO8w@mail.gmail.com>
References: <20200611114418.19852-1-sumit.semwal@linaro.org> <CAO_48GFVYOv8Km7fEh8iBPp7d5ziySBV0vB9nu_+oset6hBO8w@mail.gmail.com>
Cc:     Chenbo Feng <fengc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        Charan Teja Reddy <charante@codeaurora.org>,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        "# 3.4.x" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] dma-buf: Move dma_buf_release() from fops to dentry_ops
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>
Message-ID: <159231181752.18853.1290700688849491922@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Tue, 16 Jun 2020 13:50:17 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sumit Semwal (2020-06-16 13:42:13)
> Hello,
> 
> If there are no objections to this, I will plan to merge it soon.

I was going to suggest running it against our CI, but that's unavailable
at the moment.

There's a particularly nasty BUG_ON() in dma_buf_release that we hit
irregularly, that this might help with.
-Chris

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A1845C6A1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347850AbhKXOKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354822AbhKXOI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:08:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C5BC6187D;
        Wed, 24 Nov 2021 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759666;
        bh=MCJjMWrD72/QqkTymjHjUy8mxa62nz28BM9+cCAbtVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lVPQ8q+/Fj+IesGb76Kts5yepJpJbxrvR9G/d8C28vDcxL48ocAhY+jCPSxmN+9j+
         JUbIHoH6AVkpRsLCHIJ5eVq7vciyh7oIe66WVjKi/Ci8i9lZUGGu87N/E0/6Aa2IF8
         D416Yj00K5TA+MoQRz9lGHAaDpcZFizgG7u7eFkE=
Date:   Wed, 24 Nov 2021 14:13:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sohaib Mohamed <sohaib.amhmd@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paul Russel <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Pierre Gondois <pierre.gondois@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 301/323] perf bench: Fix two memory leaks detected
 with ASan
Message-ID: <YZ46iIIgRVUbC5lN@kroah.com>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211124115729.082611705@linuxfoundation.org>
 <CAOz-JA4kZFoOig-aNu0yai+DE81XbNBkWUAaAYgUW4TQSCoY3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOz-JA4kZFoOig-aNu0yai+DE81XbNBkWUAaAYgUW4TQSCoY3g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 02:56:17PM +0200, Sohaib Mohamed wrote:
> Hello, Greg
> 
> On Wed, Nov 24, 2021, 2:45 PM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> wrote:
> 
> > From: Sohaib Mohamed <sohaib.amhmd@gmail.com>
> >
> > [ Upstream commit 92723ea0f11d92496687db8c9725248e9d1e5e1d ]
> >
> 
> Please, remove this patch from the queue.
> This patch has a problem and should be reverted.

Dropped from all branches now, thanks.

greg k-h

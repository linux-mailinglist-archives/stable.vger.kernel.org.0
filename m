Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ACE32D444
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbhCDNhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238058AbhCDNhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD7C64EEC;
        Thu,  4 Mar 2021 13:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614865014;
        bh=vIK8TYXpUvNDeRzrHR28TIM8HkqGcN45ftUj34Lbt4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p4EgDYyaOHqPA8w4nP+XEANa7J5MyU30XbvEHm8L2QcyAI9F4H6AqE2UPOcH44Sqk
         4YdPIxXX7m2qkKCTqYFDB04lWFdAYI8kCQY8umqAG0bDyUGxSW0v4+qZyHkJpwig4/
         1HmD7tS+RgoqPpWiJ/glpMkZAohz+B1k3vSxGh+k=
Date:   Thu, 4 Mar 2021 14:36:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     aarcange@redhat.com, akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
Subject: Re: FAILED: patch "[PATCH] hugetlb: fix update_and_free_page contig
 page struct" failed to apply to 4.19-stable tree
Message-ID: <YEDidFjy2b5Jw/uU@kroah.com>
References: <161460246210369@kroah.com>
 <4712beaf-1714-e19c-32a0-ca76d398961e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4712beaf-1714-e19c-32a0-ca76d398961e@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 08:24:43PM -0800, Mike Kravetz wrote:
> On 3/1/21 4:41 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> 
> >From b6dec027a8967feb788e14f3bbd57f318005001f Mon Sep 17 00:00:00 2001
> From: Mike Kravetz <mike.kravetz@oracle.com>
> Date: Mon, 1 Mar 2021 18:12:38 -0800
> Subject: [PATCH] hugetlb: fix update_and_free_page contig page struct
>  assumption
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> commit dbfee5aee7e54f83d96ceb8e3e80717fac62ad63 upstream.

Queued up everywhere, thanks.

greg k-h

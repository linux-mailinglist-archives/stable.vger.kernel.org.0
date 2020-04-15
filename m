Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FEF1AB0C1
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 20:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415201AbgDOScx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 14:32:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416781AbgDOScw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 14:32:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C5A20771;
        Wed, 15 Apr 2020 18:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586975569;
        bh=BItXRqcnd3Qi5c80DMiRqZzRNxAmk+XWa0mvuTcWq1I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GbSwxHKRwi7Z+qk4E6yW/nXZ3IVr1/+g1H4lJcBjwGn/2j/rAAXRe2APxkjk7XRUY
         LTFcXAnn5fpAt2+Gwj5FiiY+ubfhEw5bk7yRcXUQHuzNkyN1cxWIFGl6K4onL2F6EX
         UAJ6OHG+9buRysjZykWKReVzSZAPVTkplrKllaQk=
Date:   Wed, 15 Apr 2020 11:32:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>, david@redhat.com,
        Xiongchun duan <duanxiongchun@bytedance.com>, hughd@google.com,
        imbrenda@linux.vnet.ibm.com,
        Markus Elfring <Markus.Elfring@web.de>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        yang.shi@linux.alibaba.com
Subject: Re: [External] Re: +
 mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
 added to -mm tree
Message-Id: <20200415113248.1c17147d0991099d358b4bef@linux-foundation.org>
In-Reply-To: <CAMZfGtWwE_9uSH9Vw+W2yJJhMo4BfWHx_PME+HD5h3r+A3zXeg@mail.gmail.com>
References: <20200415015410.glIzXqR5d%akpm@linux-foundation.org>
        <49e65ca7-03a2-9a82-9e1a-cf997320bcfd@virtuozzo.com>
        <CAMZfGtWwE_9uSH9Vw+W2yJJhMo4BfWHx_PME+HD5h3r+A3zXeg@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Apr 2020 16:16:50 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> > In case of vma is out of date, we also may consider to exit this function without
> > calling unstable_tree_search_insert().
> 
> Yeah, I agree with you. Should I send another patch to fix this patch
> or an upgraded
> version(v4) of this patch.

Either is OK.

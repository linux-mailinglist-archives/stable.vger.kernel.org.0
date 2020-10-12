Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3428B630
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgJLNaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgJLNaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 09:30:35 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFDCC0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 06:30:35 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c2so17663249qkf.10
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 06:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pnPTIBXyXY3lw9klvumgMEMiErvTNBjNm3i9R50FiO8=;
        b=vnTw9dJflaMIXNnNWw2vi/vOaGk2yCJ69WDQkdY4C16AMLkPTm9WzibqnJrH3CiqcT
         mJCxscrz0aU5tFQt3oG+TShN2wD1khwShvSZmM7v3nm7O0dWqniUMmRiLZDDQYjBBccN
         EQJUREQlsKPdgYnTyxfYxpHc0vHmAkbUNFICmbFU9qwruHcZYxq++kzYmfP+Jt3WKH/u
         s9pLL3UOpMht2Ts8ZdKF5KM7CdNLZlGJtrvSuo0yDSxa4ZuiVm8uVJZWBNWu3bOhsbRd
         aG5OPdQLY7OH+3bI0F0c0UQ5AwXOA6uNU9dy12iV8LG4GQPFUMJU45SjR9KBubkniWJy
         zj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pnPTIBXyXY3lw9klvumgMEMiErvTNBjNm3i9R50FiO8=;
        b=daOf1pbKZd4q+tbiyEG2wvaTJOFFcY/ddyW+sZxQEYh5YVGgkHJA8HsGnEyVscZ6Fr
         Ia9M/m1Q6K+jOOFDTE+kjZdTdKqNt4TmyAmzb+7KZALGVGccc/2KqfpoBSqfVT8gcapg
         A4DW9LVKOM+nZPkxKvS1DQ9xcXHEu7UApiwjsIV9fcuFvdB9u29+MWzh3+KsiFWcg4Hi
         RaFv0Z8OpgBC4D2KRjJBavQDQsX9SJMLuVcIZtUDQ61OqfdW9dEG68OmllHc6TltAKe9
         vFySRIZL5C8U3C0GNqe27AB/a7B9f917bnLdDn7v8twDroPvtfvwdrb7M55EgXU3hTNV
         r98g==
X-Gm-Message-State: AOAM533EANI/Rp1EKezojV00CdLIoav2sFty1tWT1v5L3kW7iylqSzLd
        HHxO1j5/52CXNtR/QVDNQqDEwA==
X-Google-Smtp-Source: ABdhPJxcAtD+DVNW0Lo9o9FmYxCJnyvNR7wF/YxZxRmvawTGsigNtgwmZAfyvj+gqt87sq8Idn2hFA==
X-Received: by 2002:a05:620a:16cb:: with SMTP id a11mr10048726qkn.474.1602509434380;
        Mon, 12 Oct 2020 06:30:34 -0700 (PDT)
Received: from localhost (pool-96-232-200-60.nycmny.fios.verizon.net. [96.232.200.60])
        by smtp.gmail.com with ESMTPSA id x91sm7657123qte.69.2020.10.12.06.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:30:33 -0700 (PDT)
Date:   Mon, 12 Oct 2020 09:28:59 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
Message-ID: <20201012132859.GD163830@cmpxchg.org>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
 <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
 <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 09, 2020 at 05:00:37PM -0700, Ralph Campbell wrote:
> 
> On 10/9/20 3:50 PM, Andrew Morton wrote:
> > On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:
> > 
> > > The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
> > > NULL before checking is_device_private_entry() so device private pages
> > > are never handled.
> > > Fix this by checking for non_swap_entry() after handling device private
> > > swap PTEs.

The fix looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> > But this makes me suspect the answer is "there aren't any that we know
> > of".  Are you sure a cc:stable is warranted?
> > 
> 
> I assume the memory cgroup accounting would be off somehow when moving
> a process to another memory cgroup.
> Currently, the device private page is charged like a normal anonymous page
> when allocated and is uncharged when the page is freed so I think that path is OK.
> Maybe someone who knows more about memory cgroup accounting can comment?

As for whether to CC stable, I'm leaning toward no:

- When moving tasks, we'd leave their device pages behind in the old
  cgroup. This isn't great, but it doesn't cause counter imbalances or
  corruption or anything - we also skip locked pages, we used to skip
  pages mapped by more than one pte, the user can select whether to
  move pages along tasks at all, and if so, whether only anon or file.

- Charge moving itself is a bit of a questionable feature, and users
  have been moving away from it. Leaving tasks in a cgroup and
  changing the configuration is a heck of a lot cheaper than moving
  potentially gigabytes of pages to another configuration domain.

- According to the Fixes tag, this isn't a regression, either. Since
  their inception, we have never migrated device pages.

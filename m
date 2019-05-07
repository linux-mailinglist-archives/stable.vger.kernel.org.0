Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40F716903
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfEGRVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:21:05 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36952 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfEGRVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:21:04 -0400
Received: by mail-lf1-f65.google.com with SMTP id h126so1281261lfh.4
        for <stable@vger.kernel.org>; Tue, 07 May 2019 10:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pAvQTClftltYLCbDqLCq0/xQYu65sVI0pkYjzVTBcB0=;
        b=NsaoLR6Ao9J19zGZUHECQ1qcF7jO6hioHJJfXFH7MjyM/ZZTDUiryrhvQk2YIHQ681
         EBOTavV5RShPc+LyF7LHGtUfsXEm9A5iJNtu5FInwxpehCTg0ugf5fdz41X0mZTg1qa6
         tJJWZ6eAmCN37uHbershG6h8l0gVd8ZV+wf1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pAvQTClftltYLCbDqLCq0/xQYu65sVI0pkYjzVTBcB0=;
        b=NEBUMl8PFRB0Spdkv/wkbJKH5Zsgt28yJ6DZb13M4vYCWYcla2nspK5hlIqFhmOZXy
         nOADBEDj3EMVj+wMGcURwF1UvOKUHibBMb5ucKh9h3XS9wN2LHqBIzcn2njD3LLOr6Ez
         HbMbR37Z3sHktFzqrLV34jC+dQGxy08FJe5wpnnaXeQUmQlbF8BDKo6DoiQkts/OWIAG
         EYaM8K7dT9vzNUsX+uJJ4pet2kXQnBTSQRomK99zGMJ6vV//B518EDgKiFH61v1jsQeE
         UgLaeblolSeCh7MoAbbkc6UYXC9eCuPSgomQMU1EPln3GGf5YlAgWJgCtn7SGVK5dMmc
         SGXg==
X-Gm-Message-State: APjAAAVI15wiOE6WpM33EOSNbqtR3RBF560zgoraATkAce7+Xjs5vSAZ
        /ZuxAC5lqr0NjWIr+hXeIWrRDWLvJjE=
X-Google-Smtp-Source: APXvYqxFysWLaoqbAIE9YUmVUnPtifxW9jJ+T3+R06g8WeRd9DMu6gbY49dKC72vIE0xh+uO1wGy7A==
X-Received: by 2002:ac2:4301:: with SMTP id l1mr18221835lfh.54.1557249662529;
        Tue, 07 May 2019 10:21:02 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id c25sm3203559ljb.20.2019.05.07.10.21.02
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 10:21:02 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id m20so5828840lji.2
        for <stable@vger.kernel.org>; Tue, 07 May 2019 10:21:02 -0700 (PDT)
X-Received: by 2002:a2e:801a:: with SMTP id j26mr8769035ljg.2.1557249335169;
 Tue, 07 May 2019 10:15:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190507053826.31622-1-sashal@kernel.org> <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
 <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com> <20190507170208.GF1747@sasha-vm>
In-Reply-To: <20190507170208.GF1747@sasha-vm>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 10:15:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
Message-ID: <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
To:     Sasha Levin <sashal@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 7, 2019 at 10:02 AM Sasha Levin <sashal@kernel.org> wrote:
>
> I got it wrong then. I'll fix it up and get efad4e475c31 in instead.

Careful. That one had a bug too, and we have 891cb2a72d82 ("mm,
memory_hotplug: fix off-by-one in is_pageblock_removable").

All of these were *horribly* and subtly buggy, and might be
intertwined with other issues. And only trigger on a few specific
machines where the memory map layout is just right to trigger some
special case or other, and you have just the right config.

It might be best to verify with Michal Hocko. Michal?

              Linus

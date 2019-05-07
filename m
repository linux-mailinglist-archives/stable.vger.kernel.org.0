Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6922F16970
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfEGRnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:43:53 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36126 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfEGRnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:43:53 -0400
Received: by mail-lj1-f194.google.com with SMTP id z1so2892282ljb.3
        for <stable@vger.kernel.org>; Tue, 07 May 2019 10:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fkA+Y9XnOGjl/cdVGrUxZb5095BOcP1bwTD0zYW4RLc=;
        b=Co2UIiT1iv1WhhnvT+1SLlkyQw1jm+jIn7F5nCWplNQ4zzVNCu8DWJlLaOs5Q4eA6v
         dX3/gvVrHWhpmKzMeYWueRW2iIbmxXCiloZEhDBiCwMyJ/AqK/gQeIT/nMiqjhbY4PKo
         2MHqNXryyh0L0banXslg9ahMI3L+ftSr/qVDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fkA+Y9XnOGjl/cdVGrUxZb5095BOcP1bwTD0zYW4RLc=;
        b=B9bONVx/KVnCtSqsBoz4ArfICsZ+KGqQEDuJv0BG07c20keTxyUq3XrP4wj5IqYr+p
         i+mzjEFDq2rT03t3Icn2MfE+fzwoPZTSq4e2kR9A6VQ+6/VICrUDRSNZEUHBHCHEsghh
         YXE3CAND3TFdi73yCCl8xGii9l7UTWlkO2ViIhpDKkN6KYibW1CRhExX/4dYqb8QAK5E
         co7lkxqxOSE70YKz+6UdY4vxhtk8TKNzG6XqM6pOfgc+1QgOl5kTTF9Mpx/B5C+u08DU
         oOdZm4vnyfIxefVByzO3asDb6BAWMbt5ioEoQeLdvYKstBoNznSLZgIISBRQnVO5G0OJ
         ScvQ==
X-Gm-Message-State: APjAAAUtnjB6KHKrFZmn7YuZdVgtukDlpwk2QGeXp9snQ3FAyHA4nomG
        rDutGEIApCouPgHLGOs2z+siQ1QcXmQ=
X-Google-Smtp-Source: APXvYqzLlPcQUkbZHQTmaB1Bxw0mST9ugOs56Wwr3zQOrNKkX2s2jht7pcsak9HZMdeg34t3dXYmKQ==
X-Received: by 2002:a2e:9350:: with SMTP id m16mr17821813ljh.38.1557251030779;
        Tue, 07 May 2019 10:43:50 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id y10sm3124848lja.71.2019.05.07.10.43.48
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 10:43:48 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id h21so15064831ljk.13
        for <stable@vger.kernel.org>; Tue, 07 May 2019 10:43:48 -0700 (PDT)
X-Received: by 2002:a2e:9d86:: with SMTP id c6mr16010057ljj.135.1557251027975;
 Tue, 07 May 2019 10:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190507053826.31622-1-sashal@kernel.org> <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
 <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
 <20190507170208.GF1747@sasha-vm> <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
 <20190507171806.GG1747@sasha-vm> <20190507173224.GS31017@dhcp22.suse.cz> <20190507173655.GA1403@bombadil.infradead.org>
In-Reply-To: <20190507173655.GA1403@bombadil.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 10:43:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjFkwKpRGP-MJA6mM6ZOu0aiqtvmqxKR78HHXVd_SwpUg@mail.gmail.com>
Message-ID: <CAHk-=wjFkwKpRGP-MJA6mM6ZOu0aiqtvmqxKR78HHXVd_SwpUg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Michal Hocko <mhocko@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
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

On Tue, May 7, 2019 at 10:36 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> Can we do something with qemu?  Is it flexible enough to hotplug memory
> at the right boundaries?

It's not just the actual hotplugged memory, it's things like how the
e820 tables were laid out for the _regular_ non-hotplug stuff too,
iirc to get the cases where something didn't work out.

I'm sure it *could* be emulated, and I'm sure some hotplug (and page
poison errors etc) testing in qemu would be lovely and presumably some
people do it, but all the cases so far have been about odd small
special cases that people didn't think of and didn't hit. I'm not sure
the qemu testing would think of them either..

                Linus

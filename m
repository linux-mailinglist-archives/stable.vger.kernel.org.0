Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE5116860
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfEGQvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 12:51:14 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42219 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfEGQvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 12:51:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id y10so8440808lji.9
        for <stable@vger.kernel.org>; Tue, 07 May 2019 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JvOdwodHOTVYJ7+EHobDSJoXyA/2IRefA+hgBIaO+dI=;
        b=TR/Xs+H41+MJkfZoDS3QvaRnKQ/g/aV8B8CcLFu7NSmvalIZMpHgldvoVhvFAQWvJv
         6nl9q4q1e1O09qZYjSX8DYPCKpQIHf0ugzOG6HjVOxJ3jM8B5tGB1rixMuYMwT8a5WVn
         OXpYD75kQFmL1W4AwtTiKcN+UF6bsE/Un6etg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JvOdwodHOTVYJ7+EHobDSJoXyA/2IRefA+hgBIaO+dI=;
        b=i3ec2mJc9GeGwh8HKlkhaw67Hw3rTB9web5HlqlS+izmKChqEKT91I/LVensVPkpFj
         ZQJZ/53LsWrvi7TjtcuhqU8Qd//yKXd3zSs30sUSf0Ydn4gsUDszcNLp7+ZTpwhDfFUl
         uzadjqoOAh8NHIN4vasjJ5qaFoQNR/3cnGpWS4NcqN8mNc4K7JcImgVJJ8XgRKj/qU2P
         BRnZvfmEELtswh9Ru/qLgz5fD07AfxgU+dsuRaT1ujFPAb7aHtnlQHoAFlnourf4s1Wg
         YNe5wt9twCJBjA7kLEgLG8BCt0npyVJIHism1SVF5mqjNN9BxKuLJzNyDttmOHjleSoA
         Xk0Q==
X-Gm-Message-State: APjAAAUbx/6XvEx6xW3s6qQbwc4l4sgtgxOwBztKvtOOo2hzzSLjqtJO
        IiTW+2y/ghDfLax9cLhEhTYPiCbMn2c=
X-Google-Smtp-Source: APXvYqxrIwDo3uLu/7TT3EsOs6xfWv8G2OZ43eS4ZYzxTWSudHUGljMH8yf3WwbjRKZIn8Yk7HuSww==
X-Received: by 2002:a2e:8018:: with SMTP id j24mr14607792ljg.149.1557247868519;
        Tue, 07 May 2019 09:51:08 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id 78sm763224lje.81.2019.05.07.09.51.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 09:51:07 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id z5so9852082lji.10
        for <stable@vger.kernel.org>; Tue, 07 May 2019 09:51:07 -0700 (PDT)
X-Received: by 2002:a2e:801a:: with SMTP id j26mr8701955ljg.2.1557247866889;
 Tue, 07 May 2019 09:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190507053826.31622-1-sashal@kernel.org> <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
In-Reply-To: <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 09:50:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
Message-ID: <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
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

On Tue, May 7, 2019 at 9:31 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> Wasn't this patch reverted in Linus's tree for causing a regression on
> some platforms? If so I'm not sure we should pull this in as a
> candidate for stable should we, or am I missing something?

Good catch. It was reverted in commit 4aa9fc2a435a ("Revert "mm,
memory_hotplug: initialize struct pages for the full memory
section"").

We ended up with efad4e475c31 ("mm, memory_hotplug:
is_mem_section_removable do not pass the end of a zone") instead (and
possibly others - this was just from looking for commit messages that
mentioned that reverted commit).

              Linus

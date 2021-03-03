Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5370732B0B9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345307AbhCCAyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234179AbhCCASV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 19:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08BB064F48;
        Wed,  3 Mar 2021 00:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614730637;
        bh=mU5PveBMUOL4vXjHcyJ4Vk66Hg1AkYJuK82tzLO57oQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fFazfdEQJPlwzLPWA6JwystQrC4mSJJ0zoD3Xq50mm051lTZHifhHMHF/vO2b7qsD
         hEsqhrkxH2QGhYrBVPY3k8ZB+lO1TebGwSpRuIiL0pvMOXJuBVWH8Gx7JfF7FY2MJe
         jbpQJXCGv4nz0tGyB83KR6vs4g/7fkmp4Kw1GMXs=
Date:   Tue, 2 Mar 2021 16:17:16 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        David Rientjes <rientjes@google.com>,
        Edgar Arriaga =?ISO-8859-1?Q?Garc=EDa?= 
        <edgararriaga@google.com>, Tim Murray <timmurray@google.com>,
        linux-mm <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 1/1] mm/madvise: replace ptrace attach requirement
 for process_madvise
Message-Id: <20210302161716.89a65d3cb5b60dbc5074cfa7@linux-foundation.org>
In-Reply-To: <CAJuCfpEOE8=L1fT4FSauy65cS82M_kW3EzTgH89ewE9HudL=VA@mail.gmail.com>
References: <20210111170622.2613577-1-surenb@google.com>
        <20210112074629.GG22493@dhcp22.suse.cz>
        <20210112174507.GA23780@redhat.com>
        <CAJuCfpFQz=x-LvONO3c4iqjKP4NKJMgUuiYc8HACKHAv1Omu0w@mail.gmail.com>
        <20210113142202.GC22493@dhcp22.suse.cz>
        <CAG48ez0=QSzuj96+5oVQ2qWqfjedv3oKtfEFzw--C8bzfvj7EQ@mail.gmail.com>
        <20210126135254.GP827@dhcp22.suse.cz>
        <CAJuCfpEnMyo9XAnoF+q1j9EkC0okZfUxxdAFhzhPJi+adJYqjw@mail.gmail.com>
        <CAJuCfpF861zhp8yR_pYx8gb+WMrORAZ0tbzcKtKxaj7L=jzw+Q@mail.gmail.com>
        <CAJuCfpFzxiBXp1rdY=H=bX+eOAVGOe72_FxwC-NTWF4fhUO26g@mail.gmail.com>
        <CAJuCfpEOE8=L1fT4FSauy65cS82M_kW3EzTgH89ewE9HudL=VA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2 Mar 2021 15:53:39 -0800 Suren Baghdasaryan <surenb@google.com> wrote:

> Hi Andrew,
> A friendly reminder to please include this patch into mm tree.
> There seem to be no more questions or objections.
> The man page you requested is accepted here:
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
> stable is CC'ed and this patch should go into 5.10 and later kernels
> The patch has been:
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: David Rientjes <rientjes@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> If you want me to resend it, please let me know.

This patch was tough.  I think it would be best to resend please, being
sure to cc everyone who commented.  To give everyone another chance to
get their heads around it.  If necessary, please update the changelog
to address any confusion/questions which have arisen thus far.

Thanks.

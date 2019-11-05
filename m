Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4DEF584
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKEGaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:30:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:43610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726842AbfKEGaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 01:30:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E26A2B1E4;
        Tue,  5 Nov 2019 06:30:09 +0000 (UTC)
Date:   Tue, 5 Nov 2019 07:30:08 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, stable@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 1/2] docs: admin-guide: Fix min value of threads-max in
 kernel.rst
Message-ID: <20191105063008.GC22672@dhcp22.suse.cz>
References: <20191101040438.6029-1-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101040438.6029-1-standby24x7@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 01-11-19 13:04:37, Masanari Iida wrote:
> Since following patch was merged 5.4-rc3, minimum value for
> threads-max changed to 1.
> 
> kernel/sysctl.c: do not override max_threads provided by userspace
> b0f53dbc4bc4c371f38b14c391095a3bb8a0bb40
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  Documentation/admin-guide/sysctl/kernel.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
> index 032c7cd3cede..38e0f10d7d9f 100644
> --- a/Documentation/admin-guide/sysctl/kernel.rst
> +++ b/Documentation/admin-guide/sysctl/kernel.rst
> @@ -1101,7 +1101,7 @@ During initialization the kernel sets this value such that even if the
>  maximum number of threads is created, the thread structures occupy only
>  a part (1/8th) of the available RAM pages.
>  
> -The minimum value that can be written to threads-max is 20.
> +The minimum value that can be written to threads-max is 1.
>  
>  The maximum value that can be written to threads-max is given by the
>  constant FUTEX_TID_MASK (0x3fffffff).
> -- 
> 2.24.0.rc1

-- 
Michal Hocko
SUSE Labs

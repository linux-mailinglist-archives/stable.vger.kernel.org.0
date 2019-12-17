Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE31225EB
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 08:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLQHx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 02:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfLQHx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 02:53:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77CF9206D3;
        Tue, 17 Dec 2019 07:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576569206;
        bh=aB61xygNweRVCvyENwafA/2Oej7mXAKlwsYd+kfYAgw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A4w9ZLl3gcKI1aB+sFHsndj3I4GPzZxXRS6fF1cOsxJnDDhiQW3xkAmvMOB0bhlwY
         FRtK/rBOb8vUiy1Q2f2Z4b63BFNoDiBWjvVs/Gp+9rKy+SJ1BlG+hj8MGerEt8JJYU
         4hm1SN3olUDJaHJHm/b14EsxxYU0Kja+t7asOFGM=
Date:   Tue, 17 Dec 2019 08:53:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        william.kucharski@oracle.com, bepvte@gmail.com, rppt@linux.ibm.com,
        Jan Kara <jack@suse.cz>, rientjes@google.com,
        dan.j.williams@intel.com, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
Message-ID: <20191217075322.GE2474507@kroah.com>
References: <20191216174848.701533383@linuxfoundation.org>
 <CA+G9fYta8SH1EhzTSLshp1xx=MqmbSKPM2oXdV1qMSx=o2Tqsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYta8SH1EhzTSLshp1xx=MqmbSKPM2oXdV1qMSx=o2Tqsw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 09:52:19AM +0530, Naresh Kamboju wrote:
> Results from Linaro’s test farm.
> Regressions on arm and qemu_arm.
> 
> Regressions (compared to build v4.14.158)
> ------------------------------------------------------------------------
> x15:
>   ltp-fs-tests:
>     * proc01
> 
> qemu_arm:
>   libhugetlbfs:
>     * HUGETLB_SHM_yes-shmoverride_linked-2M-32
>     * LD_PRELOAD_libhugetlbfs.so-HUGETLB_SHM_yes-shmoverride_unlinked-2M-32
>     * counters.sh-2M-32
>     * truncate_sigbus_versus_oom-2M-32
> 
>   ltp-fs-tests:
>     * proc01

What does all of this mean?

Can you bisect to find the offending patch?

thanks,

greg k-h

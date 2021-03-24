Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D622C347EDF
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 18:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbhCXRJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 13:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236257AbhCXRGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 13:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF90161A14;
        Wed, 24 Mar 2021 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616605601;
        bh=YJatJ6YMdx79po1ZSXMltFmZ56tTvNRjlJnx9rzxP/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OiGi4tRyerYkWyzX2Hgcme6KfniL4JE0oowPqzSweLU1tISIoH2jjhbCGDFSQOO0q
         mXSSorWeGsdODgOMI3/0polwfmdkmndyny90no4K0bKQ6L6v+EA29xrGnduRDrCkbV
         XjbEK15YaqC6mSq1zHatesYNqfK2n3CJSobm/S2c=
Date:   Wed, 24 Mar 2021 18:06:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, mike.kravetz@oracle.com,
        Nathan Chancellor <nathan@kernel.org>, dbueso@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: please pick 552546366a30 to 5.4.y
Message-ID: <YFtxnlHk4TLqtP5z@kroah.com>
References: <CAKwvOdmCpMf1Zp3tB=oqse6-Bsm_ybJQ=G5h__kEuOa47CjBHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmCpMf1Zp3tB=oqse6-Bsm_ybJQ=G5h__kEuOa47CjBHg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 09:47:49AM -0700, Nick Desaulniers wrote:
> Dear stable kernel maintainers,
> Please consider cherry-picking
> commit 552546366a30 ("hugetlbfs: hugetlb_fault_mutex_hash() cleanup")
> to linux-5.4.y.  It first landed in v5.5-rc1 and fixes an instance of
> the warning -Wsizeof-array-div.

What shows that warning?  I don't see it here with my gcc builds :)

thanks,

greg k-h

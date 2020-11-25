Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3B92C3F72
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 12:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgKYL6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 06:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729105AbgKYL6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 06:58:17 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00824206E0;
        Wed, 25 Nov 2020 11:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606305496;
        bh=Z43JqCrZpoEsDPbMMvJF4oV8D9NCp1FiWqOzZTKaoAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ORjuvBiTnwNpDq6NGHghAeiKEGw7cp0aUMKtFZX7SEllrPx7oXPHlaYH4uMZ5934v
         KC2VLuegmwz11u/86t4DuR0uN6e+o/+xZrsnqtXdWM/1o8WIy2Tn1ep/MoDUWtIGV2
         r+x8hrLSJf6qAgrQIE7yG3E+HuV3U146LCY7+nUg=
Date:   Wed, 25 Nov 2020 12:58:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     stable@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH for v4.14] mm/userfaultfd: do not access vma->vm_mm after
 calling handle_userfault()
Message-ID: <X75G1Wv4zfHpTmvY@kroah.com>
References: <1606124856217243@kroah.com>
 <20201123165258.80810-1-gerald.schaefer@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123165258.80810-1-gerald.schaefer@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 05:52:58PM +0100, Gerald Schaefer wrote:
> commit bfe8cc1db02ab243c62780f17fc57f65bde0afe1 upstream.
> 
> Alexander reported a syzkaller / KASAN finding on s390, see below for
> complete output.

<snip>

Both backports now queued up, thanks.

greg k-h

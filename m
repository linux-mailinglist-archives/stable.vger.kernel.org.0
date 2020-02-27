Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57538171828
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgB0NDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgB0NDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:03:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDC6124693;
        Thu, 27 Feb 2020 13:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582808618;
        bh=UgtBw7RFh5QlbWRiTV94zr36eIp75JJ0ryiZZLKpReA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KCzMs5/5tinRNwG/sVSvAiFuaLuEiXEq/XnBlEnNTP2+zhg5FHCHmfCgtbd1fgNeQ
         esnYWqaSiMJNkAR7f2Pgbs5GHyQfKXrL4Bhk2czDhht5rjHLOjVZG9YKKNtZxNngVh
         BR9rp7iiy6xhNIGrPoFnmThbU03icI+56+9CTCFA=
Date:   Thu, 27 Feb 2020 14:03:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     torvalds@linux-foundation.org, willy@infradead.org,
        jannh@google.com, vbabka@suse.cz, will.deacon@arm.com,
        punit.agrawal@arm.com, steve.capper@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.vnet.ibm.com,
        catalin.marinas@arm.com, n-horiguchi@ah.jp.nec.com,
        mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org, mszeredi@redhat.com,
        viro@zeniv.linux.org.uk, stable@vger.kernel.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, anishs@vmware.com,
        vsirnapalli@vmware.com, sharathg@vmware.com, srostedt@vmware.com
Subject: Re: [PATCH v4 v4.4.y 0/7] Backported fixes for 4.4 stable tree
Message-ID: <20200227130336.GA1023560@kroah.com>
References: <1582661774-30925-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1582661774-30925-1-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 26, 2020 at 01:46:07AM +0530, Ajay Kaher wrote:
> [Posting again after correcting CC’ed e-mail id]
> 
> These patches include few backported fixes for the 4.4 stable
> tree.
> I would appreciate if you could kindly consider including them in the
> next release.

Thanks for these, I'll look into them after this next round of stable
kernels.  Sorry for the delay, lots of other things to handle recently
:(

greg k-h

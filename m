Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F036631F226
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 23:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhBRWSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 17:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBRWSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 17:18:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B4964EB7;
        Thu, 18 Feb 2021 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613686645;
        bh=PNcU0MFoLneblkZM8eMbgf5EhwX8rz9XqklIk+N081U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L8/vqPj9t3CKRgnFrj+SBxKwu5tzj4hqNslVk5ME9XpnqmceUES4pLooJ8BdmOFTJ
         4VErOYImKkjx4Zuf/mLTG7+IH9kreNnXllJfjmmOZOLbZNPEhClp7XFcMe5VPGWKtB
         /sxLE4bBwMdhLetYbQpqxiMo/r+tZN+sGBTQs+oVJD7He5j1rQtRVK0U3A2kfRN3rn
         EsgkuORi6IuubT4nzL3f2e6Mh2wqPt+Vtd38vo/1eEryh/oeBLwaXxyEafSJUaXhut
         EpRAu68MdgljSUqkfn1LXty4CAXgYXqkCOlntiz6dfcHQueULVMB2ufTnGcFo4jrY9
         7cdKE9DtU6DLQ==
Date:   Thu, 18 Feb 2021 17:17:24 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, Dov Murik <dovmurik@linux.vnet.ibm.com>
Subject: Re: [PATCH] KVM: SEV: fix double locking due to incorrect backport
Message-ID: <20210218221724.GE2013@sasha-vm>
References: <20210218184058.1420763-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218184058.1420763-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 01:40:58PM -0500, Paolo Bonzini wrote:
>Fix an incorrect line in the 5.4.y and 4.19.y backports of commit
>19a23da53932bc ("Fix unsynchronized access to sev members through
>svm_register_enc_region"), first applied to 5.4.98 and 4.19.176.
>
>Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
>Reported-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
>Cc: stable@vger.kernel.org # 5.4.x
>Cc: stable@vger.kernel.org # 4.19.x
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Queued up, thanks!

-- 
Thanks,
Sasha

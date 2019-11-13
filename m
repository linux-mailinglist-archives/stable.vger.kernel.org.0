Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FBBFA001
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKMBSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbfKMBSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:18:47 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4299E20818;
        Wed, 13 Nov 2019 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573607926;
        bh=cWFUgc9/WbM1JBUyl6nC5epn+Sxpk+I2iHNF3JCvRzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFZqyCsQdXa09TJBj5G4d6yualQoRZfRb2KX0ZqsUQKbI+pL/864h+GADHn9e1yQx
         e0EQ6xcJ0J5vs4NIT2zrzuEmIvChyROaobMKvp8mA0efOggwatJMx0SSSXfpesaYlT
         WFw1Q7MKQXPv20Mb17pN3PvbHZREfKnIAyJyzqzM=
Date:   Tue, 12 Nov 2019 20:18:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.4 STABLE] kvm: mmu: Don't read PDPTEs when paging is
 not enabled
Message-ID: <20191113011845.GM8496@sasha-vm>
References: <20191112001705.5885-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191112001705.5885-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 04:17:05PM -0800, Sean Christopherson wrote:
>From: Junaid Shahid <junaids@google.com>
>
>Upstream commit d35b34a9a70edae7ef923f100e51b8b5ae9fe899.
>
>kvm should not attempt to read guest PDPTEs when CR0.PG = 0 and
>CR4.PAE = 1.
>
>Signed-off-by: Junaid Shahid <junaids@google.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Queued up for 4.4, thank you.

-- 
Thanks,
Sasha

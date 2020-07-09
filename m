Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C505721A210
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGIO0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 10:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgGIO0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 10:26:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E0B2206C3;
        Thu,  9 Jul 2020 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594304771;
        bh=ZLi9FYhVm5xn7RJqJBqePTX7TiM09RWnif+6QR44Jn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Idf5JsrYjdv+n1MqwYdxuGBt5VZxJlDPIFglAbkGWm0Rw3K2PQdqkrqb7lqgFaULf
         /76pO/nQ20kr6E1VpRj2iswpEjPWYcGrOZbwFvXhsw+WHfmqlUbXPVizT02ssRRXzi
         R48PAl1/5V3paVCGaJ3dHgtAsdrmIAXoapk7dx14=
Date:   Thu, 9 Jul 2020 10:26:10 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: "KVM: s390: reduce number of IO pins to 1" for stable
Message-ID: <20200709142610.GY2722994@sasha-vm>
References: <20200706171523.12441-1-pbonzini@redhat.com>
 <41c4e9e5-441f-3777-e399-70c82a2633e5@de.ibm.com>
 <20200708120027.GA651517@kroah.com>
 <c804e483-9eac-a578-0277-9ad10a730852@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c804e483-9eac-a578-0277-9ad10a730852@de.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 02:36:07PM +0200, Christian Borntraeger wrote:
>
>
>On 08.07.20 14:00, Greg KH wrote:
>> On Wed, Jul 08, 2020 at 01:33:49PM +0200, Christian Borntraeger wrote:
>>> stable team,
>>>
>>>
>>> Please consider commit 774911290c58 ("KVM: s390: reduce number of IO pins to 1")
>>> for stable. This can avoid OOM killer activity on highly fragmented memory
>>> even when swap and memory is available.
>>>
>>> We decided too late that this is stable material, so sorry for not marking it
>>> correctly.
>>
>> For what stable tree(s) is it relevant for?
>
>This improves commit 84223598778ba ("KVM: s390: irq routing for adapter interrupts.")
>so >= 3.15

I've queued it for all stable branches, thank you!

-- 
Thanks,
Sasha

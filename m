Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79665182DB
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 02:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfEIA1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 20:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbfEIA1K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 20:27:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34242216C4;
        Thu,  9 May 2019 00:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557361629;
        bh=n9NaYVasz19itEEeW9A7pgBMKMN9BIjYMK2U7NL6eKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ACS0u0u9xQT3gdFyhHur8CGaxlaKUadAHcx9gxNVfdHuV/ZSotizKYgMjk3Gulhvk
         V46WoVN+WdJQbLAuirVzNjwNiQ5yYKPu+6O+P71t8/rq1ZJkNn6kkunpb0gZ8o1DOq
         kPJNC7M6qOm2xkSq6yEujsYf0CGlerH0r73+9S7c=
Date:   Wed, 8 May 2019 20:27:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Major Hayden <major@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190509002708.GN1747@sasha-vm>
References: <cki.A78709C14B.5852BV39BE@redhat.com>
 <20190508164957.GA6157@kroah.com>
 <fc0c62c2-c923-822d-c255-683ca22e7495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fc0c62c2-c923-822d-c255-683ca22e7495@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 02:59:13PM -0500, Major Hayden wrote:
>On 5/8/19 11:49 AM, Greg KH wrote:
>> Meta-comment, are you all going to move to the "latest" stable queue
>> now that 5.1 is out?  Or are you stuck at 5.0?  5.0 is only going to be
>> around for a few more weeks at most.
>>
>> And, any plans on doing this for 4.19 or other older LTS kernels that
>> are going to be sticking around for many years?
>
>We generally test the latest stable, but we could try to add some of the LTS versions in addition to the latest stable if that would help. I'll add in 4.19 today and see how it runs with our existing test set.

If anything breaks we're more than happy to fix it :)

--
Thanks,
Sasha

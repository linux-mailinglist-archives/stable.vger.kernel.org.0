Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD633690D
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 03:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFFBOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 21:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbfFFBOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 21:14:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3422E2070B;
        Thu,  6 Jun 2019 01:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559783663;
        bh=g1UL1wAjgceXSzuwYTKaFWPQnj/kbq2Ld7r6iHfv+aI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V0JKCU0YiOCLo6PPXaLci0hC4lCxVPOub+PPKheilYMhNe6jsQ31aLBND0+fYWeAP
         YRhlBCfJDc41WVQ+07+jBW8mp1Uk9oMZ9eC//ulM6GMgVl8VKf8dc9Q0BvU1ch5e7A
         kkDeEYej4ekqEr3lUlTEh4dEhHyNOQKSekLq+yKE=
Date:   Wed, 5 Jun 2019 21:14:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Phil Elwell <phil@raspberrypi.org>, stable@vger.kernel.org
Subject: Re: Dynamic overlay failure in 4.19 & 4.20
Message-ID: <20190606011422.GG29739@sasha-vm>
References: <45e99a24-efb9-5473-2e57-14411537dc9f@raspberrypi.org>
 <2da582d1-11eb-3680-33f2-3a5c139613a8@raspberrypi.org>
 <20190605175059.GA29747@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190605175059.GA29747@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 07:50:59PM +0200, Greg Kroah-Hartman wrote:
>On Wed, Jun 05, 2019 at 01:02:18PM +0100, Phil Elwell wrote:
>> Hi,
>>
>> I think patch f96278810150 ("of: overlay: set node fields from
>> properties when add new overlay node") should be back-ported to 4.19,
>> for the reasons outlined below (briefly: without it, overlay fragments
>> that define phandles will appear to merged successfully, but they do
>> so without those phandles, causing any references to them to break).
>
>That patch does not properly apply to the 4.19.y tree.  Can you provide
>a working backport that I can queue up to resolve this?

Greg,

That patch has contextual dependencies on 6f75118800 ("of: overlay:
validate overlay properties #address-cells and #size-cells"), I think it
would make sense to take 6f75118800 and then f96278810150 rather than a
backport.

--
Thanks,
Sasha

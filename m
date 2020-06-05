Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034911EEEF0
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 03:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgFEBM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 21:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgFEBM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 21:12:56 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C098207ED;
        Fri,  5 Jun 2020 01:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591319575;
        bh=TIPus6gLZUqRCrDwXh04rz7C8bizFW3qdvMap51arRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4ZfSJ4ijkcGAzuSUpydSU/l1U0WIm0FYmZJi5YLeRIIAhzEv23EJV4f2GpnCReZb
         mkGDynfcqOD1AFrbfSvefkXY3qHxGjREI5xKDoSeoqAxn+uNOBjbgV48nRYL0rd5r6
         nFNmYnT+iXg2kghSpVh8mlfkJcbYq1QFKYyzHw+I=
Date:   Thu, 4 Jun 2020 21:12:54 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     David =?utf-8?Q?Bala=C5=BEic?= <xerces9@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 12/80] pppoe: only process PADT targeted at local
 interfaces
Message-ID: <20200605011254.GR1407771@sasha-vm>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173452.813559136@linuxfoundation.org>
 <CAPJ9Yc8YOeqeO4mo80iVMf3ay+CkdMvYzJY1BqXMNPcKzL6_zg@mail.gmail.com>
 <20200604201712.GB1308830@kroah.com>
 <CAPJ9Yc-0jocU2WJP_27hQa43XFwGWJJx0LBNXShoryZE1K54sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPJ9Yc-0jocU2WJP_27hQa43XFwGWJJx0LBNXShoryZE1K54sQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 12:31:31AM +0200, David Balažic wrote:
>On Thu, 4 Jun 2020 at 22:17, Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> On Thu, Jun 04, 2020 at 08:39:00PM +0200, David Balažic wrote:
>> > Hi!
>> >
>> > Is there a good reason this did not land in 4.14 branch?
>> >
>> > Openwrt is using that and so it missed this patch.
>> >
>> > Any chance it goes in in next round?
>>
>> Does it apply and build cleanly?
>>
>> I don't know why I didn't backport it further, something must have
>> broke...
>
>The patch from the above applies to linux-4.14.183
>
>If I apply it manually (open pppoe.c in editor and add the two lines
>from the patch) then it builds.
>Until LD      vmlinux.o when I run out of disk space...
>I applied it by editor because the first time something went wrong
>when copying the patch from the email and it did not apply.
>
>So it looks OK, but someone else should try it too.
>My build system is not exactly great.. (it is a VM I created for
>openwrt builds and it is after midnight and I don't feel like
>extending the virtual disk.. sorry, maybe tomorrow).

Hm, indeed it looks ok for 4.14 (and 4.9, 4.4) so I've queued it up,
thank you.

-- 
Thanks,
Sasha

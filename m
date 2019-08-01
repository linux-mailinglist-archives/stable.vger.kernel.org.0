Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE19F7DDF0
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 16:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfHAOb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 10:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731284AbfHAOb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 10:31:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 722C812BB;
        Thu,  1 Aug 2019 14:31:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F75960A9F;
        Thu,  1 Aug 2019 14:31:26 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C85C41F40;
        Thu,  1 Aug 2019 14:31:26 +0000 (UTC)
Date:   Thu, 1 Aug 2019 10:31:26 -0400 (EDT)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Message-ID: <2057215544.6298959.1564669886072.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190801140639.GB31375@kroah.com>
References: <20190730093345.25573-1-marcel@holtmann.org> <20190801133132.6BF30206A3@mail.kernel.org> <20190801135044.GB24791@kroah.com> <1983583259.6283500.1564667755023.JavaMail.zimbra@redhat.com> <20190801140639.GB31375@kroah.com>
Subject: Re: [PATCH v5.3-rc2] Bluetooth: hci_uart: check for missing tty
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.2.29, 10.4.195.22]
Thread-Topic: Bluetooth: hci_uart: check for missing tty operations
Thread-Index: C7jFpDH0teKpSIJuE8GzHUEFBMgj1g==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 01 Aug 2019 14:31:27 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Greg, all,

I've just double-checked your backports, indeed, they are fine.

Check for operations is not added for protocols which does not
use these operations. Thanks!

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

----- Original Message -----
> From: "Greg KH" <greg@kroah.com>
> To: "Vladis Dronov" <vdronov@redhat.com>
> Cc: "Sasha Levin" <sashal@kernel.org>, "Marcel Holtmann" <marcel@holtmann.org>, torvalds@linux-foundation.org,
> linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
> Sent: Thursday, August 1, 2019 4:06:39 PM
> Subject: Re: [PATCH v5.3-rc2] Bluetooth: hci_uart: check for missing tty operations
> 
> On Thu, Aug 01, 2019 at 09:55:55AM -0400, Vladis Dronov wrote:
> > Thank you, Greg!
> > 
> > I've just noticed the patch landed in the upstream and was going to start
> > stable
> > backports, but it appeared you've already done this.
> 
> Verifying that I got the 4.4.y and 4.9.y and 4.14.y backports done
> properly would be good, as I took a guess at them :)
> 
> thanks,
> 
> greg k-h

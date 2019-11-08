Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E572FF411B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 08:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfKHHQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 02:16:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfKHHQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 02:16:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10162085B;
        Fri,  8 Nov 2019 07:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573197367;
        bh=RJ3i04SwfXcwKmq0EHYyXVnlEbH7f72RMSXYsyco3L8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qNxChiB28FrgtcROd3gfSgzttSq+FiQ0KkYycBEDrRs3Uv858qYTVK5vFoSpjDSiH
         m6m0ZovTUajtO2clgbtLs3Le+Bk2cfnUr3hWbDbWlS1OqgLrWr9OaEaBwq8RbfQ6+1
         USRXfwWSAPWNM7uhvBzX7EoJ8I87W8ek41D1rTHs=
Date:   Fri, 8 Nov 2019 08:16:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "net: bcmgenet: soft reset 40nm EPHYs before MAC init" has
 been added to the 4.19-stable tree
Message-ID: <20191108071604.GA526603@kroah.com>
References: <1573050816170143@kroah.com>
 <5e6efc7e-f738-0198-3b74-433ae766da51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e6efc7e-f738-0198-3b74-433ae766da51@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 10:08:27AM -0800, Doug Berger wrote:
> Just to triple check, this commit should be removed from the 4.19-stable
> tree too.

Ah, good catch, now dropped, thanks.

greg k-h

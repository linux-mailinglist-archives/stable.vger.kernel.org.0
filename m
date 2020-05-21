Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B06A1DDB18
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgEUXgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgEUXgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:36:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CB4207D8;
        Thu, 21 May 2020 23:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590104191;
        bh=Bk1t+3feU+20ydiOpYXpQJjGjHTQrzFOr4sofrjmx8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z/tz8bRA32xQQ2Z2tljeqGH458NTJyvQVkpPPW5HxUTuTYzliQn422ZucziyS5ZYd
         PzcQ/IJlIva4gDFOABfvoQoTORqSXj7oj2Leid0V2PcJh5SCiHmaiuaynJyn+KgLKT
         S+QlDAfEGYf4JHIWPwH9fVOpxaBXYr45/4xSCggk=
Date:   Thu, 21 May 2020 19:36:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [4.4] Security fixes
Message-ID: <20200521233630.GJ33628@sasha-vm>
References: <cd7a780e9fad63868960562ca2e59383d03081c3.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd7a780e9fad63868960562ca2e59383d03081c3.camel@codethink.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 11:20:01PM +0100, Ben Hutchings wrote:
>I've backported fixes for I²C and media controller devices, dealing
>with the lifetime of related cdev and struct device instances and some
>similar race conditions.  Fixing the lifetime issue for watchdog
>devices looks impractical for 4.4, as it depends on a big refactoring
>in 4.5.
>
>All but one of these are already included in or queued for the later
>stable branches.  You dropped the I²C lifetime fix for 4.9, but I hope
>my previous replies persuaded you that it is valid.

Ignore what I said in my previous mail, I've backed out my changes and
took yours, thanks!

-- 
Thanks,
Sasha

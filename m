Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EFF9B9DA
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 02:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfHXAka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 20:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHXAka (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 20:40:30 -0400
Received: from localhost (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A5AB206BA;
        Sat, 24 Aug 2019 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566607230;
        bh=tdWLEZUDiMqln9cUGhY4UcjGN5VP14/V82Kp03AIdng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lbBVeOmXbe7+PYUT0zoKUgKsv1Ma6jWN4//g7iibmO5a/pyAQZwixR3jUoDozsP3h
         AYABqfmu4dhcicB3pUeliUXV9ru4StEFhW4gJMTSRxA8mKaFtevgX8GARZRlYlUANx
         fw+YuYxcej6fXtRY14dAZIWlkZtFk59yNPLRTQB4=
Date:   Fri, 23 Aug 2019 20:40:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Rachel Sibley <rasibley@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Jeff Bastian <jbastian@redhat.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.10-rc1-f5284fb.cki (stable)
Message-ID: <20190824004027.GG1581@sasha-vm>
References: <cki.66AF037CBA.ROCU3L6TFM@redhat.com>
 <b851881f-7bf0-fb91-f6c1-ec101f5d8fd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b851881f-7bf0-fb91-f6c1-ec101f5d8fd4@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 08:02:16AM -0400, Rachel Sibley wrote:
>The IOMMU test didn't exit properly after skip, and has since been 
>fixed. Looks like the stress-ng
>test resulted in a call trace, which can be observed in this log:
>http://beaker-archive.host.prod.eng.bos.redhat.com/beaker-logs/2019/08/37443/3744374/7270379/98159897/451777568/resultoutputfile.log

This seems to be a redhat-internal link...

--
Thanks,
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB9C2CD96A
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 15:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgLCOkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 09:40:25 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42431 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgLCOkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 09:40:24 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C9CAC22EE3;
        Thu,  3 Dec 2020 15:39:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1607006381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u13M+Fi/wa3Z0rVt0fxqI18Wvs+Sch7UcGcItdEZP2Q=;
        b=T4y41W5r0OE+EslRkxis9lWHQAdUDT0/bB31ZdeQErgYi4gjV/1HTtu5LvMroMmwFelpVq
        BzHsScTJO20FLxN5xNcdnXZM5DBFsntFTfsRnD+j+jfRrLV8v7R60j/AqwHdJtM5u7yEor
        FgCOw7UBvVsUvT/OU6FB89EN2Sn5yy8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 15:39:40 +0100
From:   Michael Walle <michael@walle.cc>
To:     Tudor.Ambarus@microchip.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        boris.brezillon@collabora.com, stable@vger.kernel.org
Subject: Re: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the
 SST25VF064C
In-Reply-To: <44be8e3c-86ca-501e-e575-55f17747bda6@microchip.com>
References: <20201202230040.14009-1-michael@walle.cc>
 <20201202230040.14009-2-michael@walle.cc>
 <44be8e3c-86ca-501e-e575-55f17747bda6@microchip.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <bf31d41ca489b5d1b7976bfb8ede88e9@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2020-12-03 15:34, schrieb Tudor.Ambarus@microchip.com:
> On 12/3/20 1:00 AM, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
>> the content is safe
>> 
>> This flash part actually has 4 block protection bits.
>> 
>> Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>> Cc: stable@vger.kernel.org # v5.7+
> 
> While the patch is correct according to the datasheet, it was
> not tested, so it's not a candidate for stable. I would update
> the commit message to indicate that the the patch was made
> solely on datasheet info and not tested, I would add the fixes
> tag, and strip cc-ing to stable.

What is the difference? Any commit with a Fixes tag will also land
in the stable trees. Just that it will cause compile errors for
kernel older than 5.7.

So if you don't want to have it in stable then you must not add
a Fixes: tag either.

-michael

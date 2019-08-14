Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967678CED7
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 10:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfHNIyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 04:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfHNIyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 04:54:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 099EB2A09C6;
        Wed, 14 Aug 2019 08:54:37 +0000 (UTC)
Received: from localhost (unknown [10.40.205.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CF5D82201;
        Wed, 14 Aug 2019 08:54:36 +0000 (UTC)
Date:   Wed, 14 Aug 2019 10:54:35 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3] mt76: mt76x0e: disable 5GHz band for MT7630E
Message-ID: <20190814085434.GB29199@redhat.com>
References: <1565703416-10669-1-git-send-email-sgruszka@redhat.com>
 <20190813175526.CCBC220840@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813175526.CCBC220840@mail.kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 14 Aug 2019 08:54:37 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 05:55:26PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189, v4.4.189.
> 
> v5.2.8: Build OK!
> v4.19.66: Failed to apply! Possible dependencies:
>     86c71d3deefa ("mt76: move eeprom utility routines in mt76x02_eeprom.h")
>     d6500cf3700f ("mt76x0: add quirk to disable 2.4GHz band for Archer T1U")
>     eef40d209ad0 ("mt76: move common eeprom definitions in mt76x02-lib module")
<snip>
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

mt76x0e support was added in 4.20 , so it's fine just to apply this
commit in 5.2 .

Stanislaw 

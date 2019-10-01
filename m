Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A87C4456
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 01:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfJAXcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 19:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729101AbfJAXcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 19:32:24 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB18721906;
        Tue,  1 Oct 2019 23:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569972743;
        bh=JKvSms0b6/gOV5YriYzOFcsOHmR1CogJsw6kXsBLwI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pdFcDM85oqoY9vietFMv+Byg96SYvSlgzvUKjlLCHLhGEdDC1SAjPk3fhPzKgSt4A
         cAkPxIgAP8KdnFh4j71VcZaSc+p1TE038YIcX+ckb7W01pxX0ZxB2fuEeCM7wj5r2z
         qfSYGChpQMda5+FOojVXDa/eQZG4vsm/HMHxf3Os=
Date:   Tue, 1 Oct 2019 19:32:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     glogow@fbihome.de, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/realtek - PCI quirk for Medion
 E4254" failed to apply to 5.3-stable tree
Message-ID: <20191001233222.GF17454@sasha-vm>
References: <1569949335234236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1569949335234236@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 07:02:15PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I'm not quite sure what was the issue here, maybe line numbers moved
around too much for quilt? Build looks fine too.

I've queued it up for 5.3-4.19.

--
Thanks,
Sasha

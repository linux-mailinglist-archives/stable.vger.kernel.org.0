Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625412E4B0
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfE2Sqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfE2Sqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:46:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FFAA23F61;
        Wed, 29 May 2019 18:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559155607;
        bh=2jSTGQIika5Ts5Fwsc/mV5ujETLoG2b0gt4BMPBg8u8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uojj0cfYOr92tRLuLsTaQg9coil+CH6wx0vHXyGcCx0HDsV0ob8dZjcqEDl3amTsN
         93pcpQEcL0mkyBk6MS9pe0sJTPzRs7Tmh85mydKtvGhJOQb9H5E28qzaQO3LolD9Wb
         3c1EaOvTpaNQ8oD7RwmyNzoiXGD07SXhsBLQBxw4=
Date:   Wed, 29 May 2019 14:46:46 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Benjamin Coddington <bcodding@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 004/375] NFS: make nfs_match_client killable
Message-ID: <20190529184646.GE12898@sasha-vm>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-4-sashal@kernel.org>
 <E7EBFAFD-D312-4EBA-970B-54F07EDD1F9D@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <E7EBFAFD-D312-4EBA-970B-54F07EDD1F9D@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 11:02:39AM -0400, Benjamin Coddington wrote:
>Hi Sasha,  if you take this one, you'll need the fix for it:
>
>c260121a97a3 ("NFS: Fix a double unlock from nfs_match,get_client")
>
>I didn't see this fix go through my inbox for your stable tree, so 
>apologies if maybe I missed it.
>
>Looks like you are also applying this one to 4.19 and 4.14, -- I'll 
>just reply once here.

Queued c260121a97a3 up for 5.1-4.14, thank you!

--
Thanks,
Sasha

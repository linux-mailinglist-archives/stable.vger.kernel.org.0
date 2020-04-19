Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9637E1AFEF2
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 01:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgDSXm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 19:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgDSXmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 19:42:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8CF20771;
        Sun, 19 Apr 2020 23:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587339745;
        bh=Mz0foaJDy0dQCzGPIs1Fu8oqh7sx0QGv5+lc0UeWqOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VEf/UJTmtjkwgJ4avSbzQRiA6gglcdleU+7VzsIhwvp/oEesJtoZNyacg/lEhPMjb
         umTlx8CoVyn+0vgwXod7tbyWyyC+LKArzW2ghx4r8V/RAmP2vGJrajMUBLJhIlD1oC
         9dSa0VLrACl2QMCqDLBxYIIob4XR9xduS/tqY7gQ=
Date:   Sun, 19 Apr 2020 19:42:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [stable] kvm: x86: Host feature SSBD doesn't imply guest feature
 SPEC_CTRL_SSBD
Message-ID: <20200419234223.GH1809@sasha-vm>
References: <4bf47792424516d5ee0f41831fd4ebc181f7d3a5.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4bf47792424516d5ee0f41831fd4ebc181f7d3a5.camel@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 19, 2020 at 09:34:18PM +0100, Ben Hutchings wrote:
>Please apply the attached backport of commit
>396d2e878f92ec108e4293f1c77ea3bc90b414ff to the 4.4, 4.9, 4.14, and
>4.19 stable branches.

Queued up, thanks!

-- 
Thanks,
Sasha

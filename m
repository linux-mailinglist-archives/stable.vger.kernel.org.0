Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7562E4CA
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfE2SvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfE2SvV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 14:51:21 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CD4624056;
        Wed, 29 May 2019 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559155880;
        bh=0ZzrcgBGVfZ/PWEdBvIb97tLixwq7FM2BS+szZHK7+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MprGCPlWVTU3pUVTYrl5/4MqcXbWnuVG9rTEYI/rjsq0I9ninigfkE7v3rdQKQwK0
         vXQknEQlHNiriONe46K1YBXeb8Kj4v6gd0J27GX0Gm60mVbG8B0shfzTpgdjJqrMPl
         jOXfIwhm1BpVQHmkaw+0iB6LJQ8dPhoHvoNLKh9A=
Date:   Wed, 29 May 2019 14:51:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     martin@omnibond.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Marshall <hubcap@omnibond.com>, devel@lists.orangefs.org
Subject: Re: [PATCH AUTOSEL 5.1 025/375] orangefs: truncate before updating
 size
Message-ID: <20190529185119.GG12898@sasha-vm>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-25-sashal@kernel.org>
 <20190522214437.GA87137@t480s.mkb.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190522214437.GA87137@t480s.mkb.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 05:44:37PM -0400, martin@omnibond.com wrote:
>I don't think it makes much sense to put this one in stable.  Without
>the rest of the pagecache patches the race doesn't exist.

Dropped it, thank you!

--
Thanks,
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 947065DCA2
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfGCCrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfGCCrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:47:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47EDB21721;
        Wed,  3 Jul 2019 02:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562122025;
        bh=/5rTbplUIS3P82/nrCyz60q08P6DaMOsWJbXI6TJPZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WnyGRBJY1cK7Y1P9+ShEnaQDIJjrrRuWf7l3cnFc0syWchrId8/4MQyjhbKpn6W6f
         76XtaI37v7uKYFzP8x25w10ch2e+eG6lWHVN5zWwJpddmLIdk024erNPm3UDdFe/Js
         1cSsKC37qvb0lFZWoglBL+7jc5ZP+q3fPSw7txEo=
Date:   Tue, 2 Jul 2019 22:47:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [STABLE 4.19] fixes for xfs memory and fs corruption
Message-ID: <20190703024704.GT11506@sasha-vm>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <20190213205804.GE32253@magnolia>
 <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
 <20190627233216.GD11506@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190627233216.GD11506@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 07:32:17PM -0400, Sasha Levin wrote:
>On Thu, Jun 27, 2019 at 07:12:48PM +0300, Amir Goldstein wrote:
>>Darrick,
>>
>>Can I have your blessing on the choice of these upstream commits
>>as stable candidates?
>>I did not observe any xfstests regressions when testing v4.19.55
>>with these patches applied.
>>
>>Sasha,
>>
>>Can you run these patches though your xfstests setup?
>>They fix nasty bugs.
>
>Will do. Tests running now - I'll update tomorrow.

I gave it a few more days, and it looks good here.

--
Thanks,
Sasha

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB158E8F
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 01:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfF0XcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 19:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfF0XcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jun 2019 19:32:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 167C12084B;
        Thu, 27 Jun 2019 23:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561678338;
        bh=mU1N/t/ui/zL9fYI+5p6MtnN3ZxYI5JKMwlh1ZDaM2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XrAz1gif88GA0ZvGIeVq3QZ+eHkS0xLMghFU3+6GOLr6MCQCp1LugGwXZDCmSa/7b
         cfNZjsaANO0UFhOKaq9ivmO3Fu/ltzRULF7ho0BRgmNkpxFey126kYtFuMPiPtgCrG
         N2TV4YM+5bW68c4zHoc4Bb34SRFrZPJuEUCJXeo0=
Date:   Thu, 27 Jun 2019 19:32:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [STABLE 4.19] fixes for xfs memory and fs corruption
Message-ID: <20190627233216.GD11506@sasha-vm>
References: <155009104740.32028.193157199378698979.stgit@magnolia>
 <20190213205804.GE32253@magnolia>
 <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOQ4uximAfJjNdunY2xK_1DwC2G7v31XWbv64AdO9nYdExUsVw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 27, 2019 at 07:12:48PM +0300, Amir Goldstein wrote:
>Darrick,
>
>Can I have your blessing on the choice of these upstream commits
>as stable candidates?
>I did not observe any xfstests regressions when testing v4.19.55
>with these patches applied.
>
>Sasha,
>
>Can you run these patches though your xfstests setup?
>They fix nasty bugs.

Will do. Tests running now - I'll update tomorrow.

--
Thanks,
Sasha

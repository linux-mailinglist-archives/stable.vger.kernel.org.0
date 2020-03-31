Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFD8199828
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 16:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgCaOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 10:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbgCaOId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 10:08:33 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F11B20838;
        Tue, 31 Mar 2020 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585663712;
        bh=NfQh3SVDHcFKUzksgzejckgXqyi/Tvm5FblasQs8G5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GWxUKHGpyVUaDAB4rIa/3r4G88Bo3hrmIThbFwEdKjvY/iTLdWhUesVigRjP+pGJl
         YOH3B9ms5fj79M3GSCRfswKNV+qzVDism8XCeZ0d1HnQnIOrnxCzqATHYqiKiLhN9w
         zs6X+AEXdjRfF5AtLrLhwx3TKP0yykShyJjxxQK4=
Date:   Tue, 31 Mar 2020 10:08:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Backport dependencies helper
Message-ID: <20200331140830.GN4189@sasha-vm>
References: <20200331123217.GM4189@sasha-vm>
 <20200331134400.GA24671@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200331134400.GA24671@1wt.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 03:44:00PM +0200, Willy Tarreau wrote:
>Hi Sasha,
>
>On Tue, Mar 31, 2020 at 08:32:17AM -0400, Sasha Levin wrote:
>> Each
>> directory represents a kernel version which we'll call K, and each file
>> inside that directory is named after an upstream commit we'll call C,
>> and it's content are the list of commits one would need to apply on top
>> of kernel K to "reach" commit C.
>
>That's very interesting! I still have nightmare-like memories or
>complete week-ends spent trying to address this using heuristics
>when I was maintaining 2.6.32 and 3.10. However how do you produce
>these ? Is this related to the stable-deps utility in your stable-tools
>repository ?

No, those tools try to do the same thing, but work differently.
stable-deps attempts to look at context lines surrounding the patch
itself to guess which other patches might be interesting.

While here, I use git-bisect to create a list of commits required to be
applied before any given commit.

-- 
Thanks,
Sasha

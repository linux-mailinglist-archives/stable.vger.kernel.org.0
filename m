Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42F2F70B1
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 03:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbhAOCoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 21:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbhAOCoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 21:44:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1296D23AC6;
        Fri, 15 Jan 2021 02:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610678612;
        bh=grJq1KY5PpM/Z0b0SsSZ3+Ozoq/ynPTitpHIpG1FDFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k5fUbAknBSkkr7M69TD7qNSI6MjjAQeKMYNbEAMyfqqRSMnlTpPM+UCqOVbKxKQlh
         qCRUp2RqBKDrNG/YN7mNWAAWryIMu0BZH6ItDyOU51IQIcwj82nKKFuTpUkJNvRKIR
         LBsL07lLo4KldzDavTdifoyjD1LcDnNvJj4xo6dbM2sXNO0M92NKynGw28f8d7MXtx
         DbTMqpJITu5fywo/qBfb2ZsLgQnWxzXybKh++O7Ag1URjtR9rjQABj6u5rBEiyGYRV
         YfEgF/AMkQg2ZI+W5loNsSD2CPazMv4UNowHj3B2caXYidf3DsicGUd73OgvJH9gZb
         wPNTFIZgXgWFg==
Date:   Thu, 14 Jan 2021 21:43:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Saied Kazemi <saied@google.com>
Cc:     gregkh@linuxfoundation.org, axboe@kernel.dk,
        stable@vger.kernel.org, Vaibhav Rustagi <vaibhavrustagi@google.com>
Subject: Re: Fix CVE-2020-29372 in 4.19 and 5.4
Message-ID: <20210115024330.GW4035784@sasha-vm>
References: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+Um-ghfTG=+x8iT-uPikM7NNsN1J6CCiztxsBgQ9OJPUBQjyg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 05:55:13PM -0800, Saied Kazemi wrote:
>Hi Greg,
>
>To fix CVE-2020-29372 in COS kernel versions 4.19 and 5.4, we
>cherry-picked the commit "mm: check that mm is still valid in
>madvise()" (bc0c4d1e176e) that Jens introduced in kernel version 5.7.0
>into our kernel sources.  The commit is small and the cherry-pick was
>successful for both COS kernels versions.
>
>Because COS 4.19 and 5.4 kernels track 4.19.y and 5.4.y respectively,
>can you please cherry-pick the commit to those stable branches?

5.4 didn't support IORING_OP_MADVISE and 4.19 didn't have io_uring to
begin with, how is this an issue on those branches?

-- 
Thanks,
Sasha

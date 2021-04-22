Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00949367FD0
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhDVLvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 07:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhDVLvl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 07:51:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 094756144D;
        Thu, 22 Apr 2021 11:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619092267;
        bh=Ir4R3zbRZtzbZs2WtvwXHvITl/awM6exbEMnF8zmLLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UhyI5eJdfD88Zdv0rMTUV2hrwn7DGxec1LJvQ+ZGgYfGC+bBUWYfMJy9XCEO88NEA
         L8U+xKoCdPjolY0QVOY+ilbAbFhSTSzqxNCSj4BhkcDDAoYg3R35iXt+1txKGPlXc7
         1khKpZmsiEU0JhxfYqMUdr9exIIidJVk6xqR8zXj9NSA0yah6nxOY4d3mGdp6UZgQF
         wV5q1B08vcOO0n+EGpB32eKcs7JjFhCBhQ/N5qO75BhGZqBaGa6BUzTFy/3t9UW6+Z
         AjUiiIGZiOFQbR/aiTBIs3C5BgDJoMC7e6mNYA8clr7rkCI+cZApKq1orBeew/boR2
         +hfWq81+V2xoA==
Date:   Thu, 22 Apr 2021 07:51:05 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [resend] revert series of umn.edu commits for v5.11.y
Message-ID: <YIFjKbiZd9hUJmbQ@sashalap>
References: <YICidTdSYPut4oVa@debian>
 <YIEVGXEoeizx6O1p@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YIEVGXEoeizx6O1p@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 07:18:01AM +0100, Sudip Mukherjee wrote:
>Hi Greg,
>
>Resending with individual attachments as the previous mail with all the
>attachments (sent last night) did not appear in https://lore.kernel.org/stable.
>
>This is based on the 190 commits that you posted for mainline. Out of
>that 24 patches had a reply mail asking not to revert (till last night).
>So, the attached series for stable is based on the remaining 166 commits.
>I have borrowed the commit message from your series.

Let's wait with these until reverts are merged upstream, we don't want
to diverge here.

-- 
Thanks,
Sasha

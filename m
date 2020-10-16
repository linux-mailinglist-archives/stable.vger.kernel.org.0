Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17528FC47
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 03:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389037AbgJPBuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 21:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388885AbgJPBuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Oct 2020 21:50:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 960572078A;
        Fri, 16 Oct 2020 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602813018;
        bh=Xj+mBp5030/4UsIx6cE0dgTRR8XQvQnGmSDr6zSCeWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r0vThze8OEM4BqYXYmEdw4gjjZyfku5rioKHjMmnQVmMLikoQ89gTAgd2iiiMDtMQ
         0hCmrOR/bdbo7F3INdrjSSS5rAbEe8svgl3wmX5jbhoiY8WmIskg1hU/jG0sttyhnz
         248ReZZkhVhG76jPqeF/KjSI1k4Gt7Hf8XHxAyhQ=
Date:   Thu, 15 Oct 2020 21:50:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Burgener <dburgener@linux.microsoft.com>
Cc:     stable@vger.kernel.org, stephen.smalley.work@gmail.com,
        paul@paul-moore.com, selinux@vger.kernel.org, jmorris@namei.org
Subject: Re: [PATCH v5.4 3/3] selinux: Create new booleans and class dirs out
 of tree
Message-ID: <20201016015017.GU2415204@sasha-vm>
References: <20201015192956.1797021-1-dburgener@linux.microsoft.com>
 <20201015192956.1797021-4-dburgener@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201015192956.1797021-4-dburgener@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 03:29:56PM -0400, Daniel Burgener wrote:
>As a final note about changes from the original patch, I dropped a patch
>that was only style cleanup, so this patch no longer takes advantage of
>the style changes.

I'd suggest to bring that patch back for this series. We're trying to
minimize the delta between upstream and stable rather than minimize
stable itself.

-- 
Thanks,
Sasha

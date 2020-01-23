Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CFA146D3B
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 16:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAWPqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 10:46:43 -0500
Received: from fanzine.igalia.com ([178.60.130.6]:49503 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgAWPqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 10:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=EybSTW7nAojsrbMigS0VuJrqBhLXEfKwemDkQL61YDw=;
        b=hREQRwPaJ0hcjFJeVMaj2jsgDr7c3KtPeusP7IqLI8a3kYOLQtKN1kyuOjUyWEWzDMazv50gyS3fdmWGupI6U1Rq/9wNjDEHFNNClsahnrEybsqiqHeo5QizbScgNbiHPs2ZGpTkDGvCjfTxRMNY5kACSTMljVDjp7wB8BHPqIM8X5QfafMF5txvQk9Mb4q1K0v9OJ7sqUA15/dHM72ZRBtKy5JzsHVyJ1Cj+gej4C9S0crCzfjbMNzqBp9/7i3dvNIrhD4qK6RRpbKJ4OCqLCSOl+ldwdnirlJ3WnhyAfeKtqQHGE/Xap+qesoqKq/2GKzmeybYUosDGC/HCBZq3w==;
Received: from 78.26.117.91.dynamic.reverse-mundo-r.com ([91.117.26.78] helo=zeus)
        by fanzine.igalia.com with esmtpsa 
        (Cipher TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim)
        id 1iuegr-00089n-3Q; Thu, 23 Jan 2020 16:46:41 +0100
Message-ID: <61f87e35445280d64b5f6955826c354580ab3e01.camel@igalia.com>
Subject: Re: [PATCH AUTOSEL 5.4 003/205] drm/v3d: don't leak bin job if
 v3d_job_init fails.
From:   Iago Toral <itoral@igalia.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Anholt <eric@anholt.net>, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>
Date:   Thu, 23 Jan 2020 16:46:31 +0100
In-Reply-To: <20200123141737.GC1706@sasha-vm>
References: <20200116164300.6705-1-sashal@kernel.org>
         <20200116164300.6705-3-sashal@kernel.org>
         <cb93a21557216d1b389390c556f421132aac88f0.camel@igalia.com>
         <20200123141737.GC1706@sasha-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-01-23 at 09:17 -0500, Sasha Levin wrote:
> On Fri, Jan 17, 2020 at 08:25:30AM +0100, Iago Toral wrote:
> > Hi Sasha,
> > 
> > 
> > please notice that there were two separate patches that addressed
> > the
> > same issue and applying both simultaneously leads to a double free
> > (which is what I see is happening with this patch: see the second
> > call
> > to kfree(bin) right below the one added here). This issue was
> > raised
> > previously here:
> > 
> > https://lists.freedesktop.org/archives/dri-devel/2019-October/241425.html
> 
> I'll drop this patch for now. Any idea why upstream didn't pick up
> the
> fix yet? I see the problem still exists there.

+Daniel

I am not sure, when this issue was found Daniel added a few people on
CC as heads-up, but maybe nobody actually got to fix the merge conflict
in the end?

Iago


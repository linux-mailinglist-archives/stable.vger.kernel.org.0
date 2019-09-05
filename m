Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1686BAAB94
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 20:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbfIES4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 14:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbfIES4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 14:56:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07503206BA;
        Thu,  5 Sep 2019 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567709811;
        bh=Tq9HFZ6S3c33RlbAMDoVG+iNI0mbItn8i1SI6gce9j8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fq9m0CUHVBBJJnSMhg3oHZEF3kmt868Nzly0VFo6VVrcFPCMz0BQCpNJ43ooP5jii
         XMEiPoVCm/MQHDzlIYg08eVkxWD2iv7P6gr+q5sec/e5N4AKfzWRHvHHB3EKEsmPop
         MApfzvX9KH2oEChG5jr+8vTuTxPx5+b+gqGK5l2w=
Date:   Thu, 5 Sep 2019 20:56:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ricard Wanderlof <ricardw@axis.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 06/77] ASoC: Fail card instantiation if DAI format
 setup fails
Message-ID: <20190905185648.GB24873@kroah.com>
References: <20190904175303.317468926@linuxfoundation.org>
 <20190904175304.060004729@linuxfoundation.org>
 <20190904180952.GF4348@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904180952.GF4348@sirena.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:09:52PM +0100, Mark Brown wrote:
> On Wed, Sep 04, 2019 at 07:52:53PM +0200, Greg Kroah-Hartman wrote:
> > [ Upstream commit 40aa5383e393d72f6aa3943a4e7b1aae25a1e43b ]
> > 
> > If the DAI format setup fails, there is no valid communication format
> > between CPU and CODEC, so fail card instantiation, rather than continue
> > with a card that will most likely not function properly.
> 
> I nacked this patch when Sasha posted it - it only improves diagnostics
> and might make systems that worked by accident break since it turns
> things into a hard failure, it won't make anything that didn't work
> previously work.

Now dropped.

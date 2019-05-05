Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466C813F95
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 15:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfEENP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 09:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbfEENP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 09:15:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70215206DF;
        Sun,  5 May 2019 13:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557062155;
        bh=auYnHjs8wzEKYfbbC8m1V9BvvrI5FZrly9EaqNjNoqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fevJcKReFs7w0Qwbc+Auamy4PUkz0Udppm8YlEY/07qN0Y5WRobYmFGjV9TJ58TOf
         ORdI62yS0p8K1x6YepkjUxdahQwFeZQ6nHlKFtsIxuCCpRp2JkjhZL4Ag/BpmTH5bt
         QdhYAt3mvxXmFl6WFd7oRDaBtmysLnfbfTfRQ06o=
Date:   Sun, 5 May 2019 15:15:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ross Zwisler <zwisler@chromium.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [linux-4.4.y PATCH] ASoC: Intel: avoid Oops if DMA setup fails
Message-ID: <20190505131553.GB25640@kroah.com>
References: <20190429182710.GA209252@google.com>
 <20190503194503.77923-1-zwisler@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503194503.77923-1-zwisler@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 01:45:03PM -0600, Ross Zwisler wrote:
> From: Ross Zwisler <zwisler@chromium.org>
> 
> commit 0efa3334d65b7f421ba12382dfa58f6ff5bf83c4 upstream.

This commit id is not in Linus's tree :(

